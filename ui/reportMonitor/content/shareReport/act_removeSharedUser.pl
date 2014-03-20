use strict;
package main;

# Define AdminName and reportOwner
$adminName = $sessionObj->param("selectedAdmin");
$userName = $sessionObj->param("selectedUser");

# Set UserIndex
$userIndex = setUserIndex();	

# init message variables
$sessionObj->param("userMessage", "");
my $errorMessage = "";

checkAdminName($adminName);
syncAdminName($adminName);
checkUserName($adminName, $userName);
syncUserName($userName);
my $memberName = $request->param('memberName');
$reportName = $request->param('reportName');

removeSharedReportMember($adminName, $userName, $memberName, $reportName);

$queryString =  "reportName=" . URLEncode($reportName);

################################################### SUBROUTINES
# Remove HOST GROUP SHARED MEMBER
sub removeSharedReportMember {
	my ($adminName, $ownerName, $memberName, $reportName) = @_;

	# Update user2Report Index								
	my $user2Report = lock_retrieve("$perfhome/var/db/mappings/user2Report.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2Report.ser");
	delete($user2Report->{$adminName}->{$ownerName}->{$memberName}->{$reportName});
	lock_store($user2Report, "$perfhome/var/db/mappings/user2Report.ser") or die("Can't store host2HostGroup in $perfhome/var/db/mappings/user2Report.ser\n");
}

1;