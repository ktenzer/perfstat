# Add Host to PerfStat configuration

use POSIX;

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

# Get OS
my $os = (uname)[0];

# Atleast one option must be set
@ARGV <= 2 or &Usage;
($option1, $option2)=@ARGV;

# Verify that user is correct
&VerifyUser;

### Main Program ###

if ($option1 =~ m/client/) {
	&Client;
	sleep 2;
} elsif ($option1 =~ m/server/) {
	&Server;
	sleep 2;
} elsif ($option1 =~ m/global/) {
	&Global;
	sleep 2;
} elsif ($option1 =~ m/list/) {
	&List;
	sleep 2;
} else {
	&Usage;
}

# Verify that user isn't root
sub VerifyUser {

	my $currentUID=getuid();
	my($savedUID) = (getpwnam("$ENV{'USER'}"))[2];
	
	if (! defined $option1|$option2) {
		&Usage;
	} elsif ($option1 !~ m/client|server|global|list/) {
		&Usage;
	} elsif ($option2 !~ m/-root/) {
		if ($currentUID == "0") {
			print "ERROR: You must use [-root] option to configure PerfStat as root user!\n";
			exit(1);
		} elsif ($currentUID != $savedUID) {
			print "ERROR: Incorrect user! PerfStat must be configured by $ENV{'USER'} user\n";
			exit(1);
		}
	}
}

