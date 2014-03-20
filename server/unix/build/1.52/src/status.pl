# PerfStat Status Program

use CGI::Carp qw(carpout);
use POSIX qw(:sys_wait_h :errno_h sys_wait_h);
use Fcntl qw(:DEFAULT);
use IO::File;
use Storable qw(lock_retrieve lock_store freeze thaw);
use Host;
use Service;
use Metric;
use Graph;

$ppid=$$;

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

# Convert Intervals from minutes to seconds
$ENV{'STATUS_INTERVAL'}=$ENV{'STATUS_INTERVAL'} * 60;

# Log all alerts and warnings to the below logfile
my $logfile = "$perfhome/var/logs/perfctl.log";
open(LOGFILE, ">> $logfile")
	or die "ERROR: Unable to append to $logfile: $!\n";
carpout(*LOGFILE);

# Check to see if alert process is already running
if (-f "$perfhome/tmp/status.pid") {
        open(PID, "$perfhome/tmp/status.pid")
                or die "ERROR: Couldn't open file $perfhome/tmp/status.pid: $!\n";
        $oldPID=<PID>;
        chomp $oldPID;
        close (PID);

        if (kill 0 => $oldPID) {
                $pidUser=`$ENV{'PS_CMD'} -f $oldPID |$ENV{'TAIL_CMD'} -1`;
                $pidUser =~ m/(\S+)\s+/;
                $pidUser=$1;

                if ($pidUser =~ m/$ENV{'USER'}/) {
                        warn "INFO: A status process is already running under PID $oldPID, aborting!\n";
                        warn "INFO: PidUser: $pidUser USER: $ENV{'USER'}\n";
                        exit(1);
                }
        }
}

# Save PID in file
open(PID, "> $perfhome/tmp/status.pid")
        or die "ERROR: Couldn't open file $perfhome/tmp/status.pid: $!\n";
print PID "$ppid\n";
close (PID);

# Load Global host data
&LoadGlobalHostData;

# Get current time (epoch) and status interval
my $curr_time=time;
my $interval=$ENV{'STATUS_INTERVAL'};
#my $nostatus=();
my $event=();
my $msg=();
my $alert=();


