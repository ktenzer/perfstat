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
	
	$notifyRule = trim($request->param('notifyRule'));
	$errorMessage = checkNotifyRule($notifyRule);
	
	if (length($errorMessage) != 0) {
		$sessionObj->param("userMessage", $errorMessage);
		$queryString = "templateName=" . URLEncode($templateName) . 
						"&notifyRule=" . URLEncode($notifyRule);
	} else {
		addNotifyRule($adminName, $templateName, $notifyRule);
		$queryString = "templateName=" . URLEncode($templateName);
	}
	
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

################################################### SUBROUTINES
#addNotifyRule
sub addNotifyRule {
	my ($adminName, $templateName, $notifyRule) = @_;
	
	my $notificationTemplate = lock_retrieve("$perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser\n");
	my $notifyRules = $notificationTemplate->getNotifyRules();
	$notifyRules->addNotifyRulesArray($notifyRule);
	
	# Serialize new file
	$notificationTemplate->lock_store("$perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser") or die "ERROR: Can't store $perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser\n";
}

1;
