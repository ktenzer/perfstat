# Modify Host Configuration

use Storable qw(lock_retrieve lock_store freeze thaw);
use POSIX;
use Host;
use User;
use File::Copy;

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

# Verify that user is correct
&VerifyUser;

# Setup global variables
my $hostName=();
my $OS=();
my $IP=();
my $owner=();

my ($option) = @ARGV;

# Check positional parameters
if ($option !~ m/-add|-mod|-del/) {
	&Usage;
	exit(1);
}

### Main Program ###

# add|mod|del host info
if ($option =~ m/-add/) {
	@ARGV >= 9 or &Usage;

	# Set counter
	my $count="0";

	foreach my $arg (@ARGV) {

		# Check Arguments
		&CheckArgs($arg);

		if ($arg =~ m/-h/) {
			my $index=$count + 1;
			$hostName=@ARGV[$index];
		} elsif ($arg =~ m/-o/) {
			my $index=$count + 1;
			$OS=@ARGV[$index];
		} elsif ($arg =~ m/-i/) {
			my $index=$count + 1;
			$IP=@ARGV[$index];
		} elsif ($arg =~ m/-u/) {
			my $index=$count + 1;
			$owner=@ARGV[$index];
		} elsif ($arg =~ m/-dynamic/) {
			$dynamic="1";
		}
		$count++;
	}
	&verifyARG;
	&CheckOwner($owner);
	&addHost;
} elsif ($option =~ m/-mod/) {
	@ARGV >= 5 or &Usage;

	# Set counter
	my $count="0";

	foreach my $arg (@ARGV) {

		# Check Arguments
		&CheckArgs($arg);

		if ($arg =~ m/-h/) {
			my $index=$count + 1;
			$hostName=@ARGV[$index];
		} elsif ($arg =~ m/-o/) {
			my $index=$count + 1;
			$OS=@ARGV[$index];
		} elsif ($arg =~ m/-i/) {
			my $index=$count + 1;
			$IP=@ARGV[$index];
		} elsif ($arg =~ m/-u/) {
			my $index=$count + 1;
			$owner=@ARGV[$index];
		} elsif ($arg =~ m/-n/) {
			my $index=$count + 1;
			$newHost=@ARGV[$index];
		} elsif ($arg =~ m/-dynamic/) {
			$dynamic="1";
		}
		$count++;
	}
	&verifyARG;
	&CheckOwner($owner);
	&modHost;
} elsif ($option =~ m/-del/) {
	@ARGV >= 3 or &Usage;

	# Set counter
	my $count="0";

	foreach my $arg (@ARGV) {

		# Check Arguments
		&CheckArgs($arg);

		if ($arg =~ m/-h/) {
			my $index=$count + 1;
			$hostName=@ARGV[$index];
		} elsif ($arg =~ m/-dynamic/) {
			$dynamic="1";
		}
		$count++;
	}
	&delHost;
}

# Verify that user isn't root
sub VerifyUser {

        my $currentUID=getuid();
        my($savedUID) = (getpwnam("$ENV{'USER'}"))[2];

        if ($currentUID == "0") {
                print "ERROR: PerfStat host configuration cannot be done as root!\n";
                exit(1);
        } elsif ($currentUID != $savedUID) {
                print "ERROR: Incorrect user! PerfStat host configuration must be done by $ENV{'USER'} user\n";
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
                print "ERROR: Owner $userName is not a valid PerfStat user!\n";
                exit(1);
	}

	# Ensure user is an admin
	my $userIndex=();

	#create user object by deserialization
	$userObject = lock_retrieve("$perfhome/var/db/users/$userName/$userName.ser");
		die("WARNING: can't retriewe $perfhome/var/db/users/$userName/$userName.ser\n") unless defined($userObject);

	#assign user object to userIndex
	$userIndex->{$userName} = $userObject;

	$userRole=$userIndex->{$userName}->getRole();

	if ($userRole !~ m/admin/) {
		print "ERROR: $userName is not an admin, only admins are permitted to add hosts!\n";
		exit(1);
	}
}

# Check Arguments
sub CheckArgs {

	my $arg=shift;

	if ($arg =~ m/^-/) {
		if ($arg !~ m/-add|-mod|-del|-h|-o|-i|-u|-n|-dynamic/) {
			print "ERROR: Invalid Argument $arg!\n";
			exit(1);
		}
	}
}