foreach $host (sort(keys(%$hostIndex))) {

	my $hostObject = $hostIndex->{$host};
	my $serviceIndex = $hostObject->{serviceIndex};

	foreach $service (sort(keys(%$serviceIndex))) {

		my $serviceObject = $serviceIndex->{$service};
		my $serviceName = $serviceObject->getServiceName();
		my $arrayLength = $serviceObject->getMetricArrayLength();
		my $lastUpdate=$serviceObject->getLastUpdate();

		# Warn if no status is found otherwise perform status check
		if (! defined $lastUpdate) {
			warn "WARNING: Status for $host:$service is blank or missing\n";
		} elsif ($lastUpdate + $interval <= $curr_time) {

			for ($counter=0; $counter < $arrayLength; $counter++) {

				my $metricObject = $serviceObject->{metricArray}->[$counter];
				my $status = $metricObject->getStatus();
				my $metricName = $metricObject->getMetricName();
				my $metricValue = $metricObject->getMetricValue();
				my $thresholdUnit = $metricObject->getThresholdUnit();
				my $friendlyName = $metricObject->getFriendlyName();
				my $hasEvents = $metricObject->getHasEvents();

				# Next if metric is already set to nostatus
				next if ($status =~ m/nostatus/);

				# Skip if events are not set/configured
				next if ($hasEvents != "1");

				$alert="nostatus";

				$event="$metricName";
				$msg="$alert $friendlyName Value: $metricValue Boundary: nostatus Unit: $thresholdUnit";

				# Set Global Environment SNMP Variables
				if (defined $ENV{'TRAP_SCRIPT'}) {
					$ENV{'ALERT'}="$alert";
					$ENV{'EVENT'}="$service.$metricName";
					$ENV{'NAME'}="$friendlyName";
					$ENV{'VALUE'}="$metricValue";
					$ENV{'BOUNDARY'}="$metricValue";
					$ENV{'THRESHOLD'}="$thresholdUnit";
				}

				# Serialize event states to hostIndex
				$metricObject->setStatus($alert);
				#warn "NOSTATUS host: $host service: $service metric: $metricName last: $lastUpdate int: $interval time: $curr_time\n";

				#$nostatus="1";

				# Serialize all services to disk (service.ser)
				$hostIndex->{$host}->{serviceIndex}->{$service}->lock_store("$perfhome/var/db/hosts/$host/services/$service.ser")
					or die "ERROR: Can't store $perfhome/var/db/hosts/$host/services/$service.ser\n";

				# Check to see if events are enabled
				exit(0) unless ($ENV{'EVENTLOG'} =~ m/y|Y/);
				my $event_disable=&EVENT_DISABLE; # List of events to disable from EVENT_DISABLE sub
				exit(0) if ($event_disable eq "*");

				# Create Event Logs and Check Notification rules
				&CREATE_EVENT_LOGS;
				&NOTIFY_RULES;
			}
		}
	}
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
        my $nostatus_filename="$perfhome/var/status/$host/$service.$event.nostatus";
        my $crit_filename="$perfhome/var/status/$host/$service.$event.crit";
        my $warn_filename="$perfhome/var/status/$host/$service.$event.warn";
        my $event_filename="$perfhome/var/events/$host/$service.log";

        if ($alert =~ m/nostatus/) {

                if (-f "$crit_filename") {
                        unlink "$crit_filename";
                }

                if (-f "$warn_filename") {
                        unlink "$warn_filename";
                }

                my $nostatus_fh = new IO::File $nostatus_filename, "w", 0660
                        or die "ERROR: Cannot Open $nostatus_filename for writing: $!\n";

                $nostatus_fh->close();
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

                if ($ENV{'ALERT_ALL'} =~ m/y|Y/) {
                        &PARSE_RULES;
                }

                if ($ENV{'ALERT_CRIT'} =~ m/y|Y/ && $alert =~ m/CRIT/ && $ENV{'ALERT_ALL'} !~ m/y|Y/) {
                        &PARSE_RULES;
                }

                if ($ENV{'ALERT_WARN'} =~ m/y|Y/ && $alert =~ m/WARN/ && $ENV{'ALERT_ALL'} !~ m/y|Y/) {
                        &PARSE_RULES;
                }
                if ($ENV{'ALERT_NOSTATUS'} =~ m/y|Y/ && $alert =~ m/nostatus/ && $ENV{'ALERT_ALL'} !~ m/y|Y/) {
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
                if ($ENV{'ALERT_NOSTATUS'} =~ m/y|Y/ && $alert =~ m/nostatus/ && $ENV{'ALERT_ALL'} !~ m/y|Y/) {
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
                        $line =~ m/^$host:(\S*):(\S*):(\S*):(\S*)/;
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
                opendir(SERVICESDIR, "$perfhome/var/db/hosts/$hostName/services")
                        or die("WARNING: Couldn't open dir $perfhome/var/db/hosts/$hostName/services: $!\n");

                while ($serviceName = readdir(SERVICESDIR)) {

                        # Skip if file starts with a . and the host.ser
                        next if ($serviceName =~ m/^\.\.?$/);
                        #next if ($serviceName =~ m/$hostName\.ser/);

                        if ($serviceName =~ /^([\S]+)\.ser$/) {

                                #create service object by deserialization
                                $serviceObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/services/$serviceName");
                                        die("WARNING: can't retriewe $perfhome/var/db/hosts/$hostName/services/$serviceName\n")
unless defined($serviceObject);

                        #assign service object to service hash
                        $serviceHash->{$1} = $serviceObject;

                        } else {
                                warn "ERROR: Serialized service data not found for $hostName:$serviceName while loading
 global data\n";
                                exit(1);
                        }
                }
                closedir(SERVICESDIR);

                #assign serviceHash to hostIndex
                $hostIndex->{$hostName}->{serviceIndex} = $serviceHash;
        }
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
