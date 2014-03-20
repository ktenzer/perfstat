# PerfStat Daemon

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

		# Load host/service data and populate hostIndex
		&LoadHostData;			# Load hosts updated host data into hostIndex
		&LoadHostServiceData;		# Load hosts updated service data into hostIndex
	
		&VERIFY_HOST; 		# Ensure client is allowed to connect
		&CREATE_DIRS;		# Create host based directories if needed
		&HOST_STATUS;		# Create timestamp for host

		# Process incomming data from client
		$buffer = <$session>;

		if (! defined $buffer) {
			warn "WARNING: Connection from $host established, but 0 bytes sent\n";
			exit (1);
		}

		&MaxBytes;		# Determine if max allowable bytes were sent

		# Exit if unexpected data is sent
		if ($buffer !~ m/data|update/) {
			warn "ERROR: Invalid data sent from $host\n";
			exit(1);
		}

		# Get OS for use in SetHostDefaults
		$buffer =~ m/(\S+)\s+/;
		$preOS=$1;

		&SetHostDefaults;	# Create default serialized host data for host

		# Handle communication from client or FE
		if ($buffer =~ m/data/) {
			&DATA;		# Handle data sent from clients
			warn "DEBUG: Connection from [$host,$port] finished\n" if ($ENV{'DEBUG'});
		} elsif ($buffer =~ m/^update/) {
			&UPDATE;	# Reload global host config deserialize/serialize
			warn "DEBUG: Connection from [$host,$port] finished\n" if ($ENV{'DEBUG'});
		}

		#  All processing complete
		exit(0);
	}
}

# Handle data sent from clients
sub DATA {

	# Get current time in epoch
	my $time=time;

	# Remove any newlines from buffer
	$buffer =~ s/\n//g;
	warn "DEBUG: Buffer contains - $buffer\n" if ($ENV{'DEBUG'});

	# Split data into array for parsing
	my @allData=split(":", $buffer);

	foreach my $line (@allData) {

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
			warn "ERROR: Data contains non-numeric character! data:$data\n";
			exit(1);
		}

		# Include sub-service in service name if defined
		if (defined $device) {
			$service="$service.$device";
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
}

# Update configuration for host
sub UPDATE {

	$buffer =~ m/\S+\s+(\S+)\s+(\S*)/gi;
	$host=$1;
	$service=$2;

	# Debugging output if set
	warn "DEBUG: Update for $host sent\n" if ($ENV{'DEBUG'});

	# Assign the recieved data to some scalars to be referenced later
	&LoadHostData;			# Load hosts updated host data into hostIndex
	&LoadHostServiceData;		# Load hosts updated service data into hostIndex

	# All processing complete
	#exit 0;
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

		# Get current host settings
		my $OS=$hostIndex->{$host}->getOS();
		my $IP=$hostIndex->{$host}->getIP();
		my $owner=$hostIndex->{$host}->getOwner();

		# Create data structure to use for serializing host data (host.ser)
		my $hostUpdate=();
		$hostUpdate = Host->new(      OS 	 => "$OS",
				      	      lastUpdate => "$time",
				              IP	 => "$IP",
				              Owner	 => "$owner",
					);

		# Serialize lastUpdate to disk (host.ser)
		$hostUpdate->lock_store("$perfhome/var/db/hosts/$host/$host.ser")
			or die "ERROR: Can't store $perfhome/var/db/hosts/$host/$host.ser\n";
	}

}

