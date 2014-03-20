#  input check functions

sub checkHostName {
	my ($hostName) = @_;
	if (length($hostName) == 0) {return("Please enter a host name");}
}

sub checkIPAddress {
	my ($ipAddress) = @_;
	if ($ipAddress !~ /(\d+)(\.\d+){3}/) { return("Please enter a valid IP Address"); } 
   	if ($ipAddress !~ /^([\d]+)\.([\d]+)\.([\d]+)\.([\d]+)$/) { return("Please enter a valid IP Address"); } 
	foreach $s (($1, $2, $3, $4)) { 
		if (0 > $s || $s > 255) { return("Please enter a valid IP Address");} 
  	}
}

sub checkThreshold {
	my ($value, $metricName, $type) =@_;
	#print ("test: $value $metricName $type<br>");
	if (length($value) == 0) {return("Missing required value for $metricName $type");}
	if ($value !~ m/\b\d+\b/) {return("Invalid value for $metricName $type: must be integer");}
}

sub checkUnit {
	my ($value, $metricName, $type) =@_;
	#print ("test: $value $metricName $type <br>");
	if (length($value) == 0) {return("Missing required value for $metricName $type");}
	if ($value =~ m/[0-9]/) {return("Invalid value for $metricName $type: must be non-numeric");}
}
1;