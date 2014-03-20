use strict;
package main;
require("lib_inputCheck.pl");

# Set UserIndex
$userIndex = setUserIndex();	
	
# init message variables
$sessionObj->param("userMessage2", "");

# Login is admin
if ($sessionObj->param("role") eq "admin") {
	#input check
	$adminName = $sessionObj->param("selectedAdmin");
	$templateName = trim($request->param('templateName'));
	securityCheckTemplateName($adminName, $templateName);
	my $applyToHostList = $sessionObj->param('applyToHostList');

	#Process	
	applyTemplatesToHosts($adminName, $templateName, $applyToHostList);
	#Return Output
	$queryString = "action=displayApplied" . "&templateName=" . URLEncode($templateName);
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

################################################### SUBROUTINES
# applyTemplatesToHosts
sub applyTemplatesToHosts {
	my ($adminName, $templateName, $hostList) = @_;
	
	# Open OS Index
	my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
	
	# Extract Metric Rules
	my $metricTemplate = lock_retrieve("$perfhome/var/db/users/$adminName/metricTemplates/$templateName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$adminName/metricTemplates/$templateName.ser\n");
	my $ruleSetIndex = $metricTemplate->getRuleSetIndex();
	
	# LOOP HOSTS
	foreach my $hostName (keys(%$hostList)) {
		opendir(DIR, "$perfhome/var/db/hosts/$hostName/services") or die("ERROR: Couldn't open dir $perfhome/var/db/hosts/$hostName/services $!\n");
		my @fileNames = sort (readdir(DIR));
		
		#LOOP HOST SERVICES
		foreach my $fileName (@fileNames) {
			next if ($fileName =~ m/^\.|^\.\./);
			
			my $osName = $admin2Host->{$adminName}->{$hostName};
			$fileName =~ /^(\w+.*)\.ser$/;
			my $serviceName = $1;
			if($serviceName !~ m/conn\./) {
				$serviceName =~ /^(\w+).*$/;
				$serviceName = $1;
			}

			#IF HOST OS AND SERVICE EXIST IN ruleSetIndex, then open host service
			if (exists($ruleSetIndex->{$osName}->{$serviceName})) {
				my $serviceObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/services/$fileName") or die("Could not lock_retrieve from $perfhome/var/db/hosts/$hostName/services/$fileName\n");
				my $metricArray = $serviceObject->getMetricArray();
				my $update = 0;
				foreach my $metricObject (@$metricArray) {
					my $metricName = $metricObject->getMetricName();
					
					#IF ruleSetIndex has a rule for the metric; Then apply it to the host
					if (exists($ruleSetIndex->{$osName}->{$serviceName}->{$metricName})) {
						$metricObject->setWarnThreshold($ruleSetIndex->{$osName}->{$serviceName}->{$metricName}->{'warnThreshold'});
						$metricObject->setCritThreshold($ruleSetIndex->{$osName}->{$serviceName}->{$metricName}->{'critThreshold'});
						$metricObject->setHasEvents($ruleSetIndex->{$osName}->{$serviceName}->{$metricName}->{'hasEvents'});
						$update = 1;
					}
				}
				if ($update) {
					$serviceObject->lock_store("$perfhome/var/db/hosts/$hostName/services/$fileName") or die "ERROR: Can't store $perfhome/var/db/hosts/$hostName/services/$fileName\n";
				}
			}
		}
		closedir(DIR);
	}
}

1;