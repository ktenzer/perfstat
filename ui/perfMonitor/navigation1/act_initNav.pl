use strict;
package main;

$userIndex = setUserIndex();	
# Login is perfstat admin
if ($sessionObj->param("userName") eq "perfstat") {
	####
	if (defined($request->param('adminName'))) {
		if ($request->param('adminName') ne $sessionObj->param('selectedAdmin')) {
			checkAdminName($request->param('adminName'));
			$sessionObj->param("selectedAdmin", $request->param('adminName'));
			$sessionObj->param("selectedUser", $request->param('adminName'));
		}
	}
	####
	if (defined($request->param('userName'))) {
		if ($request->param('userName') ne $sessionObj->param('selectedUser')) {
			checkUserName($sessionObj->param("selectedAdmin"), $request->param('userName'));
			$sessionObj->param("selectedUser", $request->param('userName'));
		}
	}

	#define list of admin
	$adminList = $userIndex;
	#define list of users
	$userList = $adminList->{$sessionObj->param("selectedAdmin")};

# Login is group admin
} elsif ($sessionObj->param('role') eq "admin") {
	###
	$sessionObj->param('selectedAdmin', $sessionObj->param('userName'));
	###
	if (defined($request->param('userName'))) {
		if ($request->param('userName') ne $sessionObj->param('selectedUser')) {
			checkUserName($sessionObj->param('selectedAdmin'), $request->param('userName'));
			$sessionObj->param('selectedUser', $request->param('userName'));
		}
	}
	#define list of users
	$userList = $userIndex->{$sessionObj->param("selectedAdmin")};

# Login is user
} else {
	$sessionObj->param('selectedAdmin', $sessionObj->param('creator'));
	$sessionObj->param('selectedUser', $sessionObj->param('userName'));
}

if (defined($request->param('groupViewStatus'))) {
	if ($request->param('groupViewStatus') ne $sessionObj->param('groupViewStatus')) {
		$sessionObj->param('groupViewStatus', $request->param('groupViewStatus'));
	}
}

#populate hostGroupArray
if (($sessionObj->param('showAllHosts')) && ($sessionObj->param('groupViewStatus') eq "allHosts")) {
	$hostGroupArray = [];
	unshiftAllHostsToHostGroupArray('pmNav');
} else {
	$hostGroupArray = populateHostGroupArray('pmNav');
}

# PULL host group services
$serviceHash = lock_retrieve("$perfhome/var/db/mappings/hostGroupServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/hostGroupServiceGraphs.ser");

1;