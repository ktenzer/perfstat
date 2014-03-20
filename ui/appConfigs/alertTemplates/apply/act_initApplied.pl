use strict;
package main;
require("lib_inputCheck.pl");

$adminName = $sessionObj->param("selectedAdmin");
$templateName = trim($request->param('templateName'));
securityCheckTemplateName($adminName, $templateName);

1;