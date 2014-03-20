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
	deleteTemplateService($adminName, $templateName, $osName, $serviceName);
	$queryString = "templateName=" . URLEncode($templateName) .
								"&osName=" . URLEncode($osName) . 
								"&serviceName=" . URLEncode($serviceName);
	
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

################################################### SUBROUTINES
#deleteTemplateService
sub deleteTemplateService {
	my ($adminName, $templateName, $osName, $serviceName) = @_;
	
	my $metricTemplate = lock_retrieve("$perfhome/var/db/users/$adminName/metricTemplates/$templateName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$adminName/metricTemplates/$templateName.ser\n");
	$ruleSetIndex = $metricTemplate->getRuleSetIndex();
	delete($ruleSetIndex->{$osName}->{$serviceName});
	$metricTemplate->lock_store("$perfhome/var/db/users/$adminName/metricTemplates/$templateName.ser") or die "ERROR: Can't store $perfhome/var/db/users/$adminName/metricTemplates/$templateName.ser\n";
}

1;
