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
print("	<body onLoad=\"parent.navigation.setLinkChosen('hostGroups');\">
my $formula0=$sessionObj->param("selectedAdmin");my $formula1=$sessionObj->param("selectedUser");print("		<div class=\"navHeader\">Host Groups :: $formula0 :: $formula1</div>
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Add Host Group</td>
print("			</tr>
 if ($sessionObj->param("userMessage") ne "") {
print("			<tr>
my $formula2=$sessionObj->param("userMessage");print("				<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"3\"><span class=\"userMessage\">$formula2</span></td>
print("			</tr>
 $sessionObj->param("userMessage", "");
 }
print("			<tr>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Group Name</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>
print("				<th nowrap=\"nowrap\">Actions</th>
print("			</tr>
print("			<tr>
print("				<form name=\"insertItem\" action=\"index.pl\" method=\"post\">
print("				<input type=\"hidden\" name=\"action\" value=\"insertHostGroup\">
my $formula3=$adminName;print("				<input type=\"hidden\" name=\"adminName\" value=\"$formula3\">
my $formula4=$userName;print("				<input type=\"hidden\" name=\"userName\" value=\"$formula4\">
my $formula5=$hgNewName;print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\"><input type=\"text\" name=\"hgNewName\" value=\"$formula5\" size=\"24\"></td>
my $formula6=$description;print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><input type=\"text\" name=\"description\" value=\"$formula6\" size=\"35\"></td>
print("				<td class=\"darkGray\" align=\"center\" valign=\"middle\"><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>
print("				</form>
print("			</tr>
print("		</table>
 if (@$myHostGroupArray != 0) {	
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"4\">My Host Groups</td>\n");
print("			</tr>
print("			<tr>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"10\">Actions</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"1%\">Host Group Name</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"1%\">Number of Hosts</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>
print("			</tr>
foreach my $tempArray (@$myHostGroupArray) {
my $hgOwner = $userName;
my $hgName = $tempArray->[0];
my $hgDescription = $tempArray->[1];
my $hgNumberOfHosts = $tempArray->[2];
$queryString = "adminName=" . URLEncode($adminName) . "&userName=" . URLEncode($userName) . "&hgOwner=" . URLEncode($hgOwner) . "&hgName=" . URLEncode($hgName) . "&hgNewName=" . URLEncode($hgName) . "&description=" . URLEncode($hgDescription);
print("			<tr>
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\" width=\"10\">
print("					<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">
print("						<tr>
my $formula7=$queryString;print("							<th nowrap=\"nowrap\"><a href=\"../config/index.pl?$formula7\">Config</a></th>
my $formula8=$queryString;print("							<th nowrap=\"nowrap\"><a href=\"../share/index.pl?$formula8\">Share</a></th>
my $formula9=$queryString;my $formula10=$hgName;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteHostGroup&$formula9\" onclick=\"return warnOnClickAnchor('Are you sure you want to delete $formula10');\">Delete</a></th>
print("						</tr>
print("					</table>
print("				</td>
my $formula11=$hgName;print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\"><span class=\"table1Text1\">$formula11</span></td>
my $formula12=$hgNumberOfHosts;print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula12</span></td>\n");
my $formula13=$hgDescription;print("				<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula13</span></td>\n");
print("			</tr>
}
print("		</table>
}
 if (@$sharedHostGroupArray != 0) {	
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"5\">Shared Host Groups</td>
print("			</tr>
print("			<tr>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"10\">Actions</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"1%\">Host Group Owner</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"1%\">Host Group Name</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"1%\">Number of Hosts</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>
print("				
print("			</tr>
foreach my $tempArray (@$sharedHostGroupArray) {
my $hgOwner = $tempArray->[0];
my $hgName = $tempArray->[1];
my $hgDescription = $tempArray->[2];
my $hgNumberOfHosts = $tempArray->[3];
$queryString = "adminName=" . URLEncode($adminName) . "&userName=" . URLEncode($userName) . "&hgOwner=" . URLEncode($hgOwner) . "&hgName=" . URLEncode($hgName);
print("			<tr>
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\" width=\"10\">
print("					<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">
print("						<tr>
my $formula14=$queryString;my $formula15=$hgName;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?action=removeSharedHostGroup&$formula14\" onclick=\"return warnOnClickAnchor('Are you sure you want to remove $formula15 from this list');\">Remove</a></th>
print("						</tr>
print("					</table>
print("				</td>
my $formula16=$hgOwner;print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\"><span class=\"table1Text1\">$formula16</span></td>
my $formula17=$hgName;print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\"><span class=\"table1Text1\">$formula17</span></td>
my $formula18=$hgNumberOfHosts;print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula18</span></td>
my $formula19=$hgDescription;print("				<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula19</span></td>
print("			</tr>
}
print("		</table>
}
print("	</body>
print("</html>\n");