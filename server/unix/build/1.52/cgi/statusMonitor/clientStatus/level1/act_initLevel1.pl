use strict;
package main;

#populate hostGroupArray
$hostGroupArray = populateHostGroupArray("smLevel1");

if ($sessionObj->param("groupViewStatus") eq "shared") {
	$navLinkChosen = "sharedHostGroups";
	if ($sessionObj->param("showAllHosts")) {
		unshiftAllHostsToHostGroupArray("smLevel1");
	}
} else {
	$navLinkChosen = "myHostGroups";
}

1;