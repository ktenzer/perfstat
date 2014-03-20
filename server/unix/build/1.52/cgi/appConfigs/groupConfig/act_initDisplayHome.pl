use strict;
package main;


$adminName = $sessionObj->param("selectedAdmin");

if (defined($request->param('timeoutInterval'))) {
	$timeoutInterval = $request->param("timeoutInterval");
} else {
	$timeoutInterval = $sessionObj->param("timeoutInterval");
}

if (defined($request->param('statusRefreshInterval'))) {
	$statusRefreshInterval = $request->param("statusRefreshInterval");
} else {
	$statusRefreshInterval = $sessionObj->param("statusRefreshInterval");
}

1;