#!/usr/local/ActivePerl-5.8/bin/perl
# Gather Uptime Metrics

use CGI::Carp qw(carpout);
use POSIX qw(uname);
use Sys::Load qw(uptime);
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
my $service="uptime";
my $os = (uname)[0];

# Metrics to collect
@metrics=qw(uptimeHour);

# Collect uptime data
$uptimeSec=int uptime();

# Calculate uptime data
$uptimeMin=$uptimeSec / 60;
$uptimeHour=$uptimeMin / 60;
$uptimeHour=sprintf("%.2f",$uptimeHour);
$uptimeDay=$uptimeHour / 24;
$uptimeDay=sprintf("%.2f",$uptimeDay);

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
$perf_out="$os data $service $uptimeDay";

open(PERFOUT, ">> $perfhome/tmp/perf.out")
        or die "WARNING: Couldn't open file handle for $perfhome/tmp/perf.out: $!\n";

flock(PERFOUT, LOCK_EX)
        or die "WARNING: Couldn't obtain exclusive lock on $perfhome/tmp/perf.out: $!\n";

print PERFOUT "$perf_out\n";

close (PERFOUT);
