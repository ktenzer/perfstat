use strict;
package main;
require("lib_inputCheck.pl");

$userIndex = setUserIndex();	

# init message variables
$sessionObj->param("userMessage1", "");
$sessionObj->param("userMessage2", "");
my $errorMessage = "";

# Login is admin
if ($sessionObj->param("role") eq "admin") {
	$adminName = $sessionObj->param("selectedAdmin");
	my $hostName = trim($request->param('hostName'));
	securityCheckHostName($adminName, $hostName);
	 
	$editName = $request->param('editName');
	$editipAddress = trim($request->param('editipAddress'));
	
	$errorMessage = checkEditHostName($editName);
	if (length($errorMessage) eq 0) {
		$errorMessage = checkIPAddress($editipAddress);
	}

	if (length($errorMessage) ne 0) {
		$sessionObj->param("userMessage2", $errorMessage);
		$queryString =  "editFlag=" . URLEncode($hostName) .
							"&editName=" . URLEncode($editName) .
							"&editipAddress=" . URLEncode($editipAddress);
	} else {
		editHost($sessionObj->param("selectedAdmin"), $hostName, $editName, $editipAddress);
		$sessionObj->param("hostName",  $editName);
		$queryString = ""
	}

# Login is user
} else { 
	die('ERROR: invalid value for $sessionObj->param("role")');
}

# -----------------------------------------------------------------------------------------SUBROUTINES
sub editHost() {
	my ($adminName, $hostID, $hostName, $ipAddress) = @_;
	
	## Update serialized hostObject
	my $hostObject = lock_retrieve("$perfhome/var/db/hosts/$hostID/$hostID.ser") or die("Error: can't retrieve $perfhome/var/db/hosts/$hostID/$hostID.ser\n");
	$hostObject->setIP($ipAddress);
	$hostObject->lock_store("$perfhome/var/db/hosts/$hostID/$hostID.ser") or die ("ERROR: Can't store $perfhome/var/db/hosts/$hostID/$hostID.ser\n");

	if ($hostID ne $hostName) {
		## Update admin2Host
		my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
		delete ($admin2Host->{$adminName}->{$hostID});
		$admin2Host->{$adminName}->{$hostName} = 0;
		lock_store($admin2Host, "$perfhome/var/db/mappings/admin2Host.ser") or die("Can't store admin2Host in $perfhome/var/db/mappings/admin2Host.ser\n");
		
		## Update host2HostGroup
		my $host2HostGroup = lock_retrieve("$perfhome/var/db/mappings/host2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/host2HostGroup.ser");
		my $userNameList = $host2HostGroup->{$hostID};
		foreach my $userName (keys(%$userNameList)) {
			my $hostGroupList = $userNameList->{$userName};
			foreach my $hostGroupName (keys(%$hostGroupList)) {
				updateHostGroup($userName, $hostGroupName, $hostID, $hostName);
			}
		}
		$host2HostGroup->{$hostName} = $host2HostGroup->{$hostID};
		delete($host2HostGroup->{$hostID});
		lock_store($host2HostGroup, "$perfhome/var/db/mappings/host2HostGroup.ser") or die("ERROR: Can't store admin2Host in $perfhome/var/db/mappings/host2HostGroup.ser\n");
		
		## Directories and files need to be renamed
		my @dirs=qw(rrd var/db/hosts var/status var/events tmp/events);
		foreach my $dir (@dirs) {
			next if (! -d "$perfhome/$dir/$hostID");
			opendir(DIR, "$perfhome/$dir/$hostID") or die("ERROR: Couldn't open dir $perfhome/$dir/$hostID: $!\n");
			# Rename/Remove host files
			while (my $fileName = readdir(DIR)) {
				next if ($fileName =~ m/^\.|^\.\./);
				if ($dir =~ m/rrd/) {
					$fileName =~ m/$hostID\.(\S+)\.rrd/;
					my $service="$1"; 
					rename("$perfhome/$dir/$hostID/$fileName","$perfhome/$dir/$hostID/$hostName.$service.rrd") or die "WARNING: Couldn't rename $fileName: $!\n";
				} elsif ($dir =~ m/var\/db\/hosts/) {
					next if ($fileName !~ m/$hostID/);
					rename("$perfhome/$dir/$hostID/$fileName","$perfhome/$dir/$hostID/$hostName.ser") or die "WARNING: Couldn't rename $fileName: $!\n";
				} else {
					unlink "$perfhome/$dir/$hostID/$fileName" or die "Couldn't remove file $perfhome/$dir/$hostID/$fileName!\n";
				}
			}
			closedir(DIR);
			rename("$perfhome/$dir/$hostID","$perfhome/$dir/$hostName") or die "ERROR: Couldn't rename $perfhome/$dir/$hostID: $!\n";
		}
	}
	# update Changelog
  rename("$perfhome/var/logs/changelogs/$hostID.ser","$perfhome/var/logs/changelogs/$hostName.ser") or die "WARNING: Couldn't rename $hostID.ser: $!\n";
}

sub updateHostGroup {
	my ($userName, $hostGroupName, $hostID, $hostName) = @_;
	my $hostGroupObject = lock_retrieve("$perfhome/var/db/users/$userName/hostGroups/$hostGroupName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/hostGroups/$hostGroupName.ser");
	my $hostGroupMemberArrayLen = $hostGroupObject.getMemberArrayLength();
	for (my $count = 0; $count < $hostGroupMemberArrayLen; $count++) {
		if ($hostGroupObject->{memberArray}->[$count] eq $hostID) {
			$hostGroupObject->{memberArray}->[$count] = $hostName;
		}
	}
}

1;