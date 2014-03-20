use strict;
package main;

$adminName = $sessionObj->param("selectedAdmin");
$addName = trim($request->param('newName'));
$addDescription = trim($request->param('newDescription'));

$editFlag = trim($request->param('editFlag'));
if(!defined($editFlag)) {$editFlag = "none";}

$editName = trim($request->param('editName'));
$editDescription = trim($request->param('editDescription'));

# put other notification templates in sorted array
$notificationTemplateArray = [];
opendir(DIR, "$perfhome/var/db/users/$adminName/alertTemplates") or die("ERROR: Couldn't open dir $perfhome/var/db/users/$adminName/alertTemplates $!\n");
my @fileNames = sort (readdir(DIR));
foreach my $fileName (@fileNames) {
	next if ($fileName =~ m/^\.|^\.\./);
	my $notificationTemplate = lock_retrieve("$perfhome/var/db/users/$adminName/alertTemplates/$fileName") or die("$perfhome/var/db/users/$adminName/alertTemplates/$fileName\n");
	my $notificationStruct = {};
	$notificationStruct->{'name'} = $notificationTemplate->getName();
	$notificationStruct->{'editName'} = $notificationTemplate->getName();
	$notificationStruct->{'editDescription'} = $notificationTemplate->getDescription();
	if ($editFlag eq $notificationStruct->{'name'}) {
		if(defined($editName)) {$notificationStruct->{'editName'} = $editName;}
		if(defined($editDescription)) {$notificationStruct->{'editDescription'} = $editDescription; }
	}
	push(@$notificationTemplateArray, $notificationStruct);
}
$lenNotificationTemplateArray = @$notificationTemplateArray;

1;