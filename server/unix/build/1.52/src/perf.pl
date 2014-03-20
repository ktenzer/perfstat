#!/usr/local/ActivePerl-5.8/bin/perl
# PerfStat Client Program

use IO::Socket qw(:DEFAULT :crlf);
use CGI::Carp qw(carpout);

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

@ARGV == 2 or &Usage;
my ($server, $line) = @ARGV or &Usage;
unless ($server =~ m/(\d*\.\d*\.\d*\.\d*)/)  {
	die "ERROR: Arguments '$server' has invalid characters.\n";
}
$server = "$1";

&SendData;

sub SendData {
	my $socket = IO::Socket::INET->new( Proto    => "tcp",
				    	    PeerAddr => "$server",
				    	    PeerPort => $ENV{'CLIENTPORT'},
				    	    Timeout  => 5)
		or die "ERROR: Cannot Connect to $server: $! ";

	$line = "$line";
	print $socket "$line";

	warn "DEBUG: Sending \"$line\" to $server $ENV{'CLIENTPORT'}\n" if ($ENV{'DEBUG'});

	close $socket;
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

# Get path to perf executable
sub PATH {
  my $path = PerlApp::exe();
	$path =~ s/\/\w*$//;
        return $path;
}

# Print Usage information
sub Usage {
print STDOUT <<EOF;
perf: incorrect number of arguments
Format: $0 IP-ADDR "DATA"
EOF
exit(1);
}
