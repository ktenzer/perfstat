#  input check functions

sub checkReportName {
	my ($userName, $reportName) = @_;
	if (length($reportName) == 0) {return("Please enter a report name");}
	if(-e "$perfhome/var/db/users/$userName/reports/$reportName.ser") {return("Report Name is already taken");}
}

1;