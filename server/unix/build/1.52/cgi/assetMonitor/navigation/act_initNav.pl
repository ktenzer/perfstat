use strict;
package main;

$userIndex = setUserIndex();	
# Login is perfstat admin
if ($sessionObj->param("userName") eq "perfstat") {
	####
	if (defined($request->param('adminName'))) {
		if ($request->param('adminName') ne $sessionObj->param("selectedAdmin")) {
			checkAdminName($request->param('adminName'));
			$sessionObj->param("selectedAdmin", $request->param('adminName'));
			$sessionObj->param("selectedUser", $request->param('adminName'));
		}
	}
	####
	if (defined($request->param('userName'))) {
		if ($request->param('userName') ne $sessionObj->param("selectedUser")) {
			checkUserName($sessionObj->param("selectedAdmin"), $request->param('userName'));
			$sessionObj->param("selectedUser", $request->param('userName'));
		}
	}

	#define list of admin
	$adminList = $userIndex;
	#define list of users
	$userList = $userIndex->{$sessionObj->param("selectedAdmin")};

# Login is group admin
} elsif ($sessionObj->param("role") eq "admin") {
	###
	if (defined($request->param('userName'))) {
		if ($request->param('userName') ne $sessionObj->param("selectedUser")) {
			checkUserName($sessionObj->param("selectedAdmin"), $request->param('userName'));
			$sessionObj->param("selectedUser", $request->param('userName'));
		}
	}
	#define list of users
	$userList = $userIndex->{$sessionObj->param("selectedAdmin")};

# Login is user
} else {
	# do nothing
}

if (defined($request->param('groupViewStatus'))) {
	if ($request->param('groupViewStatus') ne $sessionObj->param("groupViewStatus")) {
		$sessionObj->param("groupViewStatus", $request->param('groupViewStatus'));
	}
}

#populate hostGroupArray
$hostGroupArray = populateHostGroupArray();
if (($sessionObj->param("groupViewStatus") eq "shared") && ($sessionObj->param("showAllHosts")) ) {
	unshiftAllHostsToHostGroupArray();
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
		$hostGroupDescHash->{'hostGroupID'} = $hostGroupID;
		$hostGroupDescHash->{'hostGroupOwner'} = $hgOwner;
		$hostGroupDescHash->{'hasHosts'} = $hostGroupObject->getMemberHashLength();
		$hostGroupDescHash->{'hostGroupMemberHash'} = {};
		my $hgMemberHash = $hostGroupObject->{memberHash};
		foreach my $hostName (sort(keys(%$hgMemberHash))) {
			$hostGroupDescHash->{'hostGroupMemberHash'}->{$hostName} = 0;
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
	if (keys(%$hgMemberHash) == 0) {
		$hostGroupDescHash->{'hasHosts'} = 0;
		$hostGroupDescHash->{'hostGroupID'} = $hostGroupID;
		$hostGroupDescHash->{'hostGroupOwner'} = $sessionObj->param("selectedAdmin");
		$hostGroupDescHash->{'hostGroupMemberHash'} = {};
	} else {
		$hostGroupDescHash->{'hasHosts'} = 1;
		$hostGroupDescHash->{'hostGroupID'} = $hostGroupID;
		$hostGroupDescHash->{'hostGroupOwner'} = $sessionObj->param("selectedAdmin");
		foreach my $hostName (sort(keys(%$hgMemberHash))) {
			$hostGroupDescHash->{'hostGroupMemberHash'}->{$hostName} = 0;
		}
	}
	unshift(@$hostGroupArray, $hostGroupDescHash);
}

1;