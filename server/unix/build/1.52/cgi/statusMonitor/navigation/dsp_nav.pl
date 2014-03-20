use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link type=\"text/css\" rel=\"stylesheet\" href=\"../../perfStatResources/styleSheets/navigationFrame.css\">\n");
print("		<script language=\"javascript\" src=\"../../perfStatResources/javaScripts/navigationFrame.js\"></script>\n");
print("	</head>\n");
print("	<body onLoad=\"onBodyLoad('status');\">\n");
 if ($sessionObj->param("userName") eq "perfstat" || $sessionObj->param("role") eq "admin") {
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
 if ($sessionObj->param("userName") eq "perfstat") {
print("			<tr>\n");
print("				<form action=\"index.pl\" method=\"post\">\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"right\"><span class=\"table1Text1\">Admin:</span></td>\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"left\">\n");
print("					<select name=\"adminName\" size=\"1\" onChange=\"submit();\">\n");
 foreach my $adminNameTemp (sort (keys(%$adminList))) {
my $formula0=$adminNameTemp;my $formula1=$adminNameTemp eq $sessionObj->param("selectedAdmin") ? "selected" : "";;my $formula2=$adminNameTemp;print("						<option value=\"$formula0\" $formula1>$formula2</option>\n");
 }
print("					</select>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
}
 if ($sessionObj->param("role") eq "admin") {
print("			<tr>\n");
print("				<form action=\"index.pl\" method=\"post\">\n");
my $formula3=$sessionObj->param("selectedAdmin");print("				<input type=\"hidden\" name=\"adminName\" value=\"$formula3\">\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"right\"><span class=\"table1Text1\">User:</span></td>\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"left\">\n");
print("					<select name=\"userName\" size=\"1\" onChange=\"submit();\">\n");
 foreach my $userNameTemp (sort (keys(%$userList))) {
my $formula4=$userNameTemp;my $formula5=$userNameTemp eq $sessionObj->param("selectedUser")  ? "selected" : "";;my $formula6=$userNameTemp;print("						<option value=\"$formula4\" $formula5>$formula6</option>\n");
 }
print("					</select>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
}
print("		</table>\n");
}
print("		<table border=\"0\" align=\"center\" cellpadding=\"3\" cellspacing=\"1\" class=\"table1\" width=\"100%\">\n");
print("		<tr> \n");
print("			<td height=\"25\" class=\"header\">Status Monitor</td>\n");
print("		</tr>\n");
print("		<tr> \n");
print("			<td height=\"25\" class=\"subheader\">\n");
print("				<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"table2\" align=\"center\">\n");
print("					<tr>\n");
print("						<td nowrap><a href=\"javascript:openAll();\">open all</a></td>\n");
print("						<td nowrap><img src=\"../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"10\" border=\"0\"></td>\n");
print("						<td nowrap><a href=\"javascript:closeAll();\">close all</a></td>\n");
print("					</tr>\n");
print("				</table>\n");
print("			</td>\n");
print("		</tr>\n");
print("		<tr>\n");
print("			<td align=\"left\" valign=\"top\">\n");
print("				<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("					<tr>\n");
print("						<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor2.gif\" border=\"0\"></td>\n");
print("						<td nowrap><a id=\"serverStatus\" href=\"../serverStatus/index.pl?hostGroupID=allHosts\" target=\"content\">Perfstat Server</a></td>\n");
print("					</tr>\n");
print("					<tr>\n");
print("						<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor1.gif\" border=\"0\"></td>\n");
print("						<td nowrap><a id=\"myHostGroups\" href=\"index.pl?groupViewStatus=self\">My Host Groups</a></td>\n");
print("					</tr>\n");
print("					<tr>\n");
print("						<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor1.gif\" border=\"0\"></td>\n");
print("						<td nowrap><a id=\"sharedHostGroups\" href=\"index.pl?groupViewStatus=shared\">Shared Host Groups</a></td>\n");
print("					</tr>\n");
print("				</table>\n");
print("			</td>\n");
print("		</tr>\n");
print("			<tr>\n");
print("			<td align=\"left\" valign=\"top\">\n");
print("				<div id=\"navContainer\" style=\"margin-left:5px\">\n");
foreach my $hostGroupDescHash (@$hostGroupArray) {
my $hasHosts = $hostGroupDescHash->{'hasHosts'};
my $hgOwner = $hostGroupDescHash->{'hostGroupOwner'};
my $hostGroupID = $hostGroupDescHash->{'hostGroupID'};
print("				<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("					<tr>\n");
print("						<td>\n");
 if ($hasHosts == 0) {
print("							<img src=\"../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\">\n");
 } else {
my $formula7=$hostGroupID;my $formula8=$hostGroupID;my $formula9=$hostGroupID;print("							<a id=\"x$formula7\" href=\"javascript:Toggle('$formula8');\"><img name=\"x$formula9\" src=\"../../perfStatResources/images/navigation/icon_plusNavBar.gif\" border=\"0\"></a>\n");
 }
print("						</td>\n");
print("						<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor1.gif\" border=\"0\"></td>\n");
print("						<td>\n");
 if ($hasHosts == 0) {
my $formula10=$hostGroupID;print("								$formula10\n");
} else {
my $formula11=$hgOwner;my $formula12=$hostGroupID;my $formula13=$hostGroupID;my $formula14=$hostGroupID;print("							<a target=\"content\" href=\"../clientStatus/level2/index.pl?hgOwner=$formula11&hostGroupID=$formula12\" onClick=\"Toggle('$formula13');\">$formula14</a>\n");
}
print("						</td>\n");
print("					</tr>\n");
print("				</table>\n");
 if ($hasHosts != 0) {
my $formula15=$hostGroupID;print("				<div id=\"$formula15\" style=\"display:none; margin-left:1em\">\n");
my $hostGroupMemberHash = $hostGroupDescHash->{'hostGroupMemberHash'};
foreach my $hostGroupMember (sort(keys(%$hostGroupMemberHash))) {
my $hostDescHash = $hostGroupMemberHash->{$hostGroupMember};
my $hasServices = $hostDescHash->{'hasServices'};
print("				<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("					<tr>\n");
print("						<td>\n");
if ($hasServices == 0) {
print("							<img src=\"../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\">\n");
} else {
my $formula16=$hostGroupID;my $formula17=$hostGroupMember;my $formula18=$hostGroupID;my $formula19=$hostGroupMember;my $formula20=$hostGroupID;my $formula21=$hostGroupMember;print("							<a id=\"x$formula16^$formula17\" href=\"javascript:Toggle('$formula18^$formula19');\"><img name=\"x$formula20^$formula21\" src=\"../../perfStatResources/images/navigation/icon_plusNavBar.gif\" border=\"0\"></a>\n");
}
print("						</td>\n");
print("						<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor2.gif\" border=\"0\"></td>\n");
print("						<td nowrap>\n");
if ($hasServices == 0) {
my $formula22=$hostGroupMember;print("							$formula22\n");
} else {
my $formula23=$hostGroupID;my $formula24=$hostGroupMember;my $formula25=$hostGroupID;my $formula26=$hostGroupMember;my $formula27=$hostGroupMember;print("							<a target=\"content\" href=\"../clientStatus/level3/index.pl?hostGroupID=$formula23&hostName=$formula24\" onClick=\"Toggle('$formula25^$formula26');\">$formula27</a>\n");
}
print("						</td>\n");
print("					</tr>\n");
print("				</table>\n");
 if ($hasServices != 0) {
my $formula28=$hostGroupID;my $formula29=$hostGroupMember;print("				<div id=\"$formula28^$formula29\" style=\"display:none; margin-left:12px;\">\n");
my $serviceHashRefined = $hostDescHash->{'serviceHash'};
foreach my $serviceHashRefinedKey (sort(keys(%$serviceHashRefined))) {
my $serviceDescHash = $serviceHashRefined->{$serviceHashRefinedKey};
 if ($serviceDescHash->{'hasSubService'} != 1) {
print("				<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("					<tr>\n");
print("						<td><img src=\"../../perfStatResources/images/common/spacer.gif\" height=\"10\" width=\"9\" border=\"0\"></td>\n");
print("						<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor3.gif\" border=\"0\"></td>\n");
my $formula30=$hostGroupID;my $formula31=$hostGroupMember;my $formula32=$serviceHashRefinedKey;my $formula33=$serviceHashRefinedKey;print("						<td><a target=\"content\" href=\"../clientStatus/level3/index.pl?hostGroupID=$formula30&hostName=$formula31&serviceName=$formula32\">$formula33</a></td>\n");
print("					</tr>\n");
print("				</table>\n");
 } else {
my $subServiceHash = $serviceDescHash->{'subServiceHash'};
my @list = sort(keys(%$subServiceHash));
print("				<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("					<tr>\n");
my $formula34=$hostGroupID;my $formula35=$hostGroupMember;my $formula36=$serviceHashRefinedKey;my $formula37=$hostGroupID;my $formula38=$hostGroupMember;my $formula39=$serviceHashRefinedKey;my $formula40=$hostGroupID;my $formula41=$hostGroupMember;my $formula42=$serviceHashRefinedKey;print("						<td><a id=\"x$formula34^$formula35^$formula36\" href=\"javascript:Toggle('$formula37^$formula38^$formula39');\"><img name=\"x$formula40^$formula41^$formula42\" src=\"../../perfStatResources/images/navigation/icon_plusNavBar.gif\" border=\"0\"></a></td>\n");
print("						<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor3.gif\" border=\"0\"></td>\n");
my $formula43=$hostGroupID;my $formula44=$hostGroupMember;my $formula45=$serviceHashRefinedKey;my $formula46=$list[0];my $formula47=$hostGroupID;my $formula48=$hostGroupMember;my $formula49=$serviceHashRefinedKey;my $formula50=$serviceHashRefinedKey;print("						<td nowrap><a target=\"content\" href=\"../clientStatus/level3/index.pl?hostGroupID=$formula43&hostName=$formula44&serviceName=$formula45.$formula46\" onClick=\"Toggle('$formula47^$formula48^$formula49');\">$formula50</a></td>\n");
print("					</tr>\n");
print("				</table>\n");
my $formula51=$hostGroupID;my $formula52=$hostGroupMember;my $formula53=$serviceHashRefinedKey;print("				<div id=\"$formula51^$formula52^$formula53\" style=\"display:none; margin-left:12px;\">\n");
foreach my $subServiceHashKey (sort(keys(%$subServiceHash))) {
print("				<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("					<tr>\n");
print("						<td><img src=\"../../perfStatResources/images/common/spacer.gif\" height=\"10\" width=\"9\" border=\"0\"></td>\n");
print("						<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor3.gif\" border=\"0\"></td>\n");
my $formula54=$hostGroupID;my $formula55=$hostGroupMember;my $formula56=$serviceHashRefinedKey;my $formula57=$subServiceHashKey;my $formula58=$subServiceHashKey;print("						<td><a href=\"../clientStatus/level3/index.pl?hostGroupID=$formula54&hostName=$formula55&serviceName=$formula56.$formula57\" target=\"content\">$formula58</a></td>\n");
print("					</tr>\n");
print("				</table>\n");
}
print("				</div>\n");
}
}
print("				</div>\n");
}
}
print("				</div>\n");
}
}
print("				</div>\n");
print("			</td>\n");
print("		</tr>\n");
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
