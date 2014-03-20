use strict;
package main;
require("lib_inputCheck.pl");

$date = trim($request->param('date'));
$user = trim($request->param('user'));
$description = trim($request->param('description'));
my $errorMessage = "";

$errorMessage = checkDate($date);
if (length($errorMessage) eq 0) {
	$errorMessage = checkUser($user);
}
if (length($errorMessage) eq 0) {
	$errorMessage = checkDescription($description);
}

my $hgOwner = $sessionObj->param('hgOwner');
my $hgid = $sessionObj->param('hostGroupID');
my $hostName = $sessionObj->param('hostName');
my $itemID = $request->param('itemID');
if (length($errorMessage) != 0) {
	$sessionObj->param("userMessage", $errorMessage);
	$queryString = "action=displayUpdateItem" .
				"&hgOwner=$hgOwner" .
				"&hostGroupID=$hgid" .
				"&hostName=$hostName" .
				"&itemID = $itemID" .
				"&date=" . URLEncode($date) .
				"&user=" . URLEncode($user) .
				"&description=" . URLEncode($description);
} else {
	updateItem($hostName, $itemID, $date, $user, $description);
	$queryString = "hgOwner=$hgOwner" .
				"&hostGroupID=$hgid" .
				"&hostName=$hostName";
}
	

################################################### SUBROUTINES
#UPDATE ITEM
sub updateItem {
	my ($hostName, $itemID, $date, $user, $description) = @_;
	my $changeLog = lock_retrieve("$perfhome/var/logs/changelogs/$hostName.ser") or die("Could not lock_retrieve from $perfhome/var/logs/changelogs/$hostName.ser");
	my $changeLogIndex = $changeLog->{'index'};
	# Create value array
	my $valueArray = [];
	$valueArray->[0] = $date;
	$valueArray->[1] = $user;
	$valueArray->[2] = $description;
	# Update host changeLog.ser
	$changeLogIndex->{$itemID} = $valueArray;
	lock_store($changeLog, "$perfhome/var/logs/changelogs/$hostName.ser") or die("Can't store changeLog in $perfhome/var/logs/changelogs/$hostName.ser\n");
}

1;