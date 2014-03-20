use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link type=\"text/css\" rel=\"stylesheet\" href=\"../../appRez/styleSheets/navigationFrame.css\">\n");
print("		<script language=\"javascript\" src=\"../../appRez/javaScripts/navigationFrame.js\"></script>\n");
print("	</head>\n");
print("	<body onLoad=\"onBodyLoad('appConfigs');\">\n");
 if ($sessionObj->param("userName") eq "perfstat" || $sessionObj->param("role") eq "admin") {
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">	\n");
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
print("		<table border=\"0\" align=\"center\" cellpadding=\"3\" cellspacing=\"1\" class=\"table1\" width=\"100%\">\n");
print("			<tr> \n");
print("				<td height=\"25\" class=\"header\">App Configs</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td align=\"left\" valign=\"top\">\n");
print("					<div style=\"margin-left:5px\">\n");
print("					<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("						<tr>\n");
print("							<td><img src=\"../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("							<td><img src=\"../../appRez/images/navigation/icon_appConfig1.gif\" border=\"0\" width=\"19\" height=\"19\"></td>\n");
print("							<td nowrap><a id=\"userConfig\" href=\"../userConfig/level1/index.pl\" target=\"content\">User Config</a></td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td><img src=\"../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("							<td><img src=\"../../appRez/images/navigation/icon_appConfig1.gif\" border=\"0\" width=\"19\" height=\"19\"></td>\n");
print("							<td nowrap><a id=\"hostGroups\" href=\"../hostGroups/level1/index.pl\" target=\"content\">Host Groups</a></td>\n");
print("						</tr>\n");
 if ($sessionObj->param("role") eq "admin") {
print("						<tr>\n");
print("							<td><img src=\"../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("							<td><img src=\"../../appRez/images/navigation/icon_appConfig1.gif\" border=\"0\" width=\"19\" height=\"19\"></td>\n");
print("							<td nowrap><a id=\"hostConfig\" href=\"../hostConfig/list/index.pl\" target=\"content\">Host Config</a></td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td><img src=\"../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("							<td><img src=\"../../appRez/images/navigation/icon_appConfig1.gif\" border=\"0\" width=\"19\" height=\"19\"></td>\n");
print("            				<td nowrap><a id=\"alertTemplates\" href=\"../alertTemplates/list/index.pl\" target=\"content\">Alert Templates</a></td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td><img src=\"../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("							<td><img src=\"../../appRez/images/navigation/icon_appConfig1.gif\" border=\"0\" width=\"19\" height=\"19\"></td>\n");
print("							<td nowrap><p><a id=\"metricTemplates\" href=\"../metricTemplates/list/index.pl\" target=\"content\">Metric Templates</a></p>\n");
print("						   </td>\n");
print("						</tr>\n");
 }
print("					</table>\n");
print("				</div>\n");
print("			</td>\n");
print("		</tr>\n");
print("	</table>\n");
print("	</body>\n");
print("</html>\n");
