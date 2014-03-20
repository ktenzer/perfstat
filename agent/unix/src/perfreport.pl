# PerfStat Report Generator

use RRDs;

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
@ARGV >= 3 or &Usage;

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
		$list="1";
		&GetServices;
	}
	$count++;
}

# Check Arguments
sub CheckArgs {

        my $arg=shift;

        if ($arg =~ m/^-/) {
                if ($arg !~ m/-h|-s|-begin|-end|-list/) {
                        print "ERROR: Invalid Argument $arg!\n";
                        exit(1);
                }
        }
}

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

		# Print a timestamp
		my $time=localtime($start);
		print "$time";
		$start += $step;

		# Print data points for all data sources in selected RRD
		$namesRef=$#{$names};

		foreach my $ds (0 .. $namesRef) {

			# If no data point is found print NaN
			if ( ! defined $data->[$index][$ds] ) { 
				printf "  %5s %s", 'NaN', $$names[$ds];
				next;
			}

			$value=$data->[$index][$ds];
			printf "  %5.2f %s", $value, $$names[$ds];
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
  $0 [-h hostname] [-s service] [-begin <now>|<DATE><TIME>] [-end <now>|<DATE><TIME>]
  $0 [-h hostname] [-list]
EOF

exit(1);
}
