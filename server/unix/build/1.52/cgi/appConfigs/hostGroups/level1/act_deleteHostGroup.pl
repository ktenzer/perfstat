use strict;
package main;
require("lib_inputCheck.pl");

# Set UserIndex
$userIndex = setUserIndex();	

# init message variables
$sessionObj->param("userMessage", "");
my $errorMessage = "";

$adminName = $request->param('adminName');
checkAdminName($adminName);
syncAdminName($adminName);
$userName = $request->param('userName');
checkUserName($adminName, $userName);
syncUserName($userName);
my $hgName = $request->param('hgName');
deleteHostGroup($adminName, $userName, $hgName);
$queryString = "adminName=" . URLEncode($adminName) .
				"&userName=". URLEncode($userName);


################################################### SUBROUTINES
#DELETE HOSTGROUP
sub deleteHostGroup {
	my ($adminName, $userName, $hgName) = @_;
	## Delete file
	unlink("$perfhome/var/db/users/$userName/hostGroups/$hgName.ser") or die ("ERROR: Couldn't remove file $perfhome/var/db/users/$userName/hostGroups/$hgName.ser\n");

	## Update User2HostGroup Index								
	my $user2HostGroup = lock_retrieve("$perfhome/var/db/mappings/user2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2HostGroup.ser");
	foreach my $admin (keys(%$user2HostGroup)) {
	my $ownerList = $user2HostGroup->{$admin};
	foreach my $owner (keys(%$ownerList)) {
		my $userList = $ownerList->{$owner};
		foreach my $user (keys(%$userList)) {
			my $hgNameList = $userList->{$user};
			foreach my $hostGroupName (keys(%$hgNameList)) {
				if ($hgName eq $hostGroupName) {
					delete($user2HostGroup->{$admin}->{$owner}->{$user}->{$hgName});
				}
			}
		}
	}
}
	lock_store($user2HostGroup, "$perfhome/var/db/mappings/user2HostGroup.ser") or die("Can't store admin2Host in $perfhome/var/db/mappings/user2HostGroup.ser\n");
	
	## Update host2HostGroup Index								
	my $host2HostGroup = lock_retrieve("$perfhome/var/db/mappings/host2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/host2HostGroup.ser");
	foreach my $hostName (keys(%$host2HostGroup)) {
		my $userNameList = $host2HostGroup->{$hostName};
		foreach my $userName (keys(%$userNameList)) {
			my $hostGroupNameList = $userNameList->{$userName};
			foreach my $hostGroupName (keys(%$hostGroupNameList)) {
				if ($hostGroupName eq $hgName) {
					delete($host2HostGroup->{$hostName}->{$userName}->{$hostGroupName});
				}
			}
		}
	}
	lock_store($host2HostGroup, "$perfhome/var/db/mappings/host2HostGroup.ser") or die("Can't store admin2Host in $perfhome/var/db/mappings/host2HostGroup.ser\n");
}

1;