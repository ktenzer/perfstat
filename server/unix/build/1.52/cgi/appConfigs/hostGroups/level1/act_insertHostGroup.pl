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
$hgNewName = trim($request->param('hgNewName'));
$errorMessage = checkItemName($hgNewName);
$description = trim($request->param('description'));
if (length($errorMessage) ne 0) {
	$sessionObj->param("userMessage", $errorMessage);
	$queryString = "adminName=". URLEncode($adminName) .
					"&userName=". URLEncode($userName) .
					"&hgNewName=" . URLEncode($hgNewName) .
					"&description=" . URLEncode($description);
} else {
	insertHostGroup($adminName, $userName, $hgNewName, $description);
	$queryString = "action=clearItem" .
						"&adminName=" . URLEncode($adminName) .
						"&userName=". URLEncode($userName);
}
################################################### SUBROUTINES
#INSERT Item
sub insertHostGroup {
	my ($adminName, $userName, $hostGroupName, $description) = @_;
	
	# Create host group object
	my $hostGroupObject = HostGroup->new(	name			=> $hostGroupName,
													description 	=> $description,
													owner			=> $userName);
	# Serialize hostGroupObject to disk
	$hostGroupObject->lock_store("$perfhome/var/db/users/$userName/hostGroups/$hostGroupName.ser") or die("ERROR: Can't store $perfhome/var/db/users/$userName/hostGroups/$hostGroupName.ser\n");
	
	# Update User2HostGroup Index								
	my $user2HostGroup = lock_retrieve("$perfhome/var/db/mappings/user2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2HostGroup.ser");
	$user2HostGroup->{$adminName}->{$userName}->{$userName}->{$hostGroupName} = "rw";
	lock_store($user2HostGroup, "$perfhome/var/db/mappings/user2HostGroup.ser") or die("Can't store admin2Host in $perfhome/var/db/mappings/user2HostGroup.ser\n");
}

1;