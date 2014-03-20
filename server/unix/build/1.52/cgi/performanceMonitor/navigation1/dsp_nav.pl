use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link type=\"text/css\" rel=\"stylesheet\" href=\"../../perfStatResources/styleSheets/navigationFrame.css\">\n");
print("		<script language=\"javascript\" src=\"../../perfStatResources/javaScripts/navigationFrame.js\"></script>\n");
print("		<script language=\"javascript\" src=\"../../perfStatResources/javaScripts/pm.nav.js\"></script>\n");
print("	</head>\n");
print("	<body onLoad=\"onBodyLoad('performance1');\">\n");
 if ($sessionObj->param("userName") eq "perfstat" || $sessionObj->param("role") eq "admin") {
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
 if ($sessionObj->param("userName") eq "perfstat") {
print("			<tr>\n");
print("				<form action=\"index.pl\" method=\"post\">\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"right\"><span class=\"table1Text1\">Admin:</span></td>\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"left\">\n");
print("					<select name=\"adminName\" size=\"1\" onChange=\"submit();\">\n");
 foreach my $adminNameTemp (sort (keys(%$adminList))) {
my $formula0=$adminNameTemp;my $formula1=$adminNameTemp eq $sessionObj->param("selectedAdmin") ? "selected" : "";;my $formula2=$adminNameTemp;print("						<option value=\"$formula0\" $formula1>$formula2</option>\n");
 }
print("					</select>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
}
 if ($sessionObj->param("role") eq "admin") {
print("			<tr>\n");
print("				<form action=\"index.pl\" method=\"post\">\n");
my $formula3=$sessionObj->param("selectedAdmin");print("				<input type=\"hidden\" name=\"adminName\" value=\"$formula3\">\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"right\"><span class=\"table1Text1\">User:</span></td>\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"left\">\n");
print("					<select name=\"userName\" size=\"1\" onChange=\"submit();\">\n");
 foreach my $userNameTemp (sort (keys(%$userList))) {
my $formula4=$userNameTemp;my $formula5=$userNameTemp eq $sessionObj->param("selectedUser")  ? "selected" : "";;my $formula6=$userNameTemp;print("						<option value=\"$formula4\" $formula5>$formula6</option>\n");
 }
print("					</select>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
}
print("		</table>\n");
}
print("	<table border=\"0\" align=\"center\" cellpadding=\"3\" cellspacing=\"1\" class=\"table1\" width=\"100%\">\n");
print("		<tr> \n");
print("			<td height=\"25\" class=\"header\">Performance Monitor</td>\n");
print("		</tr>\n");
print("		<tr> \n");
print("			<td height=\"25\" class=\"subheader\">\n");
print("				<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"table2\" align=\"center\">\n");
print("					<tr>\n");
print("						<td nowrap><a href=\"javascript:openAll();\">open all</a></td>\n");
print("						<td nowrap><img src=\"../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"10\" border=\"0\"></td>\n");
print("						<td nowrap><a href=\"javascript:closeAll();\">close all</a></td>\n");
print("					</tr>\n");
print("				</table>\n");
print("			</td>\n");
print("		</tr>\n");
print("		<tr>\n");
print("			<td align=\"left\" valign=\"top\">\n");
print("				<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("					<tr>\n");
print("						<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor1.gif\" border=\"0\"></td>\n");
print("						<td nowrap><a id=\"myHostGroups\" href=\"index.pl?groupViewStatus=self\">My HostGroups</a></td>\n");
print("					</tr>\n");
print("					<tr>\n");
print("						<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor1.gif\" border=\"0\"></td>\n");
print("						<td nowrap><a id=\"sharedHostGroups\" href=\"index.pl?groupViewStatus=shared\">Shared HostGroups</a></td>\n");
print("					</tr>\n");
print("				</table>\n");
print("			</td>\n");
print("		</tr>\n");
print("		<tr>\n");
print("			<td align=\"left\" valign=\"top\">\n");
print("				<div id=\"navContainer\" style=\"margin-left:5px\">\n");
foreach my $hostGroupDescHash (@$hostGroupArray) {
my $hasHosts = $hostGroupDescHash->{'hasHosts'};
my $hostGroupID = $hostGroupDescHash->{'hostGroupID'};
print("				<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("					<tr>\n");
print("						<td>\n");
 if ($hasHosts == 0) {
print("							<img src=\"../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\">\n");
 } else {
my $formula7=$hostGroupID;my $formula8=$hostGroupID;my $formula9=$hostGroupID;print("							<a id=\"x$formula7\" href=\"javascript:Toggle('$formula8');\"><img name=\"x$formula9\" src=\"../../perfStatResources/images/navigation/icon_plusNavBar.gif\" border=\"0\"></a>\n");
 }
print("						</td>\n");
print("						<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor1.gif\" border=\"0\"></td>\n");
print("						<td>\n");
 if ($hasHosts == 0) {
my $formula10=$hostGroupID;print("								$formula10\n");
} else {
my $formula11=$hostGroupID;my $formula12=$hostGroupID;my $formula13=$hostGroupID;print("							<a id=\"x$formula11\" href=\"javascript:Toggle('$formula12');\">$formula13</a>\n");
}
print("						</td>\n");
print("					</tr>\n");
print("				</table>\n");
 if ($hasHosts != 0) {
my $formula14=$hostGroupID;print("				<div id=\"$formula14\" style=\"display:none; margin-left:1em\">\n");
foreach my $serviceName (sort(keys(%$serviceHash))) {
print("					<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("						<tr>\n");
my $formula15=$hostGroupID;my $formula16=$serviceName;my $formula17=$hostGroupID;my $formula18=$serviceName;my $formula19=$hostGroupID;my $formula20=$serviceName;print("							<td><a id=\"x$formula15^$formula16\" href=\"javascript:Toggle('$formula17^$formula18');\"><img name=\"x$formula19^$formula20\" src=\"../../perfStatResources/images/navigation/icon_plusNavBar.gif\" border=\"0\"></a></td>\n");
print("							<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor3.gif\" border=\"0\"></td>\n");
my $formula21=$hostGroupID;my $formula22=$serviceName;my $formula23=$hostGroupID;my $formula24=$serviceName;my $formula25=$serviceName;print("							<td><a id=\"x$formula21^$formula22\" href=\"javascript:Toggle('$formula23^$formula24');\">$formula25</a></td>\n");
print("						</tr>\n");
print("					</table>\n");
my $formula26=$hostGroupID;my $formula27=$serviceName;print("					<div id=\"$formula26^$formula27\" style=\"display:none; margin-left:12px;\">\n");
my $graphHash = $serviceHash->{$serviceName};
foreach my $graphHashName (sort(keys(%$graphHash))) {
print("							<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("								<tr>\n");
print("									<td><img src=\"../../perfStatResources/images/navigation/icon_performanceMonitor1.gif\" border=\"0\"></td>\n");
my $formula28=$hostGroupID;my $formula29=$serviceName;my $formula30=$graphHashName;my $formula31=$graphHashName;print("									<td nowrap><a href=\"javascript:parent.content.insertService('$formula28', '$formula29', '$formula30');\">$formula31<a></td>\n");
print("								</tr>\n");
print("							</table>\n");
}
print("					</div>\n");
}
print("				</div>\n");
}
}
print("			</td>\n");
print("		</tr>\n");
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
