use strict;
package main;

# Determine unique ser file
my $pid=$$;
my $serFile="$perfhome/cgi/appLib/graphs/graphData/$pid.ser";

# Set Variables
my $host = $hostName;
my $service = $serviceName;
my $width;
my $height;

my $mygraph = ();
my @label = ();
my @data = ();
my @metricNames = ();
my @colors = ();
my @metricAverages = ();
my $metricLabel;
my $metrics;
my %metricHash;
my $getData;
my @dumpArray;
my $numMetrics;
my $arrayCount;
my $metricCount;
my $offset;
my @dumpArray;
my $lastMetric;
my $total = 0;

# Convert period into seconds
if ($period =~ m/day/) {
	$period="end-1d";
} elsif ($period =~ m/week/) {
	$period="end-1w";
} elsif ($period =~ m/month/) {
	$period="end-1m";
} elsif ($period =~ m/year/) {
	$period="end-1y";
}

# Get Graph Object
my $singleServiceGraphs = lock_retrieve("$perfhome/var/db/mappings/singleServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/singleServiceGraphs.ser");
my $prefix = $serviceName;
$prefix =~ s/\..*//;
my $graphObject = $singleServiceGraphs->{$os}->{$prefix}->{$graphName};

if ($graphType =~ m/bar/) {
	$width = $graphObject->getBarWidth() * $graphScale;
	$height = $graphObject->getBarHeight() * $graphScale;
} elsif ($graphType =~ m/pie/) {
	$width = $graphObject->getPieWidth() * $graphScale;
	$height = $graphObject->getPieHeight() * $graphScale;
} else {
	die("Error: Invalid value for $graphType");
}

my $graphTitle = $graphObject->getTitle();
my $graphVerticalLabel = $graphObject->getVerticalLabel();

my $data_ref = \@{$graphObject->{metricArray}};

foreach (my $i=0; $i <= $#$data_ref; $i++) {
	my $graphMetricName = @{$graphObject->{metricArray}}[$i]->getName();
	my $metricColor = @{$graphObject->{metricArray}}[$i]->getColor();
	push(@metricNames,$graphMetricName);
	push(@colors,$metricColor);
}

AverageData($period);

# Push metric names and values into single array
my $metricNamesRef=\@metricNames;
my $metricValuesRef=\@metricAverages;
push(@data, $metricNamesRef);
push(@data, $metricValuesRef);

# Build Graph
&GraphLabel;

# Serialize Graph Data
&StoreData;

### Send Graph Data to graph AIP
my $graphAPI=`$perfhome/cgi/appLib/graphs/act_graphAPI.pl GD,$pid`;

###DEBUG Print###
#print $request->header();
#print("test: $graphAPI");

# Output Graph
#my $myimage = $mygraph->plot(\@data) or die $mygraph->error;
print header({-type =>'image/png',-expires=>'-1d',-pragma=>'nocache'});
print $graphAPI;
#print $myimage->png;

sub GraphLabel {
	# Create graph label array
	my $count=0;
	foreach my $metric (@metricNames) {
		my $digitsToCut="3";
		my $metricValue=@metricAverages[$count];

		if ($metricValue=~/\d+\.(\d){$digitsToCut,}/) {
  	  		$metricValue=sprintf("%.".($digitsToCut - 1)."f", $metricValue);
		}

		$metricLabel="$metric:$metricValue";
		push(@label,$metricLabel);
		$count++;
	}
}
	
# Average all data points foreach metric based on time period
sub AverageData {
	# turn off strics refs
	no strict "refs";
	my ($period) = @_;
	$metrics=join(",", @metricNames);
	my $report_cmd="$perfhome/bin/tools/perfreport.pl -h $host -s $service -m $metrics -dump -end now -begin $period";
	# Build Hash for sorting data
	my $count="1";
	foreach my $metric (@metricNames) {
        	$metricHash{$count}="$metric";
        	$count++;
	}

	# Dump data for time period into array
	$getData=`$report_cmd`;
	@dumpArray=split(" ", $getData);

	# Find out how many metrics we are dealing with
	$numMetrics=@metricNames;

	# Create array for each metric
	$arrayCount="1";
	$metricCount="1";
	$offset="0";
	foreach my $line (@dumpArray) {
        	foreach my $key (sort keys %metricHash) {
			# Set offset
			if ($key =~ m/$numMetrics/) {
				$lastMetric="1";
				$offset++;
			}
			if ($arrayCount =~ m/$metricCount/) {
				#print "metric: $metricHash{$key} value: $line\n";
				# Count only metric who have values
				if ($line !~ m/NaN/) {
               				push(@{$metricHash{$key}}, $line);
				}
			}
			$metricCount++;
        	}
		$arrayCount++;

		if ($offset =~ m/$numMetrics/) {
			$offset="0";
			$metricCount=$arrayCount;
			undef $lastMetric;
		}
		if (defined $lastMetric) {
			$metricCount=$metricCount - $numMetrics;
			undef $lastMetric;
		}
	}

	# Average all data foreach metric
	foreach my $key (sort keys %metricHash) {
        	my $data_ref=@{$metricHash{$key}};
		#warn("WARN: ref: $data_ref");
        	foreach my $num (@{$metricHash{$key}}) {
                	$total += $num;
        	}
        	#warn("WARN: total: $total");

		# Average Total
                my $average=();
                if ($total == "0") {
                        $average="$total";
                } else {
                        $average=$total / $data_ref;
                }

        	#warn("WARN: average: $average");


        	# Build array with all metric averages
        	push(@metricAverages, $average);

		# Undefine values
        	undef $data_ref;
        	undef $total;
        	undef $average;
	}
}

sub StoreData {

        # Create array refs
        my $dataArrayRef=\@data;
        my $labelArrayRef=\@label;
        my $colorsArrayRef=\@colors;

        my $hashArray=();

        $hashArray->{data}=$dataArrayRef;
        $hashArray->{label}=$labelArrayRef;
        $hashArray->{colors}=$colorsArrayRef;
        $hashArray->{width}=$width;
        $hashArray->{height}=$height;
        $hashArray->{graphVerticalLabel}=$graphVerticalLabel;
        $hashArray->{graphType}=$graphType;

        # Serialize graph data
        lock_store $hashArray, "$serFile"
                or die "ERROR: Can't serialize $serFile: $!\n";
}

