# Modify Host Configuration

use Storable qw(lock_retrieve lock_store freeze thaw);
use POSIX;
use File::Copy;
use Host;
use Service;
use Metric;
use Graph;

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

### Main Program ###
system("clear");
print "\n\t--------PerfStat Service Configuration--------\n\n";
print "\t1) Add Service\n";
print "\t2) Modify Service\n";
print "\t3) Delete Service\n";
print "\t4) Exit\n\n";
print "\t\tSelection: ";

my $ANS=<STDIN>;
chomp $ANS;

if ($ANS == "1") {
	&AddService;
} elsif ($ANS == "2") {
	&ModService;
} elsif ($ANS == "3") {
	&DelService;
} else {
	exit(0);
}

# Add Service
sub AddService {

	my $hostName=();
	my $OS=();
	my $serviceName=();
	my $friendlyName=();
	my $metricName=();
	my $servicePort=();

	system("clear");
	# Find configured hosts
	my $hostIndex=&FindHosts;
	print "\n\t--------PerfStat Service Configuration--------\n\n";

	my $i="1";

	foreach $host (sort(keys(%$hostIndex))) {
		$hostMap{$i}=$host;
		print "\t$i) $host\n";
		$i++;
	}

	print "\t$i) Exit\n";

	print "\n\t\tSelect Host: ";

	my $ANS=<STDIN>;
	chomp $ANS;	

	if (! defined $hostMap{$ANS}) {
		exit(0);
	}

	$hostName="$hostMap{$ANS}";

	# Select OS
	system("clear");
	print "\n\t--------PerfStat Service Configuration--------\n";
	print "\t\t[$hostName]\n\n";
	print "\t1)SunOS\n";
	print "\t2)Linux\n";
	print "\t3)WindowsNT\n";
	print "\t4)Exit\n";

	print "\n\t\tSelect OS: ";

	my $ANS=<STDIN>;
	chomp $ANS;
	
	if ($ANS == "1") {
		$OS="SunOS";
	} elsif ($ANS == "2") {
		$OS="Linux";
	} elsif ($ANS == "3") {
		$OS="WindowsNT";
	} else {
		exit(0);
	}

	# Load selected hosts data into hostIndex
	#my $hostIndex=&LoadHostData($hostMap{$ANS});
	
	system("clear");
	print "\n\t--------PerfStat Service Configuration--------\n";
	print "\t\t[$hostName]\n\n";
	print "\t1) conn.port\n";
	print "\t2) Exit\n\n";
	print "\t\tSelection: ";

	my $ANS=<STDIN>;
	chomp $ANS;

	if ($ANS == "1") {
		$serviceName="conn.port";
	} else {
		exit(0);
	}

	system("clear");
	print "\n\t--------PerfStat Service Configuration--------\n";
	print "\t\t[$hostName]\n\n";
	print "\t1) http\n";
	print "\t2) ftp\n";
	print "\t3) smtp\n";
	print "\t4) telnet\n";
	print "\t5) ssh\n";
	print "\t6) other\n";
	print "\t7) Exit\n\n";
	print "\t\tSelection: ";
	
	my $ANS=<STDIN>;
	chomp $ANS;

	if ($ANS == "6") {
		system("clear");
		print "\n\t--------PerfStat Service Configuration--------\n\n";

		print "Enter application name (ie: Web Server):";
		$friendlyName=<STDIN>;
		chomp $friendlyName;

		print "Enter application daemon (ie: http):";
		$metricName=<STDIN>;
		chomp $metricName;
	
		print "Enter application port number (ie: 80):";
		$servicePort=<STDIN>;
		chomp $servicePort;

		# Check servicePort
		if ($servicePort =~ m/\D+/) {
			print "ERROR: Invalid entry, you must enter a number!\n";
			exit(1);
		}
	} elsif ($ANS == "1") {
		$friendlyName="Web Server";
		$metricName="http";
		$servicePort="80";
	} elsif ($ANS == "2") {
		$friendlyName="FTP Server";
		$metricName="ftp";
		$servicePort="21";
	} elsif ($ANS == "3") {
		$friendlyName="Mail Server";
		$metricName="smtp";
		$servicePort="25";
	} elsif ($ANS == "4") {
		$friendlyName="Telnet Server";
		$metricName="telnet";
		$servicePort="23";
	} elsif ($ANS == "5") {
		$friendlyName="SSH Server";
		$metricName="ssh";
		$servicePort="22";
	} else {
		exit(0);
	}

	# Create Default service
	print "\nBuilding $serviceName from default template...";
	&CreateService($hostName,$OS,$serviceName,$servicePort);
	sleep 1;
	print "Done!\n";

	# Update service with new settings
	print "\nUpdating $serviceName with new settings...";
	&UpdateService($hostName,$serviceName,$metricIndex,$hasEvents,$friendlyName,$metricName,$servicePort);
	sleep 1;
	print "Done!\n";
	
}

