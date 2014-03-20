sub checkItemName {
	my ($itemName) = @_;
	if (length($itemName) == 0) {return("Please enter a host group name");}
}

sub checkSelectHostName {
	my ($adminName, $hostName) = @_;
	if (length($hostName) == 0) {die('Error: missing required value for $hostName');}
	if(!(-d "$perfhome/var/db/hosts/$hostName")) {die('Error: invalid value for $hostName: no host directory');}
	if(!(-e "$perfhome/var/db/hosts/$hostName/$hostName.ser")) {die('Error: invalid value for $hostName: no host file');}
}

1;