use strict;
package main;

# Define AdminName and hostGroupOwner
$adminName = $sessionObj->param("selectedAdmin");
my $reportOwner =  $request->param("reportOwner");
$reportName = $request->param("reportName");

my $reportObject = lock_retrieve("$perfhome/var/db/users/$reportOwner/reports/$reportName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$reportOwner/reports/$reportName.ser\n");
$contentArray = $reportObject->getContentArray();

1;