use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>Perfstat Performance and Status Monitor</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/contentFrame.js\"></script>\n");
print("	</head>\n");
print("\n");
print("	<body onLoad=\"parent.navigation.setLinkChosen('hostConfig');\">\n");
my $formula0=$sessionObj->param("selectedAdmin");print("		<div class=\"navHeader\">Host Config :: $formula0</div>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"4\" valign=\"middle\" align=\"left\">Add Host</td>\n");
print("			</tr>\n");
 if ($sessionObj->param("userMessage") ne "") {
print("			<tr>\n");
my $formula1=$sessionObj->param("userMessage");print("				<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"4\"><span class=\"userMessage\">$formula1</span></td>\n");
print("			</tr>\n");
 $sessionObj->param("userMessage", "");
 }
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">IP</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"top\" align=\"left\">OS</th>\n");
print("				<th nowrap=\"nowrap\">Actions</th>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<form name=\"insertItem\" action=\"index.pl\" method=\"post\">\n");
print("				<input type=\"hidden\" name=\"action\" value=\"insertItem\">\n");
my $formula2=$newHostName;print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\"><input type=\"text\" name=\"newHostName\" value=\"$formula2\" size=\"24\"></td>\n");
my $formula3=$ipAddress;print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><input type=\"text\" name=\"ipAddress\" value=\"$formula3\" size=\"24\"></td>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
print("					<select name=\"osName\" size=\"1\">\n");
 foreach my $osNameTemp (sort( @$osList)) {
my $formula4=$osNameTemp;my $formula5=$osNameTemp eq $osName ? "selected" : "";;my $formula6=$osNameTemp;print("							<option value=\"$formula4\" $formula5>$formula6</option>\n");
}
print("					</select>\n");
print("				</td>\n");
print("				<td class=\"darkGray\" align=\"center\" valign=\"middle\"><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>\n");
print("				</form>\n");
print("			</tr>\n");
print("		</table>\n");
 if ($lenHostArray > 0) {
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"4\">Manage Hosts</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"10\">Actions</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">IP</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">OS</th>\n");
print("			</tr>\n");
 foreach my $tempArray (@$hostArray) {
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\" width=\"10\">\n");
print("					<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("						<tr>\n");
$queryString = "hostName=$tempArray->[0]&newHostName=$tempArray->[0]&ipAddress=$tempArray->[1]&osName=$tempArray->[2]";
my $formula7=$queryString;print("								<th nowrap=\"nowrap\"><a href=\"../level2/index.pl?$formula7\">Config</a></th>\n");
my $formula8=$tempArray->[0];my $formula9=$tempArray->[0];print("								<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteItem&hostName=$formula8\" onclick=\"return warnOnClickAnchor('Are you sure you want to delete $formula9');\">Delete</a></th>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
my $formula10=$tempArray->[0];print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\"><span class=\"table1Text1\">$formula10</span></td>\n");
my $formula11=$tempArray->[1];print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula11</span></td>\n");
my $formula12=$tempArray->[2];print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\"><span class=\"table1Text2\">$formula12</span></td>\n");
print("			</tr>\n");
 }
print("		</table>\n");
}
print("	</body>\n");
print("</html>\n");
