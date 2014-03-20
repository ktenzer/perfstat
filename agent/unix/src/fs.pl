# Gather File System Metrics

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
&GetInodes;
	
# Gather Data
sub GetFS {

	open(FS, "$ENV{'DF_CMD'} -T -k|")
        	or die "ERROR: Couldn't open File Handle for $ENV{'DF_CMD'}: $!\n";
	my @df=<FS>;
	close (FS);

	foreach $line (@df) {
		next if ($line =~ m/Filesystem/);
		next if ($line !~ m/ext|vxfs/);

		if ($line =~ m/vxfs/) {
			my $vxfs="1";
		}

		$line =~ m/(\d+)\%\s+(\S+)/;
		$fsName=$2;
		$fsUsedPct=$1;

		if ($fsName =~ m/\//) {
			if ($fsName eq "/") {
				$fsName="root";
			}
			$fsName =~ s/^\///g;
			$fsName =~ s/\//,/g;
		}
		if ($vxfs == "1") {
			@{$vxfs_h{$fsName}}=$fsUsedPct;
			undef $vxfs;
		} else {
			@{$fs_h{$fsName}}=$fsUsedPct;
		}
	}
}

# Get configuration dynamically from perf-conf
sub GetInodes {

	open(INODES, "$ENV{'DF_CMD'} -i|")
		or die "ERROR: Couldn't open File Handle for $ENV{'DF_CMD'}: $!\n";
	@inodes=<INODES>;
	close (INODES);

	foreach my $fsName (sort keys %fs_h) {
		foreach my $line (@inodes) {
			next if ($line =~ m/Filesystem/);

			if ($fsName eq "root") {
				next if ($line !~ m/\/$/);
			} else {
				next if ($line !~ m/$fsName$/);
			}

			$line =~ m/(\d+)\%\s+/;
			$inodeUsedPct=$1;
			unshift (@{$fs_h{$fsName}}, $inodeUsedPct);
		}
	}

        # Ensure data was found
        if (! defined @inodes) {
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

# Default DATA
foreach my $fsName (sort keys %fs_h) {
	$perf_out="$os data $service.default $fsName @{$fs_h{$fsName}}";

	open(PERFOUT, ">> $perfhome/tmp/perf.out")
        	or die "WARNING: Couldn't open file handle for $perfhome/tmp/perf.out: $!\n";

	flock(PERFOUT,LOCK_EX)
		or die "WARNING: Couldn't obtain exclusive lock on $perfhome/tmp/perf.out: $!\n";

	print PERFOUT "$perf_out\n";

	flock(PERFOUT, LOCK_UN)
		or die "WARNING: Couldn't release lock on $perfhome/tmp/perf.out: $!\n";

	close(PERFOUT);
}

# VXFS DATA
foreach my $fsName (sort keys %vxfs_h) {
	$perf_out="$os data $service $fsName @{$vxfs_h{$fsName}}";

	open(PERFOUT, ">> $perfhome/tmp/perf.out")
        	or die "WARNING: Couldn't open file handle for $perfhome/tmp/perf.out: $!\n";

	flock(PERFOUT,LOCK_EX)
		or die "WARNING: Couldn't obtain exclusive lock on $perfhome/tmp/perf.out: $!\n";

	print PERFOUT "$perf_out\n";

	flock(PERFOUT, LOCK_UN)
		or die "WARNING: Couldn't release lock on $perfhome/tmp/perf.out: $!\n";
	
	close(PERFOUT);
}
