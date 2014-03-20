use strict;
package main;

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
my $memberName = $request->param('memberName');
$hgName = $request->param('hgName');
$permission = $request->param('permission');

insertSharedHostGroupMember($adminName, $userName, $memberName, $hgName, $permission);

$queryString = 	"adminName=" . URLEncode($adminName) .
					"&userName=" . URLEncode($userName) .
					"&hgName=" . URLEncode($hgName) .
					"&permission=" . URLEncode($permission);

################################################### SUBROUTINES
#INSERT  TO HOST GROUP
sub insertSharedHostGroupMember {
	my ($adminName, $ownerName, $memberName, $hgName, $permission) = @_;

	# Update user2HostGroup Index								
	my $user2HostGroup = lock_retrieve("$perfhome/var/db/mappings/user2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2HostGroup.ser");
	$user2HostGroup->{$adminName}->{$ownerName}->{$memberName}->{$hgName} = $permission;
	lock_store($user2HostGroup, "$perfhome/var/db/mappings/user2HostGroup.ser") or die("Can't store host2HostGroup in $perfhome/var/db/mappings/user2HostGroup.ser\n");
}

1;