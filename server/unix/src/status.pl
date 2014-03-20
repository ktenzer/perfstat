# PerfStat Status Program

use CGI::Carp qw(carpout);
use POSIX qw(:sys_wait_h :errno_h sys_wait_h);
use Fcntl qw(:DEFAULT);
use IPC::Shareable qw(:lock);
use Storable qw(lock_retrieve lock_store freeze thaw);
use Host;
use Service;
use Metric;
use Graph;

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

# Load Global host data
&LoadGlobalHostData;

# Get current time (epoch) and status interval
my $curr_time=time;
my $interval=$ENV{'STATUS_INTERVAL'};
my $nostatus=();


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

				# Next if metric is already set to nostatus
				next if ($status =~ m/nostatus/);

				my $alert="nostatus";

				# Serialize event states to hostIndex
				$metricObject->setStatus($alert);
				#warn "NOSTATUS host: $host service: $service metric: $metricName last: $lastUpdate int: $interval time: $curr_time\n";

				$nostatus="1";

				# Serialize all services to disk (service.ser)
				$hostIndex->{$host}->{serviceIndex}->{$service}->lock_store("$perfhome/var/db/hosts/$host/$service.ser")
					or die "ERROR: Can't store $perfhome/var/db/hosts/$host/$service.ser\n";
			}
		}
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
