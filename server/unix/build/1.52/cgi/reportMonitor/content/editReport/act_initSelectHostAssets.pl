# which report
$reportNameID = $request->param('reportNameID');

# HOSTGROUPS TO SELECT
my $hgOwner = $sessionObj->param("selectedUser");
my $user2HostGroup = lock_retrieve("$perfhome/var/db/mappings/user2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2HostGroup.ser");
my $hostGroupIndex = $user2HostGroup->{$sessionObj->param("selectedAdmin")}->{$hgOwner}->{$hgOwner};
$hostGroupArray = [];
if ($sessionObj->param("showAllHosts")) {
	push(@$hostGroupArray, "All Hosts");
}
foreach my $hgName (sort(keys(%$hostGroupIndex))) {
	push(@$hostGroupArray, $hgName);
}

if (@$hostGroupArray != 0) {
	# SELECTED HOST GROUP
	$hostGroupID = undef;
	if (defined( $request->param('hostGroupID'))) {
		$hostGroupID = $request->param('hostGroupID');
	}
	if(!defined($hostGroupID)) {
		$hostGroupID = $hostGroupArray->[0];
	}
	
	# HOSTS TO SELECT
	my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
	$hostArray = [];
	if ($hostGroupID eq "All Hosts") {
		my $hostHash = $admin2Host->{$sessionObj->param('selectedAdmin')};
		#define array of hosts
		foreach my $hostName (sort(keys(%$hostHash))) {
			my $tempStruct = {};
			$tempStruct->{'hostName'} = $hostName;
			push(@$hostArray, $tempStruct);
		}
	} else {
		my $hgOwner = $sessionObj->param("selectedUser");
		my $hostGroup = lock_retrieve("$perfhome/var/db/users/$hgOwner/hostGroups/$hostGroupID.ser") or die("Error: can't retrieve $perfhome/var/db/users/$hgOwner/hostGroups/$hostGroupID.ser\n");
		my $hostHash = $hostGroup->{'memberHash'};
		#define array of hosts
		foreach my $hostName (sort(keys(%$hostHash))) {
			my $tempStruct = {};
			$tempStruct->{'hostName'} = $hostName;
			push(@$hostArray, $tempStruct);
		}
	}
	
	# SELECTED HOSTS
	$selectHosts = [];
	if (defined( $request->param('selectHosts'))) {
		@$selectHosts = $request->param('selectHosts');
	}
	
	$cpu = [];
	if (defined( $request->param('cpu'))) {
		@$cpu = $request->param('cpu');
	}
	$memory = [];
	if (defined( $request->param('memory'))) {
		@$memory = $request->param('memory');
	}
	if (defined( $request->param('os'))) {
		@$os = $request->param('os');
	}
	$os = [];
	if (defined( $request->param('selectHostGroups'))) {
		@$selectHostGroups = $request->param('selectHostGroups');
	}
}
1;