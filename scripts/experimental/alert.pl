#!/usr/local/ActivePerl-5.8/bin/perl

use CGI::Carp qw(carpout);
use Mail::SendEasy;

$ppid=$$;

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

# Check to see if alert process is already running
if (-f "$perfhome/tmp/alert.pid") {
        open(PID, "$perfhome/tmp/alert.pid")
                or die "ERROR: Couldn't open file $perfhome/tmp/alert.pid: $!\n";
        $oldPID=<PID>;
        chomp $oldPID;
        close (PID);

        if (kill 0 => $oldPID) {
                $pidUser=`$ENV{'PS_CMD'} -f $oldPID |$ENV{'TAIL_CMD'} -1`;
                $pidUser =~ m/(\S+)\s+/;
                $pidUser=$1;

                if ($pidUser =~ m/$ENV{'USER'}/) {
                        warn "INFO: A alert process is already running under PID $oldPID, aborting!\n";
                        warn "INFO: PidUser: $pidUser USER: $ENV{'USER'}\n";
                        exit(1);
                }
        }
}

# Save PID in file
open(PID, "> $perfhome/tmp/alert.pid")
        or die "ERROR: Couldn't open file $perfhome/tmp/alert.pid: $!\n";
print PID "$ppid\n";
close (PID);

&ParseMail;

sub ParseMail {

	opendir(MAILDIR1, "$perfhome/var/alerts")
                	or die("ERROR: Couldn't open dir $perfhome/var/alerts: $!\n");

	while ($hostName = readdir(MAILDIR1)) {
		if ($hostName ne "." && $hostName ne "..") {

			opendir(MAILDIR2, "$perfhome/var/alerts/$hostName")
				or die("ERROR: Couldn't open dir $perfhome/var/alerts/$hostName: $!\n");
			while ($file = readdir(MAILDIR2)) {
				if ($file ne "." && $file ne "..") {
					$file =~ m/(\S+)\.(\S+)\.(\S+)/;
					$serviceName=$1;
					$metricName=$2;
					$alert=$3;

					open(FILE, "$perfhome/var/alerts/$hostName/$file")
						or die("ERROR: Couldn't open file $perfhome/var/alerts/$hostName/$file: $!\n");

					# Get email list
					@data=<FILE>;
					$emailData=@data[0];
					chomp $emailData;

					$msgData=@data[1];
					chomp $msgData;

					close(FILE);
					&SEND_ALERT($hostName,$serviceName,$metricName,$alert,$emailData,$msgData);
				}
			}
			close(MAILDIR2);
		}
	}
	closedir(MAILDIR1);
}

# Send alerts to email or pager via smtp
sub SEND_ALERT {

	my $hostName=shift;
	my $serviceName=shift;
	my $metricName=shift;
	my $alert=shift;
	my $emailData=shift;
	my $message=shift;

	# Remove comma(s) from email list
	my @emails=split(",", $emailData);

	my $sendMail = Mail::SendEasy::send(
       		smtp	=> "$ENV{'SMTP_SERVER'}",
       		from	=> "$ENV{'EMAIL_FROM'}",
       		to	=> "@emails",
       		subject	=> "$alert: $hostName: $serviceName: $metricName",
       		msg	=> "$message",
	);

	# Test for error condition otherwise remove alert file
	if (!$sendMail) {
		$error=Mail::SendEasy::error;
		chomp $error;

		warn "ERROR: SMTP $error\n";
	} else {
		warn "DEBUG: Alert $alert:$hostName:$serviceName:$metricName sent\n" if ($ENV{'DEBUG'});

		unlink "$perfhome/var/alerts/$hostName/$serviceName.$metricName.$alert"
			or die "WARN: Couldn't remove file $perfhome/var/alerts/$hostName/$serviceName.$metricName.$alert: $!\n";
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

                if ($key =~ m/^METRICS/) {
                        @services=split(/\s+/, $value);
                } else {
                        $hashref->{$key}=$value;
                }
        }
        close(FILE);
}

# Get path to perfctl executable
sub PATH {
        my $path = PerlApp::exe();
        $path =~ s/\/\w*$//;
        return $path;
}
