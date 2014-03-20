#  input check functions

sub checkUserNameLocal {
	my ($userName) = @_;
	if (length($userName) == 0) {return("Please enter a user name");}
	if (containsNonWordChar($userName)) {return("User Name has an illegal character or space");}
	if (length($userName) < 4) {return("User Name must have at least 4 characters");}
	if(-d "$perfhome/var/db/users/$userName") {return("User Name is already taken");}
}

################################################### insertUser
sub insertUser {
	my ($userName, $password, $adminName, $userRole, $perfhome) = @_;
	
	# Create user directorys
	mkdir("$perfhome/var/db/users/$userName", 0770) || die("could not create directory $perfhome/var/db/users/$userName\n");
	mkdir("$perfhome/var/db/users/$userName/hostGroups", 0770) || die("could not create directory $perfhome/var/db/users/$userName/hostGroups\n");
	mkdir("$perfhome/var/db/users/$userName/reports", 0770) || die("could not create directory $perfhome/var/db/users/$userName/reports\n");

	# Create and store user object
	my $userObject = User->new(	name		=> $userName,
										password 	=> $password,
										creator		=> $adminName,
										role		=> $userRole);
	lock_store($userObject, "$perfhome/var/db/users/$userName/$userName.ser") || die("ERROR: can't store userObject in $perfhome/var/db/users/$userName/$userName.ser\n");
	
	# Create and store policy object
	if ($userRole eq "admin") {
		$groupPolicy = GroupPolicy->new();
		lock_store($groupPolicy, "$perfhome/var/db/users/$userName/groupPolicy.ser") || die("ERROR: can't store groupPolicyObject in $perfhome/var/db/users/$userName/groupPolicy.ser\n");
	}
		
	# Update admin2User Index									
	my $admin2User = lock_retrieve("$perfhome/var/db/mappings/admin2User.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/admin2User.ser");
	if ($userRole eq "admin") {
		$admin2User->{$userName}->{$userName} = 0;
	} else { # role eq user
		$admin2User->{$adminName}->{$userName} = 0;
	}
	lock_store($admin2User, "$perfhome/var/db/mappings/admin2User.ser") or die("Can't store admin2Host in $perfhome/var/db/mappings/admin2User.ser\n");
}

