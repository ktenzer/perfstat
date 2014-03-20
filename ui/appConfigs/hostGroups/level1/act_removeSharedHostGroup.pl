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
my $hgOwner = $request->param('hgOwner');
my $hgName = $request->param('hgName');

removeSharedHostGroup($adminName, $hgOwner, $userName, $hgName);

$queryString = "adminName=" . URLEncode($adminName) .
				"&userName=". URLEncode($userName);

################################################### SUBROUTINES
# Remove HOST GROUP SHARED MEMBER
sub removeSharedHostGroup {
	my ($adminName, $ownerName, $userName, $hgName) = @_;

	# Update user2HostGroup Index								
	my $user2HostGroup = lock_retrieve("$perfhome/var/db/mappings/user2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2HostGroup.ser");
	delete($user2HostGroup->{$adminName}->{$ownerName}->{$userName}->{$hgName});
	lock_store($user2HostGroup, "$perfhome/var/db/mappings/user2HostGroup.ser") or die("Can't store host2HostGroup in $perfhome/var/db/mappings/user2HostGroup.ser\n");
}

1;