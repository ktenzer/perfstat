use strict;
package main;

# Define time
if (defined($request->param('date'))) {
	$date = $request->param('date');
} else {
	$date = "";
}

# Define user
if (defined($request->param('user'))) {
	$user = $request->param('user');
} else {
	$user = "";
}

# Define description
if (defined($request->param('description'))) {
	$description = $request->param('description');
} else {
	$description = "";
}

$sessionObj->param('hgOwner', $sessionObj->param('selectedUser'));
if ($sessionObj->param("groupViewStatus") eq "shared") {
	$sessionObj->param("hgOwner", $request->param('hgOwner'));
}
checkAndSetHostGroupID(0);
checkAndSetHostName(0);

my $hostName = $sessionObj->param('hostName');
#define array of hosts to list
my $changeLog = lock_retrieve("$perfhome/var/logs/changelogs/$hostName.ser") or die("$perfhome/var/logs/changelogs/$hostName.ser");
my $changeLogIndex = $changeLog->{'index'};
$changeLogIndexLen = keys(%$changeLogIndex);
if ($changeLogIndexLen > 0) {
	$changeLogArray = [];
	foreach my $indexValue (sort timeSort (keys(%$changeLogIndex))) {
		my $valueArray = $changeLogIndex->{$indexValue};
		unshift(@$valueArray, $indexValue);
		push(@$changeLogArray, $valueArray);
	}
}

# -----------------------------------------------------------------------------------------time Sort
sub timeSort() {	
	my $valA = $changeLogIndex->{$a}->[0];
	my $valB = $changeLogIndex->{$b}->[0];
	return $valB cmp $valA;
}
1;