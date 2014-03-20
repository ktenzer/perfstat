$sessionObj->param("userMessage1", "");
my $errorMessage = "";

$adminName = $sessionObj->param('selectedAdmin');
$userName = $sessionObj->param('selectedUser');
my $hostGroupID = $request->param('hostGroupID');
my $reportNameID = $request->param('reportNameID');
my $contentID = $request->param('contentID');

$selectHosts = [];
$cpu = [];
$memory = [];
$os = [];

@$selectHosts = $request->param('selectHosts');
@$cpu = $request->param('cpu');
@$memory = $request->param('memory');
@$os = $request->param('os');

if (@$selectHosts == 0) {
	die('Error: undefined value for $selectHosts');
}

my $cpuString = "";
if (@$cpu == 0) {
	$cpuString ="&cpu="
} else {
	foreach $cpuProperty (@$cpu) {
		$cpuString = $cpuString . "&cpu=" .  $cpuProperty;
	}
}

my $memoryString = "";
if (@$memory == 0) {
	$memoryString ="&memory="
} else {
	foreach $memoryProperty (@$memory) {
		$memoryString = $memoryString . "&memory=" .  $memoryProperty;
	}
}

my $osString = "";
if (@$os == 0) {
	$osString ="&os="
} else {
	foreach $osProperty (@$os) {
		$osString = $osString . "&os=" .  $osProperty;
	}
}

if (length($errorMessage) eq 0) {
	if (@$cpu == 0 && @$memory == 0 && @$os == 0) {
		$errorMessage = "Select assets to list";
	}
}

if (length($errorMessage) ne 0) {
	$sessionObj->param("userMessage1", $errorMessage);
	$queryString = "reportNameID=$reportNameID&contentID=$contentID&displayMode=edit&contentType=hostAssets&hostGroupID=$hostGroupID$hostString$cpuString$memoryString$osString";
} else {
	updateHostAssets($adminName, $userName, $reportNameID, $contentID, $hostGroupID, $selectHosts, $cpu, $memory, $os);
	$queryString = "reportNameID=$reportNameID";
}

sub updateHostAssets {
	my ($adminName, $userName, $reportNameID, $contentID, $hostGroupID, $selectHosts, $cpu, $memory, $os) = @_;
	my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
	my $graphStruct = {};
	foreach my $hostName (@$selectHosts) {
		$contentStruct = {};	
		$contentStruct->{'contentType'} = "hostAssets";
		$contentStruct->{'hgName'} = $hostGroupID;
		$contentStruct->{'hostName'} = $hostName;

		my @cpuArray = @$cpu;
		$contentStruct->{'cpuAssets'} = \@cpuArray;

		my @memArray = @$memory;
		$contentStruct->{'memoryAssets'} = \@memArray;

		my @osArray = @$os;
		$contentStruct->{'osAssets'} = \@osArray;

		$reportObject->updateContent($contentStruct, $contentID);
		$contentStruct = {};
	}
	lock_store($reportObject, "$perfhome/var/db/users/$userName/reports/$reportNameID.ser") || die("ERROR: can't store reportObject in $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
}


1;