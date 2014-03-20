use strict;
package main;
require("lib_inputCheck.pl");

# Set user index
$userIndex = setUserIndex();

# init message variables
$sessionObj->param("userMessage", "");
my $errorMessage = "";

if ($sessionObj->param("role") eq "admin") {
	# Login is admin
	my $templateName = $request->param('templateName');
	securityCheckTemplateName($sessionObj->param("selectedAdmin"), $templateName);
	deleteTemplate($sessionObj->param("selectedAdmin"), $templateName);
	$queryString = 	"";
	
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

################################################### SUBROUTINES
#DELETE TEMPLATE
sub deleteTemplate {
	my ($adminName, $templateName) = @_;
	unlink "$perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser" or die ("ERROR: Couldn't remove file $perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser!\n");
}

1;