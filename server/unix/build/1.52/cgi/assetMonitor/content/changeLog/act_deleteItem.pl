use strict;
package main;
require("lib_inputCheck.pl");

my $hgOwner = $sessionObj->param('hgOwner');
my $hgid = $sessionObj->param('hostGroupID');
my $hostName = $sessionObj->param('hostName');
my $itemID = $request->param('itemID');
deleteItem($hostName, $itemID);
$queryString = "hgOwner=$hgOwner" .
				"&hostGroupID=$hgid" .
				"&hostName=$hostName";

################################################### SUBROUTINES
# DELETE ITEM
sub deleteItem {
	my ($hostName, $itemID) = @_;
	my $changeLog = lock_retrieve("$perfhome/var/logs/changelogs/$hostName.ser") or die("Could not lock_retrieve from $perfhome/var/logs/changelogs/$hostName.ser");
	my $changeLogIndex = $changeLog->{'index'};
	delete($changeLogIndex->{$itemID});
	lock_store($changeLog, "$perfhome/var/logs/changelogs/$hostName.ser") or die("Can't store changeLog in $perfhome/var/logs/changelogs/$hostName.ser\n");
}

1;