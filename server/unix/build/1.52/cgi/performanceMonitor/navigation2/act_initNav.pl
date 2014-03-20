use strict;
package main;

$hostGroupID = $sessionObj->param("hostGroupID");
my $hgOwner = $sessionObj->param("selectedUser");
my $adminName = $sessionObj->param("selectedAdmin");

if ($hostGroupID ne "All Hosts") {
	my $hostGroupObject = lock_retrieve("$perfhome/var/db/users/$hgOwner/hostGroups/$hostGroupID.ser") or die("$perfhome/var/db/users/$hgOwner/hostGroups/$hostGroupID.ser");
	$hgMemberHash = $hostGroupObject->{memberHash};
} else {
	my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
	$hgMemberHash = $admin2Host->{$adminName};
}

$hostGroupDescHash = {};
if (keys(%$hgMemberHash) == 0) {
	$hostGroupDescHash->{'hasHosts'} = 0;
	$hostGroupDescHash->{'hostGroupID'} = $hostGroupID;
	$hostGroupDescHash->{'hostGroupOwner'} = $hgOwner;
	$hostGroupDescHash->{'hostGroupMemberHash'} = {};
} else {
	$hostGroupDescHash->{'hasHosts'} = 1;
	$hostGroupDescHash->{'hostGroupID'} = $hostGroupID;
	$hostGroupDescHash->{'hostGroupOwner'} = $hgOwner;	
	$hostGroupDescHash->{'hostGroupMemberHash'} = {};
	foreach my $hostName (sort(keys(%$hgMemberHash))) {
		my $hostObject = populateHostObject($hostName);
		my $serviceIndex = $hostObject->{'serviceIndex'};
		my $hostDescHash = {};
		$hostDescHash->{'hasServices'} = 0;
		$hostDescHash->{'serviceHash'} = {};
		if (keys(%$serviceIndex) != 0) {
			$hostDescHash->{'hasServices'} = 1;
			my $serviceHashRaw = makeServiceHashRaw($serviceIndex, "pmNav");
			if (keys(%$serviceHashRaw) == 0) {
				$hostDescHash->{'hasGraphs'} = 0
			} else {
				$hostDescHash->{'hasGraphs'} = 1;
				$hostDescHash->{'OS'} =  $hostObject->getOS();
				my $serviceHashRefined = makeServiceHashRefined($serviceHashRaw, 'pmNav');
				$serviceHashRefined = populateServiceHashWithDefaultGraphNames($serviceHashRefined, $hostDescHash->{'OS'});
				$hostDescHash->{'serviceHash'} = $serviceHashRefined;
			}
		}
		$hostGroupDescHash->{'hostGroupMemberHash'}->{$hostName} = $hostDescHash;
	}
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
					foreach my $graphName (sort(keys(%$tempHash))) {
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