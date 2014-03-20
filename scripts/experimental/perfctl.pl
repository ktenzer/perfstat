#!/usr/local/ActivePerl-5.8/bin/perl
# PerfStat Client Daemon

use CGI::Carp qw(carpout);
use POSIX qw(:sys_wait_h :errno_h sys_wait_h);
use Fcntl qw(:DEFAULT);
my $ppid="$$";
my $pgid=getpgrp $ppid;
my $quit = 0;

# Slurp in path to Perfhome
#my $perfhome=&PATH;
#$perfhome =~ s/\/bin//;
$perfhome="/perfstat/dev/1.52/server";
$perfOutFile="$perfhome/tmp/perf.out";

$perf="$perfhome/bin/perf.pl";

# Remove perf out file if it exists
if (-f "$perfOutFile") {
	unlink "$perfOutFile"
		or die "ERROR: Couldn't delete $perfOutFile: $!\n";
}

# Slurp in Configuration
my %conf       = ();
&GetConfiguration(\%conf);

# Set Environment Variables from %conf
foreach $key (keys %conf) {
        $ENV{$key}="$conf{$key}";
}

# Convert Intervals from minutes to seconds
$ENV{'RUN_INTERVAL'}=$ENV{'RUN_INTERVAL'} * 60;
$ENV{'STATUS_INTERVAL'}=$ENV{'STATUS_INTERVAL'} * 60;
$ENV{'PING_INTERVAL'}=$ENV{'PING_INTERVAL'} * 60;

# Save PID in file
open(PID, "> $perfhome/tmp/perfctl.pid")
        or die "ERROR: Couldn't open file $perfhome/tmp/perfctl.pid: $!\n";
print PID "$ppid\n";
close (PID);

# Save PGID in file
open(PGID, "> $perfhome/tmp/perfctl.pgid")
        or die "ERROR: Couldn't open file $perfhome/tmp/perfctl.pgid: $!\n";
print PGID "$pgid\n";
close (PGID);

# Log all alerts and warnings to the below logfile
my $logfile = "$perfhome/var/logs/perfctl.log";
open(LOGFILE, ">> $logfile")
	or die "ERROR: Unable to append to $logfile: $!\n";
carpout(*LOGFILE);

# Define Signal Handling
$SIG{INT} = $SIG{TERM} =  sub { $quit++ };
$SIG{CHLD} =  sub { while ( waitpid(-1, WNOHANG)>0 ) { } };

# Remove counter files if exist
&CounterRemove;

# Organize rates of data collection
&DataCollection;
&CheckVmstat;

# Determine how often to check host status in seconds (server only)
if ($ENV{'SERVER'} =~ m/y|Y/) {
	$interval_h{'CheckStatus'}="$ENV{'STATUS_INTERVAL'}";
}

# Determine how often to check alerts in seconds (server only)
if ($ENV{'SERVER'} =~ m/y|Y/) {
	$interval_h{'CheckAlerts'}="$ENV{'ALERT_INTERVAL'}";
}

# Determine how often to check host connectivity in seconds (server only)
if ($ENV{'SERVER'} =~ m/y|Y/) {
	$interval_h{'HostConnectivity'}="$ENV{'PING_INTERVAL'}";
}

# Set host info to run once a day if it is configured
if ($ENV{'HOST_INFO'} =~ m/y|Y/) {
	#$interval_h{'HostInfo'}="1440";
	$interval_h{'HostInfo'}="60";
}

# Organize Normal services into hash for sorting
foreach my $service (@serviceNormal) {
	$interval_h{$service}=$ENV{'RUN_INTERVAL'};
}

# Organize unique services into hash for sorting
foreach my $service (@serviceUnique) {
	$service =~ m/(\S+):(\d+)/;
       	$service=$1; my $interval=$2;
       	$interval=$interval * 60;
	$interval_h{$service}=$interval;
}

# Main Body of Program
while (!$quit) {

	my $currTime=time;

	if (-f "$perfOutFile") {
		&SendData;
	}

	# Determine if this is the first time through
	if (! defined $first)  {
		$first="1";

		# Build has relating service to it's runtime interval
		foreach my $service (keys %interval_h) {

			# Automatically run data collection programs at start
			if ($service =~ m/VMSTAT|IOSTAT/) {
				&RunProgram($service,$interval_h{$service});
			}

			$newtime=$currTime + $interval_h{$service};
			$time_h{$service}=$newtime;
		}
	} else {

		# Run service and reset it's time counter if it is = or < the current time
		foreach my $service (keys %time_h) {
	
			if ($currTime >= $time_h{$service}) {

				my $updateTime=$currTime + $interval_h{$service};
				$time_h{$service}=$updateTime;
				if ($service =~ m/VMSTAT|IOSTAT/) {
					&RunProgram($service,$interval_h{$service});
				} else {
					&RunProgram($service);
				}
			}
		}
	}

	# Sleep for 10 seconds before checking again
	sleep 10;
}

