#Libraray of UserIndex and HostGroupList function for perfstat CGI

###############################USERINDEX AND HOST GROUP HASH FUNCTIONS FUNCTIONS ################
######################################################## setUserIndex
sub setUserIndex {
	my $userIndex = {};
	my $admin2User = lock_retrieve("$perfhome/var/db/mappings/admin2User.ser") or die("Could not lock_retrieve sessions from $perfhome/var/db/mappings/admin2User.ser");
	# Login is perfstat admin
	if ($sessionObj->param("userName") eq "perfstat") {
		foreach my $adminName (sort(keys(%$admin2User))) {
			$userList = $admin2User->{$adminName};
			foreach my $userName (sort(keys(%$userList))) {
				my $role = "admin";
				if ($adminName ne $userName) {
					$role = "user";
				}
				$userIndex->{$adminName}->{$userName} = $role;
			}
		}
	# Login is group admin
	} elsif ($sessionObj->param("role") eq "admin") {
		my $adminName = $sessionObj->param("creator");
		my $userList = $admin2User->{$adminName};
		foreach my $userName (sort(keys(%$userList))) {
			my $role = "admin";
			if ($adminName ne $userName) {
				$role = "user";
			}
			$userIndex->{$adminName}->{$userName} = $role;
		}
	# Login is user
	} else {
		my $adminName = $sessionObj->param('creator');
		my $userName = $sessionObj->param('userName');
		$userIndex->{$adminName}->{$adminName} = "admin";
		$userIndex->{$adminName}->{$userName} = "user";
	}
	return $userIndex;
}

#---------------------------------------------------------------------------------------------populateHostGroupArray
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
		#find hostGroup member array
		my $hgMemberHash = $hostGroupObject->{memberHash};
		my $hostGroupDescHash = {};
		if (keys(%$hgMemberHash) == 0) {
			$hostGroupDescHash->{'hasHosts'} = 0;
			$hostGroupDescHash->{'hostGroupID'} = $hostGroupID;
			$hostGroupDescHash->{'hostGroupOwner'} = $hgOwner;
			if ($initTarget eq "smLevel1") {
				$hostGroupDescHash->{'hostGroupServiceHash'} = {};
			} elsif($initTarget eq "smNav") {	
				$hostGroupDescHash->{'hostGroupMemberHash'} = {};
			}
		} else {
			$hostGroupDescHash->{'hasHosts'} = 1;
			$hostGroupDescHash->{'hostGroupID'} = $hostGroupID;
			$hostGroupDescHash->{'hostGroupOwner'} = $hgOwner;
			if ($initTarget eq "smLevel1") {
				my $serviceHash = makeLevel1StatusHash($hgMemberHash);
				$hostGroupDescHash->{'hostGroupServiceHash'} = $serviceHash;
			} elsif($initTarget eq "smNav" || $initTarget eq "pmNav") {	
				$hostGroupDescHash->{'hostGroupMemberHash'} = {};
				foreach my $hostName (sort(keys(%$hgMemberHash))) {
					my $hostObject = populateHostObject($hostName);
					my $serviceIndex = $hostObject->{'serviceIndex'};
					my $hostDescHash = {};
					$hostDescHash->{'hasServices'} = 0;
					$hostDescHash->{'serviceHash'} = {};
					if (keys(%$serviceIndex) != 0) {
						$hostDescHash->{'hasServices'} = 1;
						my $serviceHashRaw = makeServiceHashRaw($serviceIndex, $initTarget);
						if (keys(%$serviceHashRaw) == 0) {
							if ($initTarget eq "smNav") {
								$hostDescHash->{'hasServices'} = 0;
							} elsif ($initTarget eq "pmNav") {
								$hostDescHash->{'hasGraphs'} = 0;
							}
						} else {
							if ($initTarget eq "smNav") {
								$hostDescHash->{'hasServices'} = 1;
							} elsif ($initTarget eq "pmNav") {
								$hostDescHash->{'hasGraphs'} = 1;
							}
							my $serviceHashRefined = makeServiceHashRefined($serviceHashRaw, $initTarget);
							$hostDescHash->{'serviceHash'} = $serviceHashRefined;
						}
					}
					$hostGroupDescHash->{'hostGroupMemberHash'}->{$hostName} = $hostDescHash;
				}
			}
		}
		push(@$hostGroupArray, $hostGroupDescHash);
	}
	return $hostGroupArray;
}

