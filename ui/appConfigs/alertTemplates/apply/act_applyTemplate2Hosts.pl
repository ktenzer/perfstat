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
	
	# Extract Notify Rules
	my $notificationTemplate = lock_retrieve("$perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser\n");
	my $newNotifyRules = $notificationTemplate->getNotifyRules();
	
	# APPLY TO each host
	
	foreach my $hostName (keys(%$hostList)) {
		$newNotifyRules->lock_store("$perfhome/var/db/hosts/$hostName/notifyRules.ser") or die "ERROR: Can't store $perfhome/var/db/hosts/$hostName/notifyRules.ser\n";
	}
}

1;