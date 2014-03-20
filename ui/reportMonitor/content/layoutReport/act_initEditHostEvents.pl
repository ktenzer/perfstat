$editHeaderText = "Edit Host Events";
$contentID = $request->param('contentID');
my $contentArray = $reportObject->getContentArray();
my $contentStruct = $contentArray->[$contentID];

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
	# SELECTED HOSTGROUP
	$hostGroupID = undef;
	if (defined( $request->param('hostGroupID'))) {
		$hostGroupID = $request->param('hostGroupID');
	} else {
		$hostGroupID = $contentStruct->{'hgName'};
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
	if (defined($request->param('selectHosts'))) {
		@$selectHosts = $request->param('selectHosts');
	} else {
		$selectHosts->[0] = $contentStruct->{'hostName'};
	}
	my $selectedHost = $selectHosts->[0];
	
	# SERVICES TO SELECT
	$serviceArray = [];
	$hostObject = populateHostObject($selectedHost);
	my $serviceIndex = $hostObject->{'serviceIndex'};
	foreach my $fullServiceName (sort(keys(%$serviceIndex))) {
		my $suffix = $fullServiceName;
		$suffix =~ s/.*\.//;
		if ($suffix ne "Total") {
			if ($serviceIndex->{$fullServiceName}) {
				push(@$serviceArray, $fullServiceName);
			}
		}
	}
	
	# SELECTED SERVICES
	$selectServices = [];
	if (defined($request->param('selectServices'))) {
		@$selectServices = $request->param('selectServices');
	} else {
		$selectServices->[0] = $contentStruct->{'serviceName'};
	}
}
1;