use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link type=\"text/css\" rel=\"stylesheet\" href=\"../../appRez/styleSheets/navigationFrame.css\">\n");
print("		<script language=\"javascript\" src=\"../../appRez/javaScripts/navigationFrame.js\"></script>\n");
print("		<script language=\"javascript\" src=\"../../appRez/javaScripts/sm.nav.js\"></script>\n");
print("<script language=\"javascript\">\n");
my $formula0=$js_hostGroupArray;print("	var hostGroupArray = eval('$formula0');\n");
print("	createImageArray();\n");
print("</script>\n");
print("	</head>\n");
print("	<body onLoad=\"ip=new ImagePreloader(imgs, renderMenuTree); onBodyLoad('status');\">\n");
 if ($sessionObj->param("userName") eq "perfstat" || $sessionObj->param("role") eq "admin") {
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
 if ($sessionObj->param("userName") eq "perfstat") {
print("			<tr>\n");
print("				<form action=\"index.pl\" method=\"post\">\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"right\"><span class=\"table1Text1\">Admin:</span></td>\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"left\">\n");
print("					<select name=\"adminName\" size=\"1\" onChange=\"submit();\">\n");
 foreach my $adminNameTemp (sort (keys(%$adminList))) {
my $formula1=$adminNameTemp;my $formula2=$adminNameTemp eq $sessionObj->param("selectedAdmin") ? "selected" : "";;my $formula3=$adminNameTemp;print("						<option value=\"$formula1\" $formula2>$formula3</option>\n");
 }
print("					</select>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
}
 if ($sessionObj->param("role") eq "admin") {
print("			<tr>\n");
print("				<form action=\"index.pl\" method=\"post\">\n");
my $formula4=$sessionObj->param("selectedAdmin");print("				<input type=\"hidden\" name=\"adminName\" value=\"$formula4\">\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"right\"><span class=\"table1Text1\">User:</span></td>\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"left\">\n");
print("					<select name=\"userName\" size=\"1\" onChange=\"submit();\">\n");
 foreach my $userNameTemp (sort (keys(%$userList))) {
my $formula5=$userNameTemp;my $formula6=$userNameTemp eq $sessionObj->param("selectedUser")  ? "selected" : "";;my $formula7=$userNameTemp;print("						<option value=\"$formula5\" $formula6>$formula7</option>\n");
 }
print("					</select>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
}
print("		</table>\n");
}
print("		<table border=\"0\" align=\"center\" cellpadding=\"3\" cellspacing=\"1\" class=\"table1\" width=\"100%\">\n");
print("		<tr> \n");
print("			<td height=\"25\" class=\"header\">Status Monitor</td>\n");
print("		</tr>\n");
print("		<tr> \n");
print("			<td height=\"25\" class=\"subheader\">\n");
print("				<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"table2\" align=\"center\">\n");
print("					<tr>\n");
print("						<td nowrap><a href=\"javascript:openAll();\">open all</a></td>\n");
print("						<td nowrap><img src=\"../../appRez/images/common/spacer.gif\" height=\"6\" width=\"10\" border=\"0\"></td>\n");
print("						<td nowrap><a href=\"javascript:closeAll();\">close all</a></td>\n");
print("					</tr>\n");
print("				</table>\n");
print("			</td>\n");
print("		</tr>\n");
print("		<tr>\n");
print("			<td align=\"left\" valign=\"top\">\n");
print("				<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("					<tr>\n");
print("						<td><img src=\"../../appRez/images/navigation/icon_statusMonitor2.gif\" border=\"0\"></td>\n");
print("						<td nowrap><a id=\"serverStatus\" href=\"../serverStatus/index.pl\" target=\"content\">Perfstat Server</a></td>\n");
print("					</tr>\n");
if ($sessionObj->param('showAllHosts')) {
print("					<tr>\n");
print("						<td><img src=\"../../appRez/images/navigation/icon_statusMonitor1.gif\" border=\"0\"></td>\n");
print("						<td nowrap><a id=\"allHosts\" href=\"index.pl?groupViewStatus=allHosts\">All Hosts</a></td>\n");
print("					</tr>\n");
}
print("					<tr>\n");
print("						<td><img src=\"../../appRez/images/navigation/icon_statusMonitor1.gif\" border=\"0\"></td>\n");
print("						<td nowrap><a id=\"myHostGroups\" href=\"index.pl?groupViewStatus=self\">My Host Groups</a></td>\n");
print("					</tr>\n");
print("					<tr>\n");
print("						<td><img src=\"../../appRez/images/navigation/icon_statusMonitor1.gif\" border=\"0\"></td>\n");
print("						<td nowrap><a id=\"sharedHostGroups\" href=\"index.pl?groupViewStatus=shared\">Shared Host Groups</a></td>\n");
print("					</tr>\n");
print("				</table>\n");
print("			</td>\n");
print("		</tr>\n");
print("			<tr>\n");
print("			<td align=\"left\" valign=\"top\">\n");
print("				<div id=\"navContainer\" style=\"margin-left:5px\">\n");
print("				</div>\n");
print("			</td>\n");
print("		</tr>\n");
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
