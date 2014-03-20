use strict;
package main;

# Define AdminName and hostGroupOwner
$adminName = $sessionObj->param("selectedAdmin");
$userName = $sessionObj->param("selectedUser");

$hgName = $request->param('hgName');

#define array of users to list in share dropdown
my $admin2User = lock_retrieve("$perfhome/var/db/mappings/admin2User.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2User.ser");
$potentialShareMembers = $admin2User->{$adminName};
delete($potentialShareMembers->{$userName});

# Find members already in share
my $user2HostGroup = lock_retrieve("$perfhome/var/db/mappings/user2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2HostGroup.ser");

$shareMembers = {};

my $ownerList = $user2HostGroup->{$adminName};
foreach my $owner (keys(%$ownerList)) {
	if ($owner eq $userName) {
		my $userList = $ownerList->{$owner};
		foreach my $user (keys(%$userList)) {
			if ($user ne $userName) {
				my $hgNameList = $userList->{$user};
				foreach my $indexedName (keys(%$hgNameList)) {
					if ($indexedName eq $hgName) {
						$shareMembers->{$user} = 0;
						delete($potentialShareMembers->{$user});
					}
				}
			}	
		}
	}
}

1;