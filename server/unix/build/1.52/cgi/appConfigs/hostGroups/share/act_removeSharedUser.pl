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

removeSharedHostGroupMember($adminName, $userName, $memberName, $hgName);

$queryString = 	"adminName=" . URLEncode($adminName) .
					"&userName=" . URLEncode($userName) .
					"&hgName=" . URLEncode($hgName);

################################################### SUBROUTINES
# Remove HOST GROUP SHARED MEMBER
sub removeSharedHostGroupMember {
	my ($adminName, $ownerName, $memberName, $hgName) = @_;

	# Update user2HostGroup Index								
	my $user2HostGroup = lock_retrieve("$perfhome/var/db/mappings/user2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2HostGroup.ser");
	delete($user2HostGroup->{$adminName}->{$ownerName}->{$memberName}->{$hgName});
	lock_store($user2HostGroup, "$perfhome/var/db/mappings/user2HostGroup.ser") or die("Can't store host2HostGroup in $perfhome/var/db/mappings/user2HostGroup.ser\n");
}

1;