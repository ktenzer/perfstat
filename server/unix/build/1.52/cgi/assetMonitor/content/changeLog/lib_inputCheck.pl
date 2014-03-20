#  input check functions
sub checkDate {
	my ($date) = @_;
	if (length($date) == 0) {return("Please enter a date");}
	
	if ($date =~ m/^((?:19|20)\d\d)[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])$/) {
    		# At this point, $1 holds the year, $2 the month and $3 the day of the date entered
    		if ($3 == 31 and ($2 == 4 or $2 == 6 or $2 == 9 or $2 == 11)) {
      		return "Please enter a valid date format"; # 31st of a month with 30 days
    		} elsif ($3 >= 30 and $2 == 2) {
      		return "Please enter a valid date format"; # February 30th or 31st
    		} elsif ($2 == 2 and $3 == 29 and not ($1 % 4 == 0 and ($1 % 100 <=> 0 or $1 % 400 == 0))) {
      		return "Please enter a valid date format"; # February 29th outside a leap year
    		} else {
      		return ""; # Valid date
    		}
  	} else {
   	 	return "Please enter a valid date format";
  	}
}

sub checkUser {
	my ($user) = @_;
	if (length($user) == 0) {return("Please enter a user");}
}



sub checkDescription {
	my ($description) = @_;
	if (length($description) == 0) {return("Please enter a description");}
}

1;