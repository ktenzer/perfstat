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
my $hgOwner = $sessionObj->param("selectedUser");
$hgName = trim($request->param('hgName'));
$hgNewName = trim($request->param('hgNewName'));
$errorMessage = checkItemName($hgNewName);
$description = trim($request->param('description'));
if (length($errorMessage) ne 0) {
	$sessionObj->param("userMessage", $errorMessage);
} else {
	updateHostGroup($adminName, $userName, $hgOwner, $hgName, $hgNewName, $description);
	$hgName = $hgNewName;
	$sessionObj->param("userMessage", "$hgName Updated");
	
}

$queryString = "adminName=". URLEncode($adminName) .
					"&userName=". URLEncode($userName) .
					"&hgName=". URLEncode($hgName) .
					"&hgNewName=" . URLEncode($hgNewName) .
					"&description=" . URLEncode($description);

################################################### SUBROUTINES
# UPDATE HostGroup
sub updateHostGroup {
	my ($adminName, $userName, $hgOwner, $hgName, $hgNewName, $description) = @_;

	# Retrieve host group object
	my $hostGroupObject = lock_retrieve("$perfhome/var/db/users/$hgOwner/hostGroups/$hgName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$hgOwner/hostGroups/$hgName.ser\n");
	if ($hgName ne $hgNewName) {
		$hostGroupObject->setName($hgNewName);
	}
	$hostGroupObject->setDescription($description);
	$hostGroupObject->lock_store("$perfhome/var/db/users/$hgOwner/hostGroups/$hgName.ser") or die("ERROR: Can't store $perfhome/var/db/users/$hgOwner/hostGroups/$hgName.ser\n");
	rename("$perfhome/var/db/users/$hgOwner/hostGroups/$hgName.ser","$perfhome/var/db/users/$hgOwner/hostGroups/$hgNewName.ser") or die "ERROR: Couldn't rename $perfhome/var/db/users/$hgOwner/hostGroups/$hgName.ser\n";
	
	if ($hgName ne $hgNewName) {
		## Update User2HostGroup Index								
		my $user2HostGroup = lock_retrieve("$perfhome/var/db/mappings/user2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2HostGroup.ser\n");
		$user2HostGroup->{$adminName}->{$userName}->{$hgOwner}->{$hgNewName} = $user2HostGroup->{$adminName}->{$userName}->{$hgOwner}->{$hgName};
		delete($user2HostGroup->{$adminName}->{$userName}->{$hgOwner}->{$hgName});
		lock_store($user2HostGroup, "$perfhome/var/db/mappings/user2HostGroup.ser") or die("Can't store admin2Host in $perfhome/var/db/mappings/user2HostGroup.ser\n");
		
		## Update host2HostGroup Index								
		my $host2HostGroup = lock_retrieve("$perfhome/var/db/mappings/host2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/host2HostGroup.ser\n");
		foreach my $hostName (keys(%$host2HostGroup)) {
			my $userNameList = $host2HostGroup->{$hostName};
			foreach my $userName (keys(%$userNameList)) {
				my $hostGroupNameList = $userNameList->{$userName};
				foreach my $hostGroupName (keys(%$hostGroupNameList)) {
					if ($hostGroupName eq $hgName) {
						$host2HostGroup->{$hostName}->{$userName}->{$hgNewName} = $host2HostGroup->{$hostName}->{$userName}->{$hgName};
						delete($host2HostGroup->{$hostName}->{$userName}->{$hgName});
					}
				}
			}
		}
		lock_store($host2HostGroup, "$perfhome/var/db/mappings/host2HostGroup.ser") or die("Can't store admin2Host in $perfhome/var/db/mappings/host2HostGroup.ser\n");
	}
}

1;