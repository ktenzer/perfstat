$sessionObj->param("userMessage1", "");
my $errorMessage = "";

$adminName = $sessionObj->param('selectedAdmin');
$userName = $sessionObj->param('selectedUser');

my $reportNameID = $request->param('reportNameID');

if (defined( $request->param('hostGroupID'))) {
	$hostGroupID = $request->param('hostGroupID');
} else {
	die("Error: undefined value for hostGroupID");
}

if (defined( $request->param('osName'))) {
	$osName = $request->param('osName');
} else {
	die("Error: undefined value for osName");
}

if (defined( $request->param('graphServiceType'))) {
	$graphServiceType = $request->param('graphServiceType');
} else {
	die("Error: undefined value for graphServiceType");
}

$selectGraphs = [];
$selectHosts = [];
$selectSubServices = [];
$graphInterval = [];
$graphType = [];

@$selectGraphs = $request->param('selectGraphs');
@$selectHosts = $request->param('selectHosts');
if ($graphServiceType eq "singleSubService") {
	@$selectSubServices = $request->param('selectSubServices');
}
@$graphInterval = $request->param('graphInterval');
@$graphType = $request->param('graphType');

my $graphString = "";
if (@$selectGraphs == 0) {
	$errorMessage = "Select a graph";
} else {
	foreach my $graphName (@$selectGraphs) {
		$graphString = $graphString . "&selectGraphs=" .  $graphName;
	}
}

my $hostString = "";
if (@$selectHosts == 0) {
	if (length($errorMessage) eq 0) {
		$errorMessage = "Select a Host";
	}
} else {
	foreach my $hostName (@$selectHosts) {
		$hostString = $hostString . "&selectHosts=" .  $hostName;
	}
}
my $subServiceString = "";
if ($graphServiceType eq "singleSubService") {
	if (@$selectSubServices == 0) {
		if (length($errorMessage) eq 0) {
			$errorMessage = "Select a SubService";
		}
	} else {
		foreach my $subServiceName (@$selectSubServices) {
			$subServiceString = $subServiceString . "&selectSubServices=" .  $subServiceName;
		}
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
	$queryString = "reportNameID=$reportNameID&contentType=hostGraphs&hostGroupID=$hostGroupID&osName=$osName&graphServiceType=$graphServiceType$graphString$hostString$subServiceString$graphIntervalString$graphTypeString";
} else {
	insertHostGraphs($adminName, $userName, $hostGroupID, $reportNameID, $osName, $graphServiceType, $selectGraphs, $selectHosts, $selectSubServices, $graphInterval, $graphType);
	$queryString = "reportNameID=$reportNameID&contentType=hostGraphs&hostGroupID=$hostGroupID&osName=$osName&graphServiceType=$graphServiceType";
}

sub insertHostGraphs {
	my ($adminName, $userName, $hostGroupID, $reportNameID, $osName, $graphServiceType, $selectGraphs, $selectHosts, $selectSubServices, $graphInterval, $graphType) = @_;
	my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
	if ($graphServiceType ne "singleSubService") {
		push(@$selectSubServices, "null");
	}
	foreach my $hostName (@$selectHosts) {
		foreach my $graphHolderString (@$selectGraphs) {
			foreach my $subServiceName (@$selectSubServices) {
				foreach my $interval (@$graphInterval) {
					foreach my $type (@$graphType) {
						my $graphStruct = {};
						$graphStruct->{'contentType'} = "hostGraph";
						$graphStruct->{'hgName'} = $hostGroupID;
						$graphStruct->{'osName'} = $osName;
						$graphStruct->{'graphServiceType'} = $graphServiceType;
						my @splitString = split(/\^/, $graphHolderString);
						$graphStruct->{'hostName'} = $hostName;
						$graphStruct->{'serviceName'} = $splitString[0];
						$graphStruct->{'subServiceName'} = $subServiceName;
						$graphStruct->{'graphName'} = $splitString[1];
						$graphStruct->{'intervalName'} = $interval;
						$graphStruct->{'graphType'} = $type;
						$reportObject->addContent($graphStruct);
					}
				}
			}
		}
	}
	lock_store($reportObject, "$perfhome/var/db/users/$userName/reports/$reportNameID.ser") || die("ERROR: can't store reportObject in $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
}

1;