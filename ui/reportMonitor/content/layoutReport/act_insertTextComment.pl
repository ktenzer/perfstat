$sessionObj->param("userMessage1", "");
my $errorMessage = "";

$adminName = $sessionObj->param('selectedAdmin');
$userName = $sessionObj->param('selectedUser');
my $reportNameID = $request->param('reportNameID');
$textComment = trim($request->param('textComment'));
if (length($textComment) == 0) {
	$errorMessage = "Please enter a text comment";
}
if (length($errorMessage) ne 0) {
	$sessionObj->param("userMessage1", $errorMessage);
	$queryString = "reportNameID=$reportNameID&contentType=textComment";
} else {
	insertTextComment($adminName, $userName, $reportNameID, $textComment);
	$queryString = "reportNameID=$reportNameID&contentType=textComment";
}

sub insertTextComment {
	my ($adminName, $userName, $reportNameID, $textComment) = @_;
	my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
	my $graphStruct = {};	
	$graphStruct->{'contentType'} = "textComment";
	$graphStruct->{'textComment'} = $textComment;
	$reportObject->addContent($graphStruct);
	lock_store($reportObject, "$perfhome/var/db/users/$userName/reports/$reportNameID.ser") || die("ERROR: can't store reportObject in $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
}


1;