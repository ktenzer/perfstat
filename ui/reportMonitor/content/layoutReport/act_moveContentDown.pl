$sessionObj->param("userMessage1", "");
my $errorMessage = "";

$adminName = $sessionObj->param('selectedAdmin');
$userName = $sessionObj->param('selectedUser');

my $reportNameID = $request->param('reportNameID');
my $contentID = $request->param('contentID');
my $contentType = $request->param('contentType');

my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");

my $contentArray = $reportObject->getContentArray();

$tempStruct = $contentArray->[$contentID + 1];
$contentArray->[$contentID + 1] = $contentArray->[$contentID];
$contentArray->[$contentID] = $tempStruct;

lock_store($reportObject, "$perfhome/var/db/users/$userName/reports/$reportNameID.ser") || die("ERROR: can't store reportObject in $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");

$queryString = "reportNameID=$reportNameID&contentType=$contentType";

1;