use strict;
package main;

# Slurp in Configuration
my %conf = ();
getConfiguration(\%conf);

# Set Environment Variables from %conf
foreach my $key (keys %conf) {
        $ENV{$key}="$conf{$key}";
}

$serverStatus = checkPID();
$uptime = getAppUptime();
my $PS_CMD=();

sub checkPID {

	# Determine OS
	my $OS=`$ENV{'UNAME_CMD'} -s`;

	# The ps commands are differnt
	if ($OS =~ m/SunOS/) {
		$PS_CMD="$ENV{'PS_CMD'} -fp";
	} elsif ($OS =~ m/Linux/) {
		$PS_CMD="$ENV{'PS_CMD'} -f";
	}

	open(PERFD_PID,"$perfhome/tmp/perfd.pid") or die "Couldn't open file handle for $perfhome/tmp/perfd.pid: $!\n";
	my $perfdPID=<PERFD_PID>;
	chomp $perfdPID;
	close (PERFD_PID);
	my $status;
	my $checkPID=`$PS_CMD $perfdPID`;
	my $result=$?;

	if ($result eq 0 ) {
		$status="up";
	} else {
		$status="down";
	}
	return $status;
}

# Sub for getting app uptime
sub getAppUptime {

	# Setup variables
	my $minutes=();
	my $hours=();
	my $days=();

	# Get last app start time
	open(TIME, "$perfhome/tmp/perfd.time")
		or die "ERROR: Couldn't open file $perfhome/tmp/perfd.time: $!\n";

	my $startTime=<TIME>;
	chomp $startTime;

	close (TIME);

	# Determine current time
	my $currTime=time;

	# Calculate difference between current time and app start time
	my $diff=$currTime - $startTime;

	# Calculate total minutes, hours, and days of app uptime
	my $minTotal=int($diff / 60);
	my $hourTotal=int($minTotal / 60);
	my $dayTotal=int($hourTotal / 24);

	# Calculate days/hours/minutes of app uptime
	if ($dayTotal gt 0) {

		# Calculate days
		$days=$dayTotal;
		my $recalcDays=$dayTotal * 24 * 60 * 60;	
		my $newDiffDays=$diff - $recalcDays;

		# Calculate hours
		$hours=int(($newDiffDays / 60)/60);
		my $recalcHours=$hours * 60 * 60;
		my $newDiffHours=($diff - ($recalcHours + $recalcDays));

		# Calculate minutes
		$minutes=int($newDiffHours / 60);
		my $recalcMinutes=$minutes * 60;

		my $uptime="$days days $hours hours $minutes minutes";
		return $uptime;
	
	# Calculate hours/minutes
	} elsif ($dayTotal eq 0 && $hourTotal gt 0 && $minTotal gt 0) {

		# Calculate hours
		$hours=$hourTotal;
		my $recalcHours=$hourTotal * 60 * 60;	
		my $newDiffHours=$diff - $recalcHours;

		# Calculate minutes
		$minutes=int($newDiffHours / 60);
		my $recalcMinutes=$minutes * 60;

		my $uptime="$hours hours $minutes minutes";
		return $uptime;

	# Calculate minutes
	} elsif ($minTotal gt 0 && $hourTotal eq 0 && $dayTotal eq 0) {

		# Calculate minutes
		$minutes=int($diff / 60);

		my $uptime="$minutes minutes";
		return $uptime;
	}
}

1;
