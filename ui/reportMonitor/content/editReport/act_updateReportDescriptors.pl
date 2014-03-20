use strict;
package main;
require("lib_inputCheck.pl");

# Set UserIndex
$userIndex = setUserIndex();	

# init message variables
$sessionObj->param("userMessage", "");
my $errorMessage = "";

# Define AdminName and hostGroupOwner
$adminName = $sessionObj->param("selectedAdmin");
$userName = $sessionObj->param("selectedUser");
$reportNameID = $request->param("reportNameID");

if (defined($request->param("reportName"))) {
	$reportName = $request->param("reportName");
} else {
	$reportName = ""
}
if (defined($request->param("description"))) {
	$description = $request->param("description");
} else {
	$description = ""
}

checkAdminName($adminName);
syncAdminName($adminName);
checkUserName($adminName, $userName);
syncUserName($userName);
$errorMessage = checkReportName($userName, $reportNameID, $reportName);
if (length($errorMessage) ne 0) {
	$sessionObj->param("userMessage", $errorMessage);
	my $queryString = "action=displayEditReport" .
					"adminName=". URLEncode($adminName) .
					"&userName=". URLEncode($userName) .
					"&reportNameID=" . URLEncode($reportNameID) .
					"&reportName=" . URLEncode($reportName) .
					"&description=" . URLEncode($description);
	metaRedirect(0, "index.pl?$queryString");
} else {
	updateReport($adminName, $userName, $reportNameID, $reportName, $description);
	$sessionObj->param("userMessage", "Report Updated");
	my $queryString = "adminName=". URLEncode($adminName) .
					"&userName=". URLEncode($userName) .
					"&reportNameID=" . URLEncode($reportName) .
					"&reportName=" . URLEncode($reportName) .
					"&description=" . URLEncode($description) .
					"&updateNav=1";
	metaRedirect(0, "index.pl?$queryString");
}
################################################### SUBROUTINES
#update Report
sub updateReport {
	my ($adminName, $userName, $reportNameID, $reportName, $description) = @_;

	# Retrieve host group object
	my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
	if ($reportNameID ne $reportName) {
		$reportObject->setName($reportName);
	}
	$reportObject->setDescription($description);
	$reportObject->lock_store("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("ERROR: Can't store $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
	rename("$perfhome/var/db/users/$userName/reports/$reportNameID.ser","$perfhome/var/db/users/$userName/reports/$reportName.ser") or die "ERROR: Couldn't rename $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n";
	
	if ($reportNameID ne $reportName) {
		## Update User2Report Index								
		my $user2Report = lock_retrieve("$perfhome/var/db/mappings/user2Report.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2Report.ser\n");
		$user2Report->{$adminName}->{$userName}->{$userName}->{$reportName} = $user2Report->{$adminName}->{$userName}->{$userName}->{$reportNameID};
		delete($user2Report->{$adminName}->{$userName}->{$userName}->{$reportNameID});
		lock_store($user2Report, "$perfhome/var/db/mappings/user2Report.ser") or die("Can't store admin2Host in $perfhome/var/db/mappings/user2Report.ser\n");
	}
}

1;