# Determine if host exists in etc/perf-hosts file.  If not exit.
sub VERIFY_HOST {

	# Verify if host is in hostIndex
	if (! defined $hostIndex->{$host}) {
		warn "ERROR: Hostname $host not found in hostIndex!\n";
		exit(1);
	}

	# Exit if host data not defined
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

                my @rras = split " ",$RRA;
                RRDs::create($RRD,"--step",$rrdStep,@ds,@rras);
                my $ERROR=RRDs::error;
                if($ERROR) {
                       	warn "ERROR: creating $RRD: $ERROR\n";
			exit(1);

                }
                warn "INFO: did not find $RRD, RRD Created\n";

        } else {

		# Update already existing RRD with current time
        	my $rrdtime="N";
		my $rrdupdate="$rrdtime";

		# Data needs to be in semi-colon delimited format
		$dataUpdate=join(":", @data);

                $rrdupdate = "$rrdupdate:$dataUpdate";

        	warn "DEBUG: rrdupdate = $rrdupdate\n" if ($ENV{'DEBUG'});

        	# If RRD already exists, update it with new data
        	RRDs::update("$RRD","$rrdupdate");
        	my $ERROR=RRDs::error;
        	if($ERROR) {
                	warn "ERROR: updating $RRD: $ERROR\n";
        	}

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
        	warn "ERROR: $rrd_count data points sent, RRD configuration expected $sent_count for Host: $host Service: $NoSubService\n";
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
	$hostIndex->{$host}->{serviceIndex}->{$service}->lock_store("$perfhome/var/db/hosts/$host/$service.ser")
		or die "ERROR: Can't store $perfhome/var/db/hosts/$host/$service.ser\n";
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
	my $event_filename="$perfhome/var/events/$host/$service.log";

	if ($alert =~ m/CRIT/) {

        	if (-f "$warn_filename") {
                	unlink "$warn_filename";
        	}

        	my $crit_fh = new IO::File $crit_filename, "w", 0660
                	or die "ERROR: Cannot Open $crit_filename for writing: $!\n";

        	$crit_fh->close();

	} elsif ($alert =~ m/WARN/) {

        	if (-f "$crit_filename") {
                	unlink "$crit_filename";
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

	if ($ENV{'EMAIL'} =~ m/y|Y/) {

		if ($ENV{'EMAIL_ALL'} =~ m/y|Y/) {
			&PARSE_RULES;
		}

		if ($ENV{'EMAIL_CRIT'} =~ m/y|Y/ && $alert =~ m/CRIT/ && $ENV{'EMAIL_ALL'} !~ m/y|Y/) {
			&PARSE_RULES;
		}

		if ($ENV{'EMAIL_WARN'} =~ m/y|Y/ && $alert =~ m/WARN/ && $ENV{'EMAIL_ALL'} !~ m/y|Y/) {
			&PARSE_RULES;
		}
	}
}

# Parse notify-rules
sub PARSE_RULES {

	use Time::localtime;
	$tm=localtime;
	($hour, $day) = ($tm->hour, $tm->mday);

	$input = IO::File->new("< $perfhome/etc/notify-rules")
		or die "ERROR: Couldn't open $perfhome/etc/notify-rules for reading: $!\n";

	while (defined($line = $input->getline())) {
		# Do not send alert if host is not configured in notify-rules
		next if ($line !~ m/^$host/);
		if ($line =~ m/^$host/) {
			no warnings;
			$int_hour_{${$int}}=();
			$int_day_{${$int}}=();
			$line =~ m/^$host:(\S*):(\S*):(\S*)/;
			$allow_hours=$1; $allow_days=$2; $allow_mets=$3;

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

	%mail = ( To      => "$ENV{'EMAIL_TO'}",
  	  	  From    => "$ENV{'EMAIL_FROM'}",
	  	  Subject => "$ENV{'EMAIL_SUBJECT'}",
  	  	  Message => "$event_time $alert $event $msg",
	);

	$mail{smtp} = "$ENV{'SMTP_SERVER'}";

	sendmail(%mail) or die "Error: $Mail::Sendmail::error\n";
}

# Setup host Defaults for host data
sub SetHostDefaults {

	# Copy default host serialized file to unique hostname serialized file
        if (! -f "$perfhome/var/db/hosts/$host/$host.ser") {
                copy("$perfhome/etc/configs/$preOS/host.ser","$perfhome/var/db/hosts/$host/$host.ser")
                        or die "ERROR: Couldn't serialize default host data for $host: $!\n";
        }

	# Copy default ping serialized file to conn.ping serialized file
        if (! -f "$perfhome/var/db/hosts/$host/conn.ping.ser") {
                copy("$perfhome/etc/configs/$preOS/conn.ping.ser","$perfhome/var/db/hosts/$host/conn.ping.ser")
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

	### This is a Workaround Kludge to not supporting 3 levels of service ###	
	# Create temp service containing ufs/vxfs
	my $realService=();
	if ($service =~ m/fs.default|fs.vxfs/) {
		$service =~ m/(\w+\..\w+)\../;
		$realService=$1;

		# Remove ufs/vxfs for service name
		$service =~ s/\.\w+//;
	}

        # Copy default service serialized file to unique sub-service serialized file
        if (! -f "$perfhome/var/db/hosts/$host/$service.ser") {

		# Handle services for fs different
		if ($service =~ m/fs.default|fs.vxfs/) {

                	copy("$perfhome/etc/configs/$os/$realService.ser","$perfhome/var/db/hosts/$host/$service.ser")
                        	or die "ERROR: Couldn't serialize default service data for $host:$service: $!\n";
		} else {
                	copy("$perfhome/etc/configs/$os/$NoSubService.ser","$perfhome/var/db/hosts/$host/$service.ser")
                        	or die "ERROR: Couldn't serialize default service data for $host:$service: $!\n";
		}
        }

	# If service data doesn't exist, load it
	if (! defined $hostIndex->{$host}->{serviceIndex}->{$service}) {
		&LoadHostServiceData;
		warn "INFO: Loaded new service: $service for $host\n";
	}
}


# Load global data configuration for every host (de-serilization)
sub LoadGlobalHostData {

        #create an empty hostIndex
        $hostIndex = {};

        #populate the keys of the hash with the hostNames
        opendir(STATEDIR, "$perfhome/var/db/hosts")
                or die("ERROR: Couldn't open dir $perfhome/var/db/hosts: $!\n");

                while ($hostName = readdir(STATEDIR)) {
                        if ($hostName ne "." && $hostName ne "..") {
                                $hostIndex->{$hostName} = undef;
                        }
                }
        closedir(STATEDIR);

	### Populate each host key with a host object ###
	foreach $hostName (keys(%$hostIndex)) {

		opendir(HOSTDIR, "$perfhome/var/db/hosts/$hostName")
			or die("ERROR: Couldn't open dir $perfhome/var/db/hosts/$hostName: $!\n");

		while ($fileName = readdir(HOSTDIR)) {

                        # Skip if file starts with a . and all service.ser
                        next if ($fileName =~ m/^\.\.?$/);
			next if ($fileName !~ m/$hostName\.ser/);

			if ($fileName =~ /$hostName\.ser/) {

				#create host object by deserialization
                                $hostObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/$fileName");
                                	die("ERROR: can't retriewe $perfhome/var/db/hosts/$hostName/$fileName\n") unless defined($hostObject);

				#assign host object to hostIndex
				$hostIndex->{$hostName} = $hostObject;

                        } else {
                                warn "ERROR: Serialized host data not found for $hostName:$fileName while loading global data\n";
                                exit(1);
                        }
		}
		closedir(HOSTDIR);
	}


        ### Populate each host key with a hash of all host services ###
	foreach $hostName (keys(%$hostIndex)) {

                #create an empty serviceHash
                $serviceHash = {};

                #populate empty serviceHash with service objects
                opendir(HOSTDIR, "$perfhome/var/db/hosts/$hostName")
                        or die("ERROR: Couldn't open dir $perfhome/var/db/hosts/$hostName: $!\n");

                while ($serviceName = readdir(HOSTDIR)) {

                        # Skip if file starts with a . and the host.ser
                        next if ($serviceName =~ m/^\.\.?$/);
			next if ($serviceName =~ m/$hostName\.ser/);

                        if ($serviceName =~ /^([\S]+)\.ser$/) {

                                #create service object by deserialization
                                $serviceObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/$serviceName");
                                	die("ERROR: can't retriewe $perfhome/var/db/hosts/$hostName/$serviceName\n") unless defined($serviceObject);

                        #assign service object to service hash
                        $serviceHash->{$1} = $serviceObject;

                        } else {
                                warn "ERROR: Serialized service data not found for $hostName:$serviceName while loading global data\n";
                                exit(1);
                        }
                }
                closedir(HOSTDIR);

                #assign serviceHash to hostIndex
		$hostIndex->{$hostName}->{serviceIndex} = $serviceHash;
        }

}

# Load global user data (de-serilization)
sub LoadGlobalUserData {

        #create an empty userIndex
        $userIndex = {};

	#populate the keys of the hash with the hostNames
	opendir(STATEDIR, "$perfhome/var/db/users") or die("ERROR: Couldn't open dir $perfhome/var/db/users: $!\n");

	while (my $dirName = readdir(STATEDIR)) {
		if ($dirName ne "." && $dirName ne "..") {
			opendir(USERDIR, "$perfhome/var/db/users/$dirName") or die("ERROR: Couldn't open dir $perfhome/var/db/users/$dirName: $!\n");
			while (my $fileName = readdir(USERDIR)) {
				# Skip if file starts with a . and all reports.ser
				next if ($fileName =~ m/^\.\.?$/);
				next if ($fileName !~ m/$dirName\.ser/);
				my $userObject = lock_retrieve("$perfhome/var/db/users/$dirName/$fileName");
					die("ERROR: can't retrieve $perfhome/var/db/users/$dirName/$fileName\n") unless defined($userObject);

				my $creator = $userObject->getCreator();
				my $name = $userObject->getName();
				# fill userIndex
				$userIndex -> {$creator} -> {$name}  = $userObject;
			}
		closedir(USERDIR);
		}
	}
	closedir(STATEDIR);
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
			$hostObject = lock_retrieve("$perfhome/var/db/hosts/$host/$fileName");
				die("ERROR: can't retriewe $perfhome/var/db/hosts/$host/$fileName\n") unless defined($hostObject);

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
	opendir(HOSTDIR, "$perfhome/var/db/hosts/$host")
		or die("ERROR: Couldn't open dir $perfhome/var/db/hosts/$host: $!\n");

	while ($serviceName = readdir(HOSTDIR)) {

		# Skip if file starts with a . and the host.ser
		next if ($serviceName =~ m/^\.\.?$/);
		next if ($serviceName =~ m/$host\.ser/);

		if ($serviceName =~ /^([\S]+)\.ser$/) {

			#create service object by deserialization
			$serviceObject = lock_retrieve("$perfhome/var/db/hosts/$host/$serviceName");
				die("ERROR: can't retriewe $perfhome/var/db/hosts/$host/$serviceName\n") unless defined($serviceObject);

			#assign service object to service hash
			$serviceHash->{$1} = $serviceObject;
		} else {
			warn "ERROR: Serialized data not found for $host:$serviceName while loading host data\n";
			exit(1);
		}
	}
	closedir(HOSTDIR);

	#assign serviceHash to hostIndex for given host only
	$hostIndex->{$host}->{serviceIndex} = $serviceHash;
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

$socket->close;
