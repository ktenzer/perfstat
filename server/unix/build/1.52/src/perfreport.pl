# PerfStat Report Generator

use lib "/perfstat/dev/1.51/server/lib";
use RRDs;
use Storable qw(lock_retrieve lock_store freeze thaw);
use Host;
use Service;
use Metric;

# Slurp in path to Perfhome
my $perfhome=&PATH;
$perfhome =~ s/\/bin\/tools//;

# Slurp in Configuration
my %conf       = ();
&GetConfiguration(\%conf);

# Set Environment Variables from %conf
foreach $key (keys %conf) {
        $ENV{$key}="$conf{$key}";
}

# Atleast six options must be set
@ARGV >= 4 or &Usage;

# Set counter
my $count="0";

foreach my $arg (@ARGV) {

	# Check Arguments
	&CheckArgs($arg);

	if ($arg =~ m/-h/) {
		my $index=$count + 1;
		$hostName=@ARGV[$index];
	} elsif ($arg =~ m/-s/) {
		my $index=$count + 1;
		$service=@ARGV[$index];
	} elsif ($arg =~ m/-m/) {
		my $index=$count + 1;
		$metrics=@ARGV[$index];
	} elsif ($arg =~ m/-begin/) {
		my $index=$count + 1;
		
		if (@ARGV[$index] =~ m/now/) {
			$sdate="now";
		} else {
			$sdate=@ARGV[$index];
			my $index=$count + 2;
			$stime=@ARGV[$index];
		}
	} elsif ($arg =~ m/-end/) {
		my $index=$count + 1;

		if (@ARGV[$index] =~ m/now/) {
			$edate="now";
		} else {
			$edate=@ARGV[$index];
			my $index=$count + 2;
			$etime=@ARGV[$index];
		}
	} elsif ($arg =~ m/-list/) {
		my $index=$count + 1;
		if (@ARGV[$index] =~ m/services/) {
			$list="1";
			&GetServices;
		} else {
			$service=@ARGV[$index];
			$list="1";
			&GetMetrics($service);
		}
	} elsif ($arg =~ m/-dump/) {
		$dataDump="1";
	}
	$count++;
}

# Check Arguments
sub CheckArgs {

        my $arg=shift;

        if ($arg =~ m/^-/) {
                if ($arg !~ m/-h|-s|-m|-begin|-end|-list|-dump/) {
                        print "ERROR: Invalid Argument $arg!\n";
                        exit(1);
                }
        }
}

# Split metrics into array for parsing
@metricArray=split(",",$metrics);

# Print report if list option not selected
if (! defined $list) {
	&PrintReport;
}

