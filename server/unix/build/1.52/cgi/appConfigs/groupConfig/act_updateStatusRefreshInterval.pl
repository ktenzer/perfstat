use strict;
package main;

# INPUT CHECK
$sessionObj->param("userMessage", "");

if ($request->param('statusRefreshInterval') !~ /^\d+$/) {
	# is not a positive integer
	$sessionObj->param("userMessage", "Status Refresh Interval must be an integer between 0 and 120");
}

if ($sessionObj->param("userMessage") eq "") {
	if ($request->param('statusRefreshInterval') < 0 || $request->param('statusRefreshInterval') > 120) {
		$sessionObj->param("userMessage", "Status Refresh Interval must be an integer between 0 and 120");
	}
}

if ($sessionObj->param("userMessage") eq "") {
	my $dirName = "$perfhome/var/db/users/" . $sessionObj->param('userName') . "/";
	my $fileName = "$dirName/" . $sessionObj->param('userName') . ".ser";
	
	#update user DB
	my $userObj = lock_retrieve($fileName) || die("ERROR: Unable to retrieve from $fileName\n");
	$userObj->setStatusRefreshInterval($request->param('statusRefreshInterval'));
	lock_store($userObj, $fileName) || die("ERROR: Unable to store to $fileName\n");

	#update session object parameter
	$sessionObj->param("statusRefreshInterval", $request->param('statusRefreshInterval'));
	
	# set user message
	$sessionObj->param("userMessage", "Status Refresh Interval updated");
}

1;