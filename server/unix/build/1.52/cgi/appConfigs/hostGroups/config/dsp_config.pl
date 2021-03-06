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
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Config Host Group</td>\n");
print("			</tr>\n");
 if ($sessionObj->param("userMessage") ne "") {
print("			<tr>\n");
my $formula5=$sessionObj->param("userMessage");print("				<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"3\"><span class=\"userMessage\">$formula5</span></td>\n");
print("			</tr>\n");
 $sessionObj->param("userMessage", "");
 }
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Group Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>\n");
print("				<th nowrap=\"nowrap\">Actions</th>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<form action=\"index.pl\" method=\"post\">\n");
print("				<input type=\"hidden\" name=\"action\" value=\"updateHostGroup\">\n");
my $formula6=$adminName;print("				<input type=\"hidden\" name=\"adminName\" value=\"$formula6\">\n");
my $formula7=$userName;print("				<input type=\"hidden\" name=\"userName\" value=\"$formula7\">\n");
my $formula8=$hgName;print("				<input type=\"hidden\" name=\"hgName\" value=\"$formula8\">\n");
my $formula9=$hgNewName;print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><input type=\"text\" name=\"hgNewName\" value=\"$formula9\" size=\"24\"></td>\n");
my $formula10=$description;print("					<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><input type=\"text\" name=\"description\" value=\"$formula10\" size=\"35\"></td>\n");
print("					<td class=\"darkGray\" align=\"center\" valign=\"middle\">\n");
print("						<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">\n");
print("							<tr>\n");
print("								<td nowrap=\"nowrap\"><input class=\"liteButton\" type=\"submit\" name=\"submit\" value=\"ENTER\"></td>\n");
print("							</tr>\n");
print("						</table>\n");
print("					</td>\n");
print("				</form>\n");
print("			</tr>\n");
print("		</table>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Add Host</td>\n");
print("			</tr>\n");
 if (keys(%$hostHash) != 0) {
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>\n");
print("				<th nowrap=\"nowrap\">Actions</th>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<form action=\"index.pl\" method=\"post\">\n");
print("				<input type=\"hidden\" name=\"action\" value=\"insertHost\">\n");
my $formula11=$adminName;print("				<input type=\"hidden\" name=\"adminName\" value=\"$formula11\">\n");
my $formula12=$userName;print("				<input type=\"hidden\" name=\"userName\" value=\"$formula12\">\n");
my $formula13=$hgName;print("				<input type=\"hidden\" name=\"hgName\" value=\"$formula13\">\n");
my $formula14=$hgNewName;print("				<input type=\"hidden\" name=\"hgNewName\" value=\"$formula14\">\n");
my $formula15=$description;print("				<input type=\"hidden\" name=\"description\" value=\"$formula15\">\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
print("					<select name=\"hostName\" size=\"1\">\n");
foreach my $hostHashKey (sort(keys(%$hostHash))) {
my $formula16=$hostHashKey;my $formula17=$hostHashKey;print("						<option value=\"$formula16\">$formula17</option>\n");
}
print("					</select>\n");
print("				</td>\n");
print("				<td class=\"darkGray\" align=\"center\" valign=\"middle\"><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>\n");
print("				</form>\n");
print("			</tr>\n");
 } else {
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
 if ($hostListLen == 0) {
print("						<span class=\"table1Text1\">No hosts are available</span>\n");
 } else {
print("						<span class=\"table1Text1\">All available hosts are already in host group</span>\n");
 }
print("				</td>\n");
print("			</tr>\n");
 }
print("		</table>\n");
 if (@$hostGroupMemberArray != 0) {
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Host List</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" width=\"10\">Actions</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">IP</th>\n");
print("			</tr>\n");
foreach my $hostGroupMember (@$hostGroupMemberArray) {
my $memberName = $hostGroupMember->[0];
my $tempIP = $hostGroupMember->[1];
my $queryString = 	"action=removeHost&adminName=" . URLEncode($adminName) . "&userName=" . URLEncode($userName) .  "&hgName=". URLEncode($hgName) . "&hgNewName=". URLEncode($hgNewName) . "&description=". URLEncode($description) . "&hostName=". URLEncode($memberName);
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"center\" valign=\"middle\" width=\"10\">\n");
print("					<table width=\"100%\" cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("						<tr>\n");
my $formula18=$queryString;my $formula19=$memberName;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?$formula18\" onclick=\"return warnOnClickAnchor('Are you sure you want to remove $formula19');\">Remove From List</a></th>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
my $formula20=$memberName;print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">$formula20</span></td>\n");
my $formula21=$tempIP;print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula21</span></td>\n");
print("			</tr>\n");
}
print("		</table>\n");
 } else {
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Host List</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">IP</th>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">&nbsp;</span></td>\n");
print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">&nbsp;</span></td>\n");
print("			</tr>\n");
print("		</table>\n");
 }
print("	</body>\n");
print("</html>\n");
