use strict;
package main;

$userIndex = setUserIndex();	
# Login is perfstat admin
if ($sessionObj->param("userName") eq "perfstat") {
	####
	if (defined($request->param('adminName'))) {
		if ($request->param('adminName') ne $sessionObj->param("selectedAdmin")) {
			checkAdminName($request->param('adminName'));
			$sessionObj->param("selectedAdmin", $request->param('adminName'));
			$sessionObj->param("selectedUser", $request->param('adminName'));
		}
	}
	####
	if (defined($request->param('userName'))) {
		if ($request->param('userName') ne $sessionObj->param("selectedUser")) {
			checkUserName($sessionObj->param("selectedAdmin"), $request->param('userName'));
			$sessionObj->param("selectedUser", $request->param('userName'));
		}
	}

	#define list of admin
	$adminList = $userIndex;
	#define list of users
	$userList = $userIndex->{$sessionObj->param("selectedAdmin")};

# Login is group admin
} elsif ($sessionObj->param("role") eq "admin") {
	###
	if (defined($request->param('userName'))) {
		if ($request->param('userName') ne $sessionObj->param("selectedUser")) {
			checkUserName($sessionObj->param("selectedAdmin"), $request->param('userName'));
			$sessionObj->param("selectedUser", $request->param('userName'));
		}
	}
	#define list of users
	$userList = $userIndex->{$sessionObj->param("selectedAdmin")};

# Login is user
} else {
	# do nothing
}

if (defined($request->param('groupViewStatus'))) {
	if ($request->param('groupViewStatus') ne $sessionObj->param("groupViewStatus")) {
		$sessionObj->param("groupViewStatus", $request->param('groupViewStatus'));
	}
}

#populate hostGroupArray
$hostGroupArray = populateHostGroupArray("smNav");
if (($sessionObj->param("groupViewStatus") eq "shared") && ($sessionObj->param("showAllHosts")) ) {
	unshiftAllHostsToHostGroupArray("smNav");
}

1;