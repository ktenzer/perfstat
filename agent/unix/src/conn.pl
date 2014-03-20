# Host Connectivity Check

use IO::Socket qw(:DEFAULT :crlf);
use CGI::Carp qw(carpout);
use POSIX qw(:sys_wait_h :errno_h sys_wait_h);
use Fcntl qw(:DEFAULT);
use Storable qw(lock_retrieve lock_store freeze thaw);
use Net::Ping;
use Mail::Sendmail;
use IO::File;
use Host;
use Service;
use Metric;
use Graph;

$ppid=$$;

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

# Log all alerts and warnings to the below logfile
my $logfile = "$perfhome/var/logs/perfctl.log";
open(LOGFILE, ">> $logfile")
	or die "ERROR: Unable to append to $logfile: $!\n";
carpout(*LOGFILE);

# Check to see if conn process is already running
if (-f "$perfhome/tmp/conn.pid") {
	open(PID, "$perfhome/tmp/conn.pid")
        	or die "ERROR: Couldn't open file $perfhome/tmp/conn.pid: $!\n";
	$oldPID=<PID>;
	chomp $oldPID;
	close (PID);

	if (kill 0 => $oldPID) {
		$pidUser=`$ENV{'PS_CMD'} -f $oldPID |$ENV{'TAIL_CMD'} -1`;
		$pidUser =~ m/(\S+)\s+/;
		$pidUser=$1;

		if ($pidUser =~ m/$ENV{'USER'}/) {
			warn "WARNING: A conn process is already running under PID $oldPID, aborting!\n";
			warn "WARNING: PidUser: $pidUser USER: $ENV{'USER'}\n";
			exit(1);
		}
	}
}

# Save PID in file
open(PID, "> $perfhome/tmp/conn.pid")
        or die "ERROR: Couldn't open file $perfhome/tmp/conn.pid: $!\n";
print PID "$ppid\n";
close (PID);

# Load Global host data
&LoadGlobalHostData;

# Get epoch time
$time=time;

