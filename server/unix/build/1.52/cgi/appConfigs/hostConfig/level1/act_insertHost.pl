use strict;
use File::Copy;
package main;
require("lib_inputCheck.pl");

# Set UserIndex
$userIndex = setUserIndex();	
$osList = setOSlist();	
# init message variables
$sessionObj->param("userMessage", "");
my $errorMessage = "";

# Login is admin
if ($sessionObj->param("role") eq "admin") {
	$osName = $request->param('osName');
	checkOSName($osName);
	$newHostName = trim($request->param('newHostName'));
	$errorMessage = checkHostName($newHostName);
	if (length($errorMessage) eq 0) {
		$ipAddress = trim($request->param('ipAddress'));
		$errorMessage = checkIPAddress($ipAddress);
	}
	if (length($errorMessage) != 0) {
		$sessionObj->param("userMessage", $errorMessage);
		$queryString = "newHostName=" . URLEncode($newHostName) .
						"&ipAddress=" . URLEncode($ipAddress) .
						"&osName=$osName";
	} else {
		insertHost($sessionObj->param("selectedAdmin"), $newHostName, $ipAddress, $osName);
		$queryString = "";
	}
	
} else {
	# Login is user
	die('ERROR: invalid value for $sessionObj->param("role")')
}

################################################### SUBROUTINES
#INSERT HOST
sub insertHost {
	my ($adminName, $hostName, $ipAddress, $osName) = @_;
	# Create host object
	my $hostObject = Host->new(	OS		=> $osName,
								IP 		=> $ipAddress,
								Owner	=> $adminName);
	
	# Create host directory
	if ( ! -d "$perfhome/var/db/hosts/$hostName" ) {
		mkdir("$perfhome/var/db/hosts/$hostName", 0770) or die "ERROR: Cannot mkdir $perfhome/var/db/hosts/$hostName: $!\n";
	}
	# Create services directory
	if ( ! -d "$perfhome/var/db/hosts/$hostName/services" ) {
		mkdir("$perfhome/var/db/hosts/$hostName/services", 0770) or die "ERROR: Cannot mkdir $perfhome/var/db/hosts/$hostName/services: $!\n";
	}
	# Serialize host data to disk (host.ser)
	$hostObject->lock_store("$perfhome/var/db/hosts/$hostName/$hostName.ser") or die "ERROR: Can't store $perfhome/var/db/hosts/$hostName/$hostName.ser\n";

	# Copy default ping serialized file to conn.ping serialized file
	if (! -f "$perfhome/var/db/hosts/$hostName/services/conn.ping.ser") {
		copy("$perfhome/etc/configs/$osName/conn.ping.ser","$perfhome/var/db/hosts/$hostName/services/conn.ping.ser")
			or die "ERROR: Couldn't serialize default conn.ping data for $hostName: $!\n";
	}

	# Update admin2Host Index									
	my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
	$admin2Host->{$adminName}->{$hostName} = $osName;
	lock_store($admin2Host, "$perfhome/var/db/mappings/admin2Host.ser") or die("Can't store admin2Host in $perfhome/var/db/mappings/admin2Host.ser\n");

	# Add Blank Changelog
	my $changeLog = {};
	$changeLog->{'sequence'} = 0;
	$changeLog->{'index'} = {};
	lock_store($changeLog, "$perfhome/var/logs/changelogs/$hostName.ser") or die("Can't store changeLog in $perfhome/var/logs/changelogs/$hostName.ser\n");
}

1;
