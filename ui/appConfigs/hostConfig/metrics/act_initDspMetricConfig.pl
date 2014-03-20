use strict;
package main;

checkAndSetHostName(0);
checkAndSetServiceName(1);

# DEFINE HASH of services
my $hostObject = populateHostObject($sessionObj->param('hostName'));
my $serviceIndex = $hostObject->{'serviceIndex'};
my $serviceHashRaw = makeServiceHashRaw($serviceIndex, "appConfigHost");

if  (length($sessionObj->param('serviceName')) eq 0 && %$serviceHashRaw != 0) {
	# pick the first service and if necessary the first subservice
	my @serviceList = sort(keys(%$serviceHashRaw));
	$sessionObj->param("serviceName", $serviceList[0]);
}

$serviceHashRefined = makeServiceHashRefined($serviceHashRaw, "appConfigHost");
$serviceMetricArray = $hostObject->{'serviceIndex'}->{$sessionObj->param('serviceName')}->{'metricArray'};

1;