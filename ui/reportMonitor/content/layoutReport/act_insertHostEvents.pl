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

$selectHosts = [];
$selectServices = [];

@$selectHosts = $request->param('selectHosts');
@$selectServices = $request->param('selectServices');

my $hostString = "";
if (@$selectHosts == 0) {
	$errorMessage = "Select a host";
} else {
	foreach my $hostName (@$selectHosts) {
		$hostString = $hostString . "&selectHosts=" .  $hostName;
	}
}

my $serviceString = "";
if (@$selectServices == 0) {
	if (length($errorMessage) eq 0) {
		$errorMessage = "Select a Service";
	}
} else {
	foreach my $serviceName (@$selectServices) {
		$serviceString = $serviceString . "&selectServices=" .  $serviceName;
	}
}

if (length($errorMessage) ne 0) {
	$sessionObj->param("userMessage1", $errorMessage);
	$queryString = "reportNameID=$reportNameID&contentType=hostEvents&hostGroupID=$hostGroupID$hostString$serviceString";
} else {
	insertHostEvents($adminName, $userName, $hostGroupID, $reportNameID, $selectHosts, $selectServices);
	$queryString = "reportNameID=$reportNameID&contentType=hostEvents&hostGroupID=$hostGroupID";
}

sub insertHostEvents {
	my ($adminName, $userName, $hostGroupID, $reportNameID, $selectHosts, $selectServices) = @_;
	my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
	foreach my $hostName (@$selectHosts) {
		foreach my $serviceName (@$selectServices) {
			my $contentStruct = {};
			$contentStruct->{'contentType'} = "hostEvent";
			$contentStruct->{'hgName'} = $hostGroupID;
			$contentStruct->{'hostName'} = $hostName;
			$contentStruct->{'serviceName'} = $serviceName;
			$reportObject->addContent($contentStruct);
		}
	}
	lock_store($reportObject, "$perfhome/var/db/users/$userName/reports/$reportNameID.ser") || die("ERROR: can't store reportObject in $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
}

1;