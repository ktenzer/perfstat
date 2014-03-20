# Gather CPU Metrics

use CGI::Carp qw(carpout);
use POSIX qw(uname);
use Sys::Load qw(getload);
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
my $service="cpu";
my $os = (uname)[0];

# Metrics to collect
@metrics=qw(UsrPct SysPct IdlPct Load60sec Load5min Load15min);

# Collect all cpu data
&VMSTAT;
&UPTIME;

# Collect cpu utilization statistics
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
	$data =~ m/(\S+)\s+(\S+)\s+(\S+)\s+\S+\s+$/;
	$UsrPct="$1"; $SysPct="$2"; $IdlPct="$3";
}

# Collect cpu load statistics
sub UPTIME {

	$Load60sec=(getload())[0];
	$Load5min=(getload())[1];
	$Load15min=(getload())[2];

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
$perf_out="$os data $service $UsrPct $SysPct $IdlPct $Load60sec $Load5min $Load15min";

open(PERFOUT, ">> $perfhome/tmp/perf.out")
	or die "WARNING: Couldn't open file handle for $perfhome/tmp/perf.out: $!\n";

flock(PERFOUT, LOCK_EX)
	or die "WARNING: Couldn't obtain exclusive lock on $perfhome/tmp/perf.out: $!\n";

print PERFOUT "$perf_out\n";

close (PERFOUT);
