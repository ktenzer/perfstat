#  input check functions
sub checkItemName {
	my ($adminName, $itemName) = @_;
	if (length($itemName) == 0) {return("Please enter a name");}
	if(-f "$perfhome/var/db/users/$adminName/alertTemplates/$itemName.ser") {return("Template Name is already taken");}
}

sub checkEditTemplateName {
	my ($adminName, $templateName, $newTemplateName) = @_;
	if (length($newTemplateName) == 0) {return("Please enter a Template name");}
	if ( $templateName ne $newTemplateName) {
		if(-f "$perfhome/var/db/users/$adminName/alertTemplates/$newTemplateName.ser") {return("Template Name is already taken");}
	}
}

sub securityCheckTemplateName {
	my ($adminName, $templateName) = @_;
	if (length($templateName) == 0) {die('Error: missing required value for $templateName');}
	if(!(-e "$perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser")) {die('Error: invalid value for $templateName: no template file');}
}

1;
