use strict;
package main;

$sessionObj->param('hgOwner', $sessionObj->param('selectedUser'));
if ($sessionObj->param("groupViewStatus") eq "shared") {
	my $temp = $request->param('hgOwner');
	$sessionObj->param("hgOwner", $request->param('hgOwner'));
}
checkAndSetHostGroupID(0);
checkAndSetHostName(0);

$hostObject = populateHostObject($sessionObj->param("hostName"));

1;