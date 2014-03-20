$sessionObj->param("userMessage1", "");
my $errorMessage = "";

$adminName = $sessionObj->param('selectedAdmin');
$userName = $sessionObj->param('selectedUser');
my $reportNameID = $request->param('reportNameID');
my $contentID = $request->param('contentID');

$selectHostGroups = [];
$selectGraphs = [];
$graphInterval = [];
$graphType = [];

@$selectHostGroups = $request->param('selectHostGroups');
@$selectGraphs = $request->param('selectGraphs');
@$graphInterval = $request->param('graphInterval');
@$graphType = $request->param('graphType');

if (@$selectHostGroups == 0) {
	die('Error: undefined value for $selectHostGroups');
}

if (@$selectGraphs == 0) {
	die('Error: undefined value for $selectGraphs');
}

if (@$graphInterval == 0) {
	die('Error: undefined value for $graphInterval');
}

if (@$graphType == 0) {
	die('Error: undefined value for $graphType');
}

updateHostGroupGraph($adminName, $userName, $reportNameID, $contentID, $selectHostGroups, $graphInterval, $graphType, $selectGraphs);
$queryString = "reportNameID=$reportNameID&contentType=textComment";

sub updateHostGroupGraph {
	my ($adminName, $userName, $reportNameID, $contentID, $selectHostGroups, $graphInterval, $graphType, $selectGraphs) = @_;
	my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
	foreach my $hgName (@$selectHostGroups) {
		foreach my $graphHolderString (@$selectGraphs) {
			foreach my $interval (@$graphInterval) {
				foreach my $type (@$graphType) {
					my $contentStruct = {};
					$contentStruct->{'contentType'} = "hostGroupGraph";
					my @splitString = split(/\^/, $graphHolderString);
					$contentStruct->{'hgName'} = $hgName;
					$contentStruct->{'serviceName'} = $splitString[0];
					$contentStruct->{'graphName'} = $splitString[1];
					$contentStruct->{'intervalName'} = $interval;
					$contentStruct->{'graphType'} = $type;
					$reportObject->updateContent($contentStruct, $contentID);
				}
			}
		}
	}
	lock_store($reportObject, "$perfhome/var/db/users/$userName/reports/$reportNameID.ser") || die("ERROR: can't store reportObject in $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
}


1;