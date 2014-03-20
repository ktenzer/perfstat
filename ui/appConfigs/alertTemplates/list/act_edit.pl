use strict;
package main;
require("lib_inputCheck.pl");

# Set UserIndex
$userIndex = setUserIndex();	
	
# init message variables
$sessionObj->param("userMessage", "");
$sessionObj->param("userMessage2", "");
my $errorMessage = "";

# Login is admin
if ($sessionObj->param("role") eq "admin") {
	$adminName = $sessionObj->param("selectedAdmin");
	my $templateName = trim($request->param('templateName'));
	securityCheckTemplateName($adminName, $templateName);
	
	$editName = trim($request->param('editName'));
	$editDescription = trim($request->param('editDescription'));
	$errorMessage = checkEditTemplateName($adminName, $templateName, $editName);

	if (length($errorMessage) != 0) {
		$sessionObj->param("userMessage2", $errorMessage);
		$queryString = "templateName=" . URLEncode($templateName) . 
						"&editName=" . URLEncode($editName) . 
						"&editDescription=" . URLEncode($editDescription) . 
						"&editFlag=" . URLEncode($templateName);
	} else {
		updateTemplate($adminName, $templateName, $editName, $editDescription);
		$queryString = "templateName=" . URLEncode($editName);
	}
	
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

################################################### SUBROUTINES
#UPDATE TEMPLATE
sub updateTemplate {
	my ($adminName, $templateName, $newTemplateName, $description) = @_;
	
	my $notificationTemplate = lock_retrieve("$perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser\n");
	$notificationTemplate->setName($newTemplateName);
	$notificationTemplate->setDescription($description);
	
	# Serialize new file
	$notificationTemplate->lock_store("$perfhome/var/db/users/$adminName/alertTemplates/$newTemplateName.ser") or die "ERROR: Can't store $perfhome/var/db/users/$adminName/alertTemplates/$newTemplateName.ser\n";

	if ( $templateName ne $newTemplateName) {
		# delete old file name
		unlink "$perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser" or die ("ERROR: Couldn't remove file $perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser!\n");
	}
}

1;
