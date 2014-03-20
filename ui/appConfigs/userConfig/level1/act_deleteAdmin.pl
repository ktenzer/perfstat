use strict;
package main;
require("lib_userConfig.pl");

# Set userIndex
$userIndex = setUserIndex();	

# Login is root admin
if ($sessionObj->param("userName") eq "perfstat") {
	$adminName = "perfstat";
	my $userName = trim($request->param('updateUserName'));
	if ($userName eq "perfstat") {
		die("ERROR: perfstat can't delete self");
	}
	checkUserName($userName, $userName);
	$userRole = $userIndex->{$userName}->{$userName};
	if ($userRole eq "admin") {
		deleteUser($adminName, $userName, "admin");
		$queryString = "adminName=perfstat&updateNavCode=2";
	} else {
		die('ERROR: invalid value for $userRole');
	}

# Login is group admin
} elsif ($sessionObj->param("role") eq "admin") {
	die("ERROR: group admin can't delete admin");

# Login is user	
} else {
	die("ERROR: builder can't delete an admin")
}


1;