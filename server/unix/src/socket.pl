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
my $service="socket";
my $os = (uname)[0];

# Metrics to collect
@metrics=qw(activeOpens passiveOpens estConnections);

# Run subroutines
&SOCKET;

# Collect socket information
sub SOCKET {

	open(NETSTAT,"$ENV{'NETSTAT_CMD'} -t -s|")
		or die "ERROR: couldn't open $ENV{'NETSTAT_CMD'}: $!\n";

	my @data=<NETSTAT>;
	close(NETSTAT);

	foreach my $line (@data) {
		if ($line =~ m/active\s+connection/) {
			$line =~ m/\s+(\d+)/;
			$activeOpens=$1;
		}
		if ($line =~ m/passive\s+connection/) {
			$line =~ m/\s+(\d+)/;
			$passiveOpens=$1;
		}
		if ($line =~ m/connections\s+established/) {
			$line =~ m/\s+(\d+)/;
			$estConnections=$1;
		}
	}

	# Determine actual values of counters
	&COUNTERS;
}

# Get actual value from counter
sub COUNTERS {

        @counters=qw(activeOpens passiveOpens);
        my $counterDir="$perfhome/tmp/counters";

        foreach $counter (@counters) {
                if (! -f "$counterDir/$counter") {
                        open(COUNTER, ">$counterDir/$counter")
                                or die "WARNING: Couldn't open counter for $counter: $!\n";
                        print COUNTER "${$counter}";

                        close (COUNTER);

                        # Set to 0 since we don't know the last value
                        ${$counter}="0";
                } else {
                        # Open for read
                        open(COUNTER, "< $counterDir/$counter")
                                or die "WARNING: Couldn't open counter for $counter: $!\n";

                        $data=<COUNTER>;
                        close (COUNTER);

                        # Open for write
                        open(COUNTER, "> $counterDir/$counter")
                                or die "WARNING: Couldn't open counter for $counter: $!\n";

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

# Ensure all data is collected
foreach $met (@metrics) {
        if (! defined ${$met}) {
                warn "WARNING: $met is null!\n";
        }
}

# Send SOCKET Data to Perf Server
my $perf_out="$os data $service $activeOpens $passiveOpens $estConnections";

open(PERFOUT, ">> $perfhome/tmp/perf.out")
        or die "WARNING: Couldn't open file handle for $perfhome/tmp/perf.out: $!\n";

flock(PERFOUT, LOCK_EX)
        or die "WARNING: Couldn't obtain exclusive lock on $perfhome/tmp/perf.out: $!\n";

print PERFOUT "$perf_out\n";

close (PERFOUT);
