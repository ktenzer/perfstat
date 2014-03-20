# Modify User Configuration

use Storable qw(lock_retrieve lock_store freeze thaw);
use POSIX;
use User;

# Set umask
umask(0007);

# Slurp in path to Perfhome
my $perfhome=&PATH;
$perfhome =~ s/\/bin\/tools//;

# Slurp in Configuration
my %conf       = ();
&GetConfiguration(\%conf);

# Set Environment Variables from %conf
foreach $key (keys %conf) {
        $ENV{$key}="$conf{$key}";
}

# Verify that OS user is correct
&VerifyOSUser;

# Setup global variables
my $userName=();
my $userPassword=();
my $creatorName=();
my $userRole=();

my ($option) = @ARGV;

# Check positional parameters
if ($option !~ m/-add|-mod|-del/) {
	&Usage;
	exit(1);
}

### Main Program ###

# add|mod|del user info
if ($option =~ m/-add/) {
	@ARGV >= 8 or &Usage;

	# Set counter
	my $count="0";

	foreach my $arg (@ARGV) {

		# Check Arguments
		&CheckArgs($arg);

		if ($arg =~ m/-u/) {
			my $index=$count + 1;
			$userName=@ARGV[$index];
		} elsif ($arg =~ m/-p/) {
			my $index=$count + 1;
			$userPassword=@ARGV[$index];
		} elsif ($arg =~ m/-c/) {
			my $index=$count + 1;
			$userCreator=@ARGV[$index];
		} elsif ($arg =~ m/-r/) {
			my $index=$count + 1;
			$userRole=@ARGV[$index];
		} elsif ($arg =~ m/-dynamic/) {
			$dynamic="1";
		}
		$count++;
	}
	# Check Owner
	&CheckOwner($userCreator);
	&VerifyARG;
	$userPassword=&CryptPassword($userPassword);

	&addUser;
} elsif ($option =~ m/-mod/) {
	@ARGV >= 4 or &Usage;

	# Set counter
	my $count="0";

	foreach my $arg (@ARGV) {

		# Check Arguments
		&CheckArgs($arg);

		if ($arg =~ m/-u/) {
			my $index=$count + 1;
			$userName=@ARGV[$index];
		} elsif ($arg =~ m/-p/) {
			my $index=$count + 1;
			$userPassword=@ARGV[$index];
		} elsif ($arg =~ m/-c/) {
			my $index=$count + 1;
			$userCreator=@ARGV[$index];
		} elsif ($arg =~ m/-r/) {
			my $index=$count + 1;
			$userRole=@ARGV[$index];
		} elsif ($arg =~ m/-n/) {
			my $index=$count + 1;
			$newUserName=@ARGV[$index];
		} elsif ($arg =~ m/-dynamic/) {
			$dynamic="1";
		}
		$count++;
	}
	# Check Owner
	if (defined $userCreator) {
		&CheckOwner($userCreator);
	}

	&VerifyARG;
	$userPassword=&CryptPassword($userPassword);

	&modUser;
} elsif ($option =~ m/-del/) {
	@ARGV >= 2 or &Usage;

	# Set counter
	my $count="0";

	foreach my $arg (@ARGV) {

		# Check Arguments
		&CheckArgs($arg);

		if ($arg =~ m/-u/) {
			my $index=$count + 1;
			$userName=@ARGV[$index];
		} elsif ($arg =~ m/-dynamic/) {
			$dynamic="1";
		}
		$count++;
	}
	&delUser;
}

# Verify that user isn't root
sub VerifyOSUser {

        my $currentUID=getuid();
        my($savedUID) = (getpwnam("$ENV{'USER'}"))[2];

        if ($currentUID == "0") {
                print "ERROR: PerfStat user configuration cannot be done as root!\n";
                exit(1);
        } elsif ($currentUID != $savedUID) {
                print "ERROR: Incorrect user! PerfStat user configuration must be done by $ENV{'USER'} user\n";
                exit(1);
        }
}

# Check owner to ensure it is a valid user
sub CheckOwner {

	my $userName=shift;

	opendir(USERDIR, "$perfhome/var/db/users")
		or die("ERROR: Couldn't open dir $perfhome/var/db/users: $!\n");

	while ($dirName = readdir(USERDIR)) {
		next if ($dirName =~ m/^\.|^\.\./);
		
		if ($userName =~ m/$dirName/) {
			$userMatch="1";
			last;
		}

	}

	close(USERDIR);

	if (! defined $userMatch) {
                print "ERROR: Creator $userName is not a valid PerfStat user, you must specify a valid user!\n";
                exit(1);
	}

}

# Check Arguments
sub CheckArgs {

	my $arg=shift;

	if ($arg =~ m/^-/) {
		if ($arg !~ m/-add|-mod|-del|-u|-p|-c|-r|-n|-dynamic/) {
			print "ERROR: Invalid Argument $arg!\n";
			exit(1);
		}
	}
}

