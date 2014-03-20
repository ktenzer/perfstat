use strict;
package main;

# Define AdminName and hostGroupOwner
$adminName = $sessionObj->param("selectedAdmin");
my $reportOwner =  $request->param("reportOwner");
$reportName = $request->param("reportName");

if( defined($request->param('updateNav'))) {
	$updateNav = "parent.navigation.closeAll(); parent.navigation.Toggle('$reportOwner^$reportName')"
} else {
	$updateNav = "";
}

my $reportObject = lock_retrieve("$perfhome/var/db/users/$reportOwner/reports/$reportName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$reportOwner/reports/$reportName.ser\n");
my $contentArray = $reportObject->getContentArray();
my $numColumns = $reportObject->getNumColumns();
my $graphSize = $reportObject->getGraphSize();
my $customGraphSize = $reportObject->getCustomGraphSize();
if ($graphSize =~ /small/) {
	$graphScale = .66666;
	$fontSize = "9px";
} elsif ($graphSize =~ /medium/) {
	$graphScale = 1;
	$fontSize = "11";
} elsif ($graphSize =~ /large/) {
	$graphScale = 1.33333;
	$fontSize = "11px";
} elsif ($graphSize =~ /custom/) {
	if ( $customGraphSize < 50 || $customGraphSize > 300) {die("Error: custom graph size must be between 50 and 300");}
	$graphScale = $customGraphSize/100;
	$fontSize = "11px";
}
my $customFontSize = $reportObject->getCustomFontSize();
if ($customFontSize != "") {
	$fontSize = $customFontSize . "px";	
}

my $useShortDomainNames = $reportObject->getUseShortDomainNames();

# Create Interim Display Model
my $tempRowArray = [];
my $graphArray = [];
my $nonGraphArray = [];
foreach $contentStruct (@$contentArray) {
	if (exists($contentStruct->{'hostName'})) {
		my $displayHostName = $contentStruct->{'hostName'};
		if ($useShortDomainNames) {
			$displayHostName =~ /(^[\S]+?)\./;
			$displayHostName = $1;
		}
		$contentStruct->{'displayHostName'} = $displayHostName;
	}
	if ($contentStruct->{'contentType'} eq "hostGroupGraph") {
		my $tempStruct = {};
		$tempStruct->{'colSpan'} = 1;
		$tempStruct->{'payload'} = $contentStruct;
		push(@$graphArray, $tempStruct);
	} elsif ($contentStruct->{'contentType'} eq "hostGraph") {
		my $tempStruct = {};
		$tempStruct->{'colSpan'} = 1;
		$tempStruct->{'payload'} = $contentStruct;
		push(@$graphArray, $tempStruct);
	} else { #NON GRAPH CONTENT
		if (@$graphArray != 0) {
			push(@$tempRowArray, $graphArray);
			$graphArray = [];
		}
		my $tempStruct = {};
		$tempStruct->{'colSpan'} = $numColumns;
		$tempStruct->{'payload'} = $contentStruct;
		push(@$nonGraphArray, $tempStruct);
		push(@$tempRowArray, $nonGraphArray);
		$nonGraphArray = [];
	}
}
if (@$graphArray != 0) {
	push(@$tempRowArray, $graphArray);
	$graphArray = [];
}

# Create Display Model
$displayRowArray = [];
foreach my $tempColArray (@$tempRowArray) {
	if (@$tempColArray == $numColumns) {
		push(@$displayRowArray, $tempColArray);
	} else {
		#calculate totalColSpan
		my $totalColSpan = 0;
		foreach my $tempStruct (@$tempColArray) {
			my $colSpan = $tempStruct->{'colSpan'};
			$totalColSpan = $totalColSpan + $tempStruct->{'colSpan'};
		}
		if ($totalColSpan == $numColumns) {
			push(@$displayRowArray, $tempColArray);
		} elsif ($totalColSpan < $numColumns) {
			my $colSpanDiff = $numColumns - $totalColSpan;
			for (my $i = 0; $i < $colSpanDiff; $i++) {
				my $tempStruct = {};
				$tempStruct->{'colSpan'} = 1;
				my $contentStruct = {};
				$contentStruct->{'contentType'} = "blank";
				$tempStruct->{'payload'} = $contentStruct;
				push(@$tempColArray, $tempStruct);
			}
			push(@$displayRowArray, $tempColArray);
		} elsif ($totalColSpan > $numColumns) {
			my $totalColSpan = 0;
			my $newTempColArray = [];
			foreach my $tempStruct (@$tempColArray) {
				$totalColSpan = $totalColSpan + $tempStruct->{'colSpan'};
				push(@$newTempColArray, $tempStruct);
				if ($totalColSpan == $numColumns) {
					push(@$displayRowArray, $newTempColArray);
					$totalColSpan = 0;
					$newTempColArray = [];
				}
			}
			if (@$newTempColArray) {
				my $colSpanDiff = $numColumns - @$newTempColArray;
				for (my $i = 0; $i < $colSpanDiff; $i++) {
					my $tempStruct = {};
					$tempStruct->{'colSpan'} = 1;
					my $contentStruct = {};
					$contentStruct->{'contentType'} = "blank";
					$tempStruct->{'payload'} = $contentStruct;
					push(@$newTempColArray, $tempStruct);
				}
				push(@$displayRowArray, $newTempColArray);
			}
		}
	}
}
#foreach my $tempColArray (@$displayRowArray) {
#	foreach my $tempStruct (@$tempColArray) {
#		my $colSpan = $tempStruct->{'colSpan'};
#		my $contentType = $tempStruct->{'payload'}->{'contentType'};
#		print("[$colSpan ::  $contentType]   ");
#	}
#	print("<BR>");
#}

1;