#-------------------------------------------------------------------------------------unshiftAllHostsToHostGroupArray
sub unshiftAllHostsToHostGroupArray {
	my ($initTarget) = @_;
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
		if ($initTarget eq "smLevel1") {
			$hostGroupDescHash->{'hostGroupServiceHash'} = {};
		} elsif($initTarget eq "smNav") {	
			$hostGroupDescHash->{'hostGroupMemberHash'} = {};
		}
	} else {
		$hostGroupDescHash->{'hasHosts'} = 1;
		$hostGroupDescHash->{'hostGroupID'} = $hostGroupID;
		$hostGroupDescHash->{'hostGroupOwner'} = $sessionObj->param("selectedAdmin");
		if ($initTarget eq "smLevel1") {
			my $serviceHash = makeLevel1StatusHash($hgMemberHash);
			$hostGroupDescHash->{'hostGroupServiceHash'} = $serviceHash;
		} elsif($initTarget eq "smNav" || $initTarget eq "pmNav") {	
			foreach my $hostName (sort(keys(%$hgMemberHash))) {
				my $hostObject = populateHostObject($hostName);
				my $serviceIndex = $hostObject->{'serviceIndex'};
				my $hostDescHash = {};
				$hostDescHash->{'hasServices'} = 0;
				$hostDescHash->{'serviceHash'} = {};
				if (keys(%$serviceIndex) != 0) {
					my $serviceHashRaw = makeServiceHashRaw($serviceIndex, $initTarget);
					if (keys(%$serviceHashRaw) == 0) {
						if ($initTarget eq "smNav") {
							$hostDescHash->{'hasServices'} = 0;
						} elsif ($initTarget eq "pmNav") {
							$hostDescHash->{'hasGraphs'} = 0;
						}
					} else {
						if ($initTarget eq "smNav") {
							$hostDescHash->{'hasServices'} = 1;
						} elsif ($initTarget eq "pmNav") {
							$hostDescHash->{'hasGraphs'} = 1;
						}
						my $serviceHashRefined = makeServiceHashRefined($serviceHashRaw, $initTarget);
						$hostDescHash->{'serviceHash'} = $serviceHashRefined;
					}
				}
				$hostGroupDescHash->{'hostGroupMemberHash'}->{$hostName} = $hostDescHash;
			}
		}
	}
	unshift(@$hostGroupArray, $hostGroupDescHash);
}

#-------------------------------------------------------------------------------------unshiftAllHostsToHostGroupArray
sub makeLevel1StatusHash {
	my ($memberHash) = @_;
	my $serviceHash = {};
	foreach my $hostName (sort(keys(%$memberHash))) {
		my $hostObject = populateHostObject($hostName);
		my $serviceIndex = $hostObject->{'serviceIndex'};
		foreach my $service (keys(%$serviceIndex)) {
			my $serviceObject = $serviceIndex->{$service};
			my $serviceName = $serviceObject->getServiceName();
			my $arrayLength = $serviceObject->getMetricArrayLength();

			for (my $counter=0; $counter < $arrayLength; $counter++) {
				my $metricObject = $serviceObject->{metricArray}->[$counter];
				my $hasEvents = $metricObject->getHasEvents();          
				if ($hasEvents == 1) {
					my $status = $metricObject->getStatus();
					my $prefix = $service;
					$prefix =~ s/\..*//;
					if (!exists($serviceHash->{$prefix})) {
						#service not yet added
						$serviceHash->{$prefix} = $status;
					}
					#service already added
					if ($status eq "nostatus") {
						$serviceHash->{$prefix} = $status;
						last;
					} elsif ($status eq "CRIT" && $serviceHash->{$prefix} ne "nostatus") {
						$serviceHash->{$prefix} = $status;
					} elsif ($status eq "WARN" && $serviceHash->{$prefix} ne "nostatus" && $serviceHash->{$prefix} ne "CRIT") {
						$serviceHash->{$prefix} = $status;
					} elsif ($status eq "OK"  && $serviceHash->{$prefix} ne "nostatus" && $serviceHash->{$prefix} ne "CRIT" && $serviceHash->{$prefix} ne "WARN") {
						$serviceHash->{$prefix} = $status;
					}
				}
			}
		}
	}
	return $serviceHash;
}

