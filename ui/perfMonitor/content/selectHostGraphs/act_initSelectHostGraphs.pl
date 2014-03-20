use strict;
package main;

# CURRENT HOSTGROUP, HOSTNAME, SERVICENAME
my $test = $sessionObj->param('hgOwner');

if ($sessionObj->param("groupViewStatus") ne "shared") {
	$sessionObj->param('hgOwner', $sessionObj->param('selectedUser'));
}

checkAndSetHostName(1);
checkAndSetServiceName(1);

# CURRENT graphSize, graphLayout
if (!defined($request->param("graphLayout"))) {
	$graphLayout = "1";
} else {
	$graphLayout = $request->param("graphLayout");
}
if (!defined($request->param("graphSize"))) {
	$graphSize = "medium";
} else {
	$graphSize = $request->param("graphSize");
}
if (!defined($request->param("customSize"))) {
	$customSize = "";
} else {
	$customSize = $request->param("customSize");
}

# DEFINE ARRAY of hosts to list
$hostArray = [];
if ($sessionObj->param("hostGroupID") eq "All Hosts") {
	my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
	my $hostHash = $admin2Host->{$sessionObj->param("selectedAdmin")};
	#define array of hosts
	foreach my $hostName (sort(keys(%$hostHash))) {
		push(@$hostArray, $hostName);
	}
} else {
	my $hgID = $sessionObj->param('hostGroupID');
	my $hgOwner = $sessionObj->param('hgOwner');
	my $hostGroup = lock_retrieve("$perfhome/var/db/users/$hgOwner/hostGroups/$hgID.ser") or die("Error: can't retrieve $perfhome/var/db/users/$hgOwner/hostGroups/$hgID.ser\n");
	my $hostHash = $hostGroup->{'memberHash'};
	#define array of hosts
	foreach my $hostName (sort(keys(%$hostHash))) {
		push(@$hostArray, $hostName);
	}
}
if (@$hostArray != 0) {
	if  (length($sessionObj->param("hostName")) == 0) {
		# set default to first host in sorted hostArray
		$sessionObj->param("hostName", $hostArray->[0]);
	}
	
	# DEFINE HASH of services and graphs
	my $hostObject = populateHostObject($sessionObj->param("hostName"));
	
	my $serviceIndex = $hostObject->{'serviceIndex'};
	my $serviceHashRaw = makeServiceHashRaw($serviceIndex, "pmNav");
	
	if  (length($sessionObj->param("serviceName")) eq 0 && keys(%$serviceHashRaw) != 0) {
		# pick the first service and if necessary the first subservice
		my @serviceList = sort(keys(%$serviceHashRaw));
		$sessionObj->param("serviceName", $serviceList[0]);
	}
	
	$serviceHashRefined = makeServiceHashRefined($serviceHashRaw, "pmNav");
	$selectedHostOS = $hostObject->getOS();
	$serviceHashRefined = populateServiceHashWithDefaultGraphNames($serviceHashRefined, $selectedHostOS);
}

#-------------------------------------------------------------------------------------- populateDefaultGraphNames
sub populateServiceHashWithDefaultGraphNames {
	my ($serviceHash, $os) = @_;
	my $singleServiceGraphs = lock_retrieve("$perfhome/var/db/mappings/singleServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/singleServiceGraphs.ser");
	my $multiServiceGraphs = lock_retrieve("$perfhome/var/db/mappings/multiServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/multiServiceGraphs.ser");

	foreach my $serviceName (keys(%$serviceHash)) {
		if (!defined($singleServiceGraphs->{$os}->{$serviceName})) {
			delete($serviceHash->{$serviceName});
		} else {
			my $descriptorHash =$serviceHash->{$serviceName};
			if ( $descriptorHash->{'hasSubService'} == 0) {
				$serviceHash->{$serviceName}->{'graphHash'} = $singleServiceGraphs->{$os}->{$serviceName};
			} else {
				my $subServiceHash = $descriptorHash->{'subServiceHash'};
				foreach my $subServiceName (keys(%$subServiceHash)) {
					$serviceHash->{$serviceName}->{'subServiceHash'}->{$subServiceName} = $singleServiceGraphs->{$os}->{$serviceName};
				}
				if (keys(%$subServiceHash) > 1) {
					my $multiServiceGraphNames = [];
					my $tempHash = $multiServiceGraphs->{$os}->{$serviceName};
					foreach my $graphName (sort(keys(%$tempHash ))) {
						push (@$multiServiceGraphNames, $graphName);
					}
					$descriptorHash->{'multiServiceGraphNames'} = $multiServiceGraphNames;
				}
			}
		}
	}
	return $serviceHash;
}
1;