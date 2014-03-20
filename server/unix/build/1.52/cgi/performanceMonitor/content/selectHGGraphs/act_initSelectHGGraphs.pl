use strict;
package main;

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
$hostGroupArray = populateHostGroupArray("pmNav");

if ($sessionObj->param("groupViewStatus") eq "shared") {
	$navLinkChosen = "sharedHostGroups";
	if ($sessionObj->param("showAllHosts")) {
		unshiftAllHostsToHostGroupArray("smLevel1");
	}
} else {
	$navLinkChosen = "myHostGroups";
}

# SET hostGroupID session object, if not already set
if (@$hostGroupArray != 0 && length($sessionObj->param("hostGroupID")) == 0) {
	my $hostGroupID = $hostGroupArray->[0]->{'hostGroupID'};
	$sessionObj->param("hostGroupID", $hostGroupID);
}

# PULL host group services
$serviceHash = lock_retrieve("$perfhome/var/db/mappings/hostGroupServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/hostGroupServiceGraphs.ser");


1;