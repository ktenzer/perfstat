use strict;
package main;

# Set UserIndex
$userIndex = setUserIndex();	

# init message variables
$sessionObj->param("userMessage2", "");
my $errorMessage = "";

# Login is root admin
if ($sessionObj->param("userName") eq "perfstat") {
	$adminName = $request->param('adminName');
	checkAdminName($adminName);
	my $userName = trim($request->param('updateUserName'));
	my $updateUserRole = trim($request->param('updateUserRole'));
	if ($updateUserRole eq "admin") {
		checkUserName($userName, $userName);
	} else {
		checkUserName($adminName, $userName);
	}
	$password = trim($request->param('password'));
	$errorMessage = checkPassword($password);
	if (length($errorMessage) eq 0) {
		$confirmPassword = trim($request->param('confirmPassword'));
		$errorMessage = checkConfirmPassword($password, $confirmPassword);
	}
	if (length($errorMessage) ne 0) {
		$sessionObj->param("userMessage2", $errorMessage);
		$queryString = "action=displayUpdateUser&adminName=$adminName&updateUserName=$userName";
	} else {
		updatePassword($userName, $password);
		$sessionObj->param("userMessage2", "Password Updated for $userName");
		$queryString = "action=displayUpdateUser&adminName=$adminName&updateUserName=$userName";
	}
	
} elsif ($sessionObj->param("role") eq "admin") {
	# Login is group admin
	$adminName = $sessionObj->param("userName");
	checkAdminName($adminName);
	my $userName = trim($request->param('updateUserName'));
	checkUserName($adminName, $userName);
	$password = trim($request->param('password'));
	$errorMessage = checkPassword($password);
	if (length($errorMessage) eq 0) {
		$confirmPassword = trim($request->param('confirmPassword'));
		$errorMessage = checkConfirmPassword($password, $confirmPassword);
	}
	if (length($errorMessage) ne 0) {
		$sessionObj->param("userMessage2", $errorMessage);
		$queryString = "action=displayUpdateUser&updateUserName=$userName";
	} else {
		updatePassword($userName, $password);
		$sessionObj->param("userMessage2", "Password Updated for $userName");
		$queryString = "action=displayUpdateUser&updateUserName=$userName";
	}
	
} else {
	# Login is user
	$adminName = $sessionObj->param("creator");
	my $userName = trim($request->param('updateUserName'));
	checkUserName($adminName, $userName);
	$password = trim($request->param('password'));
	$errorMessage = checkPassword($password);
	if (length($errorMessage) eq 0) {
		$confirmPassword = trim($request->param('confirmPassword'));
		$errorMessage = checkConfirmPassword($password, $confirmPassword);
	}
	if (length($errorMessage) ne 0) {
		$sessionObj->param("userMessage2", $errorMessage);
	} else {
		updatePassword($userName, $password);
		$sessionObj->param("userMessage2", "Password Updated");
	}
	$queryString = "action=displayUpdateUser&updateUserName=$userName";
}

################################################### updatePassword
sub updatePassword {
	my ($userName, $password) = @_;
	my $directoryName = "$perfhome/var/db/users/$userName";
	my $fileName = "$directoryName/$userName.ser";
	my $userObj = lock_retrieve($fileName) || die("ERROR: Can't retrieve userObj from $fileName\n");
	die("ERROR: can't define userObj from $fileName\n") unless defined($userObj);
	$userObj->setPassword($password);
	lock_store($userObj, "$fileName") || die("ERROR: can't store userObj in $fileName\n");
}


1;