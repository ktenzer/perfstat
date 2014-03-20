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
$metricTemplateArray = [];
opendir(DIR, "$perfhome/var/db/users/$adminName/metricTemplates") or die("ERROR: Couldn't open dir $perfhome/var/db/users/$adminName/metricTemplates $!\n");
my @fileNames = sort (readdir(DIR));
foreach my $fileName (@fileNames) {
	next if ($fileName =~ m/^\.|^\.\./);
	my $metricTemplate = lock_retrieve("$perfhome/var/db/users/$adminName/metricTemplates/$fileName") or die("$perfhome/var/db/users/$adminName/metricTemplates/$fileName\n");
	my $metricStruct = {};
	$metricStruct->{'name'} = $metricTemplate->getName();
	$metricStruct->{'editName'} = $metricTemplate->getName();
	$metricStruct->{'editDescription'} = $metricTemplate->getDescription();
	if ($editFlag eq $metricStruct->{'name'}) {
		if(defined($editName)) {$metricStruct->{'editName'} = $editName;}
		if(defined($editDescription)) {$metricStruct->{'editDescription'} = $editDescription; }
	}
	push(@$metricTemplateArray, $metricStruct);
}
closedir(DIR);
$lenMetricTemplateArray = @$metricTemplateArray;

1;