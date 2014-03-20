#  input check functions
sub checkNotifyRule {
	my ($notifyRule) = @_;
	if (length($notifyRule) == 0) {return("Please enter a Notify Rule");}
}

sub securityCheckTemplateName {
	my ($adminName, $templateName) = @_;
	if (length($templateName) == 0) {die('Error: missing required value for $templateName');}
	if(!(-e "$perfhome/var/db/users/$adminName/alertTemplates/$templateName.ser")) {die('Error: invalid value for $templateName: no template file');}
}

1;
