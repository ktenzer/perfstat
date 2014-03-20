use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/contentFrame.js\"></script>\n");
print("	</head>\n");
print("\n");
print("	<body>\n");
print("		<div class=\"navHeader\">\n");
my $formula0=$adminName;my $formula1=$userName;my $formula2=$sessionObj->param("selectedAdmin");my $formula3=$sessionObj->param("selectedUser");my $formula4=$hgName;print("			<a href=\"../level1/index.pl?adminName=$formula0&userName=$formula1\">Host Groups</a> :: $formula2 :: $formula3 :: $formula4\n");
print("		</div>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Add Shared User</td>\n");
print("			</tr>\n");
 if (keys(%$potentialShareMembers) != 0) {
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">User Name</th>\n");
print("				<th nowrap=\"nowrap\">Actions</th>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<form action=\"index.pl\" method=\"post\">\n");
print("				<input type=\"hidden\" name=\"action\" value=\"insertSharedUser\">\n");
my $formula5=$adminName;print("				<input type=\"hidden\" name=\"adminName\" value=\"$formula5\">\n");
my $formula6=$userName;print("				<input type=\"hidden\" name=\"userName\" value=\"$formula6\">\n");
my $formula7=$hgName;print("				<input type=\"hidden\" name=\"hgName\" value=\"$formula7\">\n");
print("					<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
print("					<select name=\"memberName\" size=\"1\">\n");
foreach my $userName (sort(keys(%$potentialShareMembers))) {
my $formula8=$userName;my $formula9=$userName;print("						<option value=\"$formula8\">$formula9</option>\n");
}
print("					</select>\n");
print("				</td>\n");
print("					<td class=\"darkGray\" align=\"center\" valign=\"middle\"><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>\n");
print("				</form>\n");
print("			</tr>\n");
 } else {
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
 if (keys(%$shareMembers) == 0) {
print("						<span class=\"table1Text1\">No users are available</span>\n");
 } else {
print("						<span class=\"table1Text1\">All available users are already have access</span>\n");
 }
print("				</td>\n");
print("			</tr>\n");
 }
print("		</table>\n");
 if (keys(%$shareMembers) != 0) {
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Shared User List</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" width=\"10\">Actions</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Shared User Name</th>\n");
print("			</tr>\n");
foreach my $memberName (sort(keys(%$shareMembers))) {
my $permissions = $shareMembers->{$memberName};
my $queryString = 	"adminName=" . URLEncode($adminName) . "&userName=" . URLEncode($userName) .  "&hgName=". URLEncode($hgName) . "&memberName=". URLEncode($memberName);
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"center\" valign=\"middle\" width=\"10\">\n");
print("					<table width=\"100%\" cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("						<tr>\n");
my $formula10=$queryString;my $formula11=$memberName;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?action=removeSharedUser&$formula10\" onclick=\"return warnOnClickAnchor('Are you sure you want to remove $formula11');\">Remove From List</a></th>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
my $formula12=$memberName;print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">$formula12</span></td>\n");
print("			</tr>\n");
}
print("		</table>\n");
 } else {
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Share List</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Shared User Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Permissions</th>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">&nbsp;</span></td>\n");
print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">&nbsp;</span></td>\n");
print("			</tr>\n");
print("		</table>\n");
 }
print("	</body>\n");
print("</html>\n");
