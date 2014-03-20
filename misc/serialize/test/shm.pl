#!/usr/local/ActivePerl-5.8/bin/perl

use lib "/perfstat/qa/1.47/server/lib";

use IPC::Shareable qw(:lock);
use Storable qw(lock_retrieve lock_store freeze thaw);
use Host;
use Service;
use Metric;
use Graph;

# Slurp in path to Perfhome
my $perfhome="/perfstat/qa/1.47/server";

# Slurp in Configuration
my %conf       = ();
&GetConfiguration(\%conf);

# Set Environment Variables from %conf
foreach $key (keys %conf) {
        $ENV{$key}="$conf{$key}";
}

# Initialize shared memory object
%shmChild=();

# tie to shared memory segment created by parent
tie($shmChild,'IPC::Shareable',$ENV{'SHM_ID'},{create     => 0,
					       destroy    => 0,
					       exclusive  => 0,
					       mode       => 0644})
	or die "WARNING: Couldn't tie host data hash to shared memory: $!\n";

# Thaw hostIndex from frozen parent object
&ThawGlobalData;

### Print host information and service information for all hosts in hostIndex ###
foreach $host (sort(keys(%$hostIndex))) {

	$hostObject = $hostIndex->{$host};
	$serviceIndex = $hostObject->{serviceIndex};

	print "Host: $host\n";

	$lastUpdate = $hostIndex->{$host}->getLastUpdate();

	$IP=$hostIndex->{$host}->getIP();
	print "IP: $IP\n";

	$OS=$hostIndex->{$host}->getOS();
	print "OS: $OS\n";

	$owner=$hostIndex->{$host}->getOwner();
	print "Owner: $owner\n";

	foreach $service (sort(keys(%$serviceIndex))) {

		print "Host: $host Service: $service\n";
                $serviceObject = $serviceIndex->{$service};
		$serviceName = $serviceObject->getServiceName();
                $arrayLength = $serviceObject->getMetricArrayLength();

		for ($counter=0; $counter < $arrayLength; $counter++) {
			
			$metricObject = $serviceObject->{metricArray}->[$counter];
			$metricName = $metricObject->getMetricName();
                        $friendlyName = $metricObject->getFriendlyName();
                        $status = $metricObject->getStatus();

			print "Metric Name: $metricName Status: $status\n";
		}

	}
}

#&CheckStatus;

# Thaw global hostIndex using shared locking
sub ThawGlobalData {

        (tied $shmChild)->shlock(LOCK_SH|LOCK_NB);
        %$hostIndex= %{ thaw($shmChild) }
                or warn "WARNING: Couldn't thaw hostIndex for global data, no hosts defined\n";
        (tied $shmChild)->shunlock;

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

sub CheckStatus {

        # Get current time (epoch) and status interval
        my $curr_time=time;
        #my $interval=$ENV{'STATUS_INTERVAL'};
        my $interval="1";
	my $nostatus=();


        foreach $host (sort(keys(%$hostIndex))) {

                my $hostObject = $hostIndex->{$host};
                my $serviceIndex = $hostObject->{serviceIndex};

                foreach $service (sort(keys(%$serviceIndex))) {

                        my $serviceObject = $serviceIndex->{$service};
                        my $serviceName = $serviceObject->getServiceName();
                        my $arrayLength = $serviceObject->getMetricArrayLength();
                        my $lastUpdate=$hostIndex->{$host}->{serviceIndex}->{$service}->getLastUpdate();

                        for ($counter=0; $counter < $arrayLength; $counter++) {

                               	my $metricObject = $serviceObject->{metricArray}->[$counter];
                               	my $metricName = $metricObject->getMetricName();
				my $status = $metricObject->getStatus();

                               	# Warn if no status is found otherwise perform status check
                               	if (! defined $lastUpdate) {
                                       	warn "WARNING: Status for $host:$service is blank or missing\n";
                               	} else {
                                       	if ($lastUpdate + $interval <= $curr_time) {
                                               	my $alert="nostatus";
                                               	# Serialize event states to hostIndex
						#$metricObject->setStatus($alert);
						warn "Host: $host Service: $service:$metricName Status: $status\n";
                                                $nostatus="1";
					}
                                }
                        }
                }

        }

	# Freeze hostIndex for transport via IPC if host(s) report nostatus
        if (defined $nostatus) {
                #&FreezeChild;
	}
}

# Freeze global hostIndex using child object
sub FreezeChild {

	(tied $shmChild)->shlock(LOCK_EX)
		or die "WARNING: Couldn't lock child shared memory object for freeze operation\n";
	$shmChild=freeze \%$hostIndex
		or die "WARNING: Couldn't freeze hostIndex for global data\n";
	(tied $shmChild)->shunlock
		or die "WARNING: Couldn't unlock child shared memory object for freeze operation\n";

}