# Client sub
sub Client {

	system("clear");

	print "\t\t---PerfStat Client Configuration---\n\n";

	# Configure PerfStat server IP
	print "Enter IP of PerfStat server [$ENV{'PERFSERVER'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'PERFSERVER'}=$ARG;
	}

	# Configure PerfStat server port
	print "Enter port running PerfStat server [$ENV{'CLIENTPORT'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'CLIENTPORT'}=$ARG;
	}

	# Configure PerfStat client metrics
	print "Enter PerfStat client services [$ENV{'METRICS'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'METRICS'}=$ARG;
	}

	# Configure PerfStat host info
	print "Would you like to enable host info (Y|N) [$ENV{'HOST_INFO'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'HOST_INFO'}=$ARG;
	}

	# Configure PerfStat client Host Info Interval
	if ($ENV{'HOST_INFO'} =~ m/y|Y/) {
		print "Enter PerfStat client Host Info Interval [$ENV{'INFO_INTERVAL'}]:";
		$ARG=<STDIN>;

		# Ensure argument is not blank
		if ($ARG !~ m/^\s+/) {
			chomp $ARG;
			$ENV{'INFO_INTERVAL'}=$ARG;
		}
	}

	# Configure PerfStat client Run Interval
	print "Enter PerfStat client Run Interval [$ENV{'RUN_INTERVAL'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'RUN_INTERVAL'}=$ARG;
	}

	# Configure OS Specific Command
	if ($os =~ m/SunOS/) {
                # Configure PerfStat client ps command
                print "Enter path to ps command [$ENV{'PS_CMD'}]:";
                $ARG=<STDIN>;

                # Ensure argument is not blank
                if ($ARG !~ m/^\s+/) {
                        chomp $ARG;
                        $ENV{'PS_CMD'}=$ARG;
                }

                # Configure PerfStat client vmstat command
                print "Enter path to vmstat command [$ENV{'VMSTAT_CMD'}]:";
                $ARG=<STDIN>;

                # Ensure argument is not blank
                if ($ARG !~ m/^\s+/) {
                        chomp $ARG;
                        $ENV{'VMSTAT_CMD'}=$ARG;
                }

                # Configure PerfStat client iostat command
                print "Enter path to iostat command [$ENV{'IOSTAT_CMD'}]:";
                $ARG=<STDIN>;

                # Ensure argument is not blank
                if ($ARG !~ m/^\s+/) {
                        chomp $ARG;
                        $ENV{'IOSTAT_CMD'}=$ARG;
                }

                # Configure PerfStat client netstat command
                print "Enter path to netstat command [$ENV{'NETSTAT_CMD'}]:";
                $ARG=<STDIN>;

                # Ensure argument is not blank
                if ($ARG !~ m/^\s+/) {
                        chomp $ARG;
                        $ENV{'NETSTAT_CMD'}=$ARG;
                }

                # Configure PerfStat client inode command
                print "Enter path to df command [$ENV{'DF_CMD'}]:";
                $ARG=<STDIN>;

                # Ensure argument is not blank
                if ($ARG !~ m/^\s+/) {
                        chomp $ARG;
                        $ENV{'DF_CMD'}=$ARG;
                }

                # Configure PerfStat client swap command
                print "Enter path to swap command [$ENV{'SWAP_CMD'}]:";
                $ARG=<STDIN>;

                # Ensure argument is not blank
                if ($ARG !~ m/^\s+/) {
                        chomp $ARG;
                        $ENV{'SWAP_CMD'}=$ARG;
                }

                # Configure PerfStat client prtconf command
                print "Enter path to prtconf command [$ENV{'PRTCONF_CMD'}]:";
                $ARG=<STDIN>;

                # Ensure argument is not blank
                if ($ARG !~ m/^\s+/) {
                        chomp $ARG;
                        $ENV{'PRTCONF_CMD'}=$ARG;
                }

                # Configure PerfStat client ifconfig command
                print "Enter path to ifconfig command [$ENV{'IFCONFIG_CMD'}]:";
                $ARG=<STDIN>;

                # Ensure argument is not blank
                if ($ARG !~ m/^\s+/) {
                        chomp $ARG;
                        $ENV{'IFCONFIG_CMD'}=$ARG;
                }

                # Configure PerfStat client kstat command
                print "Enter path to kstat command [$ENV{'KSTAT_CMD'}]:";
                $ARG=<STDIN>;

                # Ensure argument is not blank
                if ($ARG !~ m/^\s+/) {
                        chomp $ARG;
                        $ENV{'KSTAT_CMD'}=$ARG;
                }

	} elsif ($os =~ m/Linux/) {
		# Configure PerfStat client ps command
		print "Enter path to ps command [$ENV{'PS_CMD'}]:";
		$ARG=<STDIN>;

		# Ensure argument is not blank
		if ($ARG !~ m/^\s+/) {
			chomp $ARG;
			$ENV{'PS_CMD'}=$ARG;
		}

		# Configure PerfStat client vmstat command
		print "Enter path to vmstat command [$ENV{'VMSTAT_CMD'}]:";
		$ARG=<STDIN>;

		# Ensure argument is not blank
		if ($ARG !~ m/^\s+/) {
			chomp $ARG;
			$ENV{'VMSTAT_CMD'}=$ARG;
		}

		# Configure PerfStat client iostat command
		print "Enter path to iostat command [$ENV{'IOSTAT_CMD'}]:";
		$ARG=<STDIN>;

		# Ensure argument is not blank
		if ($ARG !~ m/^\s+/) {
			chomp $ARG;
			$ENV{'IOSTAT_CMD'}=$ARG;
		}

		# Configure PerfStat client netstat command
		print "Enter path to netstat command [$ENV{'NETSTAT_CMD'}]:";
		$ARG=<STDIN>;

		# Ensure argument is not blank
		if ($ARG !~ m/^\s+/) {
			chomp $ARG;
			$ENV{'NETSTAT_CMD'}=$ARG;
		}

		# Configure PerfStat client inode command
		print "Enter path to df command [$ENV{'DF_CMD'}]:";
		$ARG=<STDIN>;

		# Ensure argument is not blank
		if ($ARG !~ m/^\s+/) {
			chomp $ARG;
			$ENV{'DF_CMD'}=$ARG;
		}

		# Configure PerfStat client uname command
		print "Enter path to uname command [$ENV{'UNAME_CMD'}]:";
		$ARG=<STDIN>;

		# Ensure argument is not blank
		if ($ARG !~ m/^\s+/) {
			chomp $ARG;
			$ENV{'UNAME_CMD'}=$ARG;
		}

		# Configure PerfStat client ps command
		print "Enter path to ps command [$ENV{'PS_CMD'}]:";
		$ARG=<STDIN>;

		# Ensure argument is not blank
		if ($ARG !~ m/^\s+/) {
			chomp $ARG;
			$ENV{'PS_CMD'}=$ARG;
		}

		# Configure PerfStat client rpm command
		print "Enter path to rpm command [$ENV{'RPM_CMD'}]:";
		$ARG=<STDIN>;

		# Ensure argument is not blank
		if ($ARG !~ m/^\s+/) {
			chomp $ARG;
			$ENV{'RPM_CMD'}=$ARG;
		}
	}

	# print out updated configuration
	system("clear");
	print "\t\t---The Following have been selected---\n";

	print "PERFSERVER=$ENV{'PERFSERVER'}\n";
	print "CLIENTPORT=$ENV{'CLIENTPORT'}\n";
	print "METRICS=$ENV{'METRICS'}\n";
	print "HOST_INFO=$ENV{'HOST_INFO'}\n";
	print "INFO_INTERVAL=$ENV{'INFO_INTERVAL'}\n";
	print "RUN_INTERVAL=$ENV{'RUN_INTERVAL'}\n";

	# Print out OS Specific Commands
	if ($os =~ m/SunOS/) {
		print "PS_CMD=$ENV{'PS_CMD'}\n";
		print "VMSTAT_CMD=$ENV{'VMSTAT_CMD'}\n";
		print "IOSTAT_CMD=$ENV{'IOSTAT_CMD'}\n";
		print "NETSTAT_CMD=$ENV{'NETSTAT_CMD'}\n";
		print "DF_CMD=$ENV{'DF_CMD'}\n";
		print "SWAP_CMD=$ENV{'SWAP_CMD'}\n";
		print "PRTCONF_CMD=$ENV{'PRTCONF_CMD'}\n";
		print "IFCONFIG_CMD=$ENV{'IFCONFIG_CMD'}\n";
		print "KSTAT_CMD=$ENV{'KSTAT_CMD'}\n";
	} elsif ($os =~ m/Linux/) {
		print "PS_CMD=$ENV{'PS_CMD'}\n";
		print "VMSTAT_CMD=$ENV{'VMSTAT_CMD'}\n";
		print "IOSTAT_CMD=$ENV{'IOSTAT_CMD'}\n";
		print "NETSTAT_CMD=$ENV{'NETSTAT_CMD'}\n";
		print "DF_CMD=$ENV{'DF_CMD'}\n";
		print "UNAME_CMD=$ENV{'UNAME_CMD'}\n";
		print "PS_CMD=$ENV{'PS_CMD'}\n";
		print "RPM_CMD=$ENV{'RPM_CMD'}\n";
	}

	print "Would you like to save PerfStat client settings [Y]:";

	$ARG=<STDIN>;

	if ($ARG =~ m/^\s+/) {
		$ARG="Y";
	}

	if ($ARG =~ m/y|Y/) {
		&SaveConfiguration;
	} else {
		exit(1);
	}
}

