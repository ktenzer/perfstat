use strict;
package main;

checkAndSetHostGroupID(0);
checkAndSetHostName(0);

# CURRENT graphSize, graphLayout
if (!defined($request->param("graphSize"))) {
	$graphSize = "medium";
} else {
	$graphSize = $request->param("graphSize");
}

if (!defined($request->param("customSize"))) {
	$customSize = "";
} else {
	$customSize = $request->param("customSize");
}
if ($graphSize =~ /small/) {
	$graphScale = .66666;
} elsif ($graphSize =~ /medium/) {
	$graphScale = 1;
} elsif ($graphSize =~ /large/) {
	$graphScale = 1.33333;
} elsif ($graphSize =~ /custom/) {
	if ( $customSize < 50 || $customSize > 300) {
      		die("Error: custom graph size must be between 50 and 300");
    	}
	$graphScale = $customSize/100;
}

if (!defined($request->param("graphLayout"))) {
	$graphLayout = "1";
} else {
	$graphLayout = $request->param("graphLayout");
}

my $serializedGraphHolderArray =  $request->param('hostGraphHolderArray');
my $rawGraphHolderArray = deserializeGraphHolderArray( $serializedGraphHolderArray);
$refinedGraphHolderArray =  refineRawGraphHolderArray($rawGraphHolderArray);

sub deserializeGraphHolderArray {
	my ($serializedGraphHolderArray) = @_;
	$serializedGraphHolderArray = trim($serializedGraphHolderArray);
	my $graphHolderArray = [];
	while ( $serializedGraphHolderArray  =~  /([^;]+);/g) {
		my $serializedGraphArray = $1;
		my $graphArray = [];
		while ( $serializedGraphArray =~ /([^\^]+)\^/g) {
			push(@$graphArray, $1);
		}
		push (@$graphHolderArray, $graphArray);
	}
	return $graphHolderArray;
}

sub refineRawGraphHolderArray {
	my ($rawGraphHolderArray) = @_;
	my $refinedGraphHolderArray = [];
	foreach my $graphArray (@$rawGraphHolderArray) {
		my $os = $graphArray->[0];
		my $graphIndex = $graphArray->[1];
		my $hostName = $graphArray->[2];
		my $serviceName = $graphArray->[3];
		my $graphName = $graphArray->[4];
		my @intervalArray = @$graphArray[5, 6, 7, 8];
		my @graphTypeArray = @$graphArray[9, 10, 11];
		for (my $count1 = 0; $count1 < 4; $count1++) {
			if ($intervalArray[$count1] != 0) {
				my $intervalName = "";
				if ($count1 == 0) {
					$intervalName = "day";
				} elsif  ($count1 == 1) {
					$intervalName = "week";
				} elsif  ($count1 == 2) {
					$intervalName = "month";
				} elsif  ($count1 == 3) {
					$intervalName = "year";
				} else {
					die('Error: invalid value for $count1');
				}
				for (my $count2 = 0; $count2 <  3; $count2++) {
					if ($graphTypeArray[$count2] != 0) {
						my $graphType = "";
						if ($count2 == 0) {
							$graphType = "line";
						} elsif  ($count2 == 1) {
							$graphType = "bar";
						} elsif  ($count2 == 2) {
							$graphType = "pie";
						} else {
							die('Error: invalid value for $count2');
						}

						my $graphStructure = {}; 
						$graphStructure->{'os'} = $os;
						$graphStructure->{'graphIndex'} = $graphIndex;
						$graphStructure->{'hostName'} = $hostName;
						$graphStructure->{'serviceName'} = $serviceName;
						$graphStructure->{'graphName'} = $graphName;
						$graphStructure->{'intervalName'} = $intervalName;
						$graphStructure->{'graphType'} =  $graphType;
						push (@$refinedGraphHolderArray, $graphStructure);
					}
				}	
			}
		}
	}
	return $refinedGraphHolderArray;
}