# fs.pl - Gather File System Metrics

use CGI::Carp qw(carpout);
use vars qw( $fs_h $fsName $fsUsedPct $inodeUsedPct);
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
my $service="fs";
my $os = (uname)[0];

# Collect all File System info
&GetFS;
	
# Gather Data
sub GetFS {

	open(FS, "$ENV{'DF_CMD'} -T -k|")
        	or die "ERROR: Couldn't open File Handle for $ENV{'DF_CMD'}: $!\n";
	my @df=<FS>;
	close (FS);

	foreach $line (@df) {
		next if ($line =~ m/Filesystem/);
		next if ($line !~ m/ext|vxfs/);

		$line =~ m/(\d+)\%\s+(\S+)/;
		$fsName=$2;
		$fsUsedPct=$1;
		$fsFreePct=100 - $fsUsedPct;

		if ($fsName =~ m/\//) {
			if ($fsName eq "/") {
				$fsName="root";
			}
			$fsName =~ s/^\///g;
			$fsName =~ s/\//,/g;
		}
		@{$fs_h{$fsName}}="$fsUsedPct $fsFreePct";
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

# Default DATA
my $totalFsUsed=0;
my $totalFsFree=0;
my $fsCount=0;
foreach my $fsName (sort keys %fs_h) {

	my $perf_out="$os data $service $fsName @{$fs_h{$fsName}}";

	# Calculate Total
	my $fsData=@{$fs_h{$fsName}}[0];
	$fsData =~ m/(\S*)\s+(\S*)/;
	$totalFsUsed=$1 + $totalFsUsed;
	$totalFsFree=$2 + $totalFsFree;

	open(PERFOUT, ">> $perfhome/tmp/perf.out")
        	or die "WARNING: Couldn't open file handle for $perfhome/tmp/perf.out: $!\n";

	flock(PERFOUT,LOCK_EX)
		or die "WARNING: Couldn't obtain exclusive lock on $perfhome/tmp/perf.out: $!\n";

	print PERFOUT "$perf_out\n";

	flock(PERFOUT, LOCK_UN)
		or die "WARNING: Couldn't release lock on $perfhome/tmp/perf.out: $!\n";

	close(PERFOUT);

	$fsCount ++;
}

# Send Totals
if ("$totalFsUsed" != "0") {
	$totalFsUsed=$totalFsUsed / $fsCount;
}
if ("$totalFsFree" != "0") {
	$totalFsFree=$totalFsFree / $fsCount;
}

my $perf_out="$os data fs Total $totalFsUsed $totalFsFree";

open(PERFOUT, ">> $perfhome/tmp/perf.out")
       	or die "WARNING: Couldn't open file handle for $perfhome/tmp/perf.out: $!\n";

flock(PERFOUT,LOCK_EX)
	or die "WARNING: Couldn't obtain exclusive lock on $perfhome/tmp/perf.out: $!\n";

print PERFOUT "$perf_out\n";

flock(PERFOUT, LOCK_UN)
	or die "WARNING: Couldn't release lock on $perfhome/tmp/perf.out: $!\n";

close(PERFOUT);
