use strict;
package main;
require("lib_inputCheck.pl");

if ($sessionObj->param("role") eq "user") {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

$newHostName = $request->param('newHostName');
$ipAddress = trim($request->param('ipAddress'));
$osName = trim($request->param('osName'));

my $hostName = $sessionObj->param("hostName");
my $serviceName = $sessionObj->param("serviceName");
my $errorMessage = "";
my $errorCondition = 1;

#Sort through params and update thresholds
my $hostObject = populateHostObject($hostName);
my $serviceIndex = $hostObject->{'serviceIndex'};

my $serviceObject = $serviceIndex->{$serviceName};
my $arrayLength = $serviceObject->getMetricArrayLength();

for (my $counter=0; $counter < $arrayLength; $counter++) {
	my $metricObject = $serviceObject->{metricArray}->[$counter];
	my $hasEvents = $metricObject->getHasEvents();          
	my $status = $metricObject->getStatus();

	if ($hasEvents =~ m/-1/) {
		next;
	} elsif ($hasEvents =~ m/0/) {
		my $event="hasEvents_$counter";

		my $tempWarnThreshold=$metricObject->getWarnThreshold();
		my $tempCritThreshold=$metricObject->getCritThreshold();
		my $tempThresholdUnit=$metricObject->getThresholdUnit();
		my $tempHasEvents=trim($request->param($event));

		#Set hasEvents to 0 if not defined or 1
		if (! defined $tempHasEvents) {
			$tempHasEvents="0";
		} else {
			$tempHasEvents="1";
		}
		$errorCondition = updateMetricThresholds($serviceObject, $tempWarnThreshold, $tempCritThreshold, $tempThresholdUnit, $tempHasEvents, $counter);
	} else {
		my $warn="warnThreshold_$counter";
		my $crit="critThreshold_$counter";
		my $unit="thresholdUnit_$counter";
		my $event="hasEvents_$counter";
		my $tempWarnThreshold=trim($request->param($warn));
		my $tempCritThreshold=trim($request->param($crit));
		my $tempThresholdUnit=trim($request->param($unit));
		my $tempHasEvents=trim($request->param($event));

		#Set hasEvents to 0 if not defined
		if (! defined $tempHasEvents) {
			$tempHasEvents="0";
		} else {
			$tempHasEvents="1";
		}

		#print("$tempWarnThreshold $tempCritThreshold $tempThresholdUnit $tempHasEvents<br>");
		$errorCondition = updateMetricThresholds($serviceObject, $tempWarnThreshold,$tempCritThreshold,$tempThresholdUnit,$tempHasEvents,$counter);
	}
}

if ($errorCondition == 0)  {
	# Serialize host data to disk (host.ser)
	$serviceObject->lock_store("$perfhome/var/db/hosts/$hostName/services/$serviceName.ser") or die "ERROR: Can't store $perfhome/var/db/hosts/$hostName/services/$serviceName.ser\n";
	$sessionObj->param("userMessage2", "Metrics Updated");
}
$queryString = "action=selectMetricConfig" .
					"&hostName=" . URLEncode($hostName) .
					"&serviceName=" . URLEncode($serviceName) .
					"&newHostName=" . URLEncode($newHostName) .
					"&ipAddress=" . URLEncode($ipAddress) .
					"&osName=" . URLEncode($osName);


################################################### SUBROUTINES
#Update Metric Thresholds
sub updateMetricThresholds {
	my ($serviceObject, $tempWarnThreshold, $tempCritThreshold, $tempThresholdUnit,$tempHasEvents,$counter) = @_;
	#print ("crit: $tempCritThreshold warn: $tempWarnThreshold unit: $tempThresholdUnit event: $tempHasEvents count: $counter<br>");
	my $errorCondition = 0;
	my $metricObject = $serviceObject->{metricArray}->[$counter];
	my $friendlyName = $metricObject->getFriendlyName();
	my $lowThreshold = $metricObject->getLowThreshold();
	my $highThreshold = $metricObject->getHighThreshold();

	my $typeWarn="Warn";
	my $typeCrit="Crit";
	my $typeUnit="Unit";

	#Input Checking
	if ($tempWarnThreshold >= $tempCritThreshold) {
		$errorMessage="Invalid value for $friendlyName Warn: warn must be less than crit";
		$sessionObj->param("userMessage2", $errorMessage);
		$errorCondition = 1;
	}

	if ($tempWarnThreshold < $lowThreshold || $tempWarnThreshold > $highThreshold) {
		$errorMessage="Invalid value for $friendlyName Warn: value must be between $lowThreshold and $highThreshold";
		$sessionObj->param("userMessage2", $errorMessage);
		$errorCondition = 1;
	}

	if ($tempCritThreshold < $lowThreshold || $tempCritThreshold > $highThreshold) {
		$errorMessage="Invalid value for $friendlyName Crit: value must be between $lowThreshold and $highThreshold";
		$sessionObj->param("userMessage2", $errorMessage);
		$errorCondition = 1;
	}

	$errorMessage=checkThreshold($tempWarnThreshold,$friendlyName,$typeWarn);
	if (length($errorMessage) ne 0)  {
		$sessionObj->param("userMessage2", $errorMessage);
		$errorCondition = 1;
	}

	$errorMessage=checkThreshold($tempCritThreshold,$friendlyName,$typeCrit);
	if (length($errorMessage) ne 0) {
		$sessionObj->param("userMessage2", $errorMessage);
		$errorCondition = 1;
	}

	$errorMessage=checkUnit($tempThresholdUnit,$friendlyName,$typeUnit);
	if (length($errorMessage) ne 0)  {
		$sessionObj->param("userMessage2", $errorMessage);
		$errorCondition = 1;
	}

	#Update metrics
	if ($errorCondition == 0) {
		$metricObject->setCritThreshold($tempCritThreshold);
		$metricObject->setWarnThreshold($tempWarnThreshold);
		$metricObject->setThresholdUnit($tempThresholdUnit);
		$metricObject->setHasEvents($tempHasEvents);
	}
	return $errorCondition;
}

1;