# Setup host defaults
sub SetHostDefaults {

	# Create State Dir if it doesn't exist
	if ( ! -d "$perfhome/var/db/hosts/$hostName" ) {
		mkdir("$perfhome/var/db/hosts/$hostName",0770)
			or die "WARNING: Cannot mkdir $perfhome/var/db/hosts/$hostName: $!\n";
		warn "INFO: Did not find Directory: $perfhome/var/db/hosts/$hostName. DIR Created\n";
	}

	# Copy default host serialized file to unique hostname serialized file
	if (! -f "$perfhome/var/db/hosts/$hostName/$hostName.ser") {
		copy("$perfhome/etc/configs/$OS/host.ser","$perfhome/var/db/hosts/$hostName/$hostName.ser")
			or die "WARNING: Couldn't serialize default host data for $hostName: $!\n";
	}

}

# Load serialized host data
sub LoadHostData {

	# Defined hostIndex
	$hostIndex = {};

	if (! defined $hostIndex->{$hostName}) {

		#create host object by deserialization
		$hostObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/$hostName.ser");
			die("WARNING: can't retriewe $perfhome/var/db/hosts/$hostName/$fileName\n") unless defined($hostObject);

		#assign host object to hostIndex
		$hostIndex->{$hostName} = $hostObject;

	} else {
		if ($option =~ m/-add/) {
			warn "ERROR: Cannot add host, $hostName already exists!\n";
			exit(1);
		}
	}
}

# Verify Arguments
sub verifyARG {

	# Verify OS
	if (defined $OS) {
		if ($OS !~ m/Linux|SunOS|WindowsNT/) {
			warn "ERROR: OS: $OS not supported!  The supported OS's are: Linux, SunOS, and WindowsNT\n";
			exit(1);
		}
	}

	# Verify IP
	if (defined $IP) {
		if ($IP !~ m/\d+\.\d+\.\d+\.\d+/) {
			warn "ERROR: Incorrect format for IP $IP\n";
			exit(1);
		}
	}
}

# Add host
sub addHost {

	# Check to ensure hostname is not in configuration]
	if (-e "$perfhome/var/db/hosts/$hostName/$hostName.ser") {
		warn "ERROR: Can't add host, $hostName exists in configuration!\n";
		exit(1);
	}

	# Set Defaults
	&SetHostDefaults;

	# Load host default data
	&LoadHostData;

	$hostObject = $hostIndex->{$hostName};

	warn "INFO: Added $hostName to configuration!\n";

	# Set IP
	$hostIndex->{$hostName}->setIP($IP);

	# Set Owner
	$hostIndex->{$hostName}->setOwner($owner);

	# Serialize host data to disk (host.ser)
	$hostIndex->{$hostName}->lock_store("$perfhome/var/db/hosts/$hostName/$hostName.ser")
		or die "ERROR: Can't store $perfhome/var/db/hosts/$hostName/$hostName.ser\n";

}

# Modify Host
sub modHost {

	# Check to ensure hostname is not in configuration]
	if (! -e "$perfhome/var/db/hosts/$hostName/$hostName.ser") {
		warn "ERROR: Can't modify host, $hostName doesn't exist in configuration!\n";
		exit(1);
	}

	# Load host default data
	&LoadHostData;

	$hostObject = $hostIndex->{$hostName};

	warn "INFO: Modified $hostName configuration!\n";

	# Update host configuration
	&hostUpdate;

	# Serialize host data to disk (host.ser)
	$hostIndex->{$hostName}->lock_store("$perfhome/var/db/hosts/$hostName/$hostName.ser")
		or die "ERROR: Can't store $perfhome/var/db/hosts/$hostName/$hostName.ser\n";


	# Change hostName
	if (defined $newHost) {

		# List of directories that need to be renamed
		@dirs=qw(rrd var/db/hosts var/status var/events tmp/events);

		foreach $dir (@dirs) {

			next if (! -d "$perfhome/$dir/$hostName");

			opendir(DIR, "$perfhome/$dir/$hostName")
				or die("ERROR: Couldn't open dir $perfhome/$dir/$hostName: $!\n");

			# Rename/Remove host files
			while ($fileName = readdir(DIR)) {
				next if ($fileName =~ m/^\.|^\.\./);

				if ($dir =~ m/rrd/) {
					$fileName =~ m/$hostName\.(\S+)\.rrd/;
					my $service="$1"; 
					rename("$perfhome/$dir/$hostName/$fileName","$perfhome/$dir/$hostName/$newHost.$service.rrd")
						or die "WARNING: Couldn't rename $fileName: $!\n";
				} elsif ($dir =~ m/var\/db\/hosts/) {
					next if ($fileName !~ m/$hostName/);
					rename("$perfhome/$dir/$hostName/$fileName","$perfhome/$dir/$hostName/$newHost.ser")
						or die "WARNING: Couldn't rename $fileName: $!\n";
				} else {
					unlink "$perfhome/$dir/$hostName/$fileName"
						or die "Couldn't remove file $perfhome/$dir/$hostName/$fileName!\n";
				}
		}

		closedir(DIR);

			# Rename all host directories
			rename("$perfhome/$dir/$hostName","$perfhome/$dir/$newHost")
				or die "ERROR: Couldn't rename $perfhome/$dir/$hostName: $!\n";

		}
	}
}

