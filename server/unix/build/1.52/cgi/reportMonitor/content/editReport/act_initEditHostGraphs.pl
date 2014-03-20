$editHeaderText = "Edit Host Group Graph";
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
	} else  {
		$hostGroupID = $contentStruct->{'hgName'};
	}
	
	# OS to select
	$osList = setOSlist();
	# SELECTED OS
	$osName = undef;
	if (defined( $request->param('osName'))) {
		$osName = $request->param('osName');
	} else {
		$osName = $contentStruct->{'osName'};
	}
	
	# SELECTED graphServiceType
	$graphServiceType = undef;
	if (defined( $request->param('graphServiceType'))) {
		$graphServiceType = $request->param('graphServiceType');
	} else {
		$graphServiceType = $contentStruct->{'graphServiceType'};
	}
	
	# GRAPHS TO SELECT
	my $singleServiceGraphs = undef;
	my $multiServiceGraphs = undef;
	my $singleSubServiceGraphs = undef;
	
	if ($graphServiceType eq "singleService") {
		$singleServiceGraphs = lock_retrieve("$perfhome/var/db/mappings/singleServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/singleServiceGraphs.ser");
	} elsif ($graphServiceType eq "singleSubService") {
		$singleSubServiceGraphs = lock_retrieve("$perfhome/var/db/mappings/singleServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/singleServiceGraphs.ser");
	} elsif ($graphServiceType eq "aggregateSubService") {
		$multiServiceGraphs = lock_retrieve("$perfhome/var/db/mappings/multiServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/multiServiceGraphs.ser");
	} else {
		die("Error: Invalid value for graphServiceType");
	}
	
	$graphArray = [];
	if ( $graphServiceType eq "singleService") {
		$singleServiceServiceGraphsForOS = $singleServiceGraphs->{$osName};
		foreach my $serviceName (sort (keys(%$singleServiceServiceGraphsForOS))) {
			if ($serviceName eq "cpu" || $serviceName eq "mem" || $serviceName eq "procs" || $serviceName eq "socket" || $serviceName eq "uptime") {
				my $graphNameList = $singleServiceServiceGraphsForOS->{$serviceName};
				foreach my $graphName (sort(keys(%$graphNameList))) {
					my $tempStruct = {};
					$tempStruct->{'graphIndex'} = $single;
					$tempStruct->{'serviceName'} = $serviceName;
					$tempStruct->{'graphName'} = $graphName;
					push(@$graphArray, $tempStruct);
				}
			}
		}
	} elsif ($graphServiceType eq "singleSubService") {
		$singleSubServiceServiceGraphsForOS = $singleSubServiceGraphs->{$osName};
		foreach my $serviceName (sort (keys(%$singleSubServiceServiceGraphsForOS))) {
			if ($serviceName eq "fs" || $serviceName eq "io" || $serviceName eq "tcp") {
				my $graphNameList = $singleSubServiceServiceGraphsForOS->{$serviceName};
				foreach my $graphName (sort(keys(%$graphNameList))) {
					my $tempStruct = {};
					$tempStruct->{'graphIndex'} = $singleSubService;
					$tempStruct->{'serviceName'} = $serviceName;
					$tempStruct->{'graphName'} = $graphName;
					push(@$graphArray, $tempStruct);
				}
			}
		}
	} elsif ($graphServiceType eq "aggregateSubService") {
		$aggregateSubServiceGraphsForOS = $multiServiceGraphs->{$osName};
		foreach my $serviceName (sort (keys(%$aggregateSubServiceGraphsForOS))) {
			my $graphNameList = $aggregateSubServiceGraphsForOS->{$serviceName};
			foreach my $graphName (sort(keys(%$graphNameList))) {
				my $tempStruct = {};
				$tempStruct->{'graphIndex'} = $multi;
				$tempStruct->{'serviceName'} = $serviceName . ".all";
				$tempStruct->{'graphName'} = $graphName;
				push(@$graphArray, $tempStruct);
				my $tempStruct = {};
				$tempStruct->{'graphIndex'} = $multi;
				$tempStruct->{'serviceName'} = $serviceName . ".Total";
				$tempStruct->{'graphName'} = $graphName;
				push(@$graphArray, $tempStruct);
			}
		}
	} else {
		die("Error: Invalid value for graphServiceType");
	}
	
	# SELECTED GRAPHS
	$selectGraphs = [];
	if (defined( $request->param('selectGraphs'))) {
		@$selectGraphs = $request->param('selectGraphs');
	} else {
		$selectGraphs->[0] ="$contentStruct->{'serviceName'}^$contentStruct->{'graphName'}";
	}
	
	# HOSTS TO SELECT
	my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
	$hostArray = [];
	if ($hostGroupID eq "All Hosts") {
		my $hostHash = $admin2Host->{$sessionObj->param('selectedAdmin')};
		#define array of hosts
		foreach my $hostName (sort(keys(%$hostHash))) {
			if ($hostHash->{$hostName} eq $osName) {
				my $tempStruct = {};
				$tempStruct->{'hostName'} = $hostName;
				push(@$hostArray, $tempStruct);
			}
		}
	} else {
		my $hgOwner = $sessionObj->param("selectedUser");
		my $hostGroup = lock_retrieve("$perfhome/var/db/users/$hgOwner/hostGroups/$hostGroupID.ser") or die("Error: can't retrieve $perfhome/var/db/users/$hgOwner/hostGroups/$hostGroupID.ser\n");
		my $hostHash = $hostGroup->{'memberHash'};
		#define array of hosts
		foreach my $hostName (sort(keys(%$hostHash))) {
			if ($admin2Host->{$sessionObj->param('selectedAdmin')}->{$hostName} eq $osName) {
				my $tempStruct = {};
				$tempStruct->{'hostName'} = $hostName;
				push(@$hostArray, $tempStruct);
			}
		}
	}
	# SELECTED HOSTS
	$selectHosts = [];
	if (defined($request->param('selectHosts'))) {
		@$selectHosts = $request->param('selectHosts');
	} else {
		$selectHosts->[0] = $contentStruct->{'hostName'}
	}
	
	if ($graphServiceType eq "singleSubService") {
		my $serviceName;
		if (@$selectGraphs eq 0) {
			my $myStruct = $graphArray->[0];
			$serviceName = $myStruct->{'serviceName'};
			my $graphName = $myStruct->{'graphName'};
			my $value="$serviceName^$graphName";
			push(@$selectGraphs, $value);
		} else {
			$value = $selectGraphs->[0];
			my @splitString = split(/\^/, $value);
			$serviceName = $splitString[0];
		}
		my $selectedHost;
		if (@$selectHosts eq 0) {
			my $myStruct = $hostArray->[0];
			my $hostName = $myStruct->{'hostName'};
			push(@$selectHosts, $hostName);
			$selectedHost = $hostName;
		} else {
			$selectedHost = $selectHosts->[0];
		}
		# SUBSERVICES TO SELECT
		$subServiceArray = [];
		$hostObject = populateHostObject($selectedHost);
		my $serviceIndex = $hostObject->{'serviceIndex'};
		foreach my $fullServiceName (sort(keys(%$serviceIndex))) {
			my $prefix = $fullServiceName;
			$prefix =~ s/\..*//;
			my $suffix = $fullServiceName;
			$suffix =~ s/.*\.//;
			if ($prefix eq $serviceName) {
				if ($suffix ne "Total") {
					push(@$subServiceArray, $suffix);
				}
			}
		}
		
		# SELECTED SUBSERVICES
		$selectSubServices = [];
		if (defined($request->param('selectSubServices'))) {
			@$selectSubServices = $request->param('selectSubServices');
		} else {
			$selectSubServices->[0] = $contentStruct->{'subServiceName'};
		}
	}
	
	# SELECTED graph intervals
	$graphInterval = [];
	if (defined( $request->param('graphInterval'))) {
		@$graphInterval = $request->param('graphInterval');
	} else {
		$graphInterval->[0] = $contentStruct->{'intervalName'}; 
	}
	# SELECTED graph types
	$graphType = [];
	if (defined( $request->param('graphType'))) {
		@$graphType = $request->param('graphType');
	} else {
		$graphType->[0] = $contentStruct->{'graphType'}; 
	}
}
1;