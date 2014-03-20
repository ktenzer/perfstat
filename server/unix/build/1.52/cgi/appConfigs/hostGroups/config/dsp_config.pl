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
print("		<div class=\"navHeader\">
my $formula0=$adminName;my $formula1=$userName;my $formula2=$sessionObj->param("selectedAdmin");my $formula3=$sessionObj->param("selectedUser");my $formula4=$hgName;print("			<a href=\"../level1/index.pl?adminName=$formula0&userName=$formula1\">Host Groups</a> :: $formula2 :: $formula3 :: $formula4
print("		</div>
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Config Host Group</td>
print("			</tr>
 if ($sessionObj->param("userMessage") ne "") {
print("			<tr>
my $formula5=$sessionObj->param("userMessage");print("				<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"3\"><span class=\"userMessage\">$formula5</span></td>
print("			</tr>
 $sessionObj->param("userMessage", "");
 }
print("			<tr>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Group Name</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>
print("				<th nowrap=\"nowrap\">Actions</th>
print("			</tr>
print("			<tr>
print("				<form action=\"index.pl\" method=\"post\">
print("				<input type=\"hidden\" name=\"action\" value=\"updateHostGroup\">
my $formula6=$adminName;print("				<input type=\"hidden\" name=\"adminName\" value=\"$formula6\">
my $formula7=$userName;print("				<input type=\"hidden\" name=\"userName\" value=\"$formula7\">
my $formula8=$hgName;print("				<input type=\"hidden\" name=\"hgName\" value=\"$formula8\">
my $formula9=$hgNewName;print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><input type=\"text\" name=\"hgNewName\" value=\"$formula9\" size=\"24\"></td>
my $formula10=$description;print("					<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><input type=\"text\" name=\"description\" value=\"$formula10\" size=\"35\"></td>
print("					<td class=\"darkGray\" align=\"center\" valign=\"middle\">
print("						<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">
print("							<tr>
print("								<td nowrap=\"nowrap\"><input class=\"liteButton\" type=\"submit\" name=\"submit\" value=\"ENTER\"></td>
print("							</tr>
print("						</table>
print("					</td>
print("				</form>
print("			</tr>
print("		</table>
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Add Host</td>
print("			</tr>
 if (keys(%$hostHash) != 0) {
print("			<tr>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>
print("				<th nowrap=\"nowrap\">Actions</th>
print("			</tr>
print("			<tr>
print("				<form action=\"index.pl\" method=\"post\">
print("				<input type=\"hidden\" name=\"action\" value=\"insertHost\">
my $formula11=$adminName;print("				<input type=\"hidden\" name=\"adminName\" value=\"$formula11\">
my $formula12=$userName;print("				<input type=\"hidden\" name=\"userName\" value=\"$formula12\">
my $formula13=$hgName;print("				<input type=\"hidden\" name=\"hgName\" value=\"$formula13\">
my $formula14=$hgNewName;print("				<input type=\"hidden\" name=\"hgNewName\" value=\"$formula14\">
my $formula15=$description;print("				<input type=\"hidden\" name=\"description\" value=\"$formula15\">
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">
print("					<select name=\"hostName\" size=\"1\">
foreach my $hostHashKey (sort(keys(%$hostHash))) {
my $formula16=$hostHashKey;my $formula17=$hostHashKey;print("						<option value=\"$formula16\">$formula17</option>
}
print("					</select>
print("				</td>
print("				<td class=\"darkGray\" align=\"center\" valign=\"middle\"><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>
print("				</form>
print("			</tr>
 } else {
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">
 if ($hostListLen == 0) {
print("						<span class=\"table1Text1\">No hosts are available</span>
 } else {
print("						<span class=\"table1Text1\">All available hosts are already in host group</span>
 }
print("				</td>\n");
print("			</tr>
 }
print("		</table>
 if (@$hostGroupMemberArray != 0) {
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Host List</td>
print("			</tr>
print("			<tr>
print("				<th nowrap=\"nowrap\" width=\"10\">Actions</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">IP</th>
print("			</tr>
foreach my $hostGroupMember (@$hostGroupMemberArray) {
my $memberName = $hostGroupMember->[0];
my $tempIP = $hostGroupMember->[1];
my $queryString = 	"action=removeHost&adminName=" . URLEncode($adminName) . "&userName=" . URLEncode($userName) .  "&hgName=". URLEncode($hgName) . "&hgNewName=". URLEncode($hgNewName) . "&description=". URLEncode($description) . "&hostName=". URLEncode($memberName);
print("			<tr>
print("				<td class=\"liteGray\" align=\"center\" valign=\"middle\" width=\"10\">
print("					<table width=\"100%\" cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">
print("						<tr>
my $formula18=$queryString;my $formula19=$memberName;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?$formula18\" onclick=\"return warnOnClickAnchor('Are you sure you want to remove $formula19');\">Remove From List</a></th>
print("						</tr>
print("					</table>
print("				</td>
my $formula20=$memberName;print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">$formula20</span></td>
my $formula21=$tempIP;print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula21</span></td>
print("			</tr>
}
print("		</table>
 } else {
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Host List</td>
print("			</tr>
print("			<tr>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">IP</th>
print("			</tr>
print("			<tr>
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">&nbsp;</span></td>
print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">&nbsp;</span></td>
print("			</tr>
print("		</table>
 }
print("	</body>
print("</html>\n");