use strict;
package main;
require("lib_inputCheck.pl");

# Set UserIndex
$userIndex = setUserIndex();	

# Define AdminName and hostGroupOwner
$adminName = $sessionObj->param("selectedAdmin");
$userName = $sessionObj->param("selectedUser");

$hgName = $request->param('hgName');

# Define hgNewName
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


#define array of hosts to list in add host dropdown
my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
my $hostList = $admin2Host->{$adminName};
$hostListLen = keys(%$hostList);

$hostHash = {};
foreach my $hostName (keys(%$hostList)) {
	my $hostObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/$hostName.ser") or die("Error: can't retrieve $perfhome/var/db/hosts/$hostName/$hostName.ser\n");
	my $IP = $hostObject->getIP();
	$hostHash->{$hostName} = $IP;
}

# Find hostGroup member hash
my $hostGroupObject = lock_retrieve("$perfhome/var/db/users/$userName/hostGroups/$hgName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/hostGroups/$hgName.ser\n");
my $hostGroupMemberHash = $hostGroupObject->{memberHash};

$hostGroupMemberArray = [];
# create hash of hostGroupMembers
foreach my $hostName (sort(keys(%$hostGroupMemberHash))) {
	my $hostObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/$hostName.ser") or die("Error: can't retrieve $perfhome/var/db/hosts/$hostName/$hostName.ser\n");
	my $tempArray = [];
	$tempArray->[0] = $hostName;
	$tempArray->[1] = $hostObject->getIP();
	push(@$hostGroupMemberArray, $tempArray);
	delete($hostHash->{$hostName});
}

1;