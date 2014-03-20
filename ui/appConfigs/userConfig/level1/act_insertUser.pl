use strict;
package main;
require("lib_userConfig.pl");

# Set UserIndex
$userIndex = setUserIndex();	
# init message variables
$sessionObj->param("userMessage2", "");
my $errorMessage = "";

# Login is perfstat admin
if ($sessionObj->param("userName") eq "perfstat") {
	$adminName = $request->param('adminName');
	checkAdminName($adminName);
	$userRole = "user";
	my $userName = trim($request->param('insertUserName'));
	$errorMessage = checkUserNameLocal($userName);
	if (length($errorMessage) eq 0) {
		$password = trim($request->param('password'));
		$errorMessage = checkPassword($password);
	}
	if (length($errorMessage) eq 0) {
		$confirmPassword = trim($request->param('confirmPassword'));
		$errorMessage = checkConfirmPassword($password, $confirmPassword);
	}
	if (length($errorMessage) ne 0) {
		$sessionObj->param("userMessage2", $errorMessage);
		$queryString = "adminName=$adminName&insertUserName=$userName";
	} else {
		insertUser($userName, $password, $adminName, $userRole, $perfhome);
		$queryString = "&adminName=$adminName&updateNavCode=2";
	}

# Login is group admin
} elsif ($sessionObj->param("role") eq "admin") {
	$adminName = $sessionObj->param("userName");
	checkAdminName($adminName);
	my $userName = trim($request->param('insertUserName'));
	$userRole = "user";
	$errorMessage = checkUserNameLocal($userName);
	if (length($errorMessage) eq 0) {
		$password = trim($request->param('password'));
		$errorMessage = checkPassword($password);
	}
	if (length($errorMessage) eq 0) {
		$confirmPassword = trim($request->param('confirmPassword'));
		$errorMessage = checkConfirmPassword($password, $confirmPassword);
	}
	if (length($errorMessage) ne 0) {
		$sessionObj->param("userMessage2", $errorMessage);
		$queryString = "insertUserName=$userName";
	} else {
		insertUser($userName, $password, $adminName, $userRole, $perfhome);
		$queryString = "updateNavCode=2";
	}

# Login is user	
} else {
	die('ERROR: invalid value for $sessionObj->param("role")')
}

1;