# Server sub
sub Server {

	system("clear");

	print "\t\t---PerfStat Server Configuration---\n\n";

	# Configure PerfStat server ip
	print "Enter PerfStat server IP [$ENV{'SERVERIP'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'SERVERIP'}=$ARG;
	}

	# Configure PerfStat server port
	print "Enter port running PerfStat server [$ENV{'SERVERPORT'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'SERVERPORT'}=$ARG;
	}

	# Configure PerfStat server max bytes
	print "Enter max bytes per PerfStat server connection (bytes) [$ENV{'MAXBYTES'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'MAXBYTES'}=$ARG;
	}

	# Configure PerfStat server ping interval
	print "Enter PerfStat server ping interval [$ENV{'PING_INTERVAL'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'PING_INTERVAL'}=$ARG;
	}

	# Configure PerfStat server status interval
	print "Enter PerfStat server status interval [$ENV{'STATUS_INTERVAL'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'STATUS_INTERVAL'}=$ARG;
	}

	# Configure PerfStat server alert interval
	print "Enter PerfStat server alert interval [$ENV{'ALERT_INTERVAL'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'ALERT_INTERVAL'}=$ARG;
	}

	# Configure PerfStat server auto detect
	print "Would you like to enable Auto Detect of PerfStat clients (Y|N) [$ENV{'AUTO_DETECT'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'AUTO_DETECT'}=$ARG;
	}

	if ($ENV{'AUTO_DETECT'} =~ m/y|Y/) {

		# Configure PerfStat server admin name if auto detect is enable
		print "Enter PerfStat Admin who will own all Auto Detected clients [$ENV{'ADMIN_NAME'}]:";
		$ARG=<STDIN>;

		# Ensure argument is not blank
		if ($ARG !~ m/^\s+/) {
			chomp $ARG;
			$ENV{'ADMIN_NAME'}=$ARG;
		}
	}

	system("clear");
	print "\t\t---Email Configuration---\n";

	# Configure PerfStat email
	print "Would you like to enable email alerts (Y|N) [$ENV{'EMAIL'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'EMAIL'}=$ARG;
	}

	# Configure email
	if ($ENV{'EMAIL'} =~ m/y|Y/) {
		&EmailConfiguration;
	}

	system("clear");
	print "\t\t---Event Log Configuration---\n";

	# Configure PerfStat event logging
	print "Would you like to enable event logging (Y|N) [$ENV{'EVENTLOG'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'EVENTLOG'}=$ARG;
	}

	# Configure email
	if ($ENV{'EVENTLOG'} =~ m/y|Y/) {
		&EventLogConfiguration;
	}

	# print out updated configuration
	system("clear");
	print "\t\t---The Following have been selected---\n";

	print "SERVERIP=$ENV{'SERVERIP'}\n";
	print "SERVERPORT=$ENV{'SERVERPORT'}\n";
	print "MAXBYTES=$ENV{'MAXBYTES'}\n";
	print "PING_INTERVAL=$ENV{'PING_INTERVAL'}\n";
	print "STATUS_INTERVAL=$ENV{'STATUS_INTERVAL'}\n";
	print "ALERT_INTERVAL=$ENV{'ALERT_INTERVAL'}\n";
	print "EMAIL=$ENV{'EMAIL'}\n";

	# print email settings according to what is configured
	if ($ENV{'EMAIL'} =~ m/y|Y/) {
		print "EMAIL_ALL=$ENV{'EMAIL_ALL'}\n";

		if ($ENV{'EMAIL_ALL'} !~ m/y|Y/) {
			print "EMAIL_CRIT=$ENV{'EMAIL_CRIT'}\n";
			print "EMAIL_WARN=$ENV{'EMAIL_WARN'}\n";
			print "EMAIL_NOSTATUS=$ENV{'EMAIL_NOSTATUS'}\n";
		}

		print "SMTP_SERVER=$ENV{'SMTP_SERVER'}\n";
		print "EMAIL_FROM=$ENV{'EMAIL_FROM'}\n";
	}

	print "EVENTLOG=$ENV{'EVENTLOG'}\n";

	# print logging settings according to what is configured
	if ($ENV{'EVENTLOG'} =~ m/y|Y/) {
		print "LOGSIZE=$ENV{'LOGSIZE'}\n";
	}

	print "Would you like to save PerfStat server settings [Y]:";

	$ARG=<STDIN>;

	if ($ARG =~ m/^\s+/) {
                $ARG="Y";
        }

	if ($ARG =~ m/y|Y/) {
		&SaveConfiguration;
	} else {
		exit(1);
	}
}

