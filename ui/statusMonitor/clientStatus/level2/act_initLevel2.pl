use strict;
package main;

$sessionObj->param('hgOwner', $sessionObj->param('selectedUser'));
if ($sessionObj->param("groupViewStatus") eq "shared") {
	$sessionObj->param('hgOwner', $request->param('hgOwner'));
}
checkAndSetHostGroupID(0);

# Declare Variables
$hostHash = {};
my $hostGroupMemberHash = {};

if ($sessionObj->param("hostGroupID") eq "All Hosts") {
	#define array of allHosts
	my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
	my $hostList = $admin2Host->{$sessionObj->param("selectedAdmin")};
	foreach my $hostName (sort(keys(%$hostList))) {
		$hostGroupMemberHash->{$hostName} = 0;
	}
} else {
	my $hgOwner = $sessionObj->param('hgOwner');
	my $hgID = $sessionObj->param("hostGroupID");
	my $hostGroup = lock_retrieve("$perfhome/var/db/users/$hgOwner/hostGroups/$hgID.ser") or die("$perfhome/var/db/users/$hgOwner/hostGroups/$hgID.ser");
	$hostGroupMemberHash = $hostGroup->{'memberHash'};
}

foreach my $hostName (sort(keys(%$hostGroupMemberHash))) {
	my $hostDescHash = {};
	my $hostObject = populateHostObject($hostName);
	$hostDescHash->{'OS'} = $hostObject->getOS();
	my $lastUpdate = $hostObject->getLastUpdate();
	if ($lastUpdate == 0) {
		$lastUpdate = "null";
	} else {
		$lastUpdate = localtime($lastUpdate);
	}
	$hostDescHash->{'lastUpdate'} = $lastUpdate;
	my $serviceIndex = $hostObject->{'serviceIndex'};
	
	if (keys(%$serviceIndex) == 0) {
		$hostDescHash->{'hasServices'} = 0;
	} else {
		$hostDescHash->{'hasServices'} = 1;
		my $serviceHashRaw = makeServiceHashRaw($serviceIndex, "smLevel2");
		my $serviceHashRefined = makeServiceHashRefined($serviceHashRaw, "smLevel2");
		$hostDescHash->{'hostServiceHash'} = $serviceHashRefined;
	}
	$hostHash->{$hostName} = $hostDescHash;
}

1;