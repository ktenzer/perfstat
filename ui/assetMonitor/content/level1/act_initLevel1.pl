use strict;
package main;

#populate hostGroupArray
$hostGroupArray = populateHostGroupArray();

if ($sessionObj->param("groupViewStatus") ne "shared") {
	$navLinkChosen = "myHostGroups";
} else {
	$navLinkChosen = "sharedHostGroups";
	if ($sessionObj->param("showAllHosts")) {
		unshiftAllHostsToHostGroupArray();
	}
}

if (defined($request->param('doToggle'))) {
	my $hgid = $sessionObj->param('hostGroupID');
	$toggleScript = "toggle2('$hgid-less', '$hgid-more');";
} else {
	$toggleScript = "";
}

#-------------------------------------------------------------------------------------populateHostGroupArray
sub populateHostGroupArray {
	my ($initTarget) = @_;
	my $hostGroupArray = [];
	my $hgOwner = $sessionObj->param("selectedUser");
	my $user2HostGroup = lock_retrieve("$perfhome/var/db/mappings/user2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2HostGroup.ser");
	my $hostGroupIndex = {};
	if ($sessionObj->param("groupViewStatus") eq "self") {
		$hostGroupIndex = $user2HostGroup->{$sessionObj->param("selectedAdmin")}->{$hgOwner}->{$hgOwner};
	} elsif ($sessionObj->param("groupViewStatus") eq "shared") {
		my $ownerIndex = $user2HostGroup->{$sessionObj->param("selectedAdmin")};
		foreach my $owner (keys(%$ownerIndex)) {
		if($owner ne $sessionObj->param("selectedUser")) {
			   my $userIndex = $ownerIndex->{$owner};
			   foreach my $user (keys(%$userIndex)) {
					if ($user eq $sessionObj->param("selectedUser")) {
						my $hgIndex = $userIndex->{$user};
						foreach my $hgName (keys(%$hgIndex)) {
						    $hostGroupIndex->{$hgName} = $owner;
						}
					}
			   	}
      			}
		}
	}
	foreach my $hostGroupID (sort(keys(%$hostGroupIndex))) {
		my $hgOwner = $sessionObj->param("selectedUser");
		if ($sessionObj->param("groupViewStatus") eq "shared") {
			$hgOwner = $hostGroupIndex->{$hostGroupID};
		}
		my $hostGroupObject = lock_retrieve("$perfhome/var/db/users/$hgOwner/hostGroups/$hostGroupID.ser") or die("$perfhome/var/db/users/$hgOwner/hostGroups/$hostGroupID.ser");
		my $hostGroupDescHash = {};
		$hostGroupDescHash->{'hostGroupDescription'} = $hostGroupObject->getDescription();
		$hostGroupDescHash->{'hostGroupID'} = $hostGroupID;
		$hostGroupDescHash->{'hostGroupOwner'} = $hgOwner;
		$hostGroupDescHash->{'hostCount'} = $hostGroupObject->getMemberHashLength();
		$hostGroupDescHash->{'linuxCount'} = 0;
		$hostGroupDescHash->{'sunCount'} = 0;
		$hostGroupDescHash->{'windowsCount'} = 0;
		$hostGroupDescHash->{'hostGroupMemberHash'} = {};
		my $hgMemberHash = $hostGroupObject->{memberHash};
		foreach my $hostName (sort(keys(%$hgMemberHash))) {
			my $hostObject = populateHostObject($hostName);
			my $hostDescHash = {};
			$hostDescHash->{'ip'} = $hostObject->getIP();	
			$hostDescHash->{'os'} = $hostObject->getOS();	
			if ($hostDescHash->{'os'} eq "Linux") {
				$hostGroupDescHash->{'linuxCount'} = $hostGroupDescHash->{'linuxCount'} + 1;
			} elsif ($hostDescHash->{'os'} eq "SunOS") {
				$hostGroupDescHash->{'sunCount'} = $hostGroupDescHash->{'sunCount'} + 1;
			} elsif ($hostDescHash->{'os'} eq "WindowsNT") {
				$hostGroupDescHash->{'windowsCount'} = $hostGroupDescHash->{'windowsCount'} + 1;
			}
			$hostDescHash->{'cpuModel'} = $hostObject->getCpuModel();
			$hostGroupDescHash->{'hostGroupMemberHash'}->{$hostName} = $hostDescHash;
		}
		push(@$hostGroupArray, $hostGroupDescHash);
	}
	return $hostGroupArray;
}

#-------------------------------------------------------------------------------------unshiftAllHostsToHostGroupArray
sub unshiftAllHostsToHostGroupArray {
	my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
	my $hostGroupID = "All Hosts";
 	my $hgMemberHash = {};
	my $hostList = $admin2Host->{$sessionObj->param("selectedAdmin")};
	foreach my $hostName (sort(keys(%$hostList))) {
		$hgMemberHash->{$hostName} = 0;
	}
	my $hostGroupDescHash = {};
	$hostGroupDescHash->{'hostCount'} = keys(%$hgMemberHash);
	$hostGroupDescHash->{'hostGroupID'} = $hostGroupID;
	$hostGroupDescHash->{'hostGroupOwner'} = $sessionObj->param("selectedAdmin");
	$hostGroupDescHash->{'hostGroupDescription'} = "All hosts in the PerfStat system";
	foreach my $hostName (sort(keys(%$hgMemberHash))) {
		my $hostObject = populateHostObject($hostName);
		my $hostDescHash = {};
		$hostDescHash->{'ip'} = $hostObject->getIP();	
		$hostDescHash->{'os'} = $hostObject->getOS();	
		if ($hostDescHash->{'os'} eq "Linux") {
			$hostGroupDescHash->{'linuxCount'} = $hostGroupDescHash->{'linuxCount'} + 1;
		} elsif ($hostDescHash->{'os'} eq "SunOS") {
			$hostGroupDescHash->{'sunCount'} = $hostGroupDescHash->{'sunCount'} + 1;
		} elsif ($hostDescHash->{'os'} eq "WindowsNT") {
			$hostGroupDescHash->{'windowsCount'} = $hostGroupDescHash->{'windowsCount'} + 1;
		}
		$hostDescHash->{'cpuModel'} = $hostObject->getCpuModel();
		$hostGroupDescHash->{'hostGroupMemberHash'}->{$hostName} = $hostDescHash;
	}
	unshift(@$hostGroupArray, $hostGroupDescHash);
}

1;