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
	my $selectHosts = [];
	if (!defined($request->param('selectHosts'))) {
		$errorMessage = "Select a Host";
	} else {
		@$selectHosts = $request->param('selectHosts');
	}
	if (length($errorMessage) != 0) {
		$sessionObj->param("userMessage", $errorMessage);
		$queryString = "templateName=" . URLEncode($templateName);
	} else {
		my $applyToHostList = $sessionObj->param('applyToHostList');
		foreach my $hostName (@$selectHosts) {
			checkSelectHostName($adminName, $hostName);
			my $hostObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/$hostName.ser") or die("Error: can't retrieve $perfhome/var/db/hosts/$hostName/$hostName.ser\n");
			my $ipAddress = $hostObject->getIP();
			$applyToHostList->{$hostName} = $ipAddress;
		}
		$sessionObj->param('applyToHostList', $applyToHostList);
		$queryString = "templateName=" . URLEncode($templateName);
	}
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

1;