# Update global configuration
sub Global {

	system("clear");

	print "\t\t---PerfStat Global Configuration---\n\n";

	# Configure PerfStat PATH
	print "Enter PATH to PerfStat home [$ENV{'PERFHOME'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'PERFHOME'}=$ARG;
	}

	# Configure PerfStat USER
	print "Enter PerfStat Username [$ENV{'USER'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'USER'}=$ARG;
	}

	# Configure PerfStat GROUP
	print "Enter PerfStat Group [$ENV{'GROUP'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'GROUP'}=$ARG;
	}

	# Configure PerfStat Debug
	print "Enter Debug Level (0|1) [$ENV{'DEBUG'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'DEBUG'}=$ARG;
	}

	# print out updated configuration
	system("clear");
	print "\t\t---The Following have been selected---\n";

	print "PERFHOME=$ENV{'PERFHOME'}\n";
	print "USER=$ENV{'USER'}\n";
	print "GROUP=$ENV{'GROUP'}\n";
	print "DEBUG=$ENV{'DEBUG'}\n";

	print "Would you like to save PerfStat client settings [Y]:";

	$ARG=<STDIN>;

	if ($ARG =~ m/^\s+/) {
                $ARG="Y";
        }

	if ($ARG =~ m/y|Y/) {
		&SaveConfiguration;
	} else {
		exit(1);
	}
}

