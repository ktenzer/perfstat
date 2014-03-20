use strict;
package main;

my $inputOK = 1;
my $dirName;
my $fileName;
my $userObj;
my $groupPolicyObj;
my $temp;

# INPUT CHECK -------------------------------------------------
if ($inputOK == 1) {
	if ($userName eq "") {
		$inputOK = 0;
		$userErrorMessage = "Error: please provide a user name";
	}
}

if ($inputOK == 1) {
	if ($password eq "") {
		$inputOK = 0;
		$userErrorMessage = "Error: please provide a password";
	}
}

# PROCESS LOGIN -------------------------------------------------
if ($inputOK == 1) {
	#if $userName directory does not exist then bad username
	$dirName = "$perfhome/var/db/users/$userName";
	if (!(-e $dirName)) {
		$inputOK = 0;
		$userErrorMessage = "Error: invalid value for userName";
	}
}

if ($inputOK == 1) {
	#Check the password
	$fileName = "$dirName/$userName.ser";
	$userObj = lock_retrieve($fileName) || die("ERROR: Unable to retrieve from $fileName\n");
	if ($userObj->getName() ne $userName) {
		die("ERROR: invalid value for userName\n");
	}

	if ($userObj->getPassword() ne $password) {
		$inputOK = 0;
		$userErrorMessage = "Error: invalid value for password";
	}
}

# DISPLAY OUTPUT ---------------------------------------------------
if ($inputOK == 0) {
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_login.html");}
	require("dsp_login.pl");
} elsif ($inputOK == 1) {
	# get groupPolicy object
	if ($userObj->getRole() eq "admin") {
		$dirName = "$perfhome/var/db/users/$userName";
	} else {
		my $adminName = $userObj->getCreator();
		$dirName = "$perfhome/var/db/users/$adminName";
	}
	$fileName = "$dirName/groupPolicy.ser";
	$groupPolicyObj = lock_retrieve($fileName) || die("ERROR: Unable to retrieve from $fileName\n");
	$sessionObj->param("isLoggedIn",  "1");
	$sessionObj->param("userName",  $userName);
	$sessionObj->param("creator",  $userObj->getCreator());
	$sessionObj->param("role",  $userObj->getRole());
	$sessionObj->param("showAllHosts",  $userObj->getShowAllHosts());
	$sessionObj->param("timeoutInterval",  $groupPolicyObj->getTimeoutInterval());
	$sessionObj->param("statusRefreshInterval",  $groupPolicyObj->getStatusRefreshInterval());
	$sessionObj->param("selectedAdmin",  $userObj->getCreator());
	$sessionObj->param("selectedUser",  $userName);
	$sessionObj->param("groupViewStatus",  "self");
	$sessionObj->store();
	$doStoreSessionObject = 0;
	#Output the starting frame
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_frames.html");}
	require("dsp_frames.pl");
} else {
	die("ERROR: invalid value for inputOK\n");
}
1;