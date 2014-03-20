use strict;
package main;

# Define AdminName and reportOwner
$adminName = $sessionObj->param("selectedAdmin");
$userName = $sessionObj->param("selectedUser");

$reportName = $request->param('reportName');

#define array of users to list in share dropdown
my $admin2User = lock_retrieve("$perfhome/var/db/mappings/admin2User.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2User.ser");
$potentialShareMembers = $admin2User->{$adminName};
delete($potentialShareMembers->{$userName});

# Find members already in share
my $user2Report = lock_retrieve("$perfhome/var/db/mappings/user2Report.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2Report.ser");

$shareMembers = {};

my $ownerList = $user2Report->{$adminName};
foreach my $owner (keys(%$ownerList)) {
	if ($owner eq $userName) {
		my $userList = $ownerList->{$owner};
		foreach my $user (keys(%$userList)) {
			if ($user ne $userName) {
				my $reportNameList = $userList->{$user};
				foreach my $indexedName (keys(%$reportNameList)) {
					if ($indexedName eq $reportName) {
						$shareMembers->{$user} = 0;
						delete($potentialShareMembers->{$user});
					}
				}
			}	
		}
	}
}

1;