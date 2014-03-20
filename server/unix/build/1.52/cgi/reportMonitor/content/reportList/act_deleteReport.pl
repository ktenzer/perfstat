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
my $reportName = $request->param('reportName');
deleteReport($adminName, $userName, $reportName);


################################################### SUBROUTINES
#DELETE REPORT
sub deleteReport {
	my ($adminName, $userName, $reportName) = @_;
	## Delete file
	unlink("$perfhome/var/db/users/$userName/reports/$reportName.ser") or die ("ERROR: Couldn't remove file $perfhome/var/db/users/$userName/reports/$reportName.ser\n");

	## Update User2Report Index								
	my $user2Report = lock_retrieve("$perfhome/var/db/mappings/user2Report.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2Report.ser");
	foreach my $admin (keys(%$user2Report)) {
	my $ownerList = $user2Report->{$admin};
		foreach my $owner (keys(%$ownerList)) {
			my $userList = $ownerList->{$owner};
			foreach my $user (keys(%$userList)) {
				my $reportNameList = $userList->{$user};
				foreach my $loopReportName (keys(%$reportNameList)) {
					if ($reportName eq $loopReportName) {
						delete($user2Report->{$admin}->{$owner}->{$user}->{$reportName});
					}
				}
			}
		}
	}
	lock_store($user2Report, "$perfhome/var/db/mappings/user2Report.ser") or die("Can't store admin2Host in $perfhome/var/db/mappings/user2Report.ser\n");
}

1;