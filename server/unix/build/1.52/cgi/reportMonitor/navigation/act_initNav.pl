use strict;
package main;

$userIndex = setUserIndex();	
# Login is perfstat admin
if ($sessionObj->param("userName") eq "perfstat") {
	####
	if (defined($request->param('adminName'))) {
		if ($request->param('adminName') ne $sessionObj->param("selectedAdmin")) {
			checkAdminName($request->param('adminName'));
			$sessionObj->param("selectedAdmin", $request->param('adminName'));
			$sessionObj->param("selectedUser", $request->param('adminName'));
		}
	}
	####
	if (defined($request->param('userName'))) {
		if ($request->param('userName') ne $sessionObj->param("selectedUser")) {
			checkUserName($sessionObj->param("selectedAdmin"), $request->param('userName'));
			$sessionObj->param("selectedUser", $request->param('userName'));
		}
	}

	#define list of admin
	$adminList = $userIndex;
	#define list of users
	$userList = $userIndex->{$sessionObj->param("selectedAdmin")};

# Login is group admin
} elsif ($sessionObj->param("role") eq "admin") {
	###
	if (defined($request->param('userName'))) {
		if ($request->param('userName') ne $sessionObj->param("selectedUser")) {
			checkUserName($sessionObj->param("selectedAdmin"), $request->param('userName'));
			$sessionObj->param("selectedUser", $request->param('userName'));
		}
	}
	#define list of users
	$userList = $userIndex->{$sessionObj->param("selectedAdmin")};

# Login is user
} else {
	# do nothing
}

if (defined($request->param('groupViewStatus'))) {
	if ($request->param('groupViewStatus') ne $sessionObj->param("groupViewStatus")) {
		$sessionObj->param("groupViewStatus", $request->param('groupViewStatus'));
	}
}

# Define AdminName and hostGroupOwner
$adminName = $sessionObj->param("selectedAdmin");
$userName = $sessionObj->param("selectedUser");

if ($sessionObj->param("groupViewStatus") ne "shared") {
	#define array of  "My Reports" to list
	my $user2Report = lock_retrieve("$perfhome/var/db/mappings/user2Report.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2Report.ser");
	my $myReports = $user2Report->{$adminName}->{$userName}->{$userName};

	$reportArray = [];
	foreach my $reportName (sort(keys(%$myReports))) {
		my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportName.ser");
		my $tempArray = [];
		$tempArray->[0] = $userName;
		$tempArray->[1] = $reportName;
		push(@$reportArray, $tempArray)
	}
} else {
	#define array of "Shared Reports" to list
	my $user2Report = lock_retrieve("$perfhome/var/db/mappings/user2Report.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2Report.ser");
	my $ownerList = $user2Report->{$adminName};

	$reportArray = [];
	foreach my $owner (keys(%$ownerList)) {
		if ($owner ne $userName) {
			my $userList = $ownerList->{$owner};
			foreach my $user (keys(%$userList)) {
				if ($user eq $userName) {
					my $reportNameList = $userList->{$user};
					foreach my $reportName (keys(%$reportNameList)) {
						my $reportObject = lock_retrieve("$perfhome/var/db/users/$owner/reports/$reportName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$owner/reports/$reportName.ser");
						my $tempArray = [];
						$tempArray->[0] = $owner;
						$tempArray->[1] = $reportName;
						push(@$reportArray, $tempArray)
					}
				}	
			}
		}
	}
}

if (!defined($request->param('stopOnBodyLoad'))) {
	$doOnBodyLoad="report";
} else {
	$doOnBodyLoad="null";
}

1;