# Determine data collection
sub DataCollection {
	foreach $service (@services) {
		if ($service =~ m/mem\S*:\d+|cpu\S*:\d+/) {
			$service =~ m/(\S+):(\d+)/;
			my $service=$1; my $interval=$2;
			$interval=$interval * 60;
			$cmdCheck_h{$service}=$interval;
			$interval_h{'VMSTAT'}=$interval;
		} elsif ($service =~ m/mem|cpu/) {
			#push(@cmds,"VMSTAT");
			$interval_h{'VMSTAT'}=$ENV{'RUN_INTERVAL'};
		} elsif ($service =~ m/io\S*:\d+/) {
			$service =~ m/(\S+):(\d+)/;
			my $service=$1; my $interval=$2;
			$interval=$interval * 60;
			$cmdCheck_h{$service}=$interval;
			$interval_h{'IOSTAT'}=$interval;
		} elsif ($service =~ m/io/) {
			#push(@cmds,"IOSTAT");
			$interval_h{'IOSTAT'}=$ENV{'RUN_INTERVAL'};
		}

		# Handle services with unique intervals different
		if ($service =~ m/\S+:\d+/) {
			push(@serviceUnique,$service);
		} elsif ($service =~ m/\S+/) {
			push(@serviceNormal,$service);
		}
	}
}

# Check cpu and mem to ensure both have same interval
sub CheckVmstat {
	foreach my $service (keys %cmdCheck_h) {
		if ($service =~ m/cpu/) {
			$cpuInterval=$cmdCheck_h{$service};
		} elsif ($service =~ m/mem/) {
			$memInterval=$cmdCheck_h{$service};
		}

		if (defined $cpuInterval & $memInterval) {
			if ($cpuInterval ne $memInterval) {
				warn "ERROR: The cpu and memory services must have the same run interval\n";
				exit(1);
			}
		}
	}
}

# Collect vmstat data
sub VMSTAT {

	my $interval=shift;

	# Track vmstat pids
	my $vmstat_out="$perfhome/tmp/vmstat.out";
	my $vmstat_cmd="$ENV{'VMSTAT_CMD'} $interval 2";
	my $data=();

	warn "DEBUG: VMSTAT output file is $vmstat_out\n" if ($ENV{'DEBUG'});
	warn "DEBUG: VMSTAT command is $vmstat_cmd\n" if ($ENV{'DEBUG'});

	# Run vmstat
	$data=`$vmstat_cmd`;

	if (! defined $data) {
		warn "WARNING: Data for vmstat was not collected during this sampling\n";
	}

	# Write output to a file
	open(VMSTAT_OUT,"> $vmstat_out")
		or die "ERROR: Couldn't open file $vmstat_out: $!\n";

	# Obtain exclusive lock
	flock(VMSTAT_OUT, 2)
		or die "WARNING: Couldn't obtain exclusive lock on $vmstat_out: $!\n";

	print VMSTAT_OUT "$data";

	flock(VMSTAT_OUT, 8)
		or die "WARNING: Couldn't release lock on $vmstat_out: $!\n";

	close (VMSTAT_OUT);

}

# Collect iostat data
sub IOSTAT {

	my $interval=shift;
	my $data=();

	# Track iostat pids
	my $iostat_out="$perfhome/tmp/iostat.out";
	my $iostat_cmd="$ENV{'IOSTAT_CMD'} $interval 2 -x -d";

	warn "DEBUG: IOSTAT output file is $iostat_out\n" if ($ENV{'DEBUG'});
	warn "DEBUG: IOSTAT command is $iostat_cmd\n" if ($ENV{'DEBUG'});

	# Run iostat
	$data=`$iostat_cmd`;

	if (! defined $data) {
		warn "WARNING: Data for iostat was not collected during this sampling\n";
	}

	open(IOSTAT_OUT,"> $iostat_out")
        	or die "ERROR: Couldn't open file $iostat_out: $!\n";

	# Obtain exclusive lock
	flock(IOSTAT_OUT, 2)
		or die "WARNING: Couldn't obtain exclusive lock on $iostat_out: $!\n";

        print IOSTAT_OUT "$data";

	flock(IOSTAT_OUT, 8)
		or die "WARNING: Couldn't release lock on $iostat_out: $!\n";

	close (IOSTAT_OUT);

}