# Test host connectivity for all host in hostIndex
foreach $host (sort(keys(%$hostIndex))) {

        # Create Status Dir if it doesn't exist
        if ( ! -d "$perfhome/var/status/$host" ) {
                mkdir("$perfhome/var/status/$host",0770)
                        or die "WARNING: Cannot mkdir $perfhome/var/status/$host: $!\n";
                warn "INFO: Did not find Directory: $perfhome/var/status/$host. DIR Created\n";
        }

        # Create Event Log Dir if it doesn't exist
        if ( ! -d "$perfhome/var/events/$host" ) {
                mkdir("$perfhome/var/events/$host",0770)
                        or die "WARNING: Cannot mkdir $perfhome/var/events/$host: $!\n";
                        warn "INFO: Did not find Directory: $perfhome/var/events/$host. DIR Created\n";
        }

	my $hostObject = $hostIndex->{$host};
	my $serviceIndex = $hostObject->{serviceIndex};

	foreach $service (sort(keys(%$serviceIndex))) {

		my $serviceObject = $serviceIndex->{$service};
		my $arrayLength = $serviceObject->getMetricArrayLength();
		my $serviceName = $serviceObject->getServiceName();

		# Skip if service is not conn
		next if ($serviceName !~ m/conn.*/);

		# Skip if events are disabled for conn service on host
		exit(0) unless ($ENV{'EVENTLOG'} =~ m/y|Y/);
		my $event_disable=&EVENT_DISABLE; # List of events to disable from EVENT_DISABLE sub
		exit(0) if ($event_disable eq "*");

                # Serialize service lastUpdate to hostIndex
                if (defined $hostIndex->{$host}->{serviceIndex}->{$service}) {
                        $hostIndex->{$host}->{serviceIndex}->{$service}->setLastUpdate($time);
                }

		for ($counter=0; $counter < $arrayLength; $counter++) {

			my $metricObject = $serviceObject->{metricArray}->[$counter];
			my $hasEvents = $metricObject->getHasEvents();
			my $metricName = $metricObject->getMetricName(); 
			my $friendlyName = $metricObject->getFriendlyName(); 
			my $status = $metricObject->getStatus();

			# Skip if events are not configured
			next if ($hasEvents != "1");
			next if ($event_disable =~ m/$service/);
			next if ($event_disable =~ m/all|ALL/);

			if ($metricName =~ m/ping/) {	

				undef $noPing;

				# Test Host Conectivity
				$alert=&HostConnectivity($host);

				# Check conn.ping status
				if ($alert =~ m/OK/) {

					$event="$metricName";
					$msg="$alert $friendlyName Value: null Boundary: null Unit: null";

					if ($status !~ m/$alert/) {

						# Only notify if status ne to nostatus
						if ($status !~ m/nostatus/) {
							&CREATE_EVENT_LOGS;
							&NOTIFY_RULES;
						}

						# Serialize event states to hostIndex
						$metricObject->setStatus("OK");

						#print "$host alive\n";
					}
				} else {
					$noPing="1";

					$event="$metricName";
					$msg="$alert $friendlyName Value: null Boundary: null Unit: null";

					if ($status !~ m/$alert/) {

                                                # Only notify if status ne to nostatus
                                                if ($status !~ m/nostatus/) {
                                                        &CREATE_EVENT_LOGS;
                                                        &NOTIFY_RULES;
                                                }

						# Serialize event states to hostIndex
						$metricObject->setStatus("CRIT");

						#print "$host dead\n";
					}
				}

				# Sync changes to disk
				$hostIndex->{$host}->{serviceIndex}->{$service}->lock_store("$perfhome/var/db/hosts/$host/$service.ser")
					or die "ERROR: Can't store $perfhome/var/db/hosts/$host/$service.ser\n";

			# Metric is a port
			} else {	

				# Skip port test if host ping failed
				if ($noPing == "1") {

					$alert="CRIT";
					$event="$metricName";
					$msg="$alert $friendlyName Value: null Boundary: null Unit: null";

					if ($status !~ m/$alert/) {

						$metricObject->setStatus("CRIT");

						# Sync changes to disk if status changed
						$hostIndex->{$host}->{serviceIndex}->{$service}->lock_store("$perfhome/var/db/hosts/$host/$service.ser")
							or die "ERROR: Can't store $perfhome/var/db/hosts/$host/$service.ser\n";

						&CREATE_EVENT_LOGS;
					}

				} else {

					# Find port number to test
					my $servicePort = $metricObject->getServicePort(); 

					$alert=&PortConnectivity($host,$servicePort);

					# Check conn.port status
					if ($alert =~ m/OK/) {

						$event="$metricName";
						$msg="$alert $friendlyName Value: null Boundary: null Unit: null";

						if ($status !~ m/$alert/) {
							$metricObject->setStatus("OK");

                                                	# Only notify if status ne to nostatus
                                                	if ($status !~ m/nostatus/) {
                                                        	&CREATE_EVENT_LOGS;
                                                        	&NOTIFY_RULES;
                                                	}

							#print "$host:$servicePort alive\n";
						}
					} else {

						$event="$metricName";
						$msg="$alert $friendlyName Value: null Boundary: null Unit: null";

						if ($status !~ m/$alert/) {
							$metricObject->setStatus("CRIT");

                                                        # Only notify if status ne to nostatus
                                                        if ($status !~ m/nostatus/) {
                                                                &CREATE_EVENT_LOGS;
                                                                &NOTIFY_RULES;
                                                        }

							#print "$host:$servicePort dead\n";
						}
					}

					# Sync changes to disk
					$hostIndex->{$host}->{serviceIndex}->{$service}->lock_store("$perfhome/var/db/hosts/$host/$service.ser")
						or die "ERROR: Can't store $perfhome/var/db/hosts/$host/$service.ser\n";
				}
			}
		}
	}
}

# Test host connectivity
sub HostConnectivity {
	my $hostName=shift;

	# Ping host using tcp
	$p = Net::Ping->new();
	if ($p->ping($hostName,1)) {
		$alert="OK";
	} else {
		$alert="CRIT";
	}
	$p->close();

	return $alert;
}

