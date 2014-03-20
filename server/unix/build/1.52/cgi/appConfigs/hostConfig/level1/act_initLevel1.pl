use strict;
package main;

$osList = setOSlist();
$adminName = $sessionObj->param("selectedAdmin");
#define array of hosts to list
my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
my $hostList = $admin2Host->{$adminName};
$hostArray = [];
foreach my $hostName (sort(keys(%$hostList))) {
	my $hostObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/$hostName.ser") or die("Error: can't retrieve $perfhome/var/db/hosts/$hostName/$hostName.ser\n");
	my $tempArray = [];
	$tempArray->[0] = $hostName;
	$tempArray->[1] = $hostObject->getIP();
	$tempArray->[2] = $hostObject->getOS();
	push(@$hostArray, $tempArray);
}
$lenHostArray = @$hostArray;

1;