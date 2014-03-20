#  input check functions

sub securityCheckItemID {
	my ($adminName, $itemID) = @_;
	if (length($itemID) == 0) {die('Error: missing required value for $itemID');}
	if(!(-d "$perfhome/var/db/hosts/$itemID")) {die('Error: invalid value for $itemID: no host directory');}
	if(!(-e "$perfhome/var/db/hosts/$itemID/$itemID.ser")) {die('Error: invalid value for $itemID: no host file');}
	if (!(exists( $hostIndex->{$itemID}))) {die('Error: invalid value for $itemID');}
	if ($adminName ne "perfstat") {
		if ($hostIndex->{$itemID}->getOwner() ne $adminName)  {die('ERROR invalid permissions for $adminName');}
	}
}

sub checkItemName {
	my ($itemName) = @_;
	if (length($itemName) == 0) {return("Please enter a host group name");}
}

sub securityCheckItemName {
	my ($adminName, $itemName) = @_;
	if (length($itemName) == 0) {die('Error: missing required value for $itemName');}
	if(!(-d "$perfhome/var/db/hosts/$itemName")) {die('Error: invalid value for $itemName: no host directory');}
	if(!(-e "$perfhome/var/db/hosts/$itemName/$itemName.ser")) {die('Error: invalid value for $itemName: no host file');}
	if (!(exists( $hostIndex->{$itemName}))) {die('Error: invalid value for $itemName');}
	if ($adminName ne "perfstat") {
		if ($hostIndex->{$itemName}->getOwner() ne $adminName)  {die('ERROR invalid permissions for $adminName');}
	}
}

1;