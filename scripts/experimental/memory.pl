#!/usr/local/ActivePerl-5.8/bin/perl
# Gather Memory Metrics

use CGI::Carp qw(carpout);
use POSIX qw(uname);
use Fcntl qw(:flock);

# Slurp in path to Perfhome
#my $perfhome=&PATH;
#$perfhome =~ s/\/bin//;
$perfhome="/perfstat/dev/1.52/server";

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
my @pageData=();

# Metrics to collect
@metrics=qw(memUsedPct memFreePct swapUsedPct swapFreePct pageIn pageOut);

# Collect Memory and paging statistics
#&VMSTAT;
&MEMINFO;
&PAGEINFO;

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
	$memFreePct=100 - $memUsedPct;
	$swapUsedPct=int $swapUsed / $swapTotal * 100;
	$swapFreePct=100 - $swapUsedPct;
}

# Collect paging statistics
sub VMSTAT {
        my $vmstat_out="$perfhome/tmp/vmstat.out";

        if (! -f $vmstat_out) {
		warn "ERROR: Couldn't open file $vmstat_out: $!\n";
                exit (1);
        }

        # Slurp in vmstat data for parsing
        open(VMSTAT_OUT,"$vmstat_out")
                or die "ERROR: Couldn't open file $vmstat_out: $!\n";

	# Obtain shared lock
	flock(VMSTAT_OUT, LOCK_SH)
		or die "WARNING: Couldn't obtain shared lock on $vmstat_out: $!\n";

        @pageData=<VMSTAT_OUT>;
        close (VMSTAT_OUT);

        # Parse the secound count only
        foreach $line (@pageData) {
        
                next if ($line =~ m/^\s+procs/);
                next if ($line =~ m/^\s+r/);

                $data=$line;
                $data =~ s/^\s+//;
        }

        # Parse vmstat data
	$data =~ m/\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)\s+(\S+)/;
	$page_in_kb=$1; $page_out_kb=$2;
}

# Determine swap page information
sub PAGEINFO {

	my $page_stats="/proc/stat";

	open(SWAPINFO,"$page_stats")
		or die "ERROR: Couldn't open file $page_stats: $!\n";

	my @data=<SWAPINFO>;

	close(SWAPINFO);

	# Parse Memory statistics
	foreach my $line (@data) {
		if ($line =~ m/^swap/) {
			$line =~ m/\S+\s+(\d+)\s+(\d+)/;
			$pageIn=$1;
			$pageOut=$2;
		}
	}

	# Linuix has a 4KB page size
	$pageIn=$pageIn * 4;
	$pageOut=$pageOut * 4;

        # Determine actual values of counters
        &COUNTERS;
}

# Get actual value from counter
sub COUNTERS {

        @counters=qw(pageIn pageOut);
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
                warn "WARNING: $met is null! Data: @pageData\n";
        }
}

# Send Data to Perf Server
$perf_out="$os data $service $memUsedPct $memFreePct $swapUsedPct $swapFreePct $pageIn $pageOut";

open(PERFOUT, ">> $perfhome/tmp/perf.out")
        or die "WARNING: Couldn't open file handle for $perfhome/tmp/perf.out: $!\n";

flock(PERFOUT, LOCK_EX)
        or die "WARNING: Couldn't obtain exclusive lock on $perfhome/tmp/perf.out: $!\n";

print PERFOUT "$perf_out\n";

close (PERFOUT);
