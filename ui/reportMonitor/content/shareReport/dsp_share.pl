use strict;
package main;
print("<html>
print("	<head>
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/forms.css\" media=\"screen\">
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/contentFrame.js\"></script>
print("	</head>
print("
print("	<body>
print("		<div class=\"navHeader\">Report Monitor :: <a href=\"../reportList/index.pl\">My Reports</a> :: Share Report</div>
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Add Shared User</td>\n");
print("			</tr>
 if (keys(%$potentialShareMembers) != 0) {
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">User Name</th>\n");
print("				<th nowrap=\"nowrap\">Actions</th>\n");
print("			</tr>
print("			<tr>
print("				<form action=\"index.pl\" method=\"post\">
print("				<input type=\"hidden\" name=\"action\" value=\"insertSharedUser\">
my $formula0=$adminName;print("				<input type=\"hidden\" name=\"adminName\" value=\"$formula0\">
my $formula1=$userName;print("				<input type=\"hidden\" name=\"userName\" value=\"$formula1\">
my $formula2=$reportName;print("				<input type=\"hidden\" name=\"reportName\" value=\"$formula2\">\n");
print("					<td class=\"liteGray\" align=\"left\" valign=\"middle\">
print("					<select name=\"memberName\" size=\"1\">
foreach my $userName (sort(keys(%$potentialShareMembers))) {
my $formula3=$userName;my $formula4=$userName;print("						<option value=\"$formula3\">$formula4</option>
}
print("					</select>
print("				</td>\n");
print("					<td class=\"darkGray\" align=\"center\" valign=\"middle\"><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>\n");
print("				</form>
print("			</tr>
 } else {
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">
 if (keys(%$shareMembers) == 0) {
print("						<span class=\"table1Text1\">No users are available</span>
 } else {
print("						<span class=\"table1Text1\">All available users are already have access</span>
 }
print("				</td>\n");
print("			</tr>
 }
print("		</table>
 if (keys(%$shareMembers) != 0) {
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Shared User List</td>
print("			</tr>
print("			<tr>
print("				<th nowrap=\"nowrap\" width=\"10\">Actions</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Shared User Name</th>\n");
print("			</tr>
foreach my $memberName (sort(keys(%$shareMembers))) {
my $permissions = $shareMembers->{$memberName};
my $queryString = 	"adminName=" . URLEncode($adminName) . "&userName=" . URLEncode($userName) .  "&reportName=". URLEncode($reportName) . "&memberName=". URLEncode($memberName);
print("			<tr>
print("				<td class=\"liteGray\" align=\"center\" valign=\"middle\" width=\"10\">
print("					<table width=\"100%\" cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">
print("						<tr>
my $formula5=$queryString;my $formula6=$memberName;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?action=removeSharedUser&$formula5\" onclick=\"return warnOnClickAnchor('Are you sure you want to remove $formula6');\">Remove From List</a></th>
print("						</tr>
print("					</table>
print("				</td>\n");
my $formula7=$memberName;print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">$formula7</span></td>\n");
print("			</tr>
}
print("		</table>
 } else {
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Share List</td>
print("			</tr>
print("			<tr>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Shared User Name</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Permissions</th>
print("			</tr>
print("			<tr>
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">&nbsp;</span></td>
print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">&nbsp;</span></td>
print("			</tr>
print("		</table>
 }
print("	</body>
print("</html>\n");