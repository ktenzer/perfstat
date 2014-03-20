# Gather Memory Metrics

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
my $service="mem";
my $os = (uname)[0];

# Metrics to collect
@metrics=qw(memUsedPct swapUsedPct page_in_kb page_out_kb);

# Collect Memory and paging statistics
&MEMINFO;
&VMSTAT;

# Collect Memory statistics
sub MEMINFO {

	my $mem_stats="/proc/meminfo";

	open(MEMINFO,"$mem_stats")
		or die "ERROR: Couldn't open file $mem_stats: $!\n";

	my @data=<MEMINFO>;

	close(MEMINFO);

	# Parse Memory statistics
	foreach my $line (@data) {
		if ($line =~ m/^MemTotal/) {
			$line =~ m/\S+\s+(\S+)/;
			$memTotal=$1;
		}
		if ($line =~ m/^MemFree/) {
			$line =~ m/\S+\s+(\S+)/;
			$memFree=$1;
		}
		if ($line =~ m/^SwapTotal/) {
			$line =~ m/\S+\s+(\S+)/;
			$swapTotal="$1";
		}
		if ($line =~ m/^SwapFree/) {
			$line =~ m/\S+\s+(\S+)/;
			$swapFree=$1;
		}
	}

	# Calculate Memory percent utilization
	$memUsed=$memTotal - $memFree;
	$swapUsed=$swapTotal - $swapFree;

	$memUsedPct=int $memUsed / $memTotal * 100;
	$swapUsedPct=int $swapUsed / $swapTotal * 100;
}

# Collect paging statistics
sub VMSTAT {
        my $vmstat_out="$perfhome/tmp/vmstat.out";

        if (! -e $vmstat_out) {
		warn "ERROR: Couldn't find file $vmstat_out\n";
                exit (1);
        }

        # Slurp in vmstat data for parsing
        open(VMSTAT_OUT,"$vmstat_out")
                or die "ERROR: Couldn't open file $vmstat_out: $!\n";

	# Obtain shared lock
	flock(VMSTAT_OUT, LOCK_SH)
		or die "WARNING: Couldn't obtain shared lock on $vmstat_out: $!\n";

        my @data=<VMSTAT_OUT>;
        close (VMSTAT_OUT);

        # Parse the secound count only
        foreach $line (@data) {
        
                next if ($line =~ m/^\s+procs/);
                next if ($line =~ m/^\s+r/);

                $data=$line;
                $data =~ s/^\s+//;
        }

        # Parse vmstat data
	$data =~ m/\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)\s+(\S+)/;
	$page_in_kb=$1; $page_out_kb=$2;
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

# Send Data to Perf Server
$perf_out="$os data $service $memUsedPct $swapUsedPct $page_in_kb $page_out_kb";

open(PERFOUT, ">> $perfhome/tmp/perf.out")
        or die "WARNING: Couldn't open file handle for $perfhome/tmp/perf.out: $!\n";

flock(PERFOUT, LOCK_EX)
        or die "WARNING: Couldn't obtain exclusive lock on $perfhome/tmp/perf.out: $!\n";

print PERFOUT "$perf_out\n";

close (PERFOUT);