# Setup User defaults
sub SetUserDefaults {

	# Create User Dir if it doesn't exist
	if ( ! -d "$perfhome/var/db/users/$userName" ) {
		mkdir("$perfhome/var/db/users/$userName",0770)
			or die "WARNING: Cannot mkdir $perfhome/var/db/users/$userName: $!\n";
		warn "INFO: Did not find Directory: $perfhome/var/db/users/$userName. DIR Created\n";
	}

	# Build default user serialized file
	$userBuild = User->new(		name		=> "$userName",
					password	=> "$userPassword",
					creator		=> "$userCreator",
					role		=> "$userRole",
				);

	# Serialize user data to disk (user.ser)
	$userBuild->lock_store("$perfhome/var/db/users/$userName/$userName.ser")
		or die "ERROR: Can't store $perfhome/var/db/users/$userName/$userName.ser\n";

}

# Load serialized user data
sub LoadUserData {

	# Defined userindex
	$userIndex = {};

	if (! defined $userIndex->{$userName}) {

		#create user object by deserialization
		$userObject = lock_retrieve("$perfhome/var/db/users/$userName/$userName.ser");
			die("WARNING: can't retriewe $perfhome/var/db/users/$userName/$fileName\n") unless defined($userObject);

		#assign user object to userIndex
		$userIndex->{$userName} = $userObject;

	} else {
		if ($option =~ m/-add/) {
			warn "ERROR: Cannot add user, $userName already exists!\n";
			exit(1);
		}
	}
}

# Verify Arguments
sub VerifyARG {

	# Verify User name
	if (defined $userName) {
		if (length($userName) < "4") {
			print "ERROR: User name must be a minimum of 5 characters!\n";
			exit(1);
		}
	}

	# Verify Password
	if (defined $userPassword) {
		if ($userPassword !~ m/[a-zA-Z0-9]/) {
			print "ERROR: Invalid character in user password\n";
			exit(1);
		}

		if (length($userPassword) < "8") {
			print "ERROR: User password must be a minimum of 8 characters!\n";
			exit(1);
		}
	}

	# Verify user creator exists and is admin
	if (defined $userCreator) {

		#create user object by deserialization
		$userCreatorObject = lock_retrieve("$perfhome/var/db/users/$userCreator/$userCreator.ser");
			die("WARNING: can't retrieve $perfhome/var/db/users/$userCreator/$userCreator\n") unless defined($userCreatorObject);

		#assign user object to userIndex
		$userIndex->{$userCreator} = $userCreatorObject;

		$savedCreatorRole=$userIndex->{$userCreator}->getRole();

		if ($savedCreatorRole !~ /admin/) {
			print "ERROR: User creator role is not admin, only admin can modify users!\n";
			exit(1);
		}

		opendir(USERDIR, "$perfhome/var/db/users")
			or die("ERROR: Couldn't open dir $perfhome/var/db/users: $!\n");

		# Determine if creator is valid user
		while ($fileName = readdir(USERDIR)) {
			next if ($fileName =~ m/^\.|^\.\./);

			if ($userCreator =~ m/$fileName/) {
				$creatorMatch="1";
				last;
			}
		}

		close(USERDIR);

		if (! defined $creatorMatch) {
			print "ERROR: Invalid Creator, $userCreator is not a valid PerfStat user!\n";
			exit(1);
		}
	}

	# Verify user role
	if (defined $userRole) {
		if ($userRole !~ m/user|admin/) {
			print "ERROR: $userRole is not a valid user role, valid roles are user and admin!\n";
			exit(1);
		}
	}
}

# Add User
sub addUser {

	# Check to ensure username is not in configuration]
	if (-e "$perfhome/var/db/users/$userName/$userName.ser") {
		warn "ERROR: Can't add user, $userName exists in configuration!\n";
		exit(1);
	}

	# Set Defaults
	&SetUserDefaults;

	warn "INFO: Added $userName to configuration!\n";

}

# Modify User
sub modUser {

	# Check to ensure username is not in configuration]
	if (! -e "$perfhome/var/db/users/$userName/$userName.ser") {
		warn "ERROR: Can't modify user, $userName doesn't exist in configuration!\n";
		exit(1);
	}

	# Load user default data
	&LoadUserData;

	$userObject = $userIndex->{$userName};

	warn "INFO: Modified $userName configuration!\n";

	# Update user configuration
	&UserUpdate;

	# Serialize user data to disk (user.ser)
	$userIndex->{$userName}->lock_store("$perfhome/var/db/users/$userName/$userName.ser")
		or die "ERROR: Can't store $perfhome/var/db/users/$userName/$userName.ser\n";

	# Change userName
	if (defined $newUserName) {

		opendir(DIR, "$perfhome/var/db/users/$userName")
			or die("ERROR: Couldn't open dir $perfhome/var/db/users/$userName: $!\n");

		# Rename/Remove user files
		while ($fileName = readdir(DIR)) {
			next if ($fileName =~ m/^\.|^\.\./);

			next if ($fileName !~ m/$userName/);
			rename("$perfhome/var/db/users/$userName/$fileName","$perfhome/var/db/users/$userName/$newUserName.ser")
				or die "WARNING: Couldn't rename $fileName: $!\n";
		}

		closedir(DIR);

		# Rename User directory
		rename("$perfhome/var/db/users/$userName","$perfhome/var/db/users/$newUserName")
				or die "ERROR: Couldn't rename $perfhome/var/db/users/$userName: $!\n";

	}
}

