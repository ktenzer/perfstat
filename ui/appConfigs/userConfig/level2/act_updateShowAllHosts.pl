use strict;
package main;

# Set UserIndex
$userIndex = setUserIndex();	

# Login is root admin
if ($sessionObj->param("userName") eq "perfstat") {
	$adminName = $request->param('adminName');
	checkAdminName($adminName);
	my $updateUserName = trim($request->param('updateUserName'));
	my $updateUserRole = trim($request->param('updateUserRole'));
	if ($updateUserRole eq "admin") {
		checkUserName($updateUserName, $updateUserName);
	} else {
		checkUserName($adminName, $updateUserName);
	}
	my $updateUserShowAllHosts = trim($request->param('showAllHosts'));
	if ($updateUserShowAllHosts != 0 && $updateUserShowAllHosts != 1) {
		die("Error: invalid value for showAllHosts");
	}
	updateShowAllHosts($sessionObj->param("userName"), $updateUserName, $updateUserShowAllHosts);
	$queryString = "action=displayUpdateUser&adminName=$adminName&updateUserName=$updateUserName";
	
} elsif ($sessionObj->param("role") eq "admin") {
	# Login is group admin
	$adminName = $sessionObj->param("userName");
	checkAdminName($adminName);
	my $updateUserName = trim($request->param('updateUserName'));
	checkUserName($adminName, $updateUserName);
	$updateUserShowAllHosts = trim($request->param('showAllHosts'));
	if ($updateUserShowAllHosts != 0 && $updateUserShowAllHosts != 1) {
		die("Error: invalid value for showAllHosts");
	}
	updateShowAllHosts($sessionObj->param("userName"), $updateUserName, $updateUserShowAllHosts);
	$queryString = "action=displayUpdateUser&adminName=$adminName&updateUserName=$updateUserName";

	
} else {
	# Login is user
	$adminName = $sessionObj->param("creator");
	my $updateUserName = trim($request->param('updateUserName'));
	checkUserName($adminName, $updateUserName);
	$updateUserShowAllHosts = trim($request->param('showAllHosts'));
	if ($updateUserShowAllHosts != 0 && $updateUserShowAllHosts != 1) {
		die("Error: invalid value for showAllHosts");
	}
	updateShowAllHosts($sessionObj->param("userName"), $updateUserName, $updateUserShowAllHosts);
	$queryString = "action=displayUpdateUser&adminName=$adminName&updateUserName=$updateUserName";
}

################################################### updateShowAllHosts
sub updateShowAllHosts {
	my ($userName, $updateUserName, $showAllHosts) = @_;

	# update user file
	my $directoryName = "$perfhome/var/db/users/$updateUserName";
	my $fileName = "$directoryName/$updateUserName.ser";
	my $userObj = lock_retrieve($fileName) || die("ERROR: Can't retrieve userObj from $fileName\n");
	die("ERROR: can't define userObj from $fileName\n") unless defined($userObj);
	$userObj->setShowAllHosts($showAllHosts);
	lock_store($userObj, "$fileName") || die("ERROR: can't store userObj in $fileName\n");

	# update session object
	if ($userName eq $updateUserName) {
		$sessionObj->param('showAllHosts',  $showAllHosts);
	}
}


1;