# Test host:port connectivity
sub PortConnectivity {
	my $hostName=shift;
	my $servicePort=shift;

	# Connect to host:port and return status of connection
	my $socket = IO::Socket::INET->new( Proto    => "tcp",
					    PeerAddr => "$hostName",
                                            PeerPort => "$servicePort",
                                            Timeout  => '1') or my $noConnect=1;
	
	if (! defined $noConnect) {
		$alert="OK";
	} else {
		$alert="CRIT";
	}

	close $socket;

	return $alert;
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
        my $crit_filename="$perfhome/var/status/$host/$service.crit";
        my $warn_filename="$perfhome/var/status/$host/$service.warn";
        my $event_filename="$perfhome/var/events/$host/$service.log";

        if ($alert =~ m/CRIT/) {

                if (-f "$warn_filename") {
                        unlink "$warn_filename";
                }

                my $crit_fh = new IO::File $crit_filename, "w", 0660
                        or die "WARNING: Cannot Open $crit_filename for writing: $!\n";

                $crit_fh->close();

        } elsif ($alert =~ m/WARN/) {

                if (-f "$crit_filename") {
                        unlink "$crit_filename";
                }

                my $warn_fh = new IO::File $warn_filename, "w", 0660
                        or die "WARNING: Cannot Open $warn_filename for writing: $!\n";

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
                        or die "WARNING: Cannot Open $event_filename for writing: $!\n";

                while (<$count_fh>) {
                        next if $_ =~ m/^\s+/;
                        $count++;
                }
                $count_fh->close();

                # Save Current Log
                my $logfile_fh = new IO::File $event_filename, "r", 0660
                        or die "WARNING: Cannot Open $event_filename for writing: $!\n";
                @event_log=<$logfile_fh>;
                $logfile_fh->close();
        }

        # Write new log containing current log and new line
        my $event_fh = new IO::File $event_filename, "w", 0660
                or die "WARNING: Cannot Open $event_filename for writing: $!\n";

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
                                or die "WARNING: Cannot Open $event_filename for writing: $!\n";

                        while (<$truncate_fh>) {
                                $address = tell($truncate_fh) unless eof($truncate_fh);
                        }
                        truncate($truncate_fh, $address)
                                or die "WARNING: Couldn't Truncate $address Log: $!\n";
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
                        or die("WARNING: Couldn't open dir $perfhome/var/db/hosts/$hostName: $!\n");

                while ($fileName = readdir(HOSTDIR)) {

                        # Skip if file starts with a . and all service.ser
                        next if ($fileName =~ m/^\.\.?$/);
                        next if ($fileName !~ m/$hostName\.ser/);

                        if ($fileName =~ /$hostName\.ser/) {

                                #create host object by deserialization
                                $hostObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/$fileName");
                                        die("WARNING: can't retriewe $perfhome/var/db/hosts/$hostName/$fileName\n") unless defined($hostObject);

                                #assign host object to hostIndex
                                $hostIndex->{$hostName} = $hostObject;

                        } else {
                                warn "ERROR: Serialized host data not found for $hostName:$fileName while loading globa
l data\n";
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
                        or die("WARNING: Couldn't open dir $perfhome/var/db/hosts/$hostName: $!\n");

                while ($serviceName = readdir(HOSTDIR)) {

                        # Skip if file starts with a . and the host.ser
                        next if ($serviceName =~ m/^\.\.?$/);
                        next if ($serviceName =~ m/$hostName\.ser/);

                        if ($serviceName =~ /^([\S]+)\.ser$/) {

                                #create service object by deserialization
                                $serviceObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/$serviceName");
                                        die("WARNING: can't retriewe $perfhome/var/db/hosts/$hostName/$serviceName\n")
unless defined($serviceObject);

                        #assign service object to service hash
                        $serviceHash->{$1} = $serviceObject;

                        } else {
                                warn "ERROR: Serialized service data not found for $hostName:$serviceName while loading
 global data\n";
                                exit(1);
                        }
                }
                closedir(HOSTDIR);

                #assign serviceHash to hostIndex
                $hostIndex->{$hostName}->{serviceIndex} = $serviceHash;
        }

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

		if ($key =~ m/^METRICS/) {
			@services=split(/\s+/, $value);
		} else {
                	$hashref->{$key}=$value;
		}
        }
        close(FILE);
}

# Get path to status executable
sub PATH {
	my $path = PerlApp::exe();
	$path =~ s/\/\w*$//;
 	return $path;
}
