use strict;
package main;
require("lib_inputCheck.pl");

$adminName = $sessionObj->param("selectedAdmin");
$templateName = trim($request->param('templateName'));
securityCheckTemplateName($adminName, $templateName);

#Set OS drop down
$osList = setOSlist();
$osName = trim($request->param('osName'));
if (!defined $osName) { $osName = $osList->[0]; }

#Set Service drop down
$serviceList = [];
opendir(DIR, "$perfhome/etc/configs/$osName") or die("ERROR: Couldn't open dir $perfhome/etc/configs/$osName $!\n");
my @serviceNames = sort (readdir(DIR));
foreach my $fileName (@serviceNames) {
	next if ($fileName =~ m/^\.|^\.\./);
	next if ($fileName =~ m/host\.ser/);
	
	my $serviceObject = lock_retrieve("$perfhome/etc/configs/$osName/$fileName") or die("Could not lock_retrieve from $perfhome/etc/configs/$osName/$fileName\n");
	my $metricArray = $serviceObject->getMetricArray();
	my $addToServiceList = 0;
	foreach my $metricObject (@$metricArray) {
		my $hasEvents = $metricObject->getHasEvents();
		if ($hasEvents =~ m/-1/) { 
			next; 
		} else {
			$addToServiceList = 1;
			last;
		}
	}
	
	if ($addToServiceList) {
		$fileName =~ s/\.ser$//;
		push(@$serviceList, $fileName);
	}
}
$serviceName = trim($request->param('serviceName'));
if (!defined $serviceName) { $serviceName = $serviceList->[0] }

#GET METRIC LIST
$metricList = [];
my $serviceObject = lock_retrieve("$perfhome/etc/configs/$osName/$serviceName.ser") or die("Could not lock_retrieve from $perfhome/etc/configs/$osName/$perfhome/etc/configs/$osName/$serviceName.ser\n");
$metricList = $serviceObject->getMetricArray();
$metricListLength = $serviceObject->getMetricArrayLength();

#retrieve current metric template
my $metricTemplate = lock_retrieve("$perfhome/var/db/users/$adminName/metricTemplates/$templateName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$adminName/metricTemplates/$templateName.ser\n");
$ruleSetIndex = $metricTemplate->getRuleSetIndex();
$ruleSetIndexLength = keys(%$ruleSetIndex);
$ruleSetExists = exists($ruleSetIndex->{$osName}->{$serviceName});
my $currentValues = {};
if($ruleSetExists) {
	$currentValues = $ruleSetIndex->{$osName}->{$serviceName};
}

#GET INPUT HASH
$inputHash = {};
foreach my $metricObject (@$metricList) {
	my $metricName = $metricObject->getMetricName();
	my $hasEvents = $metricObject->getHasEvents();
	if ($hasEvents =~ m/-1/) { 
		next; 
	}
	my $inputStruct = {};
	my $warn="warnThreshold^$metricName";
	if(defined($request->param($warn))) {
		$inputStruct->{'warnThreshold'} = trim($request->param($warn));
	} else {
		if($ruleSetExists) {
			$inputStruct->{'warnThreshold'} = $currentValues->{$metricName}->{'warnThreshold'};
		} else {
			$inputStruct->{'warnThreshold'} = $metricObject->getWarnThreshold();
		}
	}
	my $crit="critThreshold^$metricName";
	if(defined($request->param($crit))) {
		$inputStruct->{'critThreshold'} = trim($request->param($crit));
	} else {
		if($ruleSetExists) {
			$inputStruct->{'critThreshold'} = $currentValues->{$metricName}->{'critThreshold'};
		} else {
			$inputStruct->{'critThreshold'} = $metricObject->getCritThreshold();
		}
	}
	my $event="hasEvents^$metricName";
	if(defined($request->param($event))) {
		$inputStruct->{'hasEvents'} = trim($request->param($event));
	} else {
		if($ruleSetExists) {
			$inputStruct->{'hasEvents'} = $currentValues->{$metricName}->{'hasEvents'};
		} else {
			$inputStruct->{'hasEvents'} =  $metricObject->getHasEvents();
		}
	}
	$inputHash->{$metricName} = $inputStruct;
}

1;