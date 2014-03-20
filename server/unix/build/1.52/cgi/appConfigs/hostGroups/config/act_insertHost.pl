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
$hgName = $request->param('hgName');
my $hostName = trim($request->param('hostName'));
checkSelectHostName($adminName, $hostName);

$hgNewName = $request->param("hgNewName");
$description = $request->param("description");

insertHostGroupMember($userName, $hgName, $hostName);
$queryString = 	"adminName=" . URLEncode($adminName) .
					"&userName=". URLEncode($userName) .
					"&hgName=". URLEncode($hgName) . 
					"&hgNewName=". URLEncode($hgNewName) .
					"&description=". URLEncode($description);

################################################### SUBROUTINES
#INSERT HOST TO HOST GROUP
sub insertHostGroupMember {
	my ($userName, $hgName, $hostName) = @_;
	# Update host group object
	my $hostGroupObject = lock_retrieve("$perfhome/var/db/users/$userName/hostGroups/$hgName.ser") or die("Error: can't retrieve $perfhome/var/db/users/$userName/hostGroups/$hgName.ser\n");
	$hostGroupObject->addMember($hostName);
	$hostGroupObject->lock_store("$perfhome/var/db/users/$userName/hostGroups/$hgName.ser") or die("ERROR: Can't store $perfhome/var/db/users/$userName/hostGroups/$hgName.ser\n");

	# Update host2HostGroup Index								
	my $host2HostGroup = lock_retrieve("$perfhome/var/db/mappings/host2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/host2HostGroup.ser\n");
	$host2HostGroup->{$hostName}->{$userName}->{$hgName} = 0;
	lock_store($host2HostGroup, "$perfhome/var/db/mappings/host2HostGroup.ser") or die("Can't store host2HostGroup in $perfhome/var/db/mappings/host2HostGroup.ser\n");
}

1;