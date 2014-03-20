$sessionObj->param("userMessage1", "");
my $errorMessage = "";

$adminName = $sessionObj->param('selectedAdmin');
$userName = $sessionObj->param('selectedUser');
my $reportNameID = $request->param('reportNameID');
my $hostGroupID = $request->param('hostGroupID');

$selectHosts = [];
$cpu = [];
$memory = [];
$os = [];

@$selectHosts = $request->param('selectHosts');
@$cpu = $request->param('cpu');
@$memory = $request->param('memory');
@$os = $request->param('os');

my $hostString = "";
if (@$selectHosts == 0) {
	$errorMessage = "Select a host";
} else {
	foreach my $hostName (@$selectHosts) {
		$hostString = $hostString . "&selectHosts=" .  $hostName;
	}
}

my $cpuString = "";
foreach $cpuProperty (@$cpu) {
	$cpuString = $cpuString . "&cpu=" .  $cpuProperty;
}

my $memoryString = "";
foreach $memoryProperty (@$memory) {
	$memoryString = $memoryString . "&memory=" .  $memoryProperty;
}

my $osString = "";
foreach $osProperty (@$os) {
	$osString = $osString . "&os=" .  $osProperty;
}

if (length($errorMessage) eq 0) {
	if (length($cpuString) == 0 && length($memoryString) == 0 && length($osString) == 0) {
		$errorMessage = "Select assets to list";
	}
}

if (length($errorMessage) ne 0) {
	$sessionObj->param("userMessage1", $errorMessage);
	$queryString = "reportNameID=$reportNameID&contentType=hostAssets&hostGroupID=$hostGroupID$hostString$cpuString$memoryString$osString";
} else {
	insertHostAssets($adminName, $userName, $reportNameID, $hostGroupID, $selectHosts, $cpu, $memory, $os);
	$queryString = "reportNameID=$reportNameID&contentType=hostAssets&hostGroupID=$hostGroupID";
}

sub insertHostAssets {
	my ($adminName, $userName, $reportNameID, $hostGroupID, $selectHosts, $cpu, $memory, $os) = @_;
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

		$reportObject->addContent($contentStruct);
		$contentStruct = {};
	}
	lock_store($reportObject, "$perfhome/var/db/users/$userName/reports/$reportNameID.ser") || die("ERROR: can't store reportObject in $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
}


1;