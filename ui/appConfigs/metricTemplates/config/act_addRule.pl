use strict;
package main;
require("lib_inputCheck.pl");

# Set UserIndex
$userIndex = setUserIndex();	
	
# init message variables
$sessionObj->param("userMessage", "");
my $errorMessage = "";

# Login is admin
if ($sessionObj->param("role") eq "admin") {
	$adminName = $sessionObj->param("selectedAdmin");
	$templateName = trim($request->param('templateName'));
	securityCheckTemplateName($adminName, $templateName);
	my $osName = trim($request->param('osName'));
	my $serviceName = trim($request->param('serviceName'));
	my $serviceObject = lock_retrieve("$perfhome/etc/configs/$osName/$serviceName.ser") or die("Could not lock_retrieve from $perfhome/etc/configs/$osName/$serviceName.ser\n");
	my $metricArray = $serviceObject->getMetricArray();

	#SET METRIC INPUT HASH
	my $inputHash = {};
	foreach my $metricObject (@$metricArray) {
		my $metricName = $metricObject->getMetricName();
		my $hasEvents = $metricObject->getHasEvents();
		if ($hasEvents =~ m/-1/) { 
			next; 
		}
		my $inputStruct = {};
		my $warn="warnThreshold^$metricName";
		my $crit="critThreshold^$metricName";
		my $event="hasEvents^$metricName";
		$inputStruct->{'warnThreshold'}=trim($request->param($warn));
		$inputStruct->{'critThreshold'}=trim($request->param($crit));
		$inputStruct->{'hasEvents'}=trim($request->param($event));
		$inputHash->{$metricName} = $inputStruct;
	}
		
	#ERROR CHECK INPUT
	foreach my $metricObject (@$metricArray) {
		my $inputStruct = {};
		my $metricName = $metricObject->getMetricName();
		my $hasEvents = $metricObject->getHasEvents();
		if ($hasEvents =~ m/-1/) { 
			next; 
		} else {
			my $friendlyName = $metricObject->getFriendlyName();
			my $lowThreshold = $metricObject->getLowThreshold();
			my $highThreshold = $metricObject->getHighThreshold();
			my $inputStruct = $inputHash->{$metricName}; 
			if(defined($inputStruct->{'warnThreshold'}) && defined($inputStruct->{'critThreshold'})) {
				$errorMessage=checkThreshold($inputStruct->{'warnThreshold'}, $friendlyName, "warn");
				if (length($errorMessage) ne 0)  {
					last;
				}
				$errorMessage=checkThreshold($inputStruct->{'critThreshold'}, $friendlyName, "crit");
				if (length($errorMessage) ne 0) {
					last;
				}
				if ($inputStruct->{'warnThreshold'} >= $inputStruct->{'critThreshold'}) {
					$errorMessage="Invalid value for $friendlyName :: Warn: warn must be less than crit";
					last;
				}
				if ($inputStruct->{'warnThreshold'} < $lowThreshold || $inputStruct->{'warnThreshold'} > $highThreshold) {
					$errorMessage="Invalid value for $friendlyName :: Warn: value must be between $lowThreshold and $highThreshold";
					last;
				}
				if ($inputStruct->{'critThreshold'} < $lowThreshold || $inputStruct->{'critThreshold'} > $highThreshold) {
					$errorMessage="Invalid value for $friendlyName :: Crit: value must be between $lowThreshold and $highThreshold";
					last;
				}
			}
		}
	}
		
	#Redirect Error Message or updateMetricTemplate
	if (length($errorMessage) != 0) {
	#ERROR MESSAGE
		$sessionObj->param("userMessage", $errorMessage);
		my $dynamicQueryString = "&";
		foreach my $metricName (keys(%$inputHash)) {
			my $inputStruct = $inputHash->{$metricName};
			my $warn = $inputStruct->{'warnThreshold'};
			my $crit = $inputStruct->{'critThreshold'};
			my $event = $inputStruct->{'hasEvents'};
			if (defined($warn)) {$dynamicQueryString .= "warnThreshold^$metricName=$warn&";}
			if (defined($crit)) {$dynamicQueryString .= "critThreshold^$metricName=$crit&";}
			if (defined($event)) {$dynamicQueryString .= "hasEvents^$metricName=$event&";}
		}
		$queryString = "templateName=" . URLEncode($templateName) .
							"&osName=" . URLEncode($osName) . 
							"&serviceName=" . URLEncode($serviceName) . $dynamicQueryString;
	} else {
	#UPDATE
		my $metricTemplate = lock_retrieve("$perfhome/var/db/users/$adminName/metricTemplates/$templateName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$adminName/metricTemplates/$templateName.ser\n");
		$ruleSetIndex = $metricTemplate->getRuleSetIndex();
		my $dynamicQueryString = "&";
		my $count = 1;
		foreach my $metricObject (@$metricArray) {
			my $metricName = $metricObject->getMetricName();
			my $hasEvents = $metricObject->getHasEvents();
			if ($hasEvents =~ m/-1/) { 
				next; 
			} else {
				my $friendlyName = $metricObject->getFriendlyName();
				my $thresholdUnit = $metricObject->getThresholdUnit();
				my $inputStruct = $inputHash->{$metricName};
				my $warn = $inputStruct->{'warnThreshold'};
				my $crit = $inputStruct->{'critThreshold'};
				my $event = $inputStruct->{'hasEvents'};
				if (defined($event)) {
					$event = 1;
				} else {		
					$event = 0;
				}
				$ruleSetIndex->{$osName}->{$serviceName}->{$metricName}->{'order'} = $count;
				$ruleSetIndex->{$osName}->{$serviceName}->{$metricName}->{'friendlyName'} = $friendlyName;
				$ruleSetIndex->{$osName}->{$serviceName}->{$metricName}->{'warnThreshold'} = $warn;
				$ruleSetIndex->{$osName}->{$serviceName}->{$metricName}->{'critThreshold'} = $crit ;
				$ruleSetIndex->{$osName}->{$serviceName}->{$metricName}->{'thresholdUnit'} = $thresholdUnit;
				$ruleSetIndex->{$osName}->{$serviceName}->{$metricName}->{'hasEvents'} = $event;
				if (defined($warn)) {$dynamicQueryString .= "warnThreshold^$metricName=$warn&";}
				if (defined($crit)) {$dynamicQueryString .= "critThreshold^$metricName=$crit&";}
				if (defined($event)) {$dynamicQueryString .= "hasEvents^$metricName=$event&";}
				$count++;
			}
		}
		# Serialize new file
		$metricTemplate->lock_store("$perfhome/var/db/users/$adminName/metricTemplates/$templateName.ser") or die "ERROR: Can't store $perfhome/var/db/users/$adminName/metricTemplates/$templateName.ser\n";
		$queryString = "templateName=" . URLEncode($templateName) .
								"&osName=" . URLEncode($osName) . 
								"&serviceName=" . URLEncode($serviceName) . $dynamicQueryString;
	}
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")');
}
1;
