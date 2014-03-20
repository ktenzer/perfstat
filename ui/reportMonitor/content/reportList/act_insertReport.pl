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

if (defined($request->param('reportName'))) {
	$reportName = $request->param('reportName');
} else {
	$reportName = "";
}
if (defined($request->param('description'))) {
	$description = $request->param('description');
} else {
	$description = ""
}

checkAdminName($adminName);
syncAdminName($adminName);
checkUserName($adminName, $userName);
syncUserName($userName);
$errorMessage = checkReportName($userName, $reportName);
if (length($errorMessage) ne 0) {
	$sessionObj->param("userMessage", $errorMessage);
	my $queryString = "adminName=". URLEncode($adminName) .
					"&userName=". URLEncode($userName) .
					"&reportName=" . URLEncode($reportName) .
					"&description=" . URLEncode($description);
	metaRedirect(0, "index.pl?$queryString");
} else {
	insertReport($adminName, $userName, $reportName, $description);
	my $queryString =  "updateNav=1" .
					"&reportNameID=" . URLEncode($reportName);
	metaRedirect(0, "index.pl?$queryString");
}
################################################### SUBROUTINES
#INSERT Report
sub insertReport {
	my ($adminName, $userName, $reportName, $description) = @_;
	
	# Create host group object
	my $reportObject = Report->new(	name	=> $reportName,
								description 	=> $description);
	# Serialize hostGroupObject to disk
	$reportObject->lock_store("$perfhome/var/db/users/$userName/reports/$reportName.ser") or die("ERROR: Can't store $perfhome/var/db/users/$userName/reports/$reportName.ser\n");
	
	# Update User2Report Index								
	my $user2Report = lock_retrieve("$perfhome/var/db/mappings/user2Report.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2Report.ser");
	$user2Report->{$adminName}->{$userName}->{$userName}->{$reportName} = "rw";
	lock_store($user2Report, "$perfhome/var/db/mappings/user2Report.ser") or die("Can't store admin2Host in $perfhome/var/db/mappings/user2Report.ser\n");
}

1;