# Run data gathering/services programs
sub RunProgram {

	my $program=shift;
	my $interval=shift;

	# Ensure client is configured in perf-conf
	if (! $ENV{'CLIENT'} =~ m/y|Y/) {
		warn "DEBUG: Not configured to run client, check perf-conf\n" if ($ENV{'DEBUG'});
		exit(1);
	}

	# Run data colloection program, service, or status
	if ($program =~ m/VMSTAT|IOSTAT/) {
		# Run iostat/vmstat for data collection
		warn "DEBUG: Running $program\n" if ($ENV{'DEBUG'});	

		$pid = fork();
		die "WARNING: Cannot Fork: $!" unless (defined $pid);
		warn "DEBUG: Child PID is $pid\n" if ($ENV{'DEBUG'});

		if ($pid == 0) {
			&$program($interval);			# Run either iostat or vmstat
			exit(0);
		}
	} elsif ($program =~ m/CheckStatus/) {
		# Run Check Status Function
		warn "DEBUG: Running $program Function\n" if ($ENV{'DEBUG'});	
		$pid = fork();
		die "WARNING: Cannot Fork: $!" unless (defined $pid);
		warn "DEBUG: Child PID is $pid\n" if ($ENV{'DEBUG'});

		if ($pid == 0) {
			$checkStatus=system("$perfhome/bin/status.pl");
			exit(0);
		}
	} elsif ($program =~ m/CheckAlerts/) {
		# Run Check Status Function
		warn "DEBUG: Running $program Function\n" if ($ENV{'DEBUG'});	
		$pid = fork();
		die "WARNING: Cannot Fork: $!" unless (defined $pid);
		warn "DEBUG: Child PID is $pid\n" if ($ENV{'DEBUG'});

		if ($pid == 0) {
			$checkAlerts=system("$perfhome/bin/alert.pl");
			exit(0);
		}
	} elsif ($program =~ m/HostConnectivity/) {
		# Run Check Status Function
		warn "DEBUG: Running $program Function\n" if ($ENV{'DEBUG'});	
		$pid = fork();
		die "WARNING: Cannot Fork: $!" unless (defined $pid);
		warn "DEBUG: Child PID is $pid\n" if ($ENV{'DEBUG'});

		if ($pid == 0) {
			$hostConnectivity=system("$perfhome/bin/conn.pl");
			exit(0);
		}
	} elsif ($program =~ m/HostInfo/) {
		# Run Check Status Function
		warn "DEBUG: Running $program Function\n" if ($ENV{'DEBUG'});	
		$pid = fork();
		die "WARNING: Cannot Fork: $!" unless (defined $pid);
		warn "DEBUG: Child PID is $pid\n" if ($ENV{'DEBUG'});

		if ($pid == 0) {
			$hostInfo=system("$perfhome/bin/info.pl");
			exit(0);
		}
	} else {
		# Run Service program
		warn "DEBUG: Running $program Service\n" if ($ENV{'DEBUG'});	

		if (! -f "$perfhome/bin/$program") {
			warn "ERROR: $perfhome/bin/$program program not found! Check perf-conf settings\n";
		}

		$runProgram=system("$perfhome/bin/$program");
	}
}

# Delete metrics counters
sub CounterRemove {

	my $counterDir="$perfhome/tmp/counters";

	opendir(COUNTERDIR, $counterDir)
		or die "Couldn't open $counterDir directory: $!\n";

	while (defined ($file = readdir(COUNTERDIR))) {
		# Skip "." and ".."
		next if $file =~ m/^\.\.?$/;

		# Remove counter file
		if (-f "$counterDir/$file") {
			unlink "$counterDir/$file"
				or die "ERROR: Couldn't delete $counterDir/$file: $!\n";
		}
	}
}

# Send data to PerfServer
sub SendData {

	my @data=();

	# Open perf out file and obtain lock
	open(PERFOUT, "< $perfOutFile")
		or warn "ERROR: Couldn't open file handle to $perfOutFile: $!\n";

	flock(PERFOUT, 1)
		or warn "ERROR: Couldn't obtain shared lock for $perfOutFile: $!\n";

	# Slurp in contents of perf out
	while (<PERFOUT>) {
		push(@data, $_);
	}
	close (PERFOUT);

	# Remove perf out file
	unlink "$perfOutFile"
		or die "ERROR: Couldn't delete $perfOutFile: $!\n";

	# Prepare and send data to PerfStat server
	my $perfOut=join(":", @data);
	$perfOut =~ s/\n//g;

	if (defined $perfOut) {
		my $sendPerf=system($perf,$ENV{'PERFSERVER'},$perfOut);
	} else {
		warn "ERROR: Data collected for this sampling is null\n";
	}

}

# Get configuration dynamically from perf-conf
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

		if ($key =~ m/^METRICS/) {
			@services=split(/\s+/, $value);
		} else {
                	$hashref->{$key}=$value;
		}
        }
        close(FILE);
}

# Get path to perfctl executable
sub PATH {
	my $path = PerlApp::exe();
	$path =~ s/\/\w*$//;
 	return $path;
}