# Modify Service
sub ModService {

        my $hostName=();
        my $OS=();
        my $serviceName=();
        my $friendlyName=();
        my $metricName=();
        my $servicePort=();

        system("clear");
        # Find configured hosts
        my $hostIndex=&FindHosts;
        print "\n\t--------PerfStat Service Configuration--------\n\n";

        my $i="1";

        foreach $host (sort(keys(%$hostIndex))) {
                $hostMap{$i}=$host;
                print "\t$i) $host\n";
                $i++;
        }
        print "\t$i) Exit\n";

        print "\n\t\tSelect Host: ";

        my $ANS=<STDIN>;
        chomp $ANS;

	if (! defined $hostMap{$ANS}) {
		exit(0);
	}

        $hostName="$hostMap{$ANS}";

        system("clear");
        # Find configured services
        print "\n\t--------PerfStat Service Configuration--------\n\n";

	# Find services to modify
	my $i=1;
	opendir(STATEDIR, "$perfhome/var/db/hosts/$hostName")
        	or die("ERROR: Couldn't open dir $ENV{'PERFHOME'}/var/db/hosts/$hostName: $!\n");

        while ($serviceName = readdir(STATEDIR)) {
        	if ($serviceName ne "." && $serviceName ne "..") {
			next if ($serviceName =~ m/$hostName/);
			$serviceName =~ s/.ser//;
        		$serviceMap{$i}=$serviceName;
                	print "\t$i) $serviceName\n";
			$i++;
        	}
       }
        closedir(STATEDIR);

	print "\t$i) Exit\n";

        print "\n\t\tSelect Service: ";

        my $ANS=<STDIN>;
        chomp $ANS;

	if (! defined $serviceMap{$ANS}) {
		exit(0);
	}

        $serviceName="$serviceMap{$ANS}";

        # De-serialize service data from disk
        my $serviceObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/$serviceName.ser");
                die("WARNING: can't retriewe $perfhome/var/db/hosts/$hostName/$serviceName.ser\n") unless defined($serviceObject);

	# Handle conn.port service different

	# Get data for all services->metrics
       	system("clear");
       	print "\n\t--------PerfStat Service Configuration--------\n\n";

	# Determine array legth
	$arrayLength = $serviceObject->getMetricArrayLength();

	my $i="1";

	for ($counter=0; $counter < $arrayLength; $counter++) {

		$metricObject = $serviceObject->{metricArray}->[$counter];
		$metricName = $metricObject->getMetricName();
		$friendlyName = $metricObject->getFriendlyName();
		$hasEvents = $metricObject->getHasEvents();
		$warnThreshold = $metricObject->getWarnThreshold();
		$critThreshold = $metricObject->getCritThreshold();
       		$servicePort=$metricObject->getServicePort();

		# Organize data according to metric name
       		$metricMap{$i}=$metricName;
		$metricValue{$metricName}{'friendlyName'}=$friendlyName;
		$metricValue{$metricName}{'hasEvents'}=$hasEvents;
		$metricValue{$metricName}{'warnThreshold'}=$warnThreshold;
		$metricValue{$metricName}{'critThreshold'}=$critThreshold;
		$metricValue{$metricName}{'servicePort'}=$servicePort;
		$metricValue{$metricName}{'metricIndex'}=$counter;
		
               	print "\t$i) $metricName\n";

		$i++;
	}

	print "\t$i) ALL\n";
	$metricMap{$i}="ALL";

	$i++;
	print "\t$i) Exit\n";

       	print "\n\t\tSelect Metric: ";

       	my $ANS=<STDIN>;
       	chomp $ANS;

	if (! defined $metricMap{$ANS}) {
		exit(0);
	}

	# Get data associated to selected metric
       	$metricName="$metricMap{$ANS}";

	if ($metricName !~ m/ALL/) {
		$friendlyName=$metricValue{$metricName}{'friendlyName'};
		$hasEvents=$metricValue{$metricName}{'hasEvents'};
		$warnThreshold=$metricValue{$metricName}{'warnThreshold'};
		$critThreshold=$metricValue{$metricName}{'critThreshold'};
		$servicePort=$metricValue{$metricName}{'servicePort'};
		$metricIndex=$metricValue{$metricName}{'metricIndex'};

       		# De-serialize service data from disk

		system("clear");
		print "\n\t--------PerfStat Service Configuration--------\n\n";

		print "Enter a friendly name [$friendlyName]:";
		$ANS=<STDIN>;
		chomp $ANS;
		if ($ANS =~ m/\w+/) {
			$friendlyName=$ANS;
		}

		print "Set event state [$hasEvents]:";
		$ANS=<STDIN>;
		chomp $ANS;
		if ($ANS =~ m/0|1/) {
			$hasEvents=$ANS;
		} elsif ($ANS =~ m/\d+/ || $ANS =~ m/\w+/) {
			print "ERROR: Invalid entry, you must enter 0 or 1!\n";
			exit(1);
		}

		print "Set warn Threshold [$warnThreshold]:";
		$ANS=<STDIN>;
		chomp $ANS;
		if ($ANS =~ m/\d+/) {
			$warnThreshold=$ANS;
		} elsif ($ANS =~ m/\w+/) {
			print "ERROR: Invalid entry, you must enter a number!\n";
			exit(1);
		}

		print "Set crit Threshold [$critThreshold]:";
		$ANS=<STDIN>;
		chomp $ANS;
		if ($ANS =~ m/\d+/) {
			$critThreshold=$ANS;
		} elsif ($ANS =~ m/\w+/) {
			print "ERROR: Invalid entry, you must enter a number!\n";
			exit(1);
		}

		# Modify service port (conn.port only)
		if (defined $servicePort) {
			print "Enter application port number [$servicePort]:";
			$ANS=<STDIN>;
			chomp $ANS;
			if ($ANS =~ m/\d+/) {
				$servicePort=$ANS;
			} elsif ($ANS =~ m/\w+/) {
				print "ERROR: Invalid entry, you must enter a number!\n";
				exit(1);
			}

			# Check servicePort
			if ($servicePort =~ m/\D+/) {
				print "ERROR: Invalid entry, you must enter a number!\n";
				exit(1);
			}
		}

		# Update service with new settings
		print "\nUpdating $serviceName:$metricName with new settings...";
		&UpdateService($hostName,$serviceName,$metricIndex,$hasEvents,$friendlyName,$metricName,$servicePort,$warnThreshold,$critThreshold);
		sleep 1;
		print "Done!\n";
	} else {
		# Update hasEvents for ALL metrics
		system("clear");
		print "\n\t--------PerfStat Service Configuration--------\n\n";

		# Set default for hasEvents
		$hasEvents="1";

		print "Set event state for $serviceName [1]:";
		$ANS=<STDIN>;
		chomp $ANS;
		if ($ANS =~ m/0|1/) {
			$hasEvents=$ANS;
		} elsif ($ANS =~ m/\d+/ || $ANS =~ m/\w+/) {
			print "ERROR: Invalid entry, you must enter 0 or 1!\n";
			exit(1);
		}

		foreach my $metricName (keys %metricValue) {
			$metricIndex=$metricValue{$metricName}{'metricIndex'};
			# Update service with new settings
			print "\nUpdating $serviceName:$metricName with new settings...";
			&UpdateService($hostName,$serviceName,$metricIndex,$hasEvents);
			sleep 1;
			print "Done!\n";
		}
	}
}

