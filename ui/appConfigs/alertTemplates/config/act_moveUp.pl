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
	my $contentID = $request->param('contentID');

	my $notificationTemplate = lock_retrieve("$perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser\n");
	my $notifyRules = $notificationTemplate->getNotifyRules();
	my $contentArray = $notifyRules->getNotifyRulesArray();

	my $tempStruct = $contentArray->[$contentID - 1];
	$contentArray->[$contentID - 1] = $contentArray->[$contentID];
	$contentArray->[$contentID] = $tempStruct;

	$notificationTemplate->lock_store("$perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser") or die "ERROR: Can't store $perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser\n";

	$queryString = "templateName=" . URLEncode($templateName);
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

1;