# Delete User 
sub delUser {

	# Check to ensure username is not in configuration]
	if (! -e "$perfhome/var/db/users/$userName/$userName.ser") {
		warn "ERROR: Can't delete user, $userName doesn't exist in configuration!\n";
		exit(1);
	}

	next if (! -d "$perfhome/var/db/users/$userName");

	# Unlink all files under user dir
	opendir(DIR, "$perfhome/var/db/users/$userName")
		or die("ERROR: Couldn't open dir $perfhome/var/db/users/$userName: $!\n");

	while ($fileName = readdir(DIR)) {
		next if ($fileName =~ m/^\.|^\.\./);
		unlink "$perfhome/var/db/users/$userName/$fileName"
			or die "Couldn't remove file $perfhome/var/db/users/$userName/$fileName!\n";
		}

	closedir(DIR);

	# Remove User Dir if it exists
	if ( -d "$perfhome/var/db/users/$userName" ) {
		rmdir "$perfhome/var/db/users/$userName"
			or die "WARNING: Cannot rmdir $perfhome/var/db/users/$userName: $!\n";
		warn "INFO: Found Directory $perfhome/var/db/users/$userName. DIR Removed\n";
	}
}

# Update userIndex
sub UserUpdate {

	# Modify username 
	if (defined $userName) {
		$userIndex->{$userName}->setName($userName);
	}

	# Modify password
	if (defined $userPassword) {
		$userIndex->{$userName}->setPassword($userPassword);
	}

	# Modify creator
	if (defined $userCreator) {
		$userIndex->{$userName}->setCreator($userCreator);
	}

	# Modify role
	if (defined $userRole) {
		$userIndex->{$userName}->setRole($userRole);
	}
}

# Load user configuration data (de-serialize)
sub LoadUserData {

        opendir(USERDIR, "$perfhome/var/db/users/$userName")
                or die("WARNING: Couldn't open dir $perfhome/var/db/users/$userName: $!\n");

        while ($fileName = readdir(USERDIR)) {

                # Skip if file starts with a . or ..
                next if ($fileName =~ m/^\.\.?$/);

                if ($fileName =~ /$userName\.ser/) {

                        #create user object by deserialization
                        $userObject = lock_retrieve("$perfhome/var/db/users/$userName/$fileName");
                                die("WARNING: can't retriewe $perfhome/var/db/users/$userName/$fileName\n") unless defined($userObject);

                        #assign user object to userIndex
                        $userIndex->{$userName} = $userObject;

                } else {
                        warn "ERROR: Serialized user data not found for $userName:$fileName while loading user data\n";
                        exit(1);
                }
        }
        closedir(USERDIR);
}

# Encrypt user password
sub CryptPassword {

	# Slurp in plain password
	$plain=shift;

	#  Use the process id & time to generate the salt key
	srand($$|time);                                 # random seed
	@saltchars=(a..z,A..Z,0..9,'.','/');            # valid salt chars
	$salt=$saltchars[int(rand($#saltchars+1))];     # first random salt char
	$salt.=$saltchars[int(rand($#saltchars+1))];    # second random salt char

	# Encrypt and save password
	$encrypted=crypt($plain, $salt);

	return $encrypted;

}

# Get path to add user executable
sub PATH {
  my $path = PerlApp::exe();
        $path =~ s/\/\w*$//;
        return $path;
}

### Get configuration dynamically from perf-conf ###
sub GetConfiguration {

        my $configfile="$perfhome/etc/perf-conf";
        my $hashref = shift;

        open(FILE, $configfile)
                or die "ERROR: Couldn't open FileHandle for $configfile: $!\n";

        my @data=<FILE>;
        foreach $line (@data) {

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

# Print Usage information
sub Usage {
print STDOUT <<EOF;
Usage:
 $0 [-add] [-u <User> -p <Password> -c <Creator> -r <Role>]
 $0 [-mod] [-u <User>] [-n <New User>] [-p <Password>] 
 \t\t [-c <Creator>] [-r <Role>]
 $0 [-del] [-u <User>]
EOF
exit(1);
}
