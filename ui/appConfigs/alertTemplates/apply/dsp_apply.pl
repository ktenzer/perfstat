use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/contentFrame.js\"></script>\n");
print("	</head>\n");
print("\n");
print("	<body>\n");
my $formula0=$templateName;print("		<div class=\"navHeader\"><a href=\"../list/index.pl\">Alert Templates</a> :: $formula0</div>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Add Host</td>\n");
print("			</tr>\n");
 if (keys(%$hostList) != 0) {
 if ($sessionObj->param("userMessage") ne "") {
print("				<tr>\n");
my $formula1=$sessionObj->param("userMessage");print("					<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"2\"><span class=\"userMessage\">$formula1</span></td>\n");
print("				</tr>\n");
 $sessionObj->param("userMessage", "");
 }
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>\n");
print("				<th nowrap=\"nowrap\">Action</th>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<form action=\"index.pl\" method=\"post\">\n");
print("				<input type=\"hidden\" name=\"action\" value=\"insertHosts\">\n");
my $formula2=$templateName;print("				<input type=\"hidden\" name=\"templateName\" value=\"$formula2\">\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
print("					<select name=\"selectHosts\" size=\"10\" multiple>\n");
foreach my $hostListKey (sort(keys(%$hostList))) {
my $formula3=$hostListKey;my $formula4=$hostListKey;print("						<option value=\"$formula3\">$formula4</option>\n");
}
print("					</select>\n");
print("				</td>\n");
print("				<td class=\"darkGray\" align=\"center\" valign=\"bottom\"><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>\n");
print("				</form>\n");
print("			</tr>\n");
 } else {
print("			<tr>\n");
print("				<td colspan=\"2\" class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
 if ($hostListLen == 0) {
print("						<span class=\"table1Text1\">No hosts are available</span>\n");
 } else {
print("						<span class=\"table1Text1\">All available hosts are already in host group</span>\n");
 }
print("				</td>\n");
print("			</tr>\n");
 }
print("	</table>\n");
 my $applyToHostList = $sessionObj->param('applyToHostList');
 if (keys(%$applyToHostList) != 0) {
print("		<table width=\"500\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Apply Template to Host List</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" width=\"10\">Actions</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">IP</th>\n");
print("			</tr>\n");
foreach my $hostName (sort(keys(%$applyToHostList))) {
my $ip = $applyToHostList->{$hostName};
my $queryString = "action=removeHost" . "&templateName=". URLEncode($templateName) . "&hostName=". URLEncode($hostName);
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"center\" valign=\"middle\" width=\"10\">\n");
print("					<table width=\"100%\" cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("						<tr>\n");
my $formula5=$queryString;my $formula6=$hostName;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?$formula5\" onclick=\"return warnOnClickAnchor('Are you sure you want to remove $formula6');\">Remove From List</a></th>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
my $formula7=$hostName;print("				<td align=\"left\" valign=\"top\" nowrap class=\"liteGray\"><span class=\"table1Text1\">$formula7</span></td>\n");
my $formula8=$ip;print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula8</span></td>\n");
print("			</tr>\n");
}
print("			<tr>\n");
print("				<form action=\"index.pl\" method=\"post\">\n");
print("				<input type=\"hidden\" name=\"action\" value=\"applyTemplate2Hosts\">\n");
my $formula9=$templateName;print("				<input type=\"hidden\" name=\"templateName\" value=\"$formula9\">\n");
print("				<td class=\"liteGray\" valign=\"top\" align=\"center\" colspan=\"3\"><input class=\"liteButton\" type=\"submit\" value=\"Apply to Hosts\"></td>\n");
print("				</form>\n");
print("			</tr>\n");
print("	</table>\n");
 } else {
print("		<table width=\"500\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Apply Template to Host List</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">IP</th>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">&nbsp;</span></td>\n");
print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">&nbsp;</span></td>\n");
print("			</tr>\n");
print("	</table>\n");
 }
print("	</body>\n");
print("</html>\n");
