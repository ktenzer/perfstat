# perfd.pl - PerfStat Daemon

use warnings;
use IO::Socket qw(:DEFAULT :crlf);
use CGI::Carp qw(carpout);
use IO::File;
use File::Copy;
use Mail::Sendmail;
use POSIX qw(:sys_wait_h :errno_h sys_wait_h);
use Fcntl qw(:DEFAULT);
use Storable qw(lock_retrieve lock_store freeze thaw);
use Host;
use Service;
use Metric;
use Graph;
use User;
use NotifyRules;
use vars qw($pid $host $IP $port $buffer $os $service $data @data $found $alert $event $event_time $msg);

my $ppid=$$;
my $quit = 0;

# Set umask
umask(0007);

# Slurp in path to Perfhome
my $perfhome=&PATH;
$perfhome =~ s/\/bin//;

# Slurp in Configuration
my %conf       = ();
&GetConfiguration(\%conf);

# Set Environment Variables from %conf
foreach $key (keys %conf) {
        $ENV{$key}="$conf{$key}";
}

# Save PID in file
open(PID, "> $perfhome/tmp/perfd.pid")
	or die "ERROR: Couldn't open file $perfhome/tmp/perfd.pid: $!\n";
print PID "$ppid\n";
close (PID);

# Log start time
my $time=time;

open(TIME, "> $perfhome/tmp/perfd.time")
	or die "ERROR: Couldn't open file $perfhome/tmp/perfd.time: $!\n";
print TIME "$time\n";
close (TIME);

# Log all alerts and warnings to the below logfile
my $logfile = "$perfhome/var/logs/perfd.log";
open(LOGFILE, ">> $logfile")
	or die "ERROR: Unable to append to $logfile: $!\n";
carpout(*LOGFILE);

# Define Signal Handling
$SIG{INT} = $SIG{TERM} =  sub { $quit++ };
$SIG{CHLD} =  sub { while ( waitpid(-1, WNOHANG)>0 ) { } };

# Open Socket
my $socket = IO::Socket::INET->new( Proto	   => "tcp", 
				    LocalAddr 	   => "$ENV{'SERVERIP'}:$ENV{'SERVERPORT'}",
				    Type	   => SOCK_STREAM,
				    Reuse	   => 1,
				    Listen	   => SOMAXCONN,
				    Timeout	   => 30)
	or die "ERROR: Couldn't open Socket on IP: $ENV{'SERVERIP'} Port: $ENV{'SERVERPORT'} :  $@\n";

# Main body of program
while (!$quit) {
	# Accept socket connection
	next unless my $session = $socket->accept;

	# Get the Hostname/IP of the client
	$host = gethostbyaddr($session->peeraddr,AF_INET) || $session->peerhost;
	$IP = $session->peerhost;

	my $port = $session->peerport;
	warn "DEBUG: Connection from [$host,$port] Established\n" if ($ENV{'DEBUG'});

	# Fork off new child process for every connection
	$pid = fork();
	die "ERROR: Cannot Fork: $!" unless (defined $pid);
	warn "DEBUG: Child PID is $pid\n" if ($ENV{'DEBUG'});
	if ($pid == 0) {

		# Close Child porcesses copy of socket connection
		$socket->close;

		# Load host/service data and populate hostIndex
		#&LoadHostData;			# Load hosts updated host data into hostIndex
		#&LoadHostServiceData;		# Load hosts updated service data into hostIndex
	
		# Process incomming data from client
		$buffer = <$session>;

		if (! defined $buffer) {
			warn "WARNING: Connection from $host established, but 0 bytes sent\n";
			exit (1);
		}

		&MaxBytes;		# Determine if max allowable bytes were sent

		# Get OS for use in SetHostDefaults
		$buffer =~ m/(\S+)\s+/;
		$preOS=$1;

		&VERIFY_HOST; 		# Ensure client is allowed to connect
		&CREATE_DIRS;		# Create host based directories if needed
		&HOST_STATUS;		# Create timestamp for host

		# Exit if unexpected data is sent
		if ($buffer !~ m/data|info/) {
			warn "ERROR: Invalid data sent from $host\n";
			exit(1);
		}

		&SetHostDefaults;	# Create default serialized host data for host

		# Remove any newlines from buffer
		$buffer =~ s/\n//g;
		warn "DEBUG: Buffer contains - $buffer\n" if ($ENV{'DEBUG'});

		# Split data into array for parsing
		my @allData=split(":", $buffer);

		# Handle communication from client or FE
		foreach my $line (@allData) {
			if ($line =~ m/^$preOS\s+data/) {
				&DATA($line);		# Handle data sent from clients
				warn "DEBUG: Connection from [$host,$port] finished\n" if ($ENV{'DEBUG'});
			} elsif ($line =~ m/^$preOS\s+info/) {
				&INFO($line);	# Handle info sent from clients
				warn "DEBUG: Connection from [$host,$port] finished\n" if ($ENV{'DEBUG'});
			}
		}

		#  All processing complete exit from Child process
		exit(0);
	}

	# Close socket connection from parent process and wait for new connection
	$session->close;
}