# Email Configuration
sub EmailConfiguration {

	# Configure PerfStat email for all events
	print "Would you like to enable email alerts for ALL events? (Y|N) [$ENV{'EMAIL_ALL'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'EMAIL_ALL'}=$ARG;
	}

	# If all events is enabled set warn/crit
	if ($ENV{'EMAIL_ALL'} =~ m/y|Y/) {
		$ENV{'EMAIL_CRIT'}="Y";
		$ENV{'EMAIL_WARN'}="Y";
		$ENV{'EMAIL_NOSTATUS'}="Y";
	} else {

		# Configure PerfStat email for crit events
		print "Would you like to enable email alerts for CRIT events? (Y|N) [$ENV{'EMAIL_CRIT'}]:";
		$ARG=<STDIN>;

		# Ensure argument is not blank
		if ($ARG !~ m/^\s+/) {
			chomp $ARG;
			$ENV{'EMAIL_CRIT'}=$ARG;
		}

		# Configure PerfStat email for warn events
		print "Would you like to enable email alerts for WARN events? (Y|N) [$ENV{'EMAIL_WARN'}]:";
		$ARG=<STDIN>;

		# Ensure argument is not blank
		if ($ARG !~ m/^\s+/) {
			chomp $ARG;
			$ENV{'EMAIL_WARN'}=$ARG;
		}

		# Configure PerfStat email for nostatus events
		print "Would you like to enable email alerts for NOSTATUS events? (Y|N) [$ENV{'EMAIL_NOSTATUS'}]:";
		$ARG=<STDIN>;

		# Ensure argument is not blank
		if ($ARG !~ m/^\s+/) {
			chomp $ARG;
			$ENV{'EMAIL_NOSTATUS'}=$ARG;
		}
	}

	# Configure PerfStat smtp server
	print "Enter IP of SMTP server [$ENV{'SMTP_SERVER'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'SMTP_SERVER'}=$ARG;
	}

	# Configure PerfStat FROM email address
	print "Enter email alert FROM address [$ENV{'EMAIL_FROM'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'EMAIL_FROM'}=$ARG;
	}
}

# Event Log Configuration
sub EventLogConfiguration {

	# Configure PerfStat event log size
	print "Enter event log size (lines) [$ENV{'LOGSIZE'}]:";
	$ARG=<STDIN>;

	# Ensure argument is not blank
	if ($ARG !~ m/^\s+/) {
		chomp $ARG;
		$ENV{'LOGSIZE'}=$ARG;
	}
}

