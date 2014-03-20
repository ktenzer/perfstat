$sessionObj->param("userMessage3", "");
my $errorMessage = "";

$adminName = $sessionObj->param('selectedAdmin');
$userName = $sessionObj->param('selectedUser');

my $reportNameID = $request->param('reportNameID');
my $contentID = $request->param('contentID');
my $contentType = $request->param('contentType');

if (!defined($request->param("numColumns"))) {
	$numColumns = "1";
} else {
	$numColumns = $request->param("numColumns");
}

if (!defined($request->param("graphSize"))) {
	$graphSize = "medium";
} else {
	$graphSize = $request->param("graphSize");
}
if (!defined($request->param("customGraphSize"))) {
	$customGraphSize = "0";
} else {
	$customGraphSize = $request->param("customGraphSize");
}
if($graphSize eq "custom") {
	if ( $customGraphSize < 50 || $customGraphSize > 300) {
      	$errorMessage = "Error: custom graph size must be between 50 and 300";
    }
} else {
	$customGraphSize = "";
}

if (!defined($request->param("customFontSize"))) {
	$customFontSize = "";
} else {
	$customFontSize = $request->param("customFontSize");
	if ($customFontSize != "") {
		if ( $customFontSize < 6 || $customFontSize > 20) {
      		$errorMessage = "Error: custom font size must be between 6 and 20";
    	}
	}
}

if (!defined($request->param("useShortDomainNames"))) {
	$useShortDomainNames = 0;
} else {
	$useShortDomainNames = $request->param("useShortDomainNames");
	if ($useShortDomainNames != 0 && $useShortDomainNames != 1) {
		$useShortDomainNames = 0;
	}
}

if (length($errorMessage) ne 0) {
	$sessionObj->param("userMessage3", $errorMessage);
	$queryString = "reportNameID=$reportNameID" .
					"&contentType=$contentType" .
					"&numColumns=$numColumns" .
					"&graphSize=$graphSize" .
					"&customGraphSize=$customGraphSize" .
					"&customFontSize=$customFontSize" .
					"&useShortDomainNames=$useShortDomainNames";
} else {
	my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");

	$reportObject->setNumColumns($numColumns);
	$reportObject->setGraphSize($graphSize);
	$reportObject->setCustomGraphSize($customGraphSize);
	$reportObject->setCustomFontSize($customFontSize);
	$reportObject->setUseShortDomainNames($useShortDomainNames);
	
	lock_store($reportObject, "$perfhome/var/db/users/$userName/reports/$reportNameID.ser") || die("ERROR: can't store reportObject in $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
	$queryString = "reportNameID=$reportNameID&contentType=$contentType";
}


1;