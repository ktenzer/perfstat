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
	my $hostName = $request->param('hostName');
	securityCheckHostName($sessionObj->param("selectedAdmin"), $hostName);
	deleteHost($sessionObj->param("selectedAdmin"), $hostName);
	$queryString = 	"";
	
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

1;