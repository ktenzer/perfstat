use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/contentFrame.js\"></script>\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/ac.users.js\"></script>\n");
print("	</head>\n");

my $formula0=$updateNavCode;my $formula1=$sessionObj->param("selectedAdmin");my $formula2=$sessionObj->param("selectedUser");print("	<body onload=\"onLoad=updateNavigation($formula0, '$formula1', '$formula2')\">\n");
my $formula3=$sessionObj->param("selectedAdmin");print("		<div class=\"navHeader\">User Config :: $formula3</div>\n");
if ($sessionObj->param("selectedAdmin") eq "perfstat") { 
print("				<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("					<tr>\n");
print("						<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"4\" valign=\"middle\" align=\"left\">Add Admin</td>\n");
print("					</tr>\n");
if ($sessionObj->param("userMessage1") ne "") {
print("					<tr>\n");
my $formula4=$sessionObj->param("userMessage1");print("						<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"4\"><span class=\"userMessage\">$formula4</span></td>\n");
print("					</tr>\n");
$sessionObj->param("userMessage1", "");
 }
print("					<tr>\n");
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Admin Name</th>\n");
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Password</th>\n");
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Confirm Password</th>\n");
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"center\"></th>\n");
print("					</tr>\n");
print("					<tr>\n");
print("						<form action=\"index.pl\" method=\"post\">\n");
print("						<input type=\"hidden\" name=\"action\" value=\"insertAdmin\">\n");
my $formula5=$insertAdminName;print("						<td class=\"liteGray\" align=\"left\" valign=\"top\"><input type=\"text\" name=\"insertAdminName\" value=\"$formula5\" size=\"18\"></td>\n");
print("						<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><input type=\"password\" name=\"password\" size=\"15\"></td>\n");
print("						<td class=\"liteGray\" align=\"left\" valign=\"top\"><input type=\"password\" name=\"confirmPassword\" size=\"15\"></td>\n");
print("						<td><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>\n");
print("						</form>\n");
print("					</tr>\n");
print("				</table>\n");
}
print("				\n");
if ($sessionObj->param("role") eq "admin") { 
print("				<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("					<tr>\n");
print("						<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Manage Admin</td>\n");
print("					</tr>\n");
print("					<tr>\n");
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"center\" width=\"1%\">Actions</th>\n");
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Admin Name</th>\n");
print("					</tr>\n");
print("					<tr>\n");
$queryString = "adminName=$adminName&role=admin&updateUserName=$adminName";
print("						<td class=\"liteGray\" align=\"left\" valign=\"middle\" width=\"1%\">\n");
print("							<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("								<tr>\n");
my $formula6=$queryString;print("									<th nowrap=\"nowrap\"><a href=\"../level2/index.pl?$formula6\">Config</a></th>\n");
print("								</tr>\n");
print("							</table>\n");
print("						</td>\n");
my $formula7=$adminName;print("						<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">$formula7</span></td>\n");
print("					</tr>\n");
foreach my $adminNameTemp (sort(keys(%$adminList))) {
if ($adminNameTemp ne $sessionObj->param("selectedAdmin")) {
print("					<tr>\n");
$queryString = "adminName=$adminName&updateUserName=$adminNameTemp";
print("						<td class=\"liteGray\" align=\"left\" valign=\"middle\" width=\"1%\">\n");
print("							<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" width=\"100%\">\n");
print("								<tr>\n");
my $formula8=$queryString;print("									<th nowrap=\"nowrap\"><a href=\"../level2/index.pl?$formula8\">Config</a></th>\n");
my $formula9=$queryString;my $formula10=$adminNameTemp;print("									<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteAdmin&$formula9\" onclick=\"return warnOnClickAnchor('Are you sure you want to delete $formula10')\">Delete</a></th>\n");
print("								</tr>\n");
print("							</table>\n");
print("						</td>\n");
my $formula11=$adminNameTemp;print("						<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">$formula11</span></td>\n");
print("					</tr>\n");
}
}
print("				</table>\n");

print("			<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("				<tr>\n");
print("					<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"4\" valign=\"middle\" align=\"left\">Add User</td>\n");
print("				</tr>\n");
if ($sessionObj->param("userMessage2") ne "") {
print("				<tr>\n");
my $formula12=$sessionObj->param("userMessage2");print("					<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"4\"><span class=\"userMessage\">$formula12</span></td>\n");
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
print("					<form name=\"insertUser\" action=\"index.pl\" method=\"post\">\n");
print("					<input type=\"hidden\" name=\"action\" value=\"insertUser\">\n");
my $formula13=$adminName;print("					<input type=\"hidden\" name=\"adminName\" value=\"$formula13\">\n");
my $formula14=$insertUserName;print("					<td class=\"liteGray\" align=\"left\" valign=\"top\"><input type=\"text\" name=\"insertUserName\" value=\"$formula14\" size=\"18\"></td>\n");
print("					<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><input type=\"password\" name=\"password\" size=\"15\"></td>\n");
print("						<td class=\"liteGray\" align=\"left\" valign=\"top\"><input type=\"password\" name=\"confirmPassword\" size=\"15\"></td>\n");
print("						<td><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>\n");
print("					</form>\n");
print("				</tr>\n");
print("			</table>\n");
print("			<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("				<tr>\n");
my $formula15=$sessionObj->param("role") eq "admin" ? "Users" : "Password";print("					<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Manage $formula15</td>\n");
print("				</tr>\n");
print("				<tr>\n");
print("					<th nowrap=\"nowrap\" valign=\"middle\" align=\"center\" width=\"10\">Actions</th>\n");
print("					<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">User Name</th>\n");
print("				</tr>\n");
foreach my $userNameTemp (sort(keys(%$userList))) {
if ($userIndex->{$adminName}->{$userNameTemp} ne "admin") {
print("				<tr>\n");
$queryString = "adminName=$adminName&updateUserName=$userNameTemp";
print("					<td class=\"liteGray\" align=\"center\" valign=\"top\" width=\"10\">\n");
print("						<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" width=\"100%\">\n");
print("							<tr>\n");
my $formula16=$queryString;print("								<th nowrap=\"nowrap\"><a href=\"../level2/index.pl?$formula16\">Config</a></th>\n");
my $formula17=$queryString;my $formula18=$userNameTemp;print("								<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteUser&$formula17\" onclick=\"return warnOnClickAnchor('Are you sure you want to delete $formula18')\">Delete</a></th>\n");
print("							</tr>\n");
print("						</table>\n");
print("					</td>\n");
my $formula19=$userNameTemp;print("					<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">$formula19</span></td>\n");
print("				</tr>\n");
}
}
print("			</table>\n");
}
print("	</body>\n");
print("</html>\n");