################################################### deleteUser
sub deleteUser {
	my ($adminName, $userName, $userRole) = @_;

	## DELETE ADMIN
	if ($userRole eq "admin") {
		my $userList = $userIndex->{$userName};
		foreach my $userNameTemp (sort(keys(%$userList))) {
			## delete admin's users including self in filesystem
			opendir(USERDIR, "$perfhome/var/db/users/$userNameTemp") or die("WARNING: Couldn't open dir $perfhome/var/db/users/$userNameTemp: $!\n");
			while (my $fileName = readdir(USERDIR)) {
				# Skip if file starts with a . 
				next if ($fileName =~ m/^\.\.?$/);
				unlink("$perfhome/var/db/users/$userNameTemp/$fileName");
			}
			closedir(USERDIR);
			rmdir("$perfhome/var/db/users/$userNameTemp/hostGroups") or die("WARNING: Couldn't remove dir $perfhome/var/db/users/$userNameTemp/hostGroups: $!\n") ;
			rmdir("$perfhome/var/db/users/$userNameTemp/reports") or die("WARNING: Couldn't remove dir $perfhome/var/db/users/$userNameTemp/reports: $!\n") ;
			rmdir("$perfhome/var/db/users/$userNameTemp") or die("WARNING: Couldn't remove dir $perfhome/var/db/users/$userNameTemp: $!\n") ;
			
			## Update user2HostGroup Index
			my $user2HostGroup = lock_retrieve("$perfhome/var/db/mappings/user2HostGroup.ser") or die("ERROR: Could not lock_retrieve from $perfhome/var/db/mappings/user2HostGroup.ser");
			delete($user2HostGroup->{$userName});
			lock_store($user2HostGroup, "$perfhome/var/db/mappings/user2HostGroup.ser") or die("ERROR: Can't store user2HostGroup in $perfhome/var/db/mappings/user2HostGroup.ser\n");
			
			## Update user2Report Index
			my $user2Report = lock_retrieve("$perfhome/var/db/mappings/user2Report.ser") or die("ERROR: Could not lock_retrieve from $perfhome/var/db/mappings/user2Report.ser");
			delete($user2Report->{$userName});
			lock_store($user2Report, "$perfhome/var/db/mappings/user2Report.ser") or die("ERROR: Can't store user2Report in $perfhome/var/db/mappings/user2Report.ser\n");
		}
		
		## Update admin2Host Index
		my $admin2Host = lock_retrieve("$perfhome/var/db/mappings/admin2Host.ser") or die("ERROR: Could not lock_retrieve from $perfhome/var/db/mappings/admin2Host.ser");
		foreach my $hostNameList (keys(%$admin2Host)) {
			foreach my $hostName (keys(%$hostNameList)) {
				deleteHost($userName, $hostName);
			}
		}
		delete($admin2Host->{$userName});
		lock_store($admin2Host, "$perfhome/var/db/mappings/admin2Host.ser") or die("ERROR: Can't store admin2Host in $perfhome/var/db/mappings/admin2Host.ser\n");

		## Update admin2User Index
		my $admin2User = lock_retrieve("$perfhome/var/db/mappings/admin2User.ser") or die("ERROR: Could not lock_retrieve from $perfhome/var/db/mappings/admin2User.ser");
		delete($admin2User->{$userName});
		lock_store($admin2User, "$perfhome/var/db/mappings/admin2User.ser") or die("ERROR: Can't store admin2Host in $perfhome/var/db/mappings/admin2User.ser\n");
	
	## DELETE USER	
	} elsif($userRole eq "user") {
		opendir(USERDIR, "$perfhome/var/db/users/$userName") or die("WARNING: Couldn't open dir $perfhome/var/db/users/$userName: $!\n");
		while (my $fileName = readdir(USERDIR)) {
			# Skip if file starts with a . 
			next if ($fileName =~ m/^\.\.?$/);
			unlink("$perfhome/var/db/users/$userName/$fileName");
		}
		closedir(USERDIR);
		rmdir("$perfhome/var/db/users/$userName/hostGroups") or die("WARNING: Couldn't remove dir $perfhome/var/db/users/$userName/hostGroups: $!\n") ;
		rmdir("$perfhome/var/db/users/$userName/reports") or die("WARNING: Couldn't remove dir $perfhome/var/db/users/$userName/reports: $!\n") ;
		rmdir("$perfhome/var/db/users/$userName") or die("WARNING: Couldn't remove dir $perfhome/var/db/users/$userName: $!\n") ;
		
		## Update user2HostGroup Index
		my $user2HostGroup = lock_retrieve("$perfhome/var/db/mappings/user2HostGroup.ser") or die("ERROR: Could not lock_retrieve from $perfhome/var/db/mappings/user2HostGroup.ser");
		delete($user2HostGroup->{$userName});
		lock_store($user2HostGroup, "$perfhome/var/db/mappings/user2HostGroup.ser") or die("ERROR: Can't store admin2Host in $perfhome/var/db/mappings/user2HostGroup.ser\n");
			
		## Update user2Report Index
		my $user2Report = lock_retrieve("$perfhome/var/db/mappings/user2Report.ser") or die("ERROR: Could not lock_retrieve from $perfhome/var/db/mappings/user2Report.ser");
		delete($user2Report->{$adminName}->{$userName});
		lock_store($user2Report, "$perfhome/var/db/mappings/user2Report.ser") or die("ERROR: Can't store admin2Host in $perfhome/var/db/mappings/user2Report.ser\n");
			
		## Update admin2User Index
		my $admin2User = lock_retrieve("$perfhome/var/db/mappings/admin2User.ser") or die("ERROR: Could not lock_retrieve from $perfhome/var/db/mappings/admin2User.ser");
		delete($admin2User->{$adminName}->{$userName});
		lock_store($admin2User, "$perfhome/var/db/mappings/admin2User.ser") or die("ERROR: Can't store admin2Host in $perfhome/var/db/mappings/admin2User.ser\n");
	} else {
		die('ERROR: invalid value for $userRole');
	}
}

1;