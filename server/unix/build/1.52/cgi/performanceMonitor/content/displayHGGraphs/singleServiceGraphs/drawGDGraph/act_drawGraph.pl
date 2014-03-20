use strict;
package main;

# Determine unique ser file
my $pid=$$;
my $serFile="$perfhome/cgi/performanceMonitor/content/graphData/$pid.ser";

# Set Variables
my $mygraph=();
my $width;
my $height;
my @colors=();
my @data=();
my @label=();
my @metricAverages=();
my @metricNames=();
my $graphTitle=();
my $graphWidth=();
my $graphHeight=();
my $graphVerticalLabel=();
my $colorIndex={};
my %colorIndex=();
my $allMetricIndex={};
my %allMetricIndex=();
my $graphMetricHash={};
my %graphMetricHash=();
my @graphMetrics=();
my @test=();
my @keys=();
my @totals=();
my @refs=();

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

# Setup host array
# DEFINE ARRAY of hosts to list
my $hostArray = [];
if ($sessionObj->param("hostGroupID") eq "All Hosts") {
	my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
	my $hostHash = $admin2Host->{$sessionObj->param("selectedAdmin")};
	#define array of hosts
	foreach my $hostName (sort(keys(%$hostHash))) {
		push(@$hostArray, $hostName);
	}
} else {
	my $hgOwner = $sessionObj->param("selectedUser");
	my $hgID = $sessionObj->param("hostGroupID");
	my $hostGroup = lock_retrieve("$perfhome/var/db/users/$hgOwner/hostGroups/$hgID.ser") or die("Error: can't retrieve $perfhome/var/db/users/$hgOwner/hostGroups/$hgID.ser\n");
	my $hostHash = $hostGroup->{'memberHash'};
	#define array of hosts
	foreach my $hostName (sort(keys(%$hostHash))) {
		push(@$hostArray, $hostName);
	}
}

# Get Graph Object
my $hostGroupServiceGraphs = lock_retrieve("$perfhome/var/db/mappings/hostGroupServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/hostGroupServiceGraphs.ser");
my $graphObject = $hostGroupServiceGraphs->{$serviceName}->{$graphName};

if ($graphType =~ m/bar/) {
	$width = $graphObject->getBarWidth() * $graphScale;
	$height = $graphObject->getBarHeight() * $graphScale;
} elsif ($graphType =~ m/pie/) {
	$width = $graphObject->getPieWidth() * $graphScale;
	$height = $graphObject->getPieHeight() * $graphScale;
} else {
	die("Error: Invalid value for $graphType");
}
&GetGraphSettings;

# Get data for all hosts/metrics
foreach my $host (@$hostArray) {
	&GetData($host);
}

# Average Gathered Data
&AverageData;

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
my $graphAPI=`$perfhome/cgi/performanceMonitor/content/act_graphAPI GD,$pid`;

###DEBUG Print###
#print $request->header();
#print("test: $graphAPI");

# Output Graph
#my $myimage = $mygraph->plot(\@data) or die $mygraph->error;
print header({-type =>'image/png',-expires=>'-1d',-pragma=>'nocache'});
print $graphAPI;
#print $myimage->png;

# Average all data foreach metric
sub AverageData {

	# turn off strics refs
	no strict "refs";

	my $total=();
	my $average=();
	my $data_ref=();

	#foreach my $key (sort keys %allMetricIndex) {
	foreach my $key (@metricNames) {
		$data_ref=@{$key};

		push(@keys,$key);
        	foreach my $num (@{$key}) {
               		$total += $num;
        	}
		push(@totals, $total);
		push(@refs, $data_ref);

        	$average=$total / $data_ref;

        	# Build array with all metric averages
        	push(@metricAverages, $average);

		# Undefine values
        	undef $data_ref;
        	undef $total;
        	undef $average;
	}
}

# Create graph label array
sub GraphLabel {

	my $count=0;
	foreach my $metric (@metricNames) {
		my $digitsToCut="3";
		my $metricValue=$metricAverages[$count];

		if ($metricValue=~/\d+\.(\d){$digitsToCut,}/) {
    			$metricValue=sprintf("%.".($digitsToCut - 1)."f", $metricValue);
		}

		my $metricLabel="$metric:$metricValue";
		push(@label,$metricLabel);
		$count++;
	}
}
	
# Get Graph settings
sub GetGraphSettings {
	$graphTitle=$graphObject->getTitle();
	$graphVerticalLabel=$graphObject->getVerticalLabel();

	my $i=();
	my $data_ref=\@{$graphObject->{metricArray}};

	foreach ($i=0; $i <= $#$data_ref; $i++) {

        	my $graphMetricName = @{$graphObject->{metricArray}}[$i]->getName();
        	my $metricColor = @{$graphObject->{metricArray}}[$i]->getColor();

        	push(@metricNames,$graphMetricName);
        	push(@colors,$metricColor);
		push (@graphMetrics,$graphMetricName);
		$allMetricIndex{$graphMetricName}="1";
	}
}

# Get all data points foreach metric based on time period
sub GetData {

	# turn off strics refs
	no strict "refs";

	my $host=shift;

	#my $metrics=join(",", @{$host});
	#foreach my $metric (sort keys %graphMetricHash) {
	#	push(@graphMetrics,$metric);
	#}

	my $metrics=join(",", @graphMetrics);

	# HACK to get hostGroup graphs to work with total
	if (-f "$perfhome/rrd/$host/$host.$serviceName.Total.rrd") {
		$serviceName="$serviceName.Total";
	}

	my $report_cmd="$perfhome/bin/tools/perfreport -h $host -s $serviceName -m $metrics -dump -end now -begin $period";

	# Build Hash for sorting data
	my $count="1";
	#foreach my $metric (@{$host}) {
	my $graphMetricCount="1";
	#foreach my $metric (sort keys %graphMetricHash) {
	foreach my $metric (@graphMetrics) {
        	#$metricHash{$count}="$metric";
        	${$host}{$count}="$metric";
        	$count++;
		$graphMetricCount ++;
	}

	# Dump data for time period into array
	my $getData=`$report_cmd`;
	my @dumpArray=split(" ", $getData);

	# Find out how many metrics we are dealing with
	my $numMetrics=@graphMetrics;
	#my $numMetrics=$graphMetricCount;

	# Create array for each metric
	my $arrayCount="1";
	my $metricCount="1";
	my $offset="0";
	my $lastMetric=();

	foreach my $line (@dumpArray) {
        	#foreach $key (sort keys %metricHash) {
        	foreach my $key (sort keys %{$host}) {
			# Set offset
			if ($key =~ m/$numMetrics/) {
				$lastMetric="1";
				$offset++;
			}
			if ($arrayCount =~ m/$metricCount/) {
				#print "host: $host metric: ${$host}{$key} value: $line\n";
				# Count only metric who have values
				if ($line !~ m/NaN/) {
               				push(@{${$host}{$key}}, $line);
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
