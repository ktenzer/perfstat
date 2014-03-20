$sessionObj->param("userMessage1", "");
my $errorMessage = "";

$adminName = $sessionObj->param('selectedAdmin');
$userName = $sessionObj->param('selectedUser');

my $reportNameID = $request->param('reportNameID');

$selectHostGroups = [];
$selectGraphs = [];
$graphInterval = [];
$graphType = [];

@$selectHostGroups = $request->param('selectHostGroups');
@$selectGraphs = $request->param('selectGraphs');
@$graphInterval = $request->param('graphInterval');
@$graphType = $request->param('graphType');

my $hostGroupString = "";
if (@$selectHostGroups == 0) {
	$errorMessage = "Select a HostGroup";
} else {
	foreach my $hgName (@$selectHostGroups) {
		$hostGroupString = $hostGroupString . "&selectHostGroups=" .  $hgName;
	}
}

my $graphString = "";
if (@$selectGraphs == 0) {
	if (length($errorMessage) eq 0) {
		$errorMessage = "Select a graph";
	}
} else {
	foreach my $graphName (@$selectGraphs) {
		$graphString = $graphString . "&selectGraphs=" .  $graphName;
	}
}

my $graphIntervalString = "";
if (@$graphInterval == 0) {
	if (length($errorMessage) eq 0) {
		$errorMessage = "Select a graph interval";
	}
} else {
	foreach $graphIntervalName (@$graphInterval) {
		$graphIntervalString = $graphIntervalString . "&graphInterval=" .  $graphIntervalName;
	}
}

my $graphTypeString = "";
if (@$graphType == 0) {
	if (length($errorMessage) eq 0) {
		$errorMessage = "Select a graph type";
	}
} else {
	foreach $graphTypeName (@$graphType) {
		$graphTypeString = $graphTypeString . "&graphType=" .  $graphTypeName;
	}
}

if (length($errorMessage) ne 0) {
	$sessionObj->param("userMessage1", $errorMessage);
	$queryString = "reportNameID=$reportNameID&contentType=hostGroupGraphs$hostGroupString$graphString$graphIntervalString$graphTypeString";
} else {
	insertHostGroupGraphs($adminName, $userName, $reportNameID,  $selectHostGroups, $graphInterval, $graphType, $selectGraphs);
	$queryString = "reportNameID=$reportNameID&contentType=hostGroupGraphs";
}

sub insertHostGroupGraphs {
	my ($adminName, $userName, $reportNameID,  $selectHostGroups, $graphInterval, $graphType, $selectGraphs) = @_;
	my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
	foreach my $hgName (@$selectHostGroups) {
		foreach my $graphHolderString (@$selectGraphs) {
			foreach my $interval (@$graphInterval) {
				foreach my $type (@$graphType) {
					my $graphStruct = {};
					$graphStruct->{'contentType'} = "hostGroupGraph";
					my @splitString = split(/\^/, $graphHolderString);
					$graphStruct->{'hgName'} = $hgName;
					$graphStruct->{'serviceName'} = $splitString[0];
					$graphStruct->{'graphName'} = $splitString[1];
					$graphStruct->{'intervalName'} = $interval;
					$graphStruct->{'graphType'} = $type;
					$reportObject->addContent($graphStruct);
				}
			}
		}
	}
	lock_store($reportObject, "$perfhome/var/db/users/$userName/reports/$reportNameID.ser") || die("ERROR: can't store reportObject in $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
}


1;