# Print friendly report for host and service
sub PrintReport {

	my $rrdfile="$ENV{'PERFHOME'}/rrd/$hostName/$hostName.$service.rrd";

	push @RRDfetch, $rrdfile, '-s', "$sdate $stime", '-e', "$edate $etime", 'AVERAGE'; 

	#print "Fetch: @RRDfetch\n";
	#exit(1);

	# Sort rrd fetch output
	($start,$step,$names,$data) = RRDs::fetch @RRDfetch;

	if ( $error = RRDs::error ) {
		print "ERROR: The rrdtool fetch failed: $error\n";
		exit(1);
	}

	# Scroll through data hash and print data points
	$dataRef=$#{$data} - 1;

	foreach my $index (0 .. $dataRef) {

		# Print regular time stamp if data dump isn't set
		if (! defined $dataDump) {
			my $time=localtime($start);
			print "$time";
		}
		#} else {
		#	#($sec,$min,$hour,$day,$month,$year,$wday,$yday,$isdst)=localtime($start);
		#	my $time=localtime($start);
		#	#$time =~ m/(\S+)\s+(\S+)\s+(\S+)\s+(\d+)\:(\d+)/;
		#	$time =~ m/(\S+)\s+(\S+)\s+(\S+)\s+(\d+)\:(\d+)/;
		#	print "$1_$2_$3_$4:$5 ";
		#}

		$start += $step;

		# Print data points for all data sources in selected RRD
		$namesRef=$#{$names};

		foreach my $ds (0 .. $namesRef) {

			$metricName=$$names[$ds];

			# If no data point is found print NaN for specified metrics
			if ( ! defined $data->[$index][$ds] ) { 
				if (@metricArray[0] =~ m/all|ALL/) {
					if (! defined $dataDump) {
						printf "  %5s %s", 'NaN', $$names[$ds];
					} else {
						printf "  %5s %s", 'NaN';
					}
					undef $metricMatch;
				} else {
					foreach my $metric (@metricArray) {
						if ($metric =~ m/$metricName/) {
							$metricMatch="1";
						}
					}
					if ($metricMatch =~ m/1/) {
						if (! defined $dataDump) {
							printf "  %5s %s", 'NaN', $$names[$ds];
						} else {
							printf "  %5s %s", 'NaN';
						}
						undef $metricMatch;
						next;
					}
				}
			}

			# If data points exist print values for specified metrics
			if (@metricArray[0] =~ m/all|ALL/) {
				$value=$data->[$index][$ds];
				if (! defined $dataDump) {
					printf "  %5.2f %s", $value, $$names[$ds];
				} else {
					printf "%5.2f %s", $value;
				}
			} else {
				foreach my $metric (@metricArray) {
					if ($metric =~ m/$metricName/) {
						$metricMatch="1";
					}
				}
				if ($metricMatch =~ m/1/) {
					$value=$data->[$index][$ds];
					if (! defined $dataDump) {
						printf "  %5.2f %s", $value, $$names[$ds];
					} else {
						printf "%5.2f %s", $value;
					}
					undef $metricMatch;
				}
			}
		}
		print "\n";
	}
exit(0);
}

# Get services list for each host
sub GetServices {

	opendir(RRDDIR, "$ENV{'PERFHOME'}/rrd/$hostName")
		or die("ERROR: Couldn't open dir $ENV{'PERFHOME'}/rrd/$hostName: $!\n");

	while ($file = readdir(RRDDIR)) {
		next if ($file !~ m/\.rrd$/);
		next if ($file !~ m/$hostName/);

		if ($file ne "." && $file ne "..") {
			$file =~ m/$hostName\.(\S+)\.rrd/;
			my $service="$1";
			push(@services, $service);
		}
	}
	closedir(RRDDIR);

	print "\nServices for $hostName:\n";
	my $count="1";
	foreach my $service (@services) {
		print "\t$count) $service\n";
		$count++;
	}

}

# Get metrics list for a host/service
sub GetMetrics {

	my $service=shift;

	# Load Service Data
	LoadHostServiceData($service,$hostName);

	my $hostObject = $hostIndex->{$hostName};
	my $serviceIndex = $hostObject->{serviceIndex};
	my $serviceObject = $serviceIndex->{$service};
	my $serviceName = $serviceObject->getServiceName();
	my $arrayLength = $serviceObject->getMetricArrayLength();
                                                                                                 
	for ($counter=0; $counter < $arrayLength; $counter++) {
		my $metricObject = $serviceObject->{metricArray}->[$counter];
		my $metricName = $metricObject->getMetricName();

		push(@metricNameArray,$metricName);
	}


	print "\nMetrics for $service on $hostName:\n";
	my $count="1";
	foreach my $metric (@metricNameArray) {
		print "\t$count) $metric\n";
		$count++;
	}
}

# Load single hosts service configuration data (de-serialize)
sub LoadHostServiceData {

	my $serviceName=shift;
	my $host=shift;

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

# Get path to addhost executable
sub PATH {
  my $path = PerlApp::exe();
        $path =~ s/\/\w*$//;
        return $path;
}

### Get configuration dynamically from perf-conf ###
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

# Print Usage information
sub Usage {

print STDOUT <<EOF;
Usage:
  $0 [-h <hostname>] [-s <service>] [-m <metric1,metric2,...>|<all>] [-begin <now>|<DATE><TIME>] [-end <now>|<DATE><TIME>] [-dump]
  $0 [-h <hostname>] [-list <services|serviceName>]
EOF

exit(1);
}
