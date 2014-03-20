use strict;
package main;

# Set userIndex
$userIndex = setUserIndex();	

# Flag whether to update navcode with javascript
if (!defined($request->param('updateNavCode'))) {
	$updateNavCode = 1;
} else {
	$updateNavCode = $request->param('updateNavCode');
}

# Login is admin
if ($sessionObj->param("role") eq "admin") {
	$adminName = $sessionObj->param("selectedAdmin");
	
	# Define insertAdminName
	if (defined($request->param('insertAdminName'))) {
		$insertAdminName = $request->param("insertAdminName");
	} else {
		$insertAdminName = "";
	}
	
	# Define insertUserName
	if (defined($request->param('insertUserName'))) {
		$insertUserName = $request->param("insertUserName");
	} else {
		$insertUserName = "";
	}
	
	if ($sessionObj->param("selectedAdmin") eq "perfstat") {
		$adminList = $userIndex;
		$userList = $adminList->{$adminName};
	} else {
		$adminList = {};
		$userList = $userIndex->{$sessionObj->param("selectedAdmin")};
	}
	
	require("dsp_level1.pl");

# Login is user
} else {
	$adminName = $sessionObj->param("selectedAdmin");
	$updateUserName = $sessionObj->param("selectedUser");
	$queryString = "adminName=$adminName&role=user&updateUserName=$updateUserName";
	metaRedirect(0, "../level2/index.pl?$queryString");
}

1;