#-------------------------------------------------------------------------------------- populateHostObject
sub populateHostObject {
	my ($hostName) = @_;
	my $hostObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/$hostName.ser") or die("Error: can't retrieve $perfhome/var/db/hosts/$hostName/$hostName.ser\n");
	#populate empty serviceHash with service objects
	my $serviceHash = {};
	opendir(SERVICESDIR, "$perfhome/var/db/hosts/$hostName/services") or die("WARNING: Couldn't open dir $perfhome/var/db/hosts/$hostName/services: $!\n");		
	while (my $serviceName = readdir(SERVICESDIR)) {
		# Skip if file starts with a . and the host.ser
		next if ($serviceName =~ m/^\.\.?$/);
		next if ($serviceName =~ m/$hostName\.ser/);

		if ($serviceName =~ /^([\S]+)\.ser$/) {
			#create service object by deserialization
			my $serviceObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/services/$serviceName") or die("WARNING: can't retriewe $perfhome/var/db/hosts/$hostName/services/$serviceName\n");
			#assign service object to service hash
			$serviceHash->{$1} = $serviceObject;
		} else {
			warn "ERROR: Serialized service data not found for $hostName:$serviceName\n";
			exit(1);
		}
	}
	closedir(SERVICESDIR);
	#assign serviceHash to hostIndex
	$hostObject->{serviceIndex} = $serviceHash;
	return $hostObject;
}

