use strict;
package main;
require("lib_inputCheck.pl");

$adminName = $sessionObj->param("selectedAdmin");
$templateName = trim($request->param('templateName'));
securityCheckTemplateName($adminName, $templateName);

$notifyRule = trim($request->param('notifyRule'));
$editFlag = trim($request->param('editFlag'));
if(!defined($editFlag)) {$editFlag = -1;}

#retrieve current values from ser file
my $notificationTemplate = lock_retrieve("$perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser\n");
my $notifyRules = $notificationTemplate->getNotifyRules();
$notifyRulesArrayLength = $notifyRules->getNotifyRulesArrayLength();
$notifyRulesArray = $notifyRules->getNotifyRulesArray();

1;