use strict;
package main;

#populate hostGroupArray
$hostGroupArray = [];

if (($sessionObj->param('showAllHosts')) && ($sessionObj->param("groupViewStatus") eq "allHosts")) {
	$navLinkChosen = "allHosts";
	unshiftAllHostsToHostGroupArray("smLevel1");
} elsif ($sessionObj->param("groupViewStatus") eq "shared") {
	$navLinkChosen = "sharedHostGroups";
	$hostGroupArray = populateHostGroupArray("smLevel1");
} else {
	$navLinkChosen = "myHostGroups";
	$hostGroupArray = populateHostGroupArray("smLevel1");
}

1;