#----------------------------------------------------------------------------------------------------- makeServiceHashRaw
sub makeServiceHashRaw {
	my ($serviceIndex, $initTarget) = @_;
	my $rawHash = {};
	foreach my $fullServiceName (keys(%$serviceIndex)) {
		my $serviceObject = $serviceIndex->{$fullServiceName};
		if ($initTarget eq "smNav" || $initTarget eq "smLevel1") {
			$rawHash->{$fullServiceName} = $serviceIndex->{$fullServiceName};
		} elsif ($initTarget eq "appConfigHost" && $fullServiceName !~ m/conn/) {
			$rawHash->{$fullServiceName} = $serviceIndex->{$fullServiceName};
		} elsif($initTarget eq "pmNav") {
				$rawHash->{$fullServiceName} = {};
		} elsif($initTarget eq "smLevel2") {
			my $arrayLength = $serviceObject->getMetricArrayLength();
			for (my $counter=0; $counter < $arrayLength; $counter++) {
				my $metricObject = $serviceObject->{metricArray}->[$counter];
				my $hasEvents = $metricObject->getHasEvents();		
				if ($hasEvents == 1) {
					my $lastMetricStatus = "OK";
					if (defined($rawHash->{$fullServiceName})){
						$lastMetricStatus = $rawHash->{$fullServiceName}
					}
					my $update = 0;
					my $endLoop = 0;
					my $newMetricStatus = $metricObject->getStatus();
					if ($newMetricStatus eq "nostatus") {
						$newMetricStatus = "nostatus";
						$update = 1;
						$endLoop = 1;
					} elsif ($newMetricStatus eq "CRIT" && ($lastMetricStatus ne "nostatus")) {
						$newMetricStatus  = "CRIT";
						$update = 1;
					} elsif ($newMetricStatus eq "WARN" && ($lastMetricStatus ne "nostatus") && ($lastMetricStatus ne "CRIT")) {
						$newMetricStatus = "WARN";
						$update = 1;
					} elsif ($newMetricStatus eq "OK" && ($lastMetricStatus ne "nostatus") && ($lastMetricStatus ne "CRIT") && ($lastMetricStatus ne "WARN")) {
						$newMetricStatus = "OK";
						$update = 1;
					} else {
						$update = 0;
					}
					if($update) {
						$rawHash->{$fullServiceName} = $newMetricStatus;
					}
					last if($endLoop);
				}
			}
		}		
	}
	return $rawHash;
}
#-------------------------------------------------------------------------------------- makeServiceHashRefined
sub makeServiceHashRefined {
	my ($rawHash, $initTarget) = @_;
	my $previousServicePrefix = "";
	my $refinedHash = {};
	foreach my $fullServiceName (sort(keys(%$rawHash))) {
		my $prefix = $fullServiceName;
		$prefix =~ s/\..*//;
		# new service or subservice
		if ($prefix ne $previousServicePrefix) {
			# if not subservice
			if ($fullServiceName !~ m/\S+\.\S+/) {
				my $tempHash = {};
				$tempHash->{'hasSubService'} = 0;
				if($initTarget eq "smLevel2" || $initTarget eq "appConfigHost") {
					my $status = $rawHash->{$fullServiceName};
					$tempHash->{'status'} = $status;
				} elsif($initTarget eq "pmNav" ) {
					$tempHash->{'graphHash'} = $rawHash->{$fullServiceName};
				}
				$refinedHash->{$prefix} = $tempHash;
				$previousServicePrefix = $prefix;
			# if is first occurrence of subservice
			} else {
				my $tempHash = {};
				my $suffix = $fullServiceName;
				$suffix =~ s/.*\.//;
				$tempHash->{'hasSubService'} = 1;
				if ($initTarget eq "smNav" || $initTarget eq "smLevel1" || $initTarget eq "pmNav" || $initTarget eq "appConfigHost") {
					$tempHash->{'subServiceHash'}->{$suffix} = $rawHash->{$fullServiceName};
				} elsif($initTarget eq "smLevel2" ) {
					my $status = $rawHash->{$fullServiceName};
					$tempHash->{'subServiceHash'}->{$suffix} = $status;
					$tempHash->{'status'} = $status;
				}
				$refinedHash->{$prefix} = $tempHash;
				$previousServicePrefix = $prefix;
			}
		# next occurrence of previously entered subservice
		} else {
			my $suffix = $fullServiceName;
			$suffix =~ s/^\w+\.//;
			if ($initTarget eq "smNav" || $initTarget eq "smLevel1" || $initTarget eq "pmNav" || $initTarget eq "appConfigHost") {
				$refinedHash->{$prefix}->{'subServiceHash'}->{$suffix} = $rawHash->{$fullServiceName};
			} elsif($initTarget eq "smLevel2") {
				my $status = $rawHash->{$fullServiceName};
				$refinedHash->{$prefix}->{'subServiceHash'}->{$suffix} = $status;
				if ($status eq "nostatus") {
					$refinedHash->{$prefix}->{'status'} = "nostatus";
				} elsif ($status eq "CRIT" && $refinedHash->{$prefix}->{'status'} ne "nostatus") {
					$refinedHash->{$prefix}->{'status'}  = "CRIT";
				} elsif ( $status eq "WARN" && $refinedHash->{$prefix}->{'status'} ne "nostatus" && $refinedHash->{$prefix}->{'status'} ne "CRIT") {
					$refinedHash->{$prefix}->{'status'}  = "WARN";
				} elsif ($status eq "OK" && $refinedHash->{$prefix}->{'status'}  ne "nostatus" && $refinedHash->{$prefix}->{'status'} ne "CRIT" && $refinedHash->{$prefix}->{'status'}  ne "WARN") {
					$refinedHash->{$prefix}->{'status'}   = "OK";
				}
			}
		}
	}
	return $refinedHash;
}

1;
