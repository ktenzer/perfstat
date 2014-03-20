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
	$adminName = $sessionObj->param('selectedAdmin');
	
	$notifyRule = trim($request->param('notifyRule'));
	$errorMessage = checkNotifyRule($notifyRule);
	
	if (length($errorMessage) != 0) {
		$sessionObj->param("userMessage", $errorMessage);
		$queryString = "hostName=" . URLEncode($sessionObj->param('hostName')) . 
							"&notifyRule=" . URLEncode($notifyRule);
	} else {
		addNotifyRule($sessionObj->param('hostName'), $notifyRule);
		$queryString = "hostName=" . URLEncode($sessionObj->param('hostName'));
	}
	
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

################################################### SUBROUTINES
#addNotifyRule
sub addNotifyRule {
	my ($hostName, $notifyRule) = @_;
	
	my $notifyRules;
	if (-e "$perfhome/var/db/hosts/$hostName/notifyRules.ser") {
		$notifyRules = lock_retrieve("$perfhome/var/db/hosts/$hostName/notifyRules.ser") or die("Could not lock_retrieve from $perfhome/var/db/hosts/$hostName/notifyRules.ser\n");
	} else {
		$notifyRules = NotifyRules->new();
	}
	$notifyRules->addNotifyRulesArray($notifyRule);
	# Serialize new file
	$notifyRules->lock_store("$perfhome/var/db/hosts/$hostName/notifyRules.ser") or die "ERROR: Can't store $perfhome/var/db/hosts/$hostName/notifyRules.ser\n";
}

1;
