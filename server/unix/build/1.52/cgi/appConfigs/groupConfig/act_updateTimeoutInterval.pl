use strict;
package main;

# INPUT CHECK
$sessionObj->param("userMessage", "");

if ($request->param('timeoutInterval') !~ /^\d+$/) {
	# is not a positive integer
	$sessionObj->param("userMessage", "Timeout Interval must be an integer between 0 and 120");
}

if ($sessionObj->param("userMessage") eq "") {
	if ($request->param('timeoutInterval') < 0 || $request->param('timeoutInterval') > 120) {
		$sessionObj->param("userMessage", "Timeout Interval must be an integer between 0 and 120");
	}
}

if ($sessionObj->param("userMessage") eq "") {
	my $dirName = "$perfhome/var/db/users/" . $sessionObj->param('userName') . "/";
	my $fileName = "$dirName/" . $sessionObj->param('userName') . ".ser";
	
	#update user DB
	my $userObj = lock_retrieve($fileName) || die("ERROR: Unable to retrieve from $fileName\n");
	$userObj->setTimeoutInterval($request->param('timeoutInterval'));
	lock_store($userObj, $fileName) || die("ERROR: Unable to store to $fileName\n");

	#update session object parameter
	$sessionObj->param("timeoutInterval", $request->param('timeoutInterval'));
	
	# set user message
	$sessionObj->param("userMessage", "Timeout Interval updated");
}

1;