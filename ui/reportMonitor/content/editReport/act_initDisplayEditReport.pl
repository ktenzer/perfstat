use strict;
package main;

# Define AdminName and hostGroupOwner
$adminName = $sessionObj->param('selectedAdmin');
$userName = $sessionObj->param('selectedUser');
$reportNameID = $request->param('reportNameID');

if( defined($request->param('updateNav'))) {
	$updateNav = "updateNavigation();"
} else {
	$updateNav = "";
}

# report descriptors
my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportNameID.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportNameID.ser\n");
if (defined($request->param("reportName"))) {
	$reportName = $request->param("reportName");
} else {
	$reportName = $reportObject->getName();
}
if (defined($request->param("description"))) {
	$description = $request->param("description");
} else {
	$description = $reportObject->getDescription();
}

1;