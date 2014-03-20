##Libraray of Utility function for perfstat CGI

######################################################## getConfiguration
## Bring in config functions from perf-conf
sub getConfiguration {
	my $configfile="$perfhome/etc/perf-conf";
	my $hashref = shift;

	open(FILE, $configfile) or die "ERROR: Couldn't open FileHandle for $configfile: $!\n";

	my @data=<FILE>;
	foreach my $line (@data) {
		# Skip line if commented out
		next if ($line =~ m/^#/);
		next if ($line =~ m/^\s+/);
		$line =~ m/(\w+)=(.+)/;
		my $key=$1;
		my $value=$2;
		$hashref->{$key}=$value;
	}
	close(FILE);
}

############################## INPUT CHECK FUNCTIONS ########################
sub checkAdminName {
	my ($adminName) = @_;
	if (length($adminName) == 0) {die('Error: missing required value for $adminName');}
	if(!(-d "$perfhome/var/db/users/$adminName")) {die('Error: invalid value for $adminName: no user directory');}
	if(!(-e "$perfhome/var/db/users/$adminName/$adminName.ser")) {die('Error: invalid value for $adminName: no user file');}
	if (!(exists( $userIndex->{$adminName}->{$adminName}))) {die('Error: invalid value for $adminName');}
}

sub syncAdminName {
	my ($adminName) = @_;
	if ($adminName ne $sessionObj->param("selectedAdmin")) {die('$adminName is out of sync');}
}

sub checkUserName {
	my ($adminName, $userName) = @_;
	if (length($userName) == 0) {die('Error: missing required value for $userName');}
	if(!(-d "$perfhome/var/db/users/$userName")) {die('Error: invalid value for $userName: no user directory');}
	if(!(-e "$perfhome/var/db/users/$userName/$userName.ser")) {die('Error: invalid value for $userName: no user file');}
	if (!(exists( $userIndex->{$adminName}->{$userName}))) {die('Error: invalid value for $userName');}
}

sub syncUserName {
	my ($userName) = @_;
	if ($userName ne $sessionObj->param("selectedUser")) {die('$userName is out of sync');}
}

sub checkHostName {
	my ($adminName, $hostName) = @_;
	if (length($hostName) == 0) {die('Error: missing required value for $hostName');}
	if(!(-d "$perfhome/var/db/hosts/$hostName")) {die('Error: invalid value for $hostName: no host directory');}
	if(!(-e "$perfhome/var/db/hosts/$hostName/$hostName.ser")) {die('Error: invalid value for $hostName: no host file');}
	my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
	if (!exists($admin2Host->{$sessionObj->param("selectedAdmin")}->{$hostName})) {die('Error: invalid value for $hostName');}
}

sub checkPassword {
	my ($password) = @_;
	if (length($password) == 0) {return("Please enter a password");}
	if (length($password) < 8) {return("Password must have at least 8 characters");}
}

sub checkConfirmPassword {
	my ($password, $confirmPassword) = @_;
	if ($password ne $confirmPassword) {return("Password and Confirm Password do not match");}
}

sub checkAndSetHostGroupID {
	my ($allowUndefinedRequestParam) = @_;

	my $hostGroupID;
	if (!$allowUndefinedRequestParam && !defined($request->param("hostGroupID"))) {
		die('Error: missing required value for hostGroupID');
	} else {
		$hostGroupID = defined($request->param('hostGroupID')) ? $request->param('hostGroupID') : "";
  }

	if (!defined($sessionObj->param("hostName"))) {$sessionObj->param("hostName", "");}

	if ($sessionObj->param("hostGroupID") ne $hostGroupID) {
    if (length($hostGroupID) == 0) {
      $sessionObj->param("hostGroupID", "");
    } elsif ($hostGroupID =~ /All Hosts/) {
      $sessionObj->param("hostGroupID",  "All Hosts");
    } else {
      my $user2HostGroup = lock_retrieve("$perfhome/var/db/mappings/user2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2HostGroup.ser");
      my $hostGroupList = $user2HostGroup->{$sessionObj->param("selectedAdmin")}->{$sessionObj->param('hgOwner')}->{$sessionObj->param("selectedUser")};
			if (!defined($hostGroupList->{$hostGroupID})) {
				die('Error: invalid value for $hostGroupID');
			} else {
				$sessionObj->param("hostGroupID",  $hostGroupID);
			}
		}
	}
}

sub checkAndSetHostName {
	my ($allowUndefinedRequestParam) = @_;

	my $hostName;
	if (!$allowUndefinedRequestParam && !defined($request->param("hostName"))) {
		die('Error: missing required value for hostName');
	} else {
		$hostName = defined($request->param('hostName')) ? $request->param('hostName') : "";
	}

	if (!defined($sessionObj->param("hostName"))) {$sessionObj->param("hostName", "");}

	if ($sessionObj->param("hostName") ne $hostName) {
		if (length($hostName) == 0) {
			$sessionObj->param("hostName",  "");
		} else {
			checkHostName($sessionObj->param("selectedAdmin"), $hostName);
			$sessionObj->param("hostName",  $hostName);
		}
	}
}

sub checkAndSetServiceName {
	my ($allowUndefinedRequestParam) = @_;

	my $serviceName;
	if (!$allowUndefinedRequestParam && !defined($request->param("serviceName"))) {
		die('Error: missing required value for serviceName');
	} else {
		$serviceName = defined($request->param('serviceName')) ? $request->param('serviceName') : "";
	}

	if (!defined($sessionObj->param("serviceName"))) {$sessionObj->param("serviceName", "");}
	if ($sessionObj->param("serviceName") ne $serviceName) {
		if (length($sessionObj->param("hostName")) == 0){
			#do nothing; init program will set
		} else {
			$sessionObj->param("serviceName",  $serviceName);
		}
	}
}

######################################################## setOSlist
sub setOSlist {
	#create an empty osList
	my $osList = [];

	#populate the keys of the hash with the hostNames
	opendir(STATEDIR, "$perfhome/etc/configs") or die("ERROR: Couldn't open dir $perfhome/etc/configs: $!\n");
	while (my $osName = readdir(STATEDIR)) {
		if ($osName ne "." && $osName ne "..") {
			push (@$osList, $osName);
		}
	}
	closedir(STATEDIR);
	return $osList;
}

######################################################## DELETE HOST
sub deleteHost {
	my ($adminName, $hostName) = @_;

	# Update admin2Host								
	my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("ERROR: Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
	delete($admin2Host->{$adminName}->{$hostName});
	lock_store($admin2Host, "$perfhome/var/db/mappings/admin2Host.ser") or die("ERROR: Can't store admin2Host in $perfhome/var/db/mappings/admin2Host.ser\n");
	
	## Update host2HostGroup
	my $host2HostGroup = lock_retrieve("$perfhome/var/db/mappings/host2HostGroup.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/host2HostGroup.ser");
	my $userNameList = $host2HostGroup->{$hostName};
	foreach my $userName (keys(%$userNameList)) {
		my $hostGroupList = $userNameList->{$userName};
		foreach my $hostGroupName (keys(%$hostGroupList)) {
			my $hostGroupObject = lock_retrieve("$perfhome/var/db/users/$userName/hostGroups/$hostGroupName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/hostGroups/$hostGroupName.ser\n");
			$hostGroupObject->deleteMember($hostName);
			$hostGroupObject->lock_store("$perfhome/var/db/users/$userName/hostGroups/$hostGroupName.ser") or die("ERROR: Can't store $perfhome/var/db/users/$userName/hostGroups/$hostGroupName.ser\n");
		}
	}
	$host2HostGroup->{$hostName} = $host2HostGroup->{$hostName};
	delete($host2HostGroup->{$hostName});
	lock_store($host2HostGroup, "$perfhome/var/db/mappings/host2HostGroup.ser") or die("ERROR: Can't store admin2Host in $perfhome/var/db/mappings/host2HostGroup.ser\n");
	
	# List of directories that need to be removed
	my @dirs=qw(rrd var/db/hosts var/status var/events var/alerts tmp/events);
	my $servicesSkip="";
	foreach my $dir (@dirs) {
		next if (! -d "$perfhome/$dir/$hostName");

		# Unlink all files under host dir
		opendir(DIR, "$perfhome/$dir/$hostName") or die("ERROR: Couldn't open dir $perfhome/$dir/$hostName: $!\n");

		while (my $fileName = readdir(DIR)) {
			next if ($fileName =~ m/^\.|^\.\./);
	
			# Remove services files and services dir under var/db/hosts/$host
			if ($fileName =~ m/services/) {

				$servicesSkip="1";

				opendir(SERVICESDIR, "$perfhome/$dir/$hostName/services") or die("ERROR: Couldn't open dir $perfhome/$dir/$hostName/services: $!\n");
				while (my $serviceFiles = readdir(SERVICESDIR)) {
					next if ($serviceFiles =~ m/^\.|^\.\./);
					unlink "$perfhome/$dir/$hostName/services/$serviceFiles" or die ("ERROR: Couldn't remove file $perfhome/$dir/$hostName/services/$serviceFiles!\n");
				}

				# Remove services dir if exists
				if ( -d "$perfhome/$dir/$hostName/services" ) {
					rmdir "$perfhome/$dir/$hostName/services" or die ("ERROR: Cannot rmdir $perfhome/$dir/$hostName/services: $!\n");
				}
			}

			# Skip if file matches services
			if ($servicesSkip =~ m/1/) {
				if ($fileName !~/services/) {
					unlink "$perfhome/$dir/$hostName/$fileName" or die ("ERROR: Couldn't remove file $perfhome/$dir/$hostName/$fileName!\n");
					$servicesSkip="";
				}
			} else {
				unlink "$perfhome/$dir/$hostName/$fileName" or die ("ERROR: Couldn't remove file $perfhome/$dir/$hostName/$fileName!\n");
			}
		}

		closedir(SERVICESDIR);
		closedir(DIR);

		# Remove State Dir if it exists
		if ( -d "$perfhome/$dir/$hostName" ) {
			rmdir "$perfhome/$dir/$hostName" or die ("ERROR: Cannot rmdir $perfhome/$dir/$hostName: $!\n");
		}
	}
  # Delete Changelog
  unlink "$perfhome/var/logs/changelogs/$hostName.ser" or die ("ERROR: Couldn't remove file $perfhome/var/logs/changelogs/$hostName.ser!\n");
}

#######################################################basicWebUtilFunctions
sub searchArray {
  my ($array, $searchString) = @_;
  my $isFound = 0;
  foreach $string (@$array) {
    if ($string eq $searchString) {
       $isFound = 1;
       last;
    }
  }
 return $isFound;
}

sub metaRedirect {
	my ($time, $url) = @_;
	print("<meta http-equiv=\"refresh\" content=\"$time; url=$url\">\n");
}
sub trim {
	my ($string) = @_;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
sub URLEncode {
	my ($string) = $_[0];
	$string =~ s/([\W])/"%" . uc(sprintf("%2.2x", ord($1)))/eg;
	return $string;
}
sub containsNonWordChar {
	my ($string) = @_;
	if ($string =~ /[\W]/) {
		return 1;
	} else {
		return 0;
	}
}


1;
