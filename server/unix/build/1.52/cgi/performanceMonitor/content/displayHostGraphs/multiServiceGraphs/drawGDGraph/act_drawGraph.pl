use strict;
package main;

# Determine unique ser file
my $pid=$$;
my $serFile="$perfhome/cgi/performanceMonitor/content/graphData/$pid.ser";

# Declare Variables
my $width;
my $height;
my $mygraph=();
my @data=();
my @subServices=();
my @subServiceNames=();
my @metricNames=();
my @metricAverages=();
my @label=();
my @data=();
my $mygraph=();
my $subService=();
my $graphObject=();
my $multiServiceGraphs=();
my $arrayName=();
my $graphVerticalLabel=();
my $graphTitle=();
my $metricHash=();
my %metricHash=();
my $arrayIndexHash=();
my %arrayIndexHash=();

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
$multiServiceGraphs = lock_retrieve("$perfhome/var/db/mappings/multiServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/multiServiceGraphs.ser");
my $prefix = $serviceName;
$prefix =~ s/\..*//;
my $graphObject = $multiServiceGraphs->{$os}->{$prefix}->{$graphName};

if ($graphType =~ m/bar/) {
	$width = $graphObject->getBarWidth() * $graphScale;
	$height = $graphObject->getBarHeight() * $graphScale;
} elsif ($graphType =~ m/pie/) {
	$width = $graphObject->getPieWidth() * $graphScale;
	$height = $graphObject->getPieHeight() * $graphScale;
} else {
	die("Error: Invalid value for $graphType");
}
$graphTitle=$graphObject->getTitle();
$graphVerticalLabel=$graphObject->getVerticalLabel();

&FindSubServices;
&GetData;

# Push metric names and values into single array
my $metricNamesRef=\@subServiceNames;
my $metricValuesRef=\@metricAverages;
push(@data, $metricNamesRef);
push(@data, $metricValuesRef);

&GraphLabel;

# Serialize Graph Data
&StoreData;

### Send Graph Data to graph AIP
my $graphAPI=`$perfhome/cgi/performanceMonitor/content/act_graphAPI GD,$pid`;

###DEBUG Print###
#print $request->header();
#print("test: $graphAPI");

# Output Graph
#my $myimage = $mygraph->plot(\@data) or die $mygraph->error;
print header({-type =>'image/png',-expires=>'-1d',-pragma=>'nocache'});
print $graphAPI;
#print $myimage->png;

# Average sub service data
sub GetData {

	my $arrayIndexCount="1";
	my $arrayIndexCreate="1";

	# Average data for all subService Metrics
	foreach my $serviceName (@subServices) {

		$subService="$serviceName";
		$subService =~ m/\S+\.(\S+)/;
		$subService=$1;

        	foreach my $metric (@{$graphObject->{metricArray}}) {
                	my $metricName = $metric->getName();

                	# Determine if metric is to be excluded from graph
                	my $subGraphExclude = $metric->getSubGraphExclude();

                	next if ($subGraphExclude =~ m/1/);

			# Build metric Names Array
        		push(@metricNames,$metricName);

			# Create sub service name array for all sub services
			my $name="$subService\_$metricName";
			push(@subServiceNames,$name);

			# Average data foreach sub service
			&AverageData($serviceName);
		}
	}
}

# Create graph label array
sub GraphLabel {

	my $count=0;
	foreach my $metric (@metricNames) {
		my $digitsToCut="3";
		my $metricValue=@metricAverages[$count];

		if ($metricValue=~/\d+\.(\d){$digitsToCut,}/) {
    			$metricValue=sprintf("%.".($digitsToCut - 1)."f", $metricValue);
		}

		my $metricLabel="$metric:$metricValue";
		push(@label,$metricLabel);
		$count++;
	}
}
	
# Average all data points foreach metric based on time period
sub AverageData {

	# Turn off stric refs
	no strict "refs";

	my $serviceName=shift;
        my $metrics=join(",", @metricNames);
	my $report_cmd="$perfhome/bin/tools/perfreport -h $hostName -s $serviceName -m $metrics -dump -end now -begin $period";

	# Build Hash for sorting data
	my $count="1";
	foreach my $metric (@metricNames) {
        	$metricHash{$count}="$metric";
        	$count++;
	}

	# Dump data for time period into array
	my $getData=`$report_cmd`;
	my @dumpArray=split(" ", $getData);

	# Find out how many metrics we are dealing with
	my $numMetrics=@metricNames;

	# Create array for each metric
	my $arrayCount="1";
	my $metricCount="1";
	my $offset="0";
	my $lastMetric=();

	foreach my $line (@dumpArray) {
        	foreach my $key (sort keys %metricHash) {

			# Set offset
			if ($key =~ m/$numMetrics/) {
				$lastMetric="1";
				$offset++;
			}

			if ($arrayCount =~ m/$metricCount/) {
				$arrayName="$metricHash{$key}$subService";
				$arrayIndexHash{$arrayName}="1";

				# Count only metric who have values
				if ($line !~ m/NaN/) {
               				push(@{$arrayName}, $line);
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
	foreach my $key (keys %arrayIndexHash) {
		# Work on current subService
		next if ($key !~ m/$subService/);

        	my $data_ref=@{$arrayName};
		
		#print "ref: $data_ref\n";

		# Get Total for metric
		my $total=();
        	foreach my $num (@{$key}) {
                	$total += $num;
        	}

        	#print "total: $total\n";

		# Average total
        	my $average=$total / $data_ref;
        	#print "average: $average\n";;

        	# Build array with all metric averages
        	push(@metricAverages, $average);

		# Undefine values
        	undef $data_ref;
        	undef $total;
        	undef $average;
	}
}

# Determine sub services based on service
sub FindSubServices {

        my $hostObject = populateHostObject($hostName);
        my $serviceIndex = $hostObject->{serviceIndex};

        foreach my $service (keys (%$serviceIndex)) {
                # Skip if not correct service.subservice
                next if ($service !~ m/$prefix.\S+/);
		# Skip Totals
		next if ($service =~ m/$prefix\.Total/);

                push(@subServices, $service);
        }
}

sub StoreData {

        # Create array refs
        my $dataArrayRef=\@data;
        my $labelArrayRef=\@label;
        my $colorsArrayRef=\@{$graphObject->{colorsArray}};

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
