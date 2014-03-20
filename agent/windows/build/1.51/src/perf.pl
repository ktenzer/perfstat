use IO::Socket qw(:DEFAULT :crlf);
use POSIX qw(uname);
my $os = (uname)[0];
$os =~ s/ //g;

# Slurp in path to Perfhome
my $perfhome=&PATH;
$perfhome =~ s/\\bin//;

# Slurp in Configuration
my %conf       = ();
&GetConfiguration(\%conf);

# Set Environment Variables from %conf
foreach my $key (keys %conf) {
        $ENV{$key}="$conf{$key}";
}

# Log all alerts and warnings to the below logfile
use CGI::Carp qw(carpout);
my $logfile = "$perfhome/var/perfctl.log";
open(LOGFILE, ">> $logfile")
    or die "Unable to append to $logfile: $!\n";
carpout(*LOGFILE);

@ARGV == 2 or &Usage;
my ($server, $line) = @ARGV or &Usage;
unless ($server =~ m/(\d*\.\d*\.\d*\.\d*)/)  {
	die "Arguments '$server' has invalid characters.\n";
}
$server = "$1";

&send_data;

sub send_data {
my $socket = IO::Socket::INET->new( Proto    => "tcp",
				    PeerAddr => "$server",
				    PeerPort => $ENV{'CLIENTPORT'},
				    Timeout  => 5)
	or die "Cannot Connect to $server: $! ";

$line = "$os $line";

warn "DEBUG: Sending \"$line\" to $server $ENV{'CLIENTPORT'}\n" if $ENV{'DEBUG'};

print $socket "$line";

close $socket;

}

# Get configuration dynamically from perf-conf
sub GetConfiguration {

  my $configfile="$perfhome/etc/perf-conf";
  my $hashref = shift;

 	open(FILE, $configfile)
    or die "Couldn't open FileHandle for $configfile: $!\n";

  my @data=<FILE>;
  foreach $line (@data) {

    # Skip line if commented out
    next if ($line =~ m/^#/);
    $line =~ m/(\w+)\s*=\s*(.+)/;
    my $key=$1;
    my $value=$2;

    if ($value =~ m/ /) {
      @metrics=split(/\s+/, $value);
    } else {
      $hashref->{$key}=$value;
    }
  }
  close(FILE);
}

# Get path to perfctl executable
sub PATH {
  my $path = PerlApp::exe();
 	$path =~ s/[\w\d]+\.exe//;
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
