$sessionObj->param("userMessage1", "");
my $errorMessage = "";

$adminName = $sessionObj->param('selectedAdmin');
$userName = $sessionObj->param('selectedUser');
my $reportNameID = $request->param('reportNameID');
my $contentID = $request->param('contentID');

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

if (@$selectGraphs == 0) {
	die('Error: undefined value for $selectGraphs');
}

if (@$selectHosts == 0) {
	die('Error: undefined value for $selectGraphs');
}

if ($graphServiceType eq "singleSubService") {
	if (@$selectSubServices == 0) {
		die('Error: undefined value for $selectGraphs');
	}
}

if (@$graphInterval == 0) {
	die('Error: undefined value for $graphInterval');
}

if (@$graphType == 0) {
	die('Error: undefined value for $graphInterval');
}

updateHostGraph($adminName, $userName, $hostGroupID, $reportNameID, $contentID, $osName, $graphServiceType, $selectGraphs, $selectHosts, $selectSubServices, $graphInterval, $graphType);
$queryString = "reportNameID=$reportNameID";

sub updateHostGraph {
	my ($adminName, $userName, $hostGroupID, $reportNameID, $contentID, $osName, $graphServiceType, $selectGraphs, $selectHosts, $selectSubServices, $graphInterval, $graphType) = @_;
	my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
	if ($graphServiceType ne "singleSubService") {
		push(@$selectSubServices, "null");
	}
	foreach my $hostName (@$selectHosts) {
		foreach my $graphHolderString (@$selectGraphs) {
			foreach my $subServiceName (@$selectSubServices) {
				foreach my $interval (@$graphInterval) {
					foreach my $type (@$graphType) {
						my $contentStruct = {};
						$contentStruct->{'contentType'} = "hostGraph";
						$contentStruct->{'hgName'} = $hostGroupID;
						$contentStruct->{'osName'} = $osName;
						$contentStruct->{'graphServiceType'} = $graphServiceType;
						my @splitString = split(/\^/, $graphHolderString);
						$contentStruct->{'hostName'} = $hostName;
						$contentStruct->{'serviceName'} = $splitString[0];
						$contentStruct->{'subServiceName'} = $subServiceName;
						$contentStruct->{'graphName'} = $splitString[1];
						$contentStruct->{'intervalName'} = $interval;
						$contentStruct->{'graphType'} = $type;
						$reportObject->updateContent($contentStruct, $contentID);
					}
				}
			}
		}
	}
	lock_store($reportObject, "$perfhome/var/db/users/$userName/reports/$reportNameID.ser") || die("ERROR: can't store reportObject in $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
}

1;