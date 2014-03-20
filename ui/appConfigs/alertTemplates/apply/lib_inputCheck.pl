sub securityCheckTemplateName {
	my ($adminName, $templateName) = @_;
	if (length($templateName) == 0) {die('Error: missing required value for $templateName');}
	if(!(-e "$perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser")) {die('Error: invalid value for $templateName: no template file');}
}

sub checkSelectHostName {
	my ($adminName, $hostName) = @_;
	if (length($hostName) == 0) {die('Error: missing required value for $hostName');}
	if(!(-d "$perfhome/var/db/hosts/$hostName")) {die('Error: invalid value for $hostName: no host directory');}
	if(!(-e "$perfhome/var/db/hosts/$hostName/$hostName.ser")) {die('Error: invalid value for $hostName: no host file');}
}

1;