# Delete Service
sub DelService {

        my $hostName=();
        my $OS=();
        my $serviceName=();
        my $friendlyName=();
        my $metricName=();
        my $servicePort=();

        system("clear");
        # Find configured hosts
        my $hostIndex=&FindHosts;
        print "\n\t--------PerfStat Service Configuration--------\n\n";

        my $i="1";

        foreach $host (sort(keys(%$hostIndex))) {
                $hostMap{$i}=$host;
                print "\t$i) $host\n";
                $i++;
        }
        print "\t$i) Exit\n";

        print "\n\t\tSelect Host: ";

        my $ANS=<STDIN>;
        chomp $ANS;

        if (! defined $hostMap{$ANS}) {
                exit(0);
        }

        $hostName="$hostMap{$ANS}";

        system("clear");
        # Find configured services
        print "\n\t--------PerfStat Service Configuration--------\n\n";

        # Find services to modify
        my $i=1;
        opendir(STATEDIR, "$perfhome/var/db/hosts/$hostName")
                or die("ERROR: Couldn't open dir $ENV{'PERFHOME'}/var/db/hosts/$hostName: $!\n");

        while ($serviceName = readdir(STATEDIR)) {
                if ($serviceName ne "." && $serviceName ne "..") {
                        next if ($serviceName =~ m/$hostName/);
                        $serviceName =~ s/.ser//;
                        $serviceMap{$i}=$serviceName;
                        print "\t$i) $serviceName\n";
                        $i++;
                }
       }
        closedir(STATEDIR);

        print "\t$i) Exit\n";

        print "\n\t\tSelect Service: ";

        my $ANS=<STDIN>;
        chomp $ANS;

        if (! defined $serviceMap{$ANS}) {
                exit(0);
        }

        $serviceName="$serviceMap{$ANS}";

	print "\nDeleting $serviceName for $hostName...";
	unlink "$perfhome/var/db/hosts/$hostName/$serviceName.ser";
	sleep(1);
	print "Done!\n";
	
}

