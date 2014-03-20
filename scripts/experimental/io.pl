#!/usr/local/ActivePerl-5.8/bin/perl
# Gather Disk Metrics

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
my $service="io";
my $os = (uname)[0];

# Run subroutines
&IOSTAT;

# Collect io statistics
sub IOSTAT {

        my $iostat_out="$perfhome/tmp/iostat.out";

        if (! -f $iostat_out) {
		warn "ERROR: Couldn't open file $iostat_out: $!\n";
                exit (1);
        }

        # Slurp in iostat data for parsing
        open(IOSTAT_OUT,"$iostat_out")
                or die "ERROR: Couldn't open file $iostat_out: $!\n";

	# Obtain shared lock
	flock(IOSTAT_OUT, LOCK_EX)
		or die "WARNING: Couldn't obtain shared lock on $iostat_out: $!\n";

        my @data=<IOSTAT_OUT>;

	if (! defined @data) {
		warn "WARNING: No data found in iostat.out!\n";
	}

        flock(IOSTAT_OUT, LOCK_UN)
                or die "WARNING: Couldn't release lock on $iostat_out: $!\n";

        close (IOSTAT_OUT);

	my $i=0;
        # Parse iostat data
	foreach $line (@data) {
                next if ($line =~ m/^\s+/);
                if ($line =~ m/^Device/) {
                        $line_num="$i";
                        $i++;
                        next;
                }

                # Only output the driver not the partition
                if ($line_num eq 1) {
                        next if ($line =~ m/\/dev\/\w+\d+/);
        		$line =~ m/(\S+)\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)\s+(\S+)\s+\S+\s+\S+\s+(\S+)\s+\S+\s+(\S+)/;
			$device=$1; my $ioReadKB=$2; my $ioWriteKB=$3; my $aWait=$4; my $ioUtilPct=$5; 
			$ioIdlePct=100 - $ioUtilPct;
			$device =~ s/\/dev\///;
			$io_h{$device}="$ioReadKB $ioWriteKB $aWait $ioUtilPct $ioIdlePct";
                }

	}

	# Ensure data was found
	if (! defined $device) {
		warn "WARNING: Data for $service service was not collected during this sampling!\n";
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

# Send Data to Perf Server
my $totalReadKB=0;
my $totalWriteKB=0;
my $totalWait=0;
my $totalUtilPct=0;
my $totalIdlePct=0;
my $ioCount=0;
foreach my $device (sort keys %io_h) {

	my $perf_out="$os data $service $device $io_h{$device}";

	# Calculate Total
	my $ioData=$io_h{$device};
	$ioData =~ /(\S*)\s+(\S*)\s+(\S*)\s+(\S*)\s+(\S*)/;
	$totalReadKB=$1 + $totalReadKB;
	$totalWriteKB=$2 + $totalWriteKB;
	$totalWait=$3 + $totalWait;
	$totalUtilPct=$4 + $totalUtilPct;
	$totalIdlePct=$5 + $totalIdlePct;

	open(PERFOUT, ">> $perfhome/tmp/perf.out")
        	or die "WARNING: Couldn't open file handle for $perfhome/tmp/perf.out: $!\n";

	flock(PERFOUT, LOCK_EX)
        	or die "WARNING: Couldn't obtain exclusive lock on $perfhome/tmp/perf.out: $!\n";

	print PERFOUT "$perf_out\n";

        flock(PERFOUT, LOCK_UN)
                or die "WARNING: Couldn't release lock on $perfhome/tmp/perf.out: $!\n";

	close(PERFOUT);

	$ioCount ++;
}

# Send IO Totals
if ("$totalReadKB" ne "0") {
	$totalReadKB=$totalReadKB / $ioCount;
}
if ("$totalWriteKB" ne "0") {
	$totalWriteKB=$totalWriteKB / $ioCount;
}
if ("$totalWait" ne "0") {
	$totalWait=$totalWait / $ioCount;
}
if ("$totalUtilPct" ne "0") {
	$totalUtilPct=$totalUtilPct / $ioCount;
}
if ("$totalIdlePct" ne "0") {
	$totalIdlePct=$totalIdlePct / $ioCount;
}

my $perf_out="$os data io Total $totalReadKB $totalWriteKB $totalWait $totalUtilPct $totalIdlePct";

open(PERFOUT, ">> $perfhome/tmp/perf.out")
       	or die "WARNING: Couldn't open file handle for $perfhome/tmp/perf.out: $!\n";

flock(PERFOUT, LOCK_EX)
       	or die "WARNING: Couldn't obtain exclusive lock on $perfhome/tmp/perf.out: $!\n";

print PERFOUT "$perf_out\n";

flock(PERFOUT, LOCK_UN)
	or die "WARNING: Couldn't release lock on $perfhome/tmp/perf.out: $!\n";

close(PERFOUT);
