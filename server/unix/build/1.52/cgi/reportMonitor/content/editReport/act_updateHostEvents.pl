$sessionObj->param("userMessage1", "");
my $errorMessage = "";

$adminName = $sessionObj->param('selectedAdmin');
$userName = $sessionObj->param('selectedUser');
my $hostGroupID = $request->param('hostGroupID');
my $reportNameID = $request->param('reportNameID');
my $contentID = $request->param('contentID');

if (defined( $request->param('hostGroupID'))) {
	$hostGroupID = $request->param('hostGroupID');
} else {
	die("Error: undefined value for hostGroupID");
}

$selectHosts = [];
$selectServices = [];

@$selectHosts = $request->param('selectHosts');
@$selectServices = $request->param('selectServices');

if (@$selectHosts == 0) {
	die('Error: undefined value for $selectHosts');
}

if (@$selectServices == 0) {
	die('Error: undefined value for $selectServices');
}

updateHostEvent($adminName, $userName, $hostGroupID, $reportNameID, $contentID, $selectHosts, $selectServices);
$queryString = "reportNameID=$reportNameID";

sub updateHostEvent {
	my ($adminName, $userName, $hostGroupID, $reportNameID, $contentID, $selectHosts, $selectServices) = @_;
	my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
	foreach my $hostName (@$selectHosts) {
		foreach my $serviceName (@$selectServices) {
			my $contentStruct = {};
			$contentStruct->{'contentType'} = "hostEvent";
			$contentStruct->{'hgName'} = $hostGroupID;
			$contentStruct->{'hostName'} = $hostName;
			$contentStruct->{'serviceName'} = $serviceName;
			$reportObject->updateContent($contentStruct, $contentID);
		}
	}
	lock_store($reportObject, "$perfhome/var/db/users/$userName/reports/$reportNameID.ser") || die("ERROR: can't store reportObject in $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
}

1;