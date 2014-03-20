use strict;
package main;
require("lib_userConfig.pl");

# init message variables
$sessionObj->param("userMessage1", "");
my $errorMessage = "";

# Login is perfstat admin
if ($sessionObj->param("userName") eq "perfstat") {
	$adminName = "perfstat";
	$userRole = "admin";
	my $userName = trim($request->param('insertAdminName'));
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
		$sessionObj->param("userMessage1", $errorMessage);
		$queryString = "adminName=$adminName&insertAdminName=$userName";
	} else {
		insertUser($userName, $password, $userName, $userRole, $perfhome);
		$queryString = "&adminName=$adminName&updateNavCode=2";
	}
# Login is group admin
} elsif ($sessionObj->param("role") eq "admin") {
	die('ERROR: invalid value for $sessionObj->param("role")')
# Login is user
} else {
	die('ERROR: invalid value for $sessionObj->param("role")')
}

1;