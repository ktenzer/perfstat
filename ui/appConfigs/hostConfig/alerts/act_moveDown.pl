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
	my $hostName = $sessionObj->param("hostName");
	
	my $notifyRules = lock_retrieve("$perfhome/var/db/hosts/$hostName/notifyRules.ser") or die("Could not lock_retrieve from $perfhome/var/db/hosts/$hostName/notifyRules.ser\n");
	my $contentArray = $notifyRules->getNotifyRulesArray();

	my $tempStruct = $contentArray->[$contentID + 1];
	$contentArray->[$contentID + 1] = $contentArray->[$contentID];
	$contentArray->[$contentID] = $tempStruct;

	$notifyRules->lock_store("$perfhome/var/db/hosts/$hostName/notifyRules.ser") or die "ERROR: Can't store $perfhome/var/db/hosts/$hostName/notifyRules.ser\n";

	$queryString = "hostName=" . URLEncode($hostName);
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

1;