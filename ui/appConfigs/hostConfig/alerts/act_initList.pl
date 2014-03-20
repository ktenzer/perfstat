use strict;
package main;

checkAndSetHostName(0);
$adminName = $sessionObj->param("selectedAdmin");

$notifyRule = trim($request->param('notifyRule'));
$editFlag = trim($request->param('editFlag'));
if(!defined($editFlag)) {$editFlag = -1;}

#retrieve current values from ser file
my $hostName = $sessionObj->param("hostName");
if (-e "$perfhome/var/db/hosts/$hostName/notifyRules.ser") {
    my $notifyRules = lock_retrieve("$perfhome/var/db/hosts/$hostName/notifyRules.ser") or die("Could not lock_retrieve from $perfhome/var/db/hosts/$hostName/notifyRules.ser\n");
	$notifyRulesArrayLength = $notifyRules->getNotifyRulesArrayLength();
	$notifyRulesArray = $notifyRules->getNotifyRulesArray();
} else {
    $notifyRulesArrayLength = 0;
}

1;