# Handle data sent from clients
sub DATA {

	# Slurp in DATA
	my $line=shift;

	# Get current time in epoch
	my $time=time;

	$line =~ m/(\S+)\s+\S+\s+(\S+)\s+(\d*.*)/gi;
	#exit(1) if ($3 eq "" || ! $3 =~ m/\d.*/  || $line eq "\015\012");

	# Assign the recieved data to some scalars to be referenced later
	$os = "$1"; $service = "$2"; $data = "$3";

	# Check OS
	if ($os !~ m/Linux|SunOS|WindowsNT/) {
		warn "ERROR: $os not supported at this time!\n";
		exit(1);
	}

	if ($data =~ m/^[A-Za-z\/]/ || $data =~ m/^[1-9]/ && $data =~ m/[A-Za-z\/]/) {

		# Parse device and data since a device is present
		$data =~ m/(\S*)\s+(\d*.*)/;
		$device="$1";
		$data="$2";
		
		# Get rid of wild characters for device
		$device =~ s/[\!\@\#\$\%\^\&\(\)\_\=\+\-\/\*]//g;
	}

	# RRDs don't need the sub-service
	$NoSubService="$service";

	# Check to ensure only numeric characters exist in data
	if ($data =~ m/[A-Za-z]/) {
		warn "ERROR: Data contains non-numeric character! $host $service data: $data\n";
		exit(1);
	}

	# Include sub-service in service name if defined
	if (defined $device) {
		$service="$service.$device";
	}	

	# Check to ensure sub-service isn't null
	if ($service =~ m/\.$/) {
		warn "ERROR: Sub-service is null for service $NoSubService!\n";
		exit(1);
	}

	@data=split(" ", $data);

	# Debugging output if set
	warn "DEBUG: $os:$service:$data\n" if ($ENV{'DEBUG'});
	
	&SetServiceDefaults;	# Create default serialized service data for host

	# Serialize service lastUpdate to hostIndex
	if (defined $hostIndex->{$host}->{serviceIndex}->{$service}) {
		$hostIndex->{$host}->{serviceIndex}->{$service}->setLastUpdate($time);
	}

	#&SetHostDefaults;      # Create default serialized host data for host
	&RRD;			# Take parsed data and store in RRD
	&EVENT_PARSE;		# Log Event Thresholds/Notification

	if (defined $device) {
		undef $device;	
	}	
}

# Update configuration for host
sub INFO {

	# Slurp in DATA
	my $line=shift;

	$line =~ m/(\S+)\s+\S+\s+(.*)/gi;
	$os="$1";
	$info="$2";

	# Debugging output if set
	warn "DEBUG: INFO for $host sent\n" if ($ENV{'DEBUG'});

	# Split info into array for parsing
	my @allInfo=split(" ", $info);

	# Organize host info
	my $cpuNum=$allInfo[0];
	my $cpuModel=$allInfo[1];
	my $cpuSpeed=$allInfo[2];
	my $memTotal=$allInfo[3];
	#my $swapTotal=$allInfo[4];
	my $osVer=$allInfo[4];
	my $kernelVer=$allInfo[5];
	my $patches=$allInfo[6];

	my @patchesArray=split(",", $patches);
	my $patchesArrayRef=\@patchesArray;

	#warn "INFO: CPU Num: $cpuNum Model: $cpuModel Speed: $cpuSpeed Mem Total: $memTotal OsVer: $osVer Kernel Ver: $kernelVer @patchesArray\n";

        # Update host info
	my %hostUpdate=();
	$hostUpdate=&HOST_UPDATE;
	$hostUpdate->{$host}->setCpuNum($cpuNum);
	$hostUpdate->{$host}->setCpuModel($cpuModel);
	$hostUpdate->{$host}->setCpuSpeed($cpuSpeed);
	$hostUpdate->{$host}->setMemTotal($memTotal);
	#$hostUpdate->{$host}->setSwapTotal($swapTotal);
	$hostUpdate->{$host}->setOsVer($osVer);
	$hostUpdate->{$host}->setKernelVer($kernelVer);
	$hostUpdate->{$host}->{patchesArray}=$patchesArrayRef;

	# Serialize host data
	$hostUpdate->{$host}->lock_store("$perfhome/var/db/hosts/$host/$host.ser")
		or die "ERROR: Can't store $perfhome/var/db/hosts/$host/$host.ser\n";
}

# Determine Max bytes allowed
sub MaxBytes {

	# Determine if data exceeds max number of bytes
	my $bytes_in += length($buffer);

	if ($bytes_in >= $ENV{'MAXBYTES'}) {
		warn "ERROR: $host sent $bytes_in bytes, the maximum bytes allowed is $ENV{'MAXBYTES'} bytes\n";
		exit(1)
	}

	warn "DEBUG: $host sent $bytes_in bytes\n" if ($ENV{'DEBUG'});

}

# Get time in Epoch format to check hosts status
sub HOST_STATUS {

	# Get current time in epoch
	my $time=time;

	# Serialize host lastUpdate to hostIndex
	if (defined $hostIndex->{$host}{lastUpdate}) {
		$hostIndex->{$host}->setLastUpdate($time);

                # Set last update
		my %hostUpdate=();
                $hostUpdate=&HOST_UPDATE;
                $hostUpdate->{$host}->setLastUpdate($time);

                # Serialize host data
                $hostUpdate->{$host}->lock_store("$perfhome/var/db/hosts/$host/$host.ser")
                       or die "ERROR: Can't store $perfhome/var/db/hosts/$host/$host.ser\n";
	}

}

# Update host information (Serialize)
sub HOST_UPDATE {

        # Get current host settings
        my $time=time;
        my $OS=$hostIndex->{$host}->getOS();
        my $IP=$hostIndex->{$host}->getIP();
        my $owner=$hostIndex->{$host}->getOwner();
        my $cpuNum=$hostIndex->{$host}->getCpuNum();
        my $cpuModel=$hostIndex->{$host}->getCpuModel();
        my $cpuSpeed=$hostIndex->{$host}->getCpuSpeed();
        my $memTotal=$hostIndex->{$host}->getMemTotal();
        #my $swapTotal=$hostIndex->{$host}->getSwapTotal();
        my $osVer=$hostIndex->{$host}->getOsVer();
        my $kernelVer=$hostIndex->{$host}->getKernelVer();

	#warn "TEST: @{$hostIndex->{$host}->{patchesArray}}\n";
        #warn "UPDATE: $OS $IP $owner $cpuNum $cpuModel $cpuSpeed $memTotal $osVer $kernelVer @{$hostIndex->{$host}->{patchesArray}}\n";

        # Create data structure to use for serializing host data (host.ser)
        my %hostObject=();
        my $hostUpdate=();
        $hostObject = Host->new(      OS           => "$OS",
                                      lastUpdate   => "$time",
                                      IP           => "$IP",
                                      Owner        => "$owner",
                                      cpuNum       => "$cpuNum",
                                      cpuModel     => "$cpuModel",
                                      cpuSpeed     => "$cpuSpeed",
                                      memTotal     => "$memTotal",
                                      #swapTotal    => "$swapTotal",
                                      osVer        => "$osVer",
                                      kernelVer    => "$kernelVer",
				      patchesArray => "$hostIndex->{$host}->{patchesArray}",
        );

        $hostUpdate->{$host} = $hostObject;

        return $hostUpdate;
}

# Determine if host exists in etc/perf-hosts file.  If not exit.
sub VERIFY_HOST {

	# Verify if host data is found and load host/service data
	if (! -f "$perfhome/var/db/hosts/$host/$host.ser") {
		if ($ENV{'AUTO_DETECT'} =~ m/y|Y/) {
			&AUTO_DETECT;

			# Load host/service data for newly detected hosts
			&LoadHostData;			# Load hosts updated host data into hostIndex
			&LoadHostServiceData;		# Load hosts updated service data into hostIndex
		} else {
			warn "ERROR: $host does not exist in configuration!\n";
			exit(1);
		}
	} else {
		# Load host/service data for existing hosts
		&LoadHostData;			# Load hosts updated host data into hostIndex
		&LoadHostServiceData;		# Load hosts updated service data into hostIndex
	}

	# Exit if host data not defined in hostIndex
	if (! defined $hostIndex->{$host}{IP}) {
		warn "ERROR: Host data not found for $host in hostIndex!\n";
		exit(1);
	}

	# Get saved IP address
	my $savedIP=$hostIndex->{$host}->getIP(); 

	if ($IP !~ m/$savedIP/) {
		warn "ERROR: IP $IP does not match for $host!\n";
		exit(1);
	}

}

# Automatically add host into configuration if it isn't detected
sub AUTO_DETECT {

	# Check to ensure user exists and is admin
	if (! -f "$perfhome/var/db/users/$ENV{'ADMIN_NAME'}/$ENV{'ADMIN_NAME'}.ser") {
		warn "ERROR: auto detect failed for $host, user $ENV{'ADMIN_NAME'} is not a valid user!\n";
		exit(1);
	}

	my $userIndex = lock_retrieve("$perfhome/var/db/users//$ENV{'ADMIN_NAME'}/$ENV{'ADMIN_NAME'}.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$ENV{'ADMIN_NAME'}/$ENV{'ADMIN_NAME'}.ser");

	if ($userIndex->{role} !~ m/admin/) {
		warn "ERROR: auto detect failed for $host, user $ENV{'ADMIN_NAME'} is not an admin user!\n";
		exit(1);
	}

	warn "INFO: Auto Detect enabled, adding $host/$IP to configuration!\n";

	# Create host object
	my $hostObject = Host->new(     OS              => $preOS,
					IP              => $IP,
					Owner   	=> $ENV{'ADMIN_NAME'});

	# Create host directory
	if ( ! -d "$perfhome/var/db/hosts/$host" ) {
		mkdir("$perfhome/var/db/hosts/$host", 0770) or die "ERROR: Cannot mkdir $perfhome/var/db/hosts/$host: $!\n";
	}
	# Serialize host data to disk (host.ser)
	$hostObject->lock_store("$perfhome/var/db/hosts/$host/$host.ser") or die "ERROR: Can't store $perfhome/var/db/hosts/$host/$host.ser\n";
	# Create services directory
	if ( ! -d "$perfhome/var/db/hosts/$host/services" ) {
		mkdir("$perfhome/var/db/hosts/$host/services", 0770) or die "ERROR: Cannot mkdir $perfhome/var/db/hosts/$host/services: $!\n";
	}

	# Copy default ping serialized file to conn.ping serialized file
	if (! -f "$perfhome/var/db/hosts/$host/services/conn.ping.ser") {
		copy("$perfhome/etc/configs/$preOS/conn.ping.ser","$perfhome/var/db/hosts/$host/services/conn.ping.ser")
			or die "ERROR: Couldn't serialize default conn.ping data for $host: $!\n";
	}

	# Update admin2Host Index
	my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
	$admin2Host->{$ENV{'ADMIN_NAME'}}->{$host} = $preOS;
	lock_store($admin2Host, "$perfhome/var/db/mappings/admin2Host.ser") or die("Can't store admin2Host in $perfhome/var/db/mappings/admin2Host.ser\n");

	# Add Blank Changelog
	my $changeLog = {};
	$changeLog->{'sequence'} = 0;
	$changeLog->{'index'} = {};
	lock_store($changeLog, "$perfhome/var/logs/changelogs/$host.ser") or die("Can't store changeLog in $perfhome/var/logs/changelogs/$host.ser\n");

	warn "INFO: $host/$IP successfully added to configuration!\n";

}

# Create host based directories
sub CREATE_DIRS {

	# Create RRD Dir if it doesn't exist
	if ( ! -d "$perfhome/rrd/$host" ) {
		mkdir("$perfhome/rrd/$host",0770)
			or die "ERROR: Cannot mkdir $perfhome/rrd/$host: $!\n";
		warn "INFO: Did not find Directory: $perfhome/rrd/$host. DIR Created\n";
	}

	# Create Status Dir if it doesn't exist
	if ( ! -d "$perfhome/var/status/$host" ) {
        	mkdir("$perfhome/var/status/$host",0770)
                	or die "ERROR: Cannot mkdir $perfhome/var/status/$host: $!\n";
                warn "INFO: Did not find Directory: $perfhome/var/status/$host. DIR Created\n";
	}

	# Create Event Log Dir if it doesn't exist
	if ( ! -d "$perfhome/var/events/$host" ) {
        	mkdir("$perfhome/var/events/$host",0770)
                	or die "ERROR: Cannot mkdir $perfhome/var/events/$host: $!\n";
                	warn "INFO: Did not find Directory: $perfhome/var/events/$host. DIR Created\n";
	}

	# Create State Dir if it doesn't exist
	if ( ! -d "$perfhome/var/db/hosts/$host" ) {
        	mkdir("$perfhome/var/db/hosts/$host",0770)
                	or die "ERROR: Cannot mkdir $perfhome/var/db/hosts/$host: $!\n";
                	warn "INFO: Did not find Directory: $perfhome/var/db/hosts/$host. DIR Created\n";
	}

	# Create services Dir if it doesn't exist
	if ( ! -d "$perfhome/var/db/hosts/$host/services" ) {
        	mkdir("$perfhome/var/db/hosts/$host/services",0770)
                	or die "ERROR: Cannot mkdir $perfhome/var/db/hosts/$host/services: $!\n";
                	warn "INFO: Did not find Directory: $perfhome/var/db/hosts/$host/services. DIR Created\n";
	}

	# Create Alert Dir if it doesn't exist
        if (! -d "$perfhome/var/alerts/$host") {
                 mkdir("$perfhome/var/alerts/$host",0770)
                        or die "ERROR: Cannot mkdir $perfhome/var/alerts/$host: $!\n";
                	warn "INFO: Did not find Directory: $perfhome/var/alerts/$host. DIR Created\n";
        }
}

# Create RRD Databases from client data
sub RRD {

	use RRDs;

	my $RRD="$perfhome/rrd/$host/$host.$service.rrd";

	# Create hash of rrd index and metric name for given host/service
	$rrd_index_h=$hostIndex->{$host}->{serviceIndex}->{$service}->getRRDIndexes();

	# Determine if correct number of data points were sent
	&RRD_CHECK;

	warn "DEBUG: RRD File $RRD\n" if ($ENV{'DEBUG'});

        # If RRD doesn't exist then create one
        if ( ! -f "$RRD" ) {

		# Get RRD Configuration to build new RRD from
		my $RRA=$hostIndex->{$host}->{serviceIndex}->{$service}->getRRA();
		my $rrdStep=$hostIndex->{$host}->{serviceIndex}->{$service}->getRRDStep();
		my $data_ref=\@data;

		# Get Metric settings
	
		my $i=();
		foreach ($i=0; $i <= $#$data_ref; $i++) {

			my $metric=$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->getMetricName();
			my $rrdDST=$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->getRRDDST();
			my $rrdHeartbeat=$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->getRRDHeartbeat();
			my $rrdMin=$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->getRRDMin();
			my $rrdMax=$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->getRRDMax();

			# Add all metric settings to data source array
			push @ds, "DS:$metric:$rrdDST:$rrdHeartbeat:$rrdMin:$rrdMax";
		}

		# Create new RRD via rrdAPI
		my $rrdAPI=`$perfhome/bin/rrdAPI new,$host,$service,$rrdStep,@ds,$RRA`;

                #my @rras = split " ",$RRA;
                #RRDs::create($RRD,"--step",$rrdStep,@ds,@rras);
                #my $ERROR=RRDs::error;
                #if($ERROR) {
                #      	warn "ERROR: creating $RRD: $ERROR\n";
		#	exit(1);

                #}
                #warn "INFO: did not find $RRD, RRD Created\n";

        } else {

		# Update already existing RRD with current time
        	my $rrdtime="N";
		my $rrdupdate="$rrdtime";

		# Data needs to be in semi-colon delimited format
		$dataUpdate=join(":", @data);

		# Update RRD via rrdAPI
		my $rrdAPI=`$perfhome/bin/rrdAPI update,$host,$service,$dataUpdate`;

                #$rrdupdate = "$rrdupdate:$dataUpdate";

        	#warn "DEBUG: rrdupdate = $rrdupdate\n" if ($ENV{'DEBUG'});

        	# If RRD already exists, update it with new data
        	#RRDs::update("$RRD","$rrdupdate");
        	#my $ERROR=RRDs::error;
        	#if($ERROR) {
                #	warn "ERROR: updating $RRD: $ERROR\n";
        	#}

	}

	# Undefine Data Source Info
	undef @ds;
}

# Ensure data sent matches RRD Configuration
sub RRD_CHECK {

	my $metric=();
	my $data_ref=\@data;
	my $rrd_count=$#$data_ref + 1;
	my $sent_count=0;

	# Calculate how many data points a given service has
	foreach $metric (sort keys %$rrd_index_h) {
        	$sent_count++
	}

	# Exit and warn if incorrect number of data points were sent
	if ($sent_count ne $rrd_count) {
        	warn "WARNING: $rrd_count data points sent, RRD configuration expected $sent_count for Host: $host Service: $NoSubService\n";
		exit(1);
	}

}

# Parse Events
sub EVENT_PARSE {

	exit(0) unless ($ENV{'EVENTLOG'} =~ m/y|Y/);

	my $event_disable=&EVENT_DISABLE; # List of events to disable from EVENT_DISABLE sub

	exit(0) if ($event_disable eq "*");

	my $data_ref=\@data;

	# Map data value to name
	my $i=();
	foreach ($i=0; $i <= $#$data_ref; $i++) {

		# Figure out if event values are set
		$hasEvents=$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->getHasEvents();

		# Update metricValue
		$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->setMetricValue($data_ref->[$i]);

		# Skip if events are not set/configured
		next if ($hasEvents != "1");
		next if ($event_disable =~ m/$service/);
		next if ($event_disable =~ m/all|ALL/);

		# Get event configuration for host/service
		$warn=$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->getWarnThreshold();
		$crit=$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->getCritThreshold();
		$metricName=$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->getMetricName();
		$friendlyName=$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->getFriendlyName();
		$thresholdUnit=$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->getThresholdUnit();
		$status=$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->getStatus();

        	if ( $data_ref->[$i] >= $warn && $data_ref->[$i] < $crit) {
			$alert="WARN";
			$event="$metricName";
			$msg="$alert $friendlyName Value: $data_ref->[$i] Boundary: $warn Unit: $thresholdUnit";

			# Set Global Environment SNMP Variables
			if (defined $ENV{'TRAP_SCRIPT'}) {
				$ENV{'ALERT'}="$alert";
				$ENV{'EVENT'}="$service.$metricName";
				$ENV{'NAME'}="$friendlyName";
				$ENV{'VALUE'}="$data_ref->[$i]";
				$ENV{'BOUNDARY'}="$warn";
				$ENV{'THRESHOLD'}="$thresholdUnit";
			}

			# If metric status has changed process event
			if ($alert !~ m/$status/) {

				# Only notify if status ne to nostatus
				if ($status !~ m/nostatus/) {
					&CREATE_EVENT_LOGS;
					&NOTIFY_RULES;
				}

				# Serialize event states to hostIndex
				$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->setStatus($alert);
			}

        	} elsif ($data_ref->[$i] >= $crit) {
			$alert="CRIT";
			$event="$metricName";	
			$msg="$alert $friendlyName Value: $data_ref->[$i] Boundary: $crit Unit: $thresholdUnit";

			# Set Global Environment SNMP Variables
			if (defined $ENV{'TRAP_SCRIPT'}) {
				$ENV{'ALERT'}="$alert";
				$ENV{'EVENT'}="$service.$metricName";
				$ENV{'NAME'}="$friendlyName";
				$ENV{'VALUE'}="$data_ref->[$i]";
				$ENV{'BOUNDARY'}="$crit";
				$ENV{'THRESHOLD'}="$thresholdUnit";
			}

			# If metric status has changed process event
			if ($alert !~ m/$status/) {

				# Only notify if status ne to nostatus
				if ($status !~ m/nostatus/) {
					&CREATE_EVENT_LOGS;
					&NOTIFY_RULES;
				}

				# Serialize event states to hostIndex
				$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->setStatus($alert);
			}

        	} else {
			$alert="OK";
			$event="$metricName";	
			$msg="$alert $friendlyName Value: $data_ref->[$i] Boundary: $warn Unit: $thresholdUnit";

			# Set Global Environment SNMP Variables
			if (defined $ENV{'TRAP_SCRIPT'}) {
				$ENV{'ALERT'}="$alert";
				$ENV{'EVENT'}="$service.$metricName";
				$ENV{'NAME'}="$friendlyName";
				$ENV{'VALUE'}="$data_ref->[$i]";
				$ENV{'BOUNDARY'}="$warn";
				$ENV{'THRESHOLD'}="$thresholdUnit";
			}

			# If metric status has changed process event
			if ($alert !~ m/$status/) {

				# Only notify if status ne to nostatus
				if ($status !~ m/nostatus/) {
					&CREATE_EVENT_LOGS;
					&NOTIFY_RULES;
				}

				# Serialize event states to hostIndex
				$hostIndex->{$host}->{serviceIndex}->{$service}->{metricArray}->[$i]->setStatus($alert);
			}
		}
	}

	# Serialize all services to disk (service.ser)
	$hostIndex->{$host}->{serviceIndex}->{$service}->lock_store("$perfhome/var/db/hosts/$host/services/$service.ser")
		or die "ERROR: Can't store $perfhome/var/db/hosts/$host/services/$service.ser\n";
}

# Disable Events if configured in event-disable (optional)
sub EVENT_DISABLE {

	$input = IO::File->new("< /$perfhome/etc/events-disable")
        	or die "ERROR: Couldn't open $perfhome/etc/events-disable for reading: $!\n";

	while (defined($line = $input->getline())) {
        	if ($line =~ m/$host/) {
			$line =~ m/$host:(\S*)/;
			$match="$1";
		}
	}

	$input->close();

	if (defined $match) {
		my @event_disable=split(/:/, $match);
		my $event_disable="@event_disable";
		return $event_disable;
	}

}

# Create and Track historical event logs
sub CREATE_EVENT_LOGS {

	$event_time=localtime;
	my $count="0";
	my $address=();
	my $crit_filename="$perfhome/var/status/$host/$service.$event.crit";
	my $warn_filename="$perfhome/var/status/$host/$service.$event.warn";
	my $nostatus_filename="$perfhome/var/status/$host/$service.$event.nostatus";
	my $event_filename="$perfhome/var/events/$host/$service.log";

	if ($alert =~ m/CRIT/) {

        	if (-f "$warn_filename") {
                	unlink "$warn_filename";
        	}

        	if (-f "$nostatus_filename") {
                	unlink "$nostatus_filename";
        	}

        	my $crit_fh = new IO::File $crit_filename, "w", 0660
                	or die "ERROR: Cannot Open $crit_filename for writing: $!\n";

        	$crit_fh->close();

	} elsif ($alert =~ m/WARN/) {

        	if (-f "$crit_filename") {
                	unlink "$crit_filename";
        	}

        	if (-f "$nostatus_filename") {
                	unlink "$nostatus_filename";
        	}

        	my $warn_fh = new IO::File $warn_filename, "w", 0660
                	or die "ERROR: Cannot Open $warn_filename for writing: $!\n";

        	$warn_fh->close();
	} else {

        	if (-f "$crit_filename") {
                	unlink "$crit_filename";
        	}

        	if (-f "$warn_filename") {
                	unlink "$warn_filename";
        	}

        	if (-f "$nostatus_filename") {
                	unlink "$nostatus_filename";
        	}
	}

	# Determinie how many lines the log contains
	if (-f $event_filename) {
        	my $count_fh = new IO::File $event_filename, "r", 0660
                	or die "ERROR: Cannot Open $event_filename for writing: $!\n";

        	while (<$count_fh>) {
                	next if $_ =~ m/^\s+/;
                	$count++;
        	}
        	$count_fh->close();

		# Save Current Log
        	my $logfile_fh = new IO::File $event_filename, "r", 0660
                	or die "ERROR: Cannot Open $event_filename for writing: $!\n";
        	@event_log=<$logfile_fh>;
        	$logfile_fh->close();
	}

	# Write new log containing current log and new line
	my $event_fh = new IO::File $event_filename, "w", 0660
                or die "ERROR: Cannot Open $event_filename for writing: $!\n";

	print $event_fh "$event_time $msg\n";

	if (-f $event_filename) {
        	foreach $line (@event_log) {
                	print $event_fh "$line";
        	}
	}

	$event_fh->close();

	# If the event log exceeds the log size limit truncate the last line
	if (-f $event_filename) {
        	if ($count >= $ENV{'LOGSIZE'}) {

                	my $truncate_fh = new IO::File $event_filename, "r+", 0660
                        	or die "ERROR: Cannot Open $event_filename for writing: $!\n";

                	while (<$truncate_fh>) {
                        	$address = tell($truncate_fh) unless eof($truncate_fh);
                	}
                	truncate($truncate_fh, $address)
                        	or die "ERROR: Couldn't Truncate $address Log: $!\n";
                	$truncate_fh->close();
        	}
	}
}

# Determine who will recieve notification if it is enabled
sub NOTIFY_RULES {

	# Determine wether to send smtp alerts
	if ($ENV{'EMAIL'} =~ m/y|Y/) {

		if ($ENV{'ALERT_ALL'} =~ m/y|Y/) {
			&PARSE_RULES;
		}

		if ($ENV{'ALERT_CRIT'} =~ m/y|Y/ && $alert =~ m/CRIT/ && $ENV{'ALERT_ALL'} !~ m/y|Y/) {
			&PARSE_RULES;
		}

		if ($ENV{'ALERT_WARN'} =~ m/y|Y/ && $alert =~ m/WARN/ && $ENV{'ALERT_ALL'} !~ m/y|Y/) {
			&PARSE_RULES;
		}
	}

	# Determine wether to send alerts based on trap script
	if (defined $ENV{'TRAP_SCRIPT'}) {

		if ($ENV{'ALERT_ALL'} =~ m/y|Y/) {
			&PARSE_RULES;
		}

		if ($ENV{'ALERT_CRIT'} =~ m/y|Y/ && $alert =~ m/CRIT/ && $ENV{'ALERT_ALL'} !~ m/y|Y/) {
			&PARSE_RULES;
		}

		if ($ENV{'ALERT_WARN'} =~ m/y|Y/ && $alert =~ m/WARN/ && $ENV{'ALERT_ALL'} !~ m/y|Y/) {
			&PARSE_RULES;
		}
	}
}

# Parse notify-rules
sub PARSE_RULES {

	# Skip if no rules are found
	if (-f "$perfhome/var/db/hosts/$host/notifyRules.ser") {

		use Time::localtime;
		$tm=localtime;
		($hour, $day) = ($tm->hour, $tm->mday);

		# Create notifyRules object by deserialization
		my $notifyRulesObject = lock_retrieve("$perfhome/var/db/hosts/$host/notifyRules.ser");
			die("ERROR: can't retrieve $perfhome/var/db/hosts/$host/notifyRules.ser\n") unless defined($notifyRulesObject);

		#warn "NOTIFY RULE: @{$notifyRulesObject->{notifyRulesArray}}\n";

		foreach my $rule (@{$notifyRulesObject->{notifyRulesArray}}) {
			no warnings;
			$int_hour_{${$int}}=();
			$int_day_{${$int}}=();
			$rule =~ m/(\S*):(\S*):(\S*):(\S*)/;
			$allow_hours=$1; $allow_days=$2; $allow_mets=$3; $email_list=$4;

			if ($allow_hours eq "*") {
				$rule_hour="OK";
			} else {
				@hours=split(/[-,]/, $allow_hours);

				# Reference the array values for hours
				$hours_ref=\@hours;

				# Find out how many pairs we are dealing with for hours
				$hours_pairs=(($#$hours_ref + 1) / 2);

				# Determine hour ranges and if the actual hour fits into range
				foreach ($int=0; $odd_hour <= $hours_pairs; $int++) {
					$second_field=$int + 1;
					$int_hour_{${$int}}=$hours[$second_field] - $hours[$int];

					$hour_total=$hours[$int] + $int_hour_{${$int}};

					foreach ($count=$hours[$int]; $count <= $hour_total; $count++) {
						next if (! defined $count);
						if ($hour eq $count) {
							$rule_hour="OK";
							last;
						}
					}

					$odd_hour=$odd_hour + 1;
					$int=$int + 1;
				}
			}

			if ($allow_days eq "*") {
				$rule_day="OK";
			} else {
				@days=split(/[-,]/, $allow_days);

				# Reference the array values for days
				$days_ref=\@days;

				# Find out how many pairs we are dealing with for days
				$days_pairs=(($#$days_ref + 1) / 2);

				# Determine hour ranges and if the actual hour fits into range
				foreach ($int=0; $odd_day <= $days_pairs; $int++) {
					$second_field=$int + 1;
					$int_day_{${$int}}=$days[$second_field] - $days[$int];

					$day_total=$days[$int] + $int_day_{${$int}};

					foreach ($count=$days[$int]; $count <= $day_total; $count++) {
						next if (! defined $count);
						if ($day eq $count) {
							$rule_day="OK";
							last;
						}
					}

					$odd_day=$odd_day + 1;
					$int=$int + 1;
				}
			}

			# Determine what metrics alerts can be sent for
			if ($allow_mets eq "*") {
				$rule_met="OK";
			} else {
				@mets=split(/,/, $allow_mets);

				foreach $met (@mets) {
					if ($met =~ m/$service/) {
						$rule_met="OK";
					}
				}
			}

			if (defined $rule_hour && defined $rule_day && defined $rule_met) {
				&SEND_ALERT;
			}
		}
	}
}

# Send alerts to email or pager via smtp
sub SEND_ALERT {

	# Send smtp alert if email is enabled
	if ($ENV{'EMAIL'} =~ m/y|Y/) {
		open(ALERT, "> $perfhome/var/alerts/$host/$service.$event.$alert")
			or die "ERROR: Couldn't open file $perfhome/var/alerts/$host/$service.$event.$alert: $!\n";

		print ALERT "$email_list\n$event_time $service:$event $msg";

		close(ALERT);
	}

	# Send Trap if traps are enabled
	if (defined $ENV{'TRAP_SCRIPT'}) {
		&ParseTrapScript;
		warn "DEBUG: $ENV{'TRAP_SCRIPT'}\n" if ($ENV{'DEBUG'});
		#warn "TRAP: $ENV{'TRAP_SCRIPT'}\n";
	}

}

# Setup host Defaults for host data
sub SetHostDefaults {

	# Copy default host serialized file to unique hostname serialized file
        if (! -f "$perfhome/var/db/hosts/$host/$host.ser") {
                copy("$perfhome/etc/configs/$preOS/host.ser","$perfhome/var/db/hosts/$host/$host.ser")
                        or die "ERROR: Couldn't serialize default host data for $host: $!\n";
        }

	# Copy default ping serialized file to conn.ping serialized file
        if (! -f "$perfhome/var/db/hosts/$host/services/conn.ping.ser") {
                copy("$perfhome/etc/configs/$preOS/conn.ping.ser","$perfhome/var/db/hosts/$host/services/conn.ping.ser")
                        or die "ERROR: Couldn't serialize default conn data for $host: $!\n";
        }

	# If service data doesn't exist, load it
	if (! defined $hostIndex->{$host}{OS}) {
		&LoadHostData;
		warn "INFO: Loaded new host data for $host\n";
	}
}

# Setup host Defaults for service data
sub SetServiceDefaults {

        # Copy default service serialized file to unique sub-service serialized file
        if (! -f "$perfhome/var/db/hosts/$host/services/$service.ser") {

                copy("$perfhome/etc/configs/$os/$NoSubService.ser","$perfhome/var/db/hosts/$host/services/$service.ser")
                       	or die "ERROR: Couldn't serialize default service data for $host:$service: $!\n";
        }

	# If service data doesn't exist, load it
	if (! defined $hostIndex->{$host}->{serviceIndex}->{$service}) {
		&LoadHostServiceData;
		warn "INFO: Loaded new service: $service for $host\n";
	}
}

# Load single hosts host configuration data (de-serialize)
sub LoadHostData {

	#create an empty serviceHash
	$serviceHash = {};

	### Check to ensure host exists ###
	if (! -f "$perfhome/var/db/hosts/$host/$host.ser") {
		warn "ERROR: $host does not exist in configuration!\n";
		exit(1);
	}

        ### Populate each host key with a host object ###
	opendir(HOSTDIR, "$perfhome/var/db/hosts/$host")
		or die("ERROR: Couldn't open dir $perfhome/var/db/hosts/$host: $!\n");

	while ($fileName = readdir(HOSTDIR)) {

		# Skip if file starts with a . and all service.ser
		next if ($fileName =~ m/^\.\.?$/);
		next if ($fileName !~ m/$host\.ser/);

		if ($fileName =~ /$host\.ser/) {

			#create host object by deserialization
			$hostObject = lock_retrieve("$perfhome/var/db/hosts/$host/$fileName")
				or die "ERROR: can't retrieve $perfhome/var/db/hosts/$host/$fileName: $!\n";
				die("ERROR: can't retrieve $perfhome/var/db/hosts/$host/$fileName, hostObject not defined\n") unless defined($hostObject);

			#assign host object to hostIndex
			$hostIndex->{$host} = $hostObject;

		} else {
			warn "ERROR: Serialized host data not found for $host:$fileName while loading host data\n";
			exit(1);
		}
	}
	closedir(HOSTDIR);
}

# Load single hosts service configuration data (de-serialize)
sub LoadHostServiceData {

	#create an empty serviceHash
	$serviceHash = {};

	### Populate empty serviceHash with service objects ###
	opendir(SERVICESDIR, "$perfhome/var/db/hosts/$host/services")
		or die("ERROR: Couldn't open dir $perfhome/var/db/hosts/$host/services: $!\n");

	while ($serviceName = readdir(SERVICESDIR)) {

		# Skip if file starts with a . and the host.ser
		next if ($serviceName =~ m/^\.\.?$/);
		#next if ($serviceName =~ m/$host\.ser/);

		if ($serviceName =~ /^([\S]+)\.ser$/) {

			#create service object by deserialization
			$serviceObject = lock_retrieve("$perfhome/var/db/hosts/$host/services/$serviceName");
				die("ERROR: can't retriewe $perfhome/var/db/hosts/$host/services/$serviceName\n") unless defined($serviceObject);

			#assign service object to service hash
			$serviceHash->{$1} = $serviceObject;
		} else {
			warn "ERROR: Serialized data not found for $host:$serviceName while loading host data\n";
			exit(1);
		}
	}
	closedir(SERVICESDIR);

	#assign serviceHash to hostIndex for given host only
	$hostIndex->{$host}->{serviceIndex} = $serviceHash;
}

# Parse trap script and convert dynamic variables
sub ParseTrapScript {

        my $configfile="$perfhome/etc/perf-conf";

        open(FILE, $configfile)
                or die "ERROR: Couldn't open FileHandle for $configfile: $!\n";

        my @data=<FILE>;
        foreach $line (@data) {

                # Skip line if commented out
                next unless ($line =~ m/^TRAP_SCRIPT/);
                $line =~ m/(\w+)=(.+)/;

                my $key=$1;
                my $value=$2;

                # Dereference any variables that were set in conf file using the % flag
                if ($value =~ m/\%/) {
                        my @value=split(' ',$value);

                        foreach my $var (@value) {
                                next if ($var !~ m/%/);
                                $var =~ m/\%(\S+)/;
                                my $var="$1";
                                $value =~ s/\%$var/$ENV{$var}/;
                        }
                }

                $ENV{$key}=$value;
        }
        close(FILE);
}

# Get configuration dynamically from perf-conf
sub GetConfiguration {

	my $configfile="$perfhome/etc/perf-conf";
	my $hashref = shift;

	open(FILE, $configfile)
		or die "ERROR: Couldn't open FileHandle for $configfile: $!\n";

	my @data=<FILE>;
	foreach $line (@data) {

		# Skip line if commented out
		next if ($line =~ m/^#/);
		next if ($line =~ m/^\s+/);
		$line =~ m/(\w+)=(.+)/;

		my $key=$1;
		my $value=$2;

		$hashref->{$key}=$value;
	}
	close(FILE);
}

# Get path to perfctl executable
sub PATH {
  my $path = PerlApp::exe();
	$path =~ s/\/\w*$//;
        return $path;
}

#$socket->close;
