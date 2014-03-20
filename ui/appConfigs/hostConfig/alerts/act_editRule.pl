use strict;
package main;

# Set UserIndex
$userIndex = setUserIndex();	
	
# init message variables
$sessionObj->param("userMessage", "");
my $errorMessage = "";

# Login is admin
if ($sessionObj->param("role") eq "admin") {
	my $contentID = $request->param('contentID');
	$notifyRule = trim($request->param('notifyRule'));
	editNotifyRule($contentID, $notifyRule);
	$queryString = "hostName=" . URLEncode($sessionObj->param('hostName'));
	
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

################################################### SUBROUTINES
sub editNotifyRule {
	my ($contentID, $notifyRule) = @_;
	
	my $hostName = $sessionObj->param("hostName");
	my $notifyRules = lock_retrieve("$perfhome/var/db/hosts/$hostName/notifyRules.ser") or die("Could not lock_retrieve from $perfhome/var/db/hosts/$hostName/notifyRules.ser\n");
	$notifyRules->updateNotifyRulesArray($contentID, $notifyRule);
	$notifyRules->lock_store("$perfhome/var/db/hosts/$hostName/notifyRules.ser") or die "ERROR: Can't store $perfhome/var/db/hosts/$hostName/notifyRules.ser\n";
}

1;