# Delete Host
sub delHost {

	# Check to ensure hostname is not in configuration]
	if (! -e "$perfhome/var/db/hosts/$hostName/$hostName.ser") {
		warn "ERROR: Can't delete host, $hostName doesn't exist in configuration!\n";
		exit(1);
	}

	# List of directories that need to be removed
	@dirs=qw(rrd var/db/hosts var/status var/events tmp/events);

	foreach $dir (@dirs) {

		next if (! -d "$perfhome/$dir/$hostName");

		# Unlink all files under host dir
		opendir(DIR, "$perfhome/$dir/$hostName")
			or die("ERROR: Couldn't open dir $perfhome/$dir/$hostName: $!\n");

		while ($fileName = readdir(DIR)) {
			next if ($fileName =~ m/^\.|^\.\./);
			unlink "$perfhome/$dir/$hostName/$fileName"
				or die "Couldn't remove file $perfhome/$dir/$hostName/$fileName!\n";
		}

		closedir(DIR);

		# Remove State Dir if it exists
		if ( -d "$perfhome/$dir/$hostName" ) {
			rmdir "$perfhome/$dir/$hostName"
				or die "WARNING: Cannot rmdir $perfhome/$dir/$hostName: $!\n";
			warn "INFO: Found Directory $perfhome/$dir/$hostName. DIR Removed\n";
		}
	}
}

# Update hostIndex
sub hostUpdate {

	if (defined $dynamic) {

		# Create data structure to use for serializing host data (host.ser)
		my $hostUpdate=();

                # Get current host settings
		my $savedOS=$hostIndex->{$hostName}->getOS();
		my $savedIP=$hostIndex->{$hostName}->getIP();
		my $savedOwner=$hostIndex->{$hostName}->getOwner();

		$hostUpdate = Host->new(	OS         => "$savedOS",
						IP         => "$savedIP",
						Owner      => "$savedOwner",
					);

		# Modify IP
		if (defined $IP) {
			$hostIndex->{$hostName}->setIP($IP);
			$hostUpdate->setIP($IP);
		}

		# Modify Owner
		if (defined $owner) {
			$hostIndex->{$hostName}->setOwner($owner);
			$hostUpdate->setOwner($owner);
		}

		# Modify OS
		if (defined $OS) {
			$hostIndex->{$hostName}->setOS($OS);
			$hostUpdate->setOS($OS);
		}

		# Serialize lastUpdate to disk (host.ser)
		$hostUpdate->lock_store("$perfhome/var/db/hosts/$hostName/$hostName.ser")
			or die "ERROR: Can't store $perfhome/var/db/hosts/$hostName/$hostName.ser\n";

	} else {
	
		# Modify IP
		if (defined $IP) {
			$hostIndex->{$hostName}->setIP($IP);
		}

		# Modify Owner
		if (defined $owner) {
			$hostIndex->{$hostName}->setOwner($owner);
		}

		# Modify OS
		if (defined $OS) {
			$hostIndex->{$hostName}->setOS($OS);
		}
	}
}

# Load single hosts host configuration data (de-serialize)
sub LoadHostData {

        #create an empty serviceHash
        $serviceHash = {};

        ### Populate each host key with a host object ###

        opendir(HOSTDIR, "$perfhome/var/db/hosts/$hostName")
                or die("WARNING: Couldn't open dir $perfhome/var/db/hosts/$hostName: $!\n");

        while ($fileName = readdir(HOSTDIR)) {

                # Skip if file starts with a . and all service.ser
                next if ($fileName =~ m/^\.\.?$/);
                next if ($fileName !~ m/$hostName\.ser/);

                if ($fileName =~ /$hostName\.ser/) {

                        #create host object by deserialization
                        $hostObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/$fileName");
                                die("WARNING: can't retriewe $perfhome/var/db/hosts/$hostName/$fileName\n") unless defined($hostObject);

                        #assign host object to hostIndex
                        $hostIndex->{$hostName} = $hostObject;

                } else {
                        warn "ERROR: Serialized host data not found for $hostName:$fileName while loading host data\n";
                        exit(1);
                }
        }
        closedir(HOSTDIR);
}

# Get path to addhost executable
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
 $0 [-add] [-h <Hostname> -o <OS> -i <IP> -u <OWNER>]
 $0 [-mod] [-h <Hostname>] [-n <New Hostname>] [-o <OS>] 
 \t\t [-i <IP>] [-u <OWNER>]
 $0 [-del] [-h <Hostname>]
EOF
exit(1);
}
