# Gather TCP Metrics

use CGI::Carp qw(carpout);
use POSIX qw(uname);
use Fcntl qw(:flock);

# Slurp in path to Perfhome
my $perfhome=&PATH;
$perfhome =~ s/\/bin//;

# Slurp in Configuration
my %conf       = ();
&GetConfiguration(\%conf);

# Set Environment Variables from %conf
foreach $key (keys %conf) {
        $ENV{$key}="$conf{$key}";
}

# Log all alerts and warnings to the below logfile
my $logfile = "$perfhome/var/logs/perfctl.log";
open(LOGFILE, ">> $logfile")
        or die "ERROR: Unable to append to $logfile: $!\n";
carpout(*LOGFILE);

# Setup Variables
my $service="tcp";
my $os = (uname)[0];

# Run subroutines
&TRAFFIC;

# Collect TCP bytes in/out
sub TRAFFIC {
	$tcp_traffic="/proc/net/dev";

	open(TRAFFIC,"$tcp_traffic")
		or die "ERROR: Couldn't open file $tcp_traffic: $!\n";

	my @data=<TRAFFIC>;
	close(TRAFFIC);

	foreach my $line (@data) {
		next if ($line =~ m/^Inter/);
		next if ($line =~ m/\s+face/);
		next if ($line =~ m/\s+lo/);
		$line =~ m/\s+(\S+):(\s+\S+|\S+)\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)/;
		$device=$1; $tcpBytesIn=$2; $tcpBytesOut=$3;
		next if ($device =~ m/\S+:\d+/);
		$tcpBytesIn =~ s/^\s+//;
		$tcpBytesOut =~ s/^\s+//;
		$device =~ s/://;
		&COUNTERS($device);
		$tcp_h{$device}="$tcpBytesIn $tcpBytesOut";
	}

        # Ensure data was found
        if (! defined $device) {
                warn "WARNING: Data for $service service was not collected during this sampling!\n";
        }
}

# Get actual value from counter
sub COUNTERS {

	my $device=shift;

	@counters=qw(tcpBytesIn tcpBytesOut);
	my $counterDir="$perfhome/tmp/counters";

	foreach $counter (@counters) {
		my $counterFile="$counter.$device";
		if (! -f "$counterDir/$counterFile") {
			open(COUNTER, ">$counterDir/$counterFile")
				or die "WARNING: Couldn't open counter for $counterFile: $!\n";
			print COUNTER "${$counter}";
	
			close (COUNTER);

			# Set to 0 since we don't know the last value
			${$counter}="0";
		} else {
			# Open for read
			open(COUNTER, "< $counterDir/$counterFile")
				or die "WARNING: Couldn't open counter for $counterFile: $!\n";

			$data=<COUNTER>;
			close (COUNTER);
	
			# Open for write
			open(COUNTER, "> $counterDir/$counterFile")
				or die "WARNING: Couldn't open counter for $counterFile: $!\n";

			print COUNTER "${$counter}";
	
			close (COUNTER);

			${$counter}=${$counter} - $data;
		}
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

                $hashref->{$key}=$value;
        }
        close(FILE);
}

# Get path to perfctl executable
sub PATH {
  my $path = PerlApp::exe();
	$path =~ s/\/\w*$//;
        return $path;
}

# Send TCP Data to Perf Server
foreach $key (sort keys %tcp_h) {
	$perf_out="$os data $service $key $tcp_h{$key}";

	open(PERFOUT, ">> $perfhome/tmp/perf.out")
        	or die "WARNING: Couldn't open file handle for $perfhome/tmp/perf.out: $!\n";

	flock(PERFOUT, LOCK_EX)
        	or die "WARNING: Couldn't obtain exclusive lock on $perfhome/tmp/perf.out: $!\n";

	print PERFOUT "$perf_out\n";

        flock(PERFOUT, LOCK_UN)
                or die "WARNING: Couldn't release lock on $perfhome/tmp/perf.out: $!\n";
}

close(PERFOUT);
