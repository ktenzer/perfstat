use strict;
package main;
require("lib_inputCheck.pl");

$adminName = $sessionObj->param("selectedAdmin");
$templateName = trim($request->param('templateName'));
securityCheckTemplateName($adminName, $templateName);

#define array of hosts to list in add host dropdown
my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
$hostList = $admin2Host->{$adminName};
$hostListLen = keys(%$hostList);

if (defined($request->param('start')) || !defined($sessionObj->param('applyToHostList'))) {
	my $applyToHostList = {};
	$sessionObj->param('applyToHostList', $applyToHostList);
}

# delete from hostlist the hosts already in applytoHostHash
my $applyToHostList = $sessionObj->param('applyToHostList');
foreach my $hostName (sort(keys(%$applyToHostList))) {
	delete($hostList->{$hostName});
}

1;