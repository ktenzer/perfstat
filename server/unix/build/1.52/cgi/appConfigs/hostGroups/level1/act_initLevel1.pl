use strict;
package main;

# Define AdminName and hostGroupOwner
$adminName = $sessionObj->param("selectedAdmin");
$userName = $sessionObj->param("selectedUser");

# Define new hostGroupName for updates
if (defined($request->param('hgName'))) {
	$hgNewName = $request->param("hgNewName");
} else {
	$hgNewName = "";
}

# Define description
if (defined($request->param('description'))) {
	$description = $request->param("description");
} else {
	$description = "";
}

#define array of  "My Host Groups" to list
my $user2HostGroup = lock_retrieve("$perfhome/var/db/mappings/user2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2HostGroup.ser");
my $myHostGroupList = $user2HostGroup->{$adminName}->{$userName}->{$userName};

$myHostGroupArray = [];
foreach my $hostGroupName (sort(keys(%$myHostGroupList))) {
	my $hostGroupObject = lock_retrieve("$perfhome/var/db/users/$userName/hostGroups/$hostGroupName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/hostGroups/$hostGroupName.ser");
	my $tempArray = [];
	$tempArray->[0] = $hostGroupName;
	$tempArray->[1] = $hostGroupObject->getDescription();
	$tempArray->[2] = $hostGroupObject->getMemberHashLength();
	push(@$myHostGroupArray, $tempArray)
}

#define array of "Shared Host Groups" to list
$sharedHostGroupArray = [];

my $ownerList = $user2HostGroup->{$adminName};
foreach my $owner (keys(%$ownerList)) {
	if ($owner ne $userName) {
		my $userList = $ownerList->{$owner};
		foreach my $user (keys(%$userList)) {
			if ($user eq $userName) {
				my $hgNameList = $userList->{$user};
				foreach my $hgName (keys(%$hgNameList)) {
					my $hostGroupObject = lock_retrieve("$perfhome/var/db/users/$owner/hostGroups/$hgName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$owner/hostGroups/$hgName.ser");
					my $tempArray = [];
					$tempArray->[0] = $owner;
					$tempArray->[1] = $hgName;
					$tempArray->[2] = $hostGroupObject->getDescription();
					$tempArray->[3] = $hostGroupObject->getMemberHashLength();
					$tempArray->[4] = $hgNameList->{$hgName};
					push(@$sharedHostGroupArray, $tempArray)
				}
			}	
		}
	}
}

1;