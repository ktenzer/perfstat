#  input check functions
sub checkNotifyRule {
	my ($notifyRule) = @_;
	if (length($notifyRule) == 0) {return("Please enter a Notify Rule");}
}

1;