# Save PerfStat configuration
sub SaveConfiguration {

	# Open perf-conf for reading
	open(PERFCONF,"$perfhome/etc/perf-conf")
		or die "ERROR: Couldn't open file $perfhome/etc/perf-conf for reading: $!\n";

	my @data=<PERFCONF>;

	foreach my $line (@data) {
		next if ($line =~ m/^#/);
		next if ($line =~ m/^\s+/);

                $line =~ m/(\w+)=(.+)/;
                my $key=$1;
                my $value=$2;
		$line =~ s/$key=$value/$key=$ENV{$key}/;
	}

	close(PERFCONF);

	# Zero out perf-conf
	open(PERFCONF,"> $perfhome/etc/perf-conf")
		or die "ERROR: Couldn't open file $perfhome/etc/perf-conf for writing: $!\n";
	close(PERFCONF);

	# Open perf-conf for writing
	open(PERFCONF,">> $perfhome/etc/perf-conf")
		or die "ERROR: Couldn't open file $perfhome/etc/perf-conf for writing: $!\n";
	foreach my $line (@data) {
		print PERFCONF "$line";
	}

	close(PERFCONF);

	if ($option1 =~ m/global/) {

		# Open perf.sh for reading
		open(PERF,"$perfhome/perf.sh")
			or die "ERROR: Couldn't open file $perfhome/perf.sh for reading: $!\n";

		my @data=<PERF>;

		foreach my $line (@data) {
			next unless ($line =~ m/^PERFHOME/);
			$line =~ s/$line/PERFHOME=$ENV{'PERFHOME'}\n/;
		}

		close(PERF);

		# Zero out perf.sh
		open(PERF,"> $perfhome/perf.sh")
			or die "ERROR: Couldn't open file $perfhome/perf.sh for writing: $!\n";
		close(PERF);

		# Open perf.sh for writing
		open(PERF,">> $perfhome/perf.sh")
			or die "ERROR: Couldn't open file $perfhome/perf.sh for writing: $!\n";
		foreach my $line (@data) {
			print PERF "$line";
		}

		close(PERF);

		# Open app_globals.pl for reading
		if ($ENV{'SERVER'} =~ m/y|Y/) {
			open(APPGLOBALS,"$perfhome/cgi/app_globals.pl")
				or die "ERROR: Couldn't open file $perfhome/cgi/app_globals.pl for reading: $!\n";

			my @data=<APPGLOBALS>;

			foreach my $line (@data) {
				next unless ($line =~ m/perfhome\s+\=\s+(\S+)/);
				$line =~ s/$1/\"$ENV{'PERFHOME'}\"\;/;
			}

			close(APPGLOBALS);

			# Zero out app_globals.pl
			open(APPGLOBALS,"> $perfhome/cgi/app_globals.pl")
				or die "ERROR: Couldn't open file $perfhome/cgi/app_globals.pl for writing: $!\n";
			close(APPGLOBALS);

			# Open app_globals.pl for writing
			open(APPGLOBALS,">> $perfhome/cgi/app_globals.pl")
				or die "ERROR: Couldn't open file $perfhome/cgi/app_globals.pl for writing: $!\n";
			foreach my $line (@data) {
				print APPGLOBALS "$line";
			}

			close(APPGLOBALS);
		}
	}
	print "\nPerfstat Configuration has been Saved!\n";
}

# List perfstat configuration information
sub List {

        # Open perf-conf for reading
        open(PERFCONF,"$perfhome/etc/perf-conf")
                or die "ERROR: Couldn't open file $perfhome/etc/perf-conf for reading: $!\n";

        my @data=<PERFCONF>;

        foreach my $line (@data) {
                next if ($line =~ m/^#/);
                next if ($line =~ m/^\s+/);

                $line =~ m/(\w+)=(.+)/;
                my $key=$1;
                my $value=$2;
                $line =~ s/$key=$value/$key=$ENV{$key}/;

		print "$line";
        }

        close(PERFCONF);
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

	if ($ENV{'SERVER'} =~ m/Y|y/) {
print STDOUT <<EOF;
Usage:
 $0 [-list] [-root]
 $0 [-server] [-root]
 $0 [-client] [-root]
 $0 [-global] [-root]
EOF
exit(1);
	} else {
print STDOUT <<EOF;
Usage:
 $0 [-list] [-root]
 $0 [-client] [-root]
 $0 [-global] [-root]
EOF
exit(1);
	}
}
