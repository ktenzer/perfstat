#  input check functions
sub checkOSName {
	my ($osName) = @_;
	my $osListLen = @$osList;
	my $osFound = 0;
	for ($osCount = 0; $osFound == 0 && $osCount < $osListLen; $osCount++) {
		if ($osList->[$osCount] eq $osName) {
			$osFound = 1;
		}
	} 
	if ($osFound == 0) { die('Error: invalid value for $osName'); }
}

sub checkHostName {
	my ($hostName) = @_;
	if (length($hostName) == 0) {return("Please enter a host name");}
	if(-d "$perfhome/var/db/hosts/$hostName") {return("Host Name is already taken");}
}

sub checkIPAddress {
	my ($ipAddress) = @_;
	if ($ipAddress !~ /(\d+)(\.\d+){3}/) { return("Please enter a valid IP Address"); } 
   	if ($ipAddress !~ /^([\d]+)\.([\d]+)\.([\d]+)\.([\d]+)$/) { return("Please enter a valid IP Address"); } 
	foreach $s (($1, $2, $3, $4)) { 
		if (0 > $s || $s > 255) { return("Please enter a valid IP Address");} 
  	}
}

sub securityCheckHostName {
	my ($adminName, $hostName) = @_;
	if (length($hostName) == 0) {die('Error: missing required value for $hostName');}
	if(!(-d "$perfhome/var/db/hosts/$hostName")) {die('Error: invalid value for $hostName: no host directory');}
	if(!(-d "$perfhome/var/db/hosts/$hostName/services")) {die('Error: invalid value for $hostName: no host services directory');}
	if(!(-e "$perfhome/var/db/hosts/$hostName/$hostName.ser")) {die('Error: invalid value for $hostName: no host file');}
}

1;
