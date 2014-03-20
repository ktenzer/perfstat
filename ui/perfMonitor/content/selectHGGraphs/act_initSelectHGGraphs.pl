use strict;
package main;

$sessionObj->param('hgOwner', $sessionObj->param('selectedUser'));
checkAndSetHostGroupID(1);

# CURRENT graphSize, graphLayout
if (!defined($request->param("graphSize"))) {
	$graphSize = "medium";
} else {
	$graphSize = $request->param("graphSize");
}
if (!defined($request->param("graphLayout"))) {
	$graphLayout = "1";
} else {
	$graphLayout = $request->param("graphLayout");
}
if (!defined($request->param("customSize"))) {
	$customSize = "";
} else {
	$customSize = $request->param("customSize");
}

#populate hostGroupArray
$hostGroupArray = [];

if (($sessionObj->param('showAllHosts')) && ($sessionObj->param("groupViewStatus") eq "allHosts")) {
	$navLinkChosen = "allHosts";
	unshiftAllHostsToHostGroupArray("smLevel1");
} elsif ($sessionObj->param("groupViewStatus") eq "shared") {
	$navLinkChosen = "sharedHostGroups";
	my $prelimHostGroupArray = populateHostGroupArray("pmNav");
	#Get Rid of hostgroups with no hosts
	foreach my $hostGroupDescHash (@$prelimHostGroupArray) {
		if ($hostGroupDescHash->{'hasHosts'}) {
			push(@$hostGroupArray, $hostGroupDescHash);
		}
	}					
} else {
	my $prelimHostGroupArray = populateHostGroupArray("pmNav");
	$navLinkChosen = "myHostGroups";
	#Get Rid of hostgroups with no hosts
	foreach my $hostGroupDescHash (@$prelimHostGroupArray) {
		if ($hostGroupDescHash->{'hasHosts'}) {
			push(@$hostGroupArray, $hostGroupDescHash);
		}
	}					
}

# SET hostGroupID session object, if not already set
if (@$hostGroupArray != 0 && length($sessionObj->param("hostGroupID")) == 0) {
	my $hostGroupID = $hostGroupArray->[0]->{'hostGroupID'};
	$sessionObj->param("hostGroupID", $hostGroupID);
}
if ($sessionObj->param("groupViewStatus") eq "shared") {
	my $hgOwner;
	foreach my $hostGroupDescHash (@$hostGroupArray) {
		if ($hostGroupDescHash->{'hostGroupID'} eq $sessionObj->param('hostGroupID')) {
			$sessionObj->param('hgOwner', $hostGroupDescHash->{'hostGroupOwner'});
			last;
		}
	}
}

# PULL host group services
$serviceHash = lock_retrieve("$perfhome/var/db/mappings/hostGroupServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/hostGroupServiceGraphs.ser");

1;