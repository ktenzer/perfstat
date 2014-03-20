use strict;
package main;
require("lib_userConfig.pl");

# Set user index
$userIndex = setUserIndex();

# Login is root admin
if ($sessionObj->param("userName") eq "perfstat") {
	$adminName = $request->param('adminName');
	checkAdminName($adminName);
	my $userName = trim($request->param('updateUserName'));
	if ($userName eq "perfstat") {
		die("ERROR: perfstat can't delete self");
	}
	checkUserName($adminName, $userName);
	$userRole = $userIndex->{$adminName}->{$userName};
	if ($userRole eq "user") {
		deleteUser($adminName, $userName, $userRole);
		$queryString = "adminName=$adminName&updateNavCode=2";	
	} else {
		die('ERROR: invalid value for $userRole');
	}

# Login is group admin
} elsif ($sessionObj->param("role") eq "admin") {
	$adminName = $sessionObj->param("userName");
	checkAdminName($adminName);
	my $userName = trim($request->param('updateUserName'));
	if ($adminName eq $userName) {
		die("ERROR: group admin can't delete self");
	}
	checkUserName($adminName, $userName);
	$userRole = $userIndex->{$adminName}->{$userName}->getRole();
	if ($userRole eq "user") {
		deleteUser($adminName, $userName, $userRole);
		$queryString = "updateNavCode=2";
	} else {
		die('ERROR: invalid value for $userRole');
	}

# Login is user
} else {
	die("ERROR: builder can't delete a user")
}


1;