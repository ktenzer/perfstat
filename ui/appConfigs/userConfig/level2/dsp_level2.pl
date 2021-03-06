use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">\n");
print("	</head>\n");

print("	<body onLoad=\"parent.navigation.setLinkChosen('userConfig');\">\n");
my $formula0=$navHeaderText;my $formula1=$sessionObj->param("selectedAdmin");my $formula2=$updateUserName;print("		<div class=\"navHeader\">$formula0  :: $formula1 :: $formula2</div>\n");
print("			<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("				<tr>\n");
print("					<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"4\" valign=\"middle\" align=\"left\">Modify User</td>\n");
print("				</tr>\n");
 if ($sessionObj->param("userMessage2") ne "") {
print("				<tr>\n");
my $formula3=$sessionObj->param("userMessage2");print("					<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"4\"><span class=\"userMessage\">$formula3</span></td>\n");
print("				</tr>\n");
 $sessionObj->param("userMessage2", "");
 }

print("				<tr>\n");
print("					<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">User Name</th>\n");
print("					<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Password</th>\n");
print("					<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Confirm Password</th>\n");
print("					<th nowrap=\"nowrap\" valign=\"middle\" align=\"center\"></th>\n");
print("				</tr>\n");
print("				<tr>\n");
print("					<form action=\"index.pl\" method=\"post\">\n");
print("						<input type=\"hidden\" name=\"action\" value=\"updateUserPassword\">\n");
my $formula4=$adminName;print("						<input type=\"hidden\" name=\"adminName\" value=\"$formula4\">\n");
my $formula5=$updateUserName;print("						<input type=\"hidden\" name=\"updateUserName\" value=\"$formula5\">\n");
my $formula6=$updateUserRole;print("						<input type=\"hidden\" name=\"updateUserRole\" value=\"$formula6\">\n");
my $formula7=$updateUserName;print("						<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">$formula7</span></td>\n");
print("						<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><input type=\"password\" name=\"password\" size=\"15\"></td>\n");
print("						<td class=\"liteGray\" align=\"left\" valign=\"top\"><input type=\"password\" name=\"confirmPassword\" size=\"15\"></td>\n");
print("						<td class=\"darkGray\" valign=\"top\" align=\"center\"><input class=\"liteButton\" type=\"submit\" name=\"submit\" value=\"ENTER\"></td>\n");
print("					</form>\n");
print("				</tr>\n");
print("			</table>\n");
print("			\n");
print("			<form action=\"index.pl\" method=\"post\">\n");
print("				<input type=\"hidden\" name=\"action\" value=\"updateShowAllHosts\">\n");
my $formula8=$adminName;print("				<input type=\"hidden\" name=\"adminName\" value=\"$formula8\">\n");
my $formula9=$updateUserName;print("				<input type=\"hidden\" name=\"updateUserName\" value=\"$formula9\">\n");
my $formula10=$updateUserRole;print("				<input type=\"hidden\" name=\"updateUserRole\" value=\"$formula10\">\n");
print("				<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("					<tr>\n");
print("						<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Preference</td>\n");
print("					</tr>\n");
print("					<tr>\n");
print("						<td class=\"liteGray\" valign=\"middle\" align=\"left\"><span class=\"table1Text1\">Show All Hosts</span></td>\n");
print("						<td class=\"liteGray\" valign=\"middle\" align=\"left\">\n");
print("							<select name=\"showAllHosts\" size=\"1\" onchange=\"submit();\">\n");
my $formula11=$updateUserShowAllHosts eq 1 ? "selected" : "";;print("							<option value=\"1\" $formula11>true</option>\n");
my $formula12=$updateUserShowAllHosts eq 0 ? "selected" : "";;print("							<option value=\"0\" $formula12>false</option>\n");
print("						</select>\n");
print("						</td>\n");
print("					</tr>\n");
print("				</table>\n");
print("			</form>\n");
print("	</body>\n");
print("</html>\n");
