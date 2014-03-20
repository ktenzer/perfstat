use strict;
package main;

# Define AdminName and hostGroupOwner
$adminName = $sessionObj->param("selectedAdmin");
$userName = $sessionObj->param("selectedUser");

if( defined($request->param('updateNav'))) {
	$updateNav = "updateNavigation();"
} else {
	$updateNav = "";
}

# Define navLinkChosen (myReports or sharedReports)
if ($sessionObj->param("groupViewStatus") ne "shared") {
	$navLinkChosen = "myHostGroups";
} else {
	$navLinkChosen = "sharedHostGroups";
}

if ($sessionObj->param("groupViewStatus") ne "shared") {
	#define array of  "My Reports" to list
	my $user2Report = lock_retrieve("$perfhome/var/db/mappings/user2Report.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2Report.ser");
	my $myReports = $user2Report->{$adminName}->{$userName}->{$userName};

	$myReportArray = [];
	foreach my $reportName (sort(keys(%$myReports))) {
		my $reportObject = lock_retrieve("$perfhome/var/db/users/$userName/reports/$reportName.ser") or die("Could not lock_retrieve from $perfhome/var/db/users/$userName/reports/$reportName.ser");
		my $tempArray = [];
		$tempArray->[0] = $reportName;
		$tempArray->[1] = $reportObject->getDescription();
		push(@$myReportArray, $tempArray)
	}
} else {
	#define array of "Shared Reports" to list
	my $user2Report = lock_retrieve("$perfhome/var/db/mappings/user2Report.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/user2Report.ser");
	my $ownerList = $user2Report->{$adminName};

	$sharedReportArray = [];
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
						$tempArray->[2] = $reportObject->getDescription();
						push(@$sharedReportArray, $tempArray)
					}
				}	
			}
		}
	}
}

if (defined($request->param("reportName"))) {
	$reportName = $request->param("reportName");
} else {
	$reportName = ""
}
if (defined($request->param("description"))) {
	$description = $request->param("description");
} else {
	$description = ""
}

1;