use strict;
package main;

# Define AdminName and hostGroupOwner
$adminName = $sessionObj->param('selectedAdmin');
my $reportOwner =  $request->param("reportOwner");
$userName = $sessionObj->param('selectedUser');
$reportNameID = $request->param('reportNameID');

# report descriptors
$reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");

if (defined($request->param("reportName"))) {
	$reportName = $request->param("reportName");
} else {
	$reportName = $reportObject->getName();
}

if( defined($request->param('updateNav'))) {
	$updateNav = "parent.navigation.closeAll(); parent.navigation.Toggle('$reportOwner^$reportName')"
} else {
	$updateNav = "";
}

# report content
if (defined($request->param('numColumns'))) {
	$numColumns = $request->param('numColumns');
} else {
	$numColumns = $reportObject->getNumColumns();
}
if (defined($request->param('graphSize'))) {
	$graphSize = $request->param('graphSize');
} else {
	$graphSize = $reportObject->getGraphSize();
}
if (defined($request->param('customGraphSize'))) {
	$customGraphSize = $request->param('customGraphSize');
} else {
	$customGraphSize = $reportObject->getCustomGraphSize();
}
if (defined($request->param('customFontSize'))) {
	$customFontSize = $request->param('customFontSize');
} else {
	$customFontSize = $reportObject->getCustomFontSize();
}
if (defined($request->param('useShortDomainNames'))) {
	$useShortDomainNames = $request->param('useShortDomainNames');
} else {
	$useShortDomainNames = $reportObject->getUseShortDomainNames();
}


# Whether we are adding or editing an element
if( !defined($request->param('displayMode'))) {
	$displayMode = "add";
} else {
	$displayMode = $request->param('displayMode');
}

if ($displayMode eq "add") {
	# content type to look at
	if( !defined($request->param('contentType'))) {
		$contentType = "textComment";
	} else {
		$contentType = $request->param('contentType');
	}
	if ($contentType eq "textComment") {
		require("act_initSelectTextComment.pl");	
	} elsif ($contentType eq "hostGroupGraphs") {
		require("act_initSelectHostGroupGraphs.pl");
	} elsif ($contentType eq "hostAssets") {
		require("act_initSelectHostAssets.pl");
	} elsif ($contentType eq "hostEvents") {
		require("act_initSelectHostEvents.pl");
	} elsif ($contentType eq "hostGraphs") {
		require("act_initSelectHostGraphs.pl");
	} else {
		die("Error: invalid value for contentType");
	}
} elsif ($displayMode eq "edit") {
	if( !defined($request->param('contentType'))) {
		die("Error: undefined value for contentType");
	} else {
		$contentType = $request->param('contentType');
	}
	if ($contentType eq "textComment") {
		require("act_initEditTextComment.pl");	
	} elsif ($contentType eq "hostGroupGraph") {
		require("act_initEditHostGroupGraphs.pl");
	} elsif ($contentType eq "hostAssets") {
		require("act_initEditHostAssets.pl");
	} elsif ($contentType eq "hostEvent") {
		require("act_initEditHostEvents.pl");
	} elsif ($contentType eq "hostGraph") {
		require("act_initEditHostGraphs.pl");
	} else {
		die("Error: invalid value for contentType");
	}
} else {
	die("Error: invalid value for displayMode");
}

# report content
$contentArrayLen = $reportObject->getContentArrayLength();
if ($contentArrayLen > 0) {
	$contentDisplayArray = [];
	my $contentArray = $reportObject->getContentArray();
	for (my $i=0; $i < $contentArrayLen; $i++) {
		my $displayStruct = {};
		$displayStruct->{'contentID'} = $i;
		my $contentStruct = $contentArray->[$i];
		# TEXT COMMENT
		if ($contentStruct->{'contentType'}  eq "textComment") {
			$displayStruct->{'contentType'} = "textComment";
			my $textDisplay = "Text Comment :: $contentStruct->{'textComment'}";
			$displayStruct->{'textDisplay'} = $textDisplay;
		# HOST GROUP GRAPH
		} elsif ($contentStruct->{'contentType'} eq "hostGroupGraph") {
			$displayStruct->{'contentType'} = "hostGroupGraph";
			my $textDisplay = "Host Group Graph :: $contentStruct->{'hgName'} :: $contentStruct->{'serviceName'} :: $contentStruct->{'graphName'} :: $contentStruct->{'intervalName'} :: $contentStruct->{'graphType'}";
			$displayStruct->{'textDisplay'} = $textDisplay;
		# HOST ASSET
		} elsif ($contentStruct->{'contentType'}  eq "hostAssets") {
			$displayStruct->{'contentType'} = "hostAssets";
			my $cpuString = "none";
			my $memString = "none";
			my $osString = "none";
			my $assetList1 = $contentStruct->{'cpuAssets'};
			my $numAssets1 = @$assetList1;
			if ($numAssets1) {
				$cpuString = "";
				for (my $i = 0; $i < $numAssets1; $i++) {
					$cpuString = $cpuString . $assetList1->[$i];
					if (($i + 1) != $numAssets1) { 
						$cpuString = $cpuString . ", ";
					}
				}
			}

			my $assetList2 = $contentStruct->{'memoryAssets'};
			my $numAssets2 = @$assetList2;
			if ($numAssets2) {
				$memString = "";
				for (my $i = 0; $i < $numAssets2; $i++) {
					$memString = $memString . $assetList2->[$i];
					if (($i + 1) != $numAssets2) { 
						$memString = $memString . ", ";
					}
				}
			}

			my $assetList3 = $contentStruct->{'osAssets'};
			my $numAssets3 = @$assetList3;
			if ($numAssets3) {
				$osString = "";
				for (my $i = 0; $i < $numAssets3; $i++) {
					$osString = $osString . $assetList3->[$i];
					if (($i + 1) != $numAssets3) { 
						$osString = $osString . ", ";
					}
				}
			}
			
			my $textDisplay = "Host Assets :: $contentStruct->{'hostName'} :: (cpu: $cpuString) :: (mem: $memString) :: (os: $osString)";
			$displayStruct->{'textDisplay'} = $textDisplay;
		# HOST EVENT
		} elsif ($contentStruct->{'contentType'} eq "hostEvent") {
			$displayStruct->{'contentType'} = "hostEvent";
			my $textDisplay = "Host Event :: $contentStruct->{'hostName'} :: $contentStruct->{'serviceName'}";
			$displayStruct->{'textDisplay'} = $textDisplay;
		# HOST GRAPH
		} elsif ($contentStruct->{'contentType'} eq "hostGraph") {
			$displayStruct->{'contentType'} = "hostGraph";
			my $textDisplay;
			if ($contentStruct->{'graphServiceType'} ne "singleSubService") {
				$textDisplay = "Host Graph :: $contentStruct->{'hostName'} :: $contentStruct->{'serviceName'} :: $contentStruct->{'graphName'} :: $contentStruct->{'intervalName'} :: $contentStruct->{'graphType'}";
			} else {
				$textDisplay = "Host Graph :: $contentStruct->{'hostName'} :: $contentStruct->{'serviceName'} :: $contentStruct->{'subServiceName'} :: $contentStruct->{'graphName'} :: $contentStruct->{'intervalName'} :: $contentStruct->{'graphType'}";
			}
			$displayStruct->{'textDisplay'} = $textDisplay;
		}
		push(@$contentDisplayArray, $displayStruct);
	}
}
1;