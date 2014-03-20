use strict;
package main;

if ($sessionObj->param("role") eq "admin") {
	$navHeaderText = '<a href="../level1/index.pl">User Config</a>';
} else {
	$navHeaderText = "User Config";
}

$adminName = $sessionObj->param("selectedAdmin");
$updateUserName = $request->param("updateUserName");

my $fileName = "$perfhome/var/db/users/$updateUserName/$updateUserName.ser";
my $userObj = lock_retrieve($fileName) || die("ERROR: Can't retrieve userObj from $fileName\n");
$updateUserShowAllHosts = $userObj->getShowAllHosts();
$updateUserRole = $userObj->getRole();

1;