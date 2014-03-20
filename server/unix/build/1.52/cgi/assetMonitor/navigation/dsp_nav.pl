use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link type=\"text/css\" rel=\"stylesheet\" href=\"../../perfStatResources/styleSheets/navigationFrame.css\">\n");
print("		<script language=\"javascript\" src=\"../../perfStatResources/javaScripts/navigationFrame.js\"></script>\n");
print("	</head>\n");
print("	<body onLoad=\"onBodyLoad('asset');\">\n");
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
print("			<td height=\"25\" class=\"header\">Asset Monitor</td>\n");
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
print("						<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor1.gif\" border=\"0\"></td>\n");
print("						<td nowrap><a id=\"myHostGroups\" href=\"index.pl?groupViewStatus=self\">My HostGroups</a></td>\n");
print("					</tr>\n");
print("					<tr>\n");
print("						<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor1.gif\" border=\"0\"></td>\n");
print("						<td nowrap><a id=\"sharedHostGroups\" href=\"index.pl?groupViewStatus=shared\">Shared HostGroups</a></td>\n");
print("					</tr>\n");
print("				</table>\n");
print("			</td>\n");
print("		</tr>\n");
print("		<tr>\n");
print("			<td align=\"left\" valign=\"top\">\n");
print("				<div id=\"navContainer\" style=\"margin-left:5px\">\n");
foreach my $hostGroupDescHash (@$hostGroupArray) {
my $hasHosts = $hostGroupDescHash->{'hasHosts'};
my $hgOwner = $hostGroupDescHash->{'hostGroupOwner'};
my $hostGroupID = $hostGroupDescHash->{'hostGroupID'};
print("					<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("						<tr>\n");
print("							<td>\n");
 if ($hasHosts == 0) {
print("								<img src=\"../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\">\n");
 } else {
my $formula7=$hostGroupID;my $formula8=$hostGroupID;my $formula9=$hostGroupID;print("								<a id=\"x$formula7\" href=\"javascript:Toggle('$formula8');\"><img name=\"x$formula9\" src=\"../../perfStatResources/images/navigation/icon_plusNavBar.gif\" border=\"0\"></a>\n");
 }
print("							</td>\n");
print("							<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor1.gif\" border=\"0\"></td>\n");
print("							<td>\n");
 if ($hasHosts == 0) {
my $formula10=$hostGroupID;print("									$formula10\n");
} else {
my $formula11=$hostGroupID;my $formula12=$hostGroupID;print("								<a href=\"javascript:Toggle('$formula11');\">$formula12</a>\n");
}
print("							</td>\n");
print("						</tr>\n");
print("					</table>\n");
 if ($hasHosts != 0) {
my $formula13=$hostGroupID;print("					<div id=\"$formula13\" style=\"display:none; margin-left:1em\">\n");
my $hostGroupMemberHash = $hostGroupDescHash->{'hostGroupMemberHash'};
foreach my $hostGroupMember (sort(keys(%$hostGroupMemberHash))) {
print("						<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("							<tr>\n");
print("								<td><img src=\"../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("								<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor2.gif\" border=\"0\"></td>\n");
my $formula14=URLEncode($hgOwner);my $formula15=URLEncode($hostGroupID);my $formula16=$hostGroupMember;my $formula17=$hostGroupMember;print("								<td nowrap><a target=\"content\" href=\"../content/detailView/index.pl?hgOwner=$formula14&hostGroupID=$formula15&hostName=$formula16\">$formula17</a></td>\n");
print("							</tr>\n");
print("						</table>\n");
}
print("					</div>\n");
}
}
print("				</div>\n");
print("			</td>\n");
print("		</tr>\n");
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
