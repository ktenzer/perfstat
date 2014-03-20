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
if (length($errorMessage) != 0) {
	$sessionObj->param("userMessage", $errorMessage);
	$queryString = "hgOwner=$hgOwner" .
				"&hostGroupID=$hgid" .
				"&hostName=$hostName" .
				"&date=" . URLEncode($date) .
				"&user=" . URLEncode($user) .
				"&description=" . URLEncode($description);
} else {
	insertItem($sessionObj->param('hostName'), $date, $user, $description);
	$queryString = "hgOwner=$hgOwner" .
				"&hostGroupID=$hgid" .
				"&hostName=$hostName";
}
	

################################################### SUBROUTINES
#INSERT ITEM
sub insertItem {
	my ($hostName, $date, $user, $description) = @_;
	my $changeLog = lock_retrieve("$perfhome/var/logs/changelogs/$hostName.ser") or die("Could not lock_retrieve from $perfhome/var/logs/changelogs/$hostName.ser");
	my $changeLogSequence = $changeLog->{'sequence'} = $changeLog->{'sequence'} + 1;
	my $changeLogIndex = $changeLog->{'index'};
	# Create value array
	my $valueArray = [];
	$valueArray->[0] = $date;
	$valueArray->[1] = $user;
	$valueArray->[2] = $description;
	# Update host changeLog.ser
	$changeLogIndex->{$changeLogSequence} = $valueArray;
	lock_store($changeLog, "$perfhome/var/logs/changelogs/$hostName.ser") or die("Can't store changeLog in $perfhome/var/logs/changelogs/$hostName.ser\n");
}

1;