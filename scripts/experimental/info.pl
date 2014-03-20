#!/usr/local/ActivePerl-5.8/bin/perl
# Gather Host Info

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
my $service="info";
my $os = (uname)[0];

# Location of OS info
my $cpuInfo="/proc/cpuinfo";
my $memInfo="/proc/meminfo";
my $osInfo="/proc/version";

# Define variables
my $cpuNum=();
my $cpuModel=();
my $cpuSpeed=();
my $cpuHash=();
my $memTotal=();
my $swapTotal=();
my $osVersion=();
my $kernelVersion=();
my $patches=();

&CPUINFO;
&MEMINFO;
&OSINFO;
&PatchINFO;

# Gather cpu info
sub CPUINFO {

	open (CPUINFO,"$cpuInfo")
		or die "ERROR: couldn't open $cpuInfo: $!\n";

	my @data=<CPUINFO>;
	close (CPUINFO);

	$cpuNum=0;
	foreach my $line (@data) {

		if ($line =~ m/^processor/) {
			#$line =~ m/\S+\s+:\s+(\d*)/;
			#$cpuNum="$1";
			$cpuNum++;
		}	

		if ($line =~ m/^model\s+name/) {
			#$line =~ m/\S+\s+\S+\s+:\s+(.*)\s+CPU\s+(\S+)/;
			$line =~ m/\S+\s+\S+\s+:\s+(\S+)\s+(\S+).*\s+(\S+)/;
			$cpuModel="$1$2";
			$cpuSpeed="$3";
			$cpuSpeed=$cpuSpeed * 1000;

			if ($cpuModel =~ m/\s+/) {
				$cpuModel =~ s/\s+//g;
			}
			#$cpuHash{$cpuNum}="$cpuModel";
		}
	}

	# Gather MEM Info

	# Print Results
	#print "CPU Num: $cpuNum Model: $cpuModel Speed: $cpuSpeed\n";
	#foreach my $key (sort keys %cpuHash) {
		#print "key: $key value: $cpuHash{$key}\n";
	#}
}

sub MEMINFO {

        open (MEMINFO,"$memInfo")
               or die "ERROR: couldn't open $memInfo: $!\n";

        my @data=<MEMINFO>;
        close (MEMINFO);

        foreach my $line (@data) {

               if ($line =~ m/^MemTotal/) {
                       $line =~ m/\S+\s+(\d*)/;

                       $memTotal="$1";

		       $memTotal=int($memTotal / 1024);
               }

               if ($line =~ m/^SwapTotal/) {
                       $line =~ m/\S+\s+(\d*)/;

                       $swapTotal="$1";
               }

        }
	
	#print "mem: $memTotal swap: $swapTotal\n";
}

# Gather OS Info
sub OSINFO {

	open (OSINFO,"$osInfo")
		or die "ERROR: couldn't open $osInfo: $!\n";

	my $data=<OSINFO>;
	close(OSINFO);

	#$data =~ m/\S+\s+\S+\s+(\S+)\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)/;
	$data =~ m/\S+\s+\S+\s+(\S+).*\s+\((.*)\)\)/;

	$kernelVersion="$1";
	$osVersion="$2";
	$osVersion =~ s/ /_/g;

	#print "os: $osVersion kernel: $kernelVersion\n";

}

# Gather Patch Info
sub PatchINFO {

	open (PATCHINFO, "$ENV{'RPM_CMD'} -qg \"System Environment/Base\"|")
		or die "ERROR: Couldn't open file handle for $ENV{'RPM_CMD'} -qg \"System Environment/Base\": $!\n";

	my @patchesArray=<PATCHINFO>;
	chomp @patchesArray;

	close(PATCHINFO);

	$patches=join(",", @patchesArray);

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
$perf_out="$os info $cpuNum $cpuModel $cpuSpeed $memTotal $osVersion $kernelVersion $patches";
#$perf_out="$os info $cpuNum $cpuModel $cpuSpeed $memTotal $osVersion $kernelVersion";

#print "OUT: $perf_out\n";

open(PERFOUT, ">> $perfhome/tmp/perf.out")
	or die "WARNING: Couldn't open file handle for $perfhome/tmp/perf.out: $!\n";

flock(PERFOUT, LOCK_EX)
	or die "WARNING: Couldn't obtain exclusive lock on $perfhome/tmp/perf.out: $!\n";

print PERFOUT "$perf_out\n";

close (PERFOUT);
