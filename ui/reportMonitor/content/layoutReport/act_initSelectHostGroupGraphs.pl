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
	# SELECTED HOSTGROUPS
	$selectHostGroups = [];
	if (defined( $request->param('selectHostGroups'))) {
		@$selectHostGroups = $request->param('selectHostGroups');
	}
	
	# SELECTED graph intervals
	$graphInterval = [];
	if (defined( $request->param('graphInterval'))) {
		@$graphInterval = $request->param('graphInterval');
	}
	# SELECTED graph types
	$graphType = [];
	if (defined( $request->param('graphType'))) {
		@$graphType = $request->param('graphType');
	}
	
	# SELECTED GRAPHS
	$selectGraphs = [];
	if (defined( $request->param('selectGraphs'))) {
		@$selectGraphs = $request->param('selectGraphs');
	}
	
	
	# GRAPHS TO SELECT
	my $hostGroupServiceGraphs = lock_retrieve("$perfhome/var/db/mappings/hostGroupServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/hostGroupServiceGraphs.ser");
	$graphArray = [];
	foreach my $serviceName (sort (keys(%$hostGroupServiceGraphs))) {
		my $graphNameList = $hostGroupServiceGraphs->{$serviceName};
		foreach my $graphName (sort(keys(%$graphNameList))) {
			my $value = $graphNameList->{$graphName};
			my $tempStruct = {};
			$tempStruct->{'serviceName'} = $serviceName;
			$tempStruct->{'graphName'} = $graphName;
			push(@$graphArray, $tempStruct);
		}
	}
}
1;