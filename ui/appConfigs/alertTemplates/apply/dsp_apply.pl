use strict;
package main;
print("<html>
print("	<head>
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/contentFrame.js\"></script>
print("	</head>
print("
print("	<body>
my $formula0=$templateName;print("		<div class=\"navHeader\"><a href=\"../list/index.pl\">Alert Templates</a> :: $formula0</div>
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Add Host</td>
print("			</tr>
 if (keys(%$hostList) != 0) {
 if ($sessionObj->param("userMessage") ne "") {
print("				<tr>
my $formula1=$sessionObj->param("userMessage");print("					<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"2\"><span class=\"userMessage\">$formula1</span></td>
print("				</tr>
 $sessionObj->param("userMessage", "");
 }
print("			<tr>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>
print("				<th nowrap=\"nowrap\">Action</th>
print("			</tr>
print("			<tr>
print("				<form action=\"index.pl\" method=\"post\">
print("				<input type=\"hidden\" name=\"action\" value=\"insertHosts\">
my $formula2=$templateName;print("				<input type=\"hidden\" name=\"templateName\" value=\"$formula2\">
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">
print("					<select name=\"selectHosts\" size=\"10\" multiple>
foreach my $hostListKey (sort(keys(%$hostList))) {
my $formula3=$hostListKey;my $formula4=$hostListKey;print("						<option value=\"$formula3\">$formula4</option>
}
print("					</select>
print("				</td>
print("				<td class=\"darkGray\" align=\"center\" valign=\"bottom\"><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>
print("				</form>
print("			</tr>
 } else {
print("			<tr>
print("				<td colspan=\"2\" class=\"liteGray\" align=\"left\" valign=\"middle\">
 if ($hostListLen == 0) {
print("						<span class=\"table1Text1\">No hosts are available</span>
 } else {
print("						<span class=\"table1Text1\">All available hosts are already in host group</span>
 }
print("				</td>
print("			</tr>
 }
print("	</table>
 my $applyToHostList = $sessionObj->param('applyToHostList');
 if (keys(%$applyToHostList) != 0) {
print("		<table width=\"500\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Apply Template to Host List</td>
print("			</tr>
print("			<tr>
print("				<th nowrap=\"nowrap\" width=\"10\">Actions</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">IP</th>
print("			</tr>
foreach my $hostName (sort(keys(%$applyToHostList))) {
my $ip = $applyToHostList->{$hostName};
my $queryString = "action=removeHost" . "&templateName=". URLEncode($templateName) . "&hostName=". URLEncode($hostName);
print("			<tr>
print("				<td class=\"liteGray\" align=\"center\" valign=\"middle\" width=\"10\">
print("					<table width=\"100%\" cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">
print("						<tr>
my $formula5=$queryString;my $formula6=$hostName;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?$formula5\" onclick=\"return warnOnClickAnchor('Are you sure you want to remove $formula6');\">Remove From List</a></th>
print("						</tr>
print("					</table>
print("				</td>
my $formula7=$hostName;print("				<td align=\"left\" valign=\"top\" nowrap class=\"liteGray\"><span class=\"table1Text1\">$formula7</span></td>
my $formula8=$ip;print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula8</span></td>
print("			</tr>
}
print("			<tr>
print("				<form action=\"index.pl\" method=\"post\">
print("				<input type=\"hidden\" name=\"action\" value=\"applyTemplate2Hosts\">
my $formula9=$templateName;print("				<input type=\"hidden\" name=\"templateName\" value=\"$formula9\">
print("				<td class=\"liteGray\" valign=\"top\" align=\"center\" colspan=\"3\"><input class=\"liteButton\" type=\"submit\" value=\"Apply to Hosts\"></td>
print("				</form>
print("			</tr>
print("	</table>
 } else {
print("		<table width=\"500\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Apply Template to Host List</td>
print("			</tr>
print("			<tr>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">IP</th>
print("			</tr>
print("			<tr>
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">&nbsp;</span></td>
print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">&nbsp;</span></td>
print("			</tr>
print("	</table>
 }
print("	</body>
print("</html>\n");