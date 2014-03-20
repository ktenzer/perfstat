#!/usr/local/ActivePerl-5.8/bin/perl

my $perfhome="/perfstat/dev/1.52/server";

use lib "/perfstat/dev/1.52/server/lib/RRD";
use CGI::Carp qw(carpout);
use RRDs;

# Log all alerts and warnings to the below logfile
my $logfile = "$perfhome/var/logs/perfd.log";
open(LOGFILE, ">> $logfile")
        or die "ERROR: Unable to append to $logfile: $!\n";
carpout(*LOGFILE);

# Define Global Variables
my $host=();
my $service=();
my $metricData=();
my $RRA=();
my $DS=();
my $rrdStep=();

# Parse RRD Data
my $buffer=join(" ",@ARGV);
#print "test: $buffer\n";

my @data=split(",",$buffer);

$rrdAction=@data[0];

if ($rrdAction =~ m/^new/) {
	$host=@data[1];
	$service=@data[2];
	$rrdStep=@data[3];
	$DS=@data[4];
	$RRA=@data[5];
	
	#warn "new: host:$host service:$service DS:$DS RRA: $RRA\n";
	&RRD;
} elsif ($rrdAction =~ m/^update/) {
	$host=@data[1];
	$service=@data[2];
	$metricData=@data[3];
	#@metricData=split(" ", @data[3]);

	#warn "update: host:$host service:$service data:@metricData\n";
	&RRD;
} else {
	warn "ERROR: RRD Failure, data is mungled: $!\n";
	exit(1);
}

# Create RRD Databases from client data
sub RRD {

        my $RRD="$perfhome/rrd/$host/$host.$service.rrd";

        warn "DEBUG: RRD File $RRD\n" if ($ENV{'DEBUG'});

        # If RRD doesn't exist then create one
        if ( ! -f "$RRD" ) {

                my @rras = split " ",$RRA;
		my @ds = split " ",$DS;

                RRDs::create($RRD,"--step",$rrdStep,@ds,@rras);
                my $ERROR=RRDs::error;
                if($ERROR) {
                        warn "ERROR: creating $RRD: $ERROR\n";
                        exit(1);

                }
                warn "INFO: did not find $RRD, RRD Created\n";

        } else {

                # Update already existing RRD with current time
                my $rrdtime="N";
                my $rrdupdate="$rrdtime";

                $rrdupdate = "$rrdupdate:$metricData";

                warn "DEBUG: rrdupdate = $rrdupdate\n" if ($ENV{'DEBUG'});

                # If RRD already exists, update it with new data
                RRDs::update("$RRD","$rrdupdate");
                my $ERROR=RRDs::error;
                if($ERROR) {
                        warn "ERROR: updating $RRD: $ERROR\n";
                }

        }
}
