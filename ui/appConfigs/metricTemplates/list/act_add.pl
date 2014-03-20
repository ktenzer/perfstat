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
	$addName = trim($request->param('addName'));
	$addDescription = trim($request->param('addDescription'));
	$errorMessage = checkItemName($sessionObj->param('selectedAdmin'), $addName);

	if (length($errorMessage) != 0) {
		$sessionObj->param("userMessage", $errorMessage);
		$queryString = "addName=" . URLEncode($addName) . "&addDescription=" . URLEncode($addDescription);
	} else {
		insertTemplate($sessionObj->param('selectedAdmin'), $addName, $addDescription);
		$queryString = "";
	}
	
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

################################################### SUBROUTINES
#INSERT TEMPLATE
sub insertTemplate {
	my ($adminName, $addName, $addDescription) = @_;

	my $metricTemplate = MetricTemplate->new(	name => $addName,
													description => $addDescription);
	
	# Serialize host data to disk (host.ser)
	$metricTemplate->lock_store("$perfhome/var/db/users/$adminName/metricTemplates/$addName.ser") or die "ERROR: Can't store $perfhome/var/db/users/$adminName/metricTemplates/$addName.ser\n";
}

1;
