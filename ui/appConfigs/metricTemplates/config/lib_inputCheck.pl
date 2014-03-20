#  input check functions
sub checkNotifyRule {
	my ($notifyRule) = @_;
	if (length($notifyRule) == 0) {return("Please enter a Notify Rule");}
}

sub securityCheckTemplateName {
	my ($adminName, $templateName) = @_;
	if (length($templateName) == 0) {die('Error: missing required value for $templateName');}
	if(!(-e "$perfhome/var/db/users/$adminName/metricTemplates/$templateName.ser")) {die('Error: invalid value for $templateName: no template file');}
}

sub checkThreshold {
	my ($value, $metricName, $type) =@_;
	if (length($value) == 0) {return("Missing required value for $metricName :: $type");}
	if ($value !~ m/\b\d+\b/) {return("Invalid value for $metricName $type: must be integer");}
}

1;
