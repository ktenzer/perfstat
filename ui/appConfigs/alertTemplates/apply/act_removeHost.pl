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
	#input check
	$adminName = $sessionObj->param("selectedAdmin");
	$templateName = trim($request->param('templateName'));
	securityCheckTemplateName($adminName, $templateName);
	my $hostName = trim($request->param('hostName'));
	checkSelectHostName($adminName, $hostName);
	#Process
	my $applyToHostList = $sessionObj->param('applyToHostList');
	delete($applyToHostList->{$hostName});
	$sessionObj->param('applyToHostList', $applyToHostList);
	#Return Output
	$queryString = "templateName=" . URLEncode($templateName);
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

1;