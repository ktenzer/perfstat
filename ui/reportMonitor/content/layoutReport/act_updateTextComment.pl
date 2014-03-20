$sessionObj->param("userMessage1", "");
my $errorMessage = "";

$adminName = $sessionObj->param('selectedAdmin');
$userName = $sessionObj->param('selectedUser');
my $reportNameID = $request->param('reportNameID');
my $contentID = $request->param('contentID');
$textComment = trim($request->param('textComment'));
if (length($textComment) == 0) {
	$errorMessage = "Please enter a text comment";
}
if (length($errorMessage) ne 0) {
	$sessionObj->param("userMessage1", $errorMessage);
	$queryString = "displayMode=edit&contentType=textComment&reportNameID=$reportNameID&contentID=$contentID";
} else {
	updateTextComment($adminName, $userName, $reportNameID, $contentID, $textComment);
	$queryString = "reportNameID=$reportNameID&contentType=textComment";
}

sub updateTextComment {
	my ($adminName, $userName, $reportNameID, $contentID, $textComment) = @_;
	my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
	my $contentStruct = {};	
	$contentStruct->{'contentType'} = "textComment";
	$contentStruct->{'textComment'} = $textComment;
	$reportObject->updateContent($contentStruct, $contentID);
	lock_store($reportObject, "$perfhome/var/db/users/$userName/reports/$reportNameID.ser") || die("ERROR: can't store reportObject in $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
}


1;