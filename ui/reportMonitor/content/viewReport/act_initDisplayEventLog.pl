use strict;
package main;

my $reportNameID = $request->param('reportNameID');
my $hostGroupID = $request->param('hostGroupID');

my $hostName = $request->param('hostName');
my $serviceName = $request->param('serviceName');
my $file="$perfhome/var/events/$hostName/$serviceName.log";

# Open perf out file and obtain lock
open(FILE, "< $file")
        or warn "ERROR: Couldn't open file handle to $file: $!\n";

flock(FILE, 1)
        or warn "ERROR: Couldn't obtain shared lock for $file: $!\n";

$logData = [];
# Slurp in contents of file to data
while (<FILE>) {
        push(@$logData, $_);
}

close(FILE);

1;