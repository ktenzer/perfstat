use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/contentFrame.js\"></script>\n");
print("	</head>\n");

print("	<body onLoad=\"parent.navigation.setLinkChosen('hostGroups');\">\n");
print("		<div class=\"navHeader\">Host Groups</div>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Add Host Group</td>\n");
print("			</tr>\n");
 if ($sessionObj->param("userMessage") ne "") {
print("			<tr>\n");
my $formula0=$sessionObj->param("userMessage");print("				<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"3\"><span class=\"userMessage\">$formula0</span></td>\n");
print("			</tr>\n");
 $sessionObj->param("userMessage", "");
 }
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Group Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>\n");
print("				<th nowrap=\"nowrap\">Actions</th>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<form name=\"insertItem\" action=\"index.pl\" method=\"post\">\n");
print("				<input type=\"hidden\" name=\"action\" value=\"insertHostGroup\">\n");
my $formula1=$adminName;print("				<input type=\"hidden\" name=\"adminName\" value=\"$formula1\">\n");
my $formula2=$userName;print("				<input type=\"hidden\" name=\"userName\" value=\"$formula2\">\n");
my $formula3=$hgNewName;print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\"><input type=\"text\" name=\"hgNewName\" value=\"$formula3\" size=\"24\"></td>\n");
my $formula4=$description;print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><input type=\"text\" name=\"description\" value=\"$formula4\" size=\"35\"></td>\n");
print("				<td class=\"darkGray\" align=\"center\" valign=\"middle\"><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>\n");
print("				</form>\n");
print("			</tr>\n");
print("		</table>\n");
 if (@$myHostGroupArray != 0) {	
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"4\">My Host Groups</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"10\">Actions</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"1%\">Host Group Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"1%\">Number of Hosts</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>\n");
print("			</tr>\n");
foreach my $tempArray (@$myHostGroupArray) {
my $hgOwner = $userName;
my $hgName = $tempArray->[0];
my $hgDescription = $tempArray->[1];
my $hgNumberOfHosts = $tempArray->[2];
$queryString = "adminName=" . URLEncode($adminName) . "&userName=" . URLEncode($userName) . "&hgOwner=" . URLEncode($hgOwner) . "&hgName=" . URLEncode($hgName) . "&hgNewName=" . URLEncode($hgName) . "&description=" . URLEncode($hgDescription);
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\" width=\"10\">\n");
print("					<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("						<tr>\n");
my $formula5=$queryString;print("							<th nowrap=\"nowrap\"><a href=\"../config/index.pl?$formula5\">Config</a></th>\n");
my $formula6=$queryString;print("							<th nowrap=\"nowrap\"><a href=\"../share/index.pl?$formula6\">Share</a></th>\n");
my $formula7=$queryString;my $formula8=$hgName;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteHostGroup&$formula7\" onclick=\"return warnOnClickAnchor('Are you sure you want to delete $formula8');\">Delete</a></th>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
my $formula9=$hgName;print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\"><span class=\"table1Text1\">$formula9</span></td>\n");
my $formula10=$hgNumberOfHosts;print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula10</span></td>\n");
my $formula11=$hgDescription;print("				<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula11</span></td>\n");
print("			</tr>\n");
}
print("		</table>\n");
}
 if (@$sharedHostGroupArray != 0) {	
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"5\">Shared Host Groups</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"10\">Actions</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"1%\">Host Group Owner</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"1%\">Host Group Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"1%\">Number of Hosts</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>\n");
print("				\n");
print("			</tr>\n");
foreach my $tempArray (@$sharedHostGroupArray) {
my $hgOwner = $tempArray->[0];
my $hgName = $tempArray->[1];
my $hgDescription = $tempArray->[2];
my $hgNumberOfHosts = $tempArray->[3];
$queryString = "adminName=" . URLEncode($adminName) . "&userName=" . URLEncode($userName) . "&hgOwner=" . URLEncode($hgOwner) . "&hgName=" . URLEncode($hgName);
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\" width=\"10\">\n");
print("					<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("						<tr>\n");
my $formula12=$queryString;my $formula13=$hgName;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?action=removeSharedHostGroup&$formula12\" onclick=\"return warnOnClickAnchor('Are you sure you want to remove $formula13 from this list');\">Remove</a></th>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
my $formula14=$hgOwner;print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\"><span class=\"table1Text1\">$formula14</span></td>\n");
my $formula15=$hgName;print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\"><span class=\"table1Text1\">$formula15</span></td>\n");
my $formula16=$hgNumberOfHosts;print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula16</span></td>\n");
my $formula17=$hgDescription;print("				<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula17</span></td>\n");
print("			</tr>\n");
}
print("		</table>\n");
}
print("	</body>\n");
print("</html>\n");
