#  input check functions

sub checkThreshold {
	my ($value, $metricName, $type) =@_;
	if (length($value) == 0) {return("Missing required value for $metricName $type");}
	if ($value !~ m/\b\d+\b/) {return("Invalid value for $metricName $type: must be integer");}
}

1;