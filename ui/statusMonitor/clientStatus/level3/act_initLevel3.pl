use strict;
package main;

checkAndSetHostGroupID(0);
checkAndSetHostName(0);
checkAndSetServiceName(1);

$hostObject = populateHostObject($sessionObj->param("hostName"));
my $serviceIndex = $hostObject->{'serviceIndex'};
my $serviceHashRaw = makeServiceHashRaw($serviceIndex, "smLevel2");
my $testServiceName = $sessionObj->param("serviceName");

if  (length($sessionObj->param("serviceName")) == 0 && keys(%$serviceHashRaw) != 0) {
	# pick the first service and if necessary the first subservice
	my @serviceList = sort(keys(%$serviceHashRaw));
	$sessionObj->param("serviceName", $serviceList[0]);
}

$serviceHashRefined = makeServiceHashRefined($serviceHashRaw, "smLevel2");
1;