# Create new service for given host
sub CreateService {

	my $hostName=shift;
	my $OS=shift;
	my $serviceName=shift;
	my $servicePort=shift;

	# Copy default ping serialized file to conn.ping serialized file
	if (! -f "$perfhome/var/db/hosts/$host/$serviceName.ser") {
		copy("$perfhome/etc/configs/$OS/$serviceName.ser","$perfhome/var/db/hosts/$hostName/$serviceName.$servicePort.ser")
			or die "WARNING: Couldn't serialize default conn data for $hostName: $!\n";
	} else {
		warn "ERROR: The $serviceName already exists for $hostName!\n";
	}

}

# Re-serialize ser file with updated data
sub UpdateService {

	my $hostName=shift;
	my $serviceName=shift;
	my $metricIndex=shift;
	my $hasEvents=shift;
	my $friendlyName=shift;
	my $metricName=shift;
	my $servicePort=shift;
	my $warnThreshold=shift;
	my $critThreshold=shift;

	# Determine if servicePort is being changed (conn.port only)
	if ($serviceName =~ m/conn.port/) {
		if ($serviceName !~ m/conn.port.\d+/) {
			$serviceName="$serviceName.$servicePort";
		} elsif ($serviceName !~ m/conn.port.$servicePort/) {
			$noMatch="1";
		}
	}

	# Copy service to new file if port changed (conn.port only)
	if (defined $noMatch) {
		copy("$perfhome/var/db/hosts/$hostName/$serviceName.ser","$perfhome/var/db/hosts/$hostName/conn.port.$servicePort.ser")
			or die "WARNING: Couldn't modify $serviceName for $hostName: $!\n";

		# Remove old service file
		unlink "$perfhome/var/db/hosts/$hostName/$serviceName.ser";

		$serviceName =~ s/.\d+/.$servicePort/;
	}

	# De-serialize service data from disk
	my $serviceObject = lock_retrieve("$perfhome/var/db/hosts/$hostName/$serviceName.ser");
		die("WARNING: can't retriewe $perfhome/var/db/hosts/$hostName/$serviceName.ser\n") unless defined($serviceObject);

	# Update metric settings
	$metricObject=$serviceObject->{metricArray}->[$metricIndex];

	# Only update if value is set
	if (defined $friendlyName) {
		$metricObject->setFriendlyName($friendlyName);
	}

	if (defined $metricName) {
		$metricObject->setMetricName($metricName);
	}

	if (defined $hasEvents) {
		$metricObject->setHasEvents($hasEvents);
	}

	if (defined $warnThreshold) {
		$metricObject->setWarnThreshold($warnThreshold);
	}

	if (defined $critThreshold) {
		$metricObject->setCritThreshold($critThreshold);
	}

	if (defined $servicePort) {
		$metricObject->setServicePort($servicePort);
	}

	# Serialize service back to disk
	$serviceObject->lock_store("$perfhome/var/db/hosts/$hostName/$serviceName.ser")
		or die "ERROR: Can't store $perfhome/var/db/hosts/$hostName/$serviceName.ser\n";

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

# Find Hosts
sub FindHosts {

	#create an empty hostIndex
	$hostIndex = {};

	#populate the keys of the hash with the hostNames
	opendir(STATEDIR, "$perfhome/var/db/hosts")
		or die("ERROR: Couldn't open dir $perfhome/var/db/hosts: $!\n");

	while ($hostName = readdir(STATEDIR)) {
		if ($hostName ne "." && $hostName ne "..") {
			$hostIndex->{$hostName} = undef;
		}
	}
	closedir(STATEDIR);
	
	return $hostIndex;

}

# Load single hosts host configuration data (de-serialize)
sub LoadHostData {
	
	my $host=shift;

        #create an empty serviceHash
        $serviceHash = {};

        ### Populate each host key with a host object ###

        opendir(HOSTDIR, "$perfhome/var/db/hosts/$host")
                or die("WARNING: Couldn't open dir $perfhome/var/db/hosts/$host: $!\n");

        while ($fileName = readdir(HOSTDIR)) {

                # Skip if file starts with a . and all service.ser
                next if ($fileName =~ m/^\.\.?$/);
                next if ($fileName !~ m/$host\.ser/);

                if ($fileName =~ /$host\.ser/) {

                        #create host object by deserialization
                        $hostObject = lock_retrieve("$perfhome/var/db/hosts/$host/$fileName");
                                die("WARNING: can't retriewe $perfhome/var/db/hosts/$host/$fileName\n") unless defined($hostObject);

                        #assign host object to hostIndex
                        $hostIndex->{$host} = $hostObject;

                } else {
                        warn "ERROR: Serialized host data not found for $host:$fileName while loading host data\n";
                        exit(1);
                }
        }
        closedir(HOSTDIR);

	return $hostIndex;
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
	#if (! -f "$perfhome/var/db/hosts/$hostName/$hostName.ser") {
	#	copy("$perfhome/etc/configs/$OS/host.ser","$perfhome/var/db/hosts/$hostName/$hostName.ser")
		#	or die "WARNING: Couldn't serialize default host data for $hostName: $!\n";
	#}

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
