use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>Perfstat Performance and Status Monitor</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/contentFrame.js\"></script>\n");
print("	</head>\n");
print("	<body onLoad=\"parent.navigation.setLinkChosen('hostConfig');\">\n");
print("		<div class=\"navHeader\">Host Config</div>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"4\" valign=\"middle\" align=\"left\">Add Host</td>\n");
print("			</tr>\n");
 if ($sessionObj->param("userMessage") ne "") {
print("			<tr>\n");
my $formula0=$sessionObj->param("userMessage1");print("				<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"4\"><span class=\"userMessage\">$formula0</span></td>\n");
print("			</tr>\n");
 $sessionObj->param("userMessage1", "");
 }
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">IP</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"top\" align=\"left\">OS</th>\n");
print("				<th nowrap=\"nowrap\">Actions</th>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<form name=\"insertItem\" action=\"index.pl\" method=\"post\">\n");
print("				<input type=\"hidden\" name=\"action\" value=\"add\">\n");
my $formula1=$newHostName;print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\"><input type=\"text\" name=\"newHostName\" value=\"$formula1\" size=\"24\"></td>\n");
my $formula2=$newipAddress;print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><input type=\"text\" name=\"newipAddress\" value=\"$formula2\" size=\"24\"></td>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
print("					<select name=\"newosName\" size=\"1\">\n");
 foreach my $osNameTemp (sort( @$osList)) {
my $formula3=$osNameTemp;my $formula4=$osNameTemp eq $newosName ? "selected" : "";;my $formula5=$osNameTemp;print("							<option value=\"$formula3\" $formula4>$formula5</option>\n");
}
print("					</select>\n");
print("				</td>\n");
print("				<td class=\"darkGray\" align=\"center\" valign=\"middle\"><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>\n");
print("				</form>\n");
print("			</tr>\n");
print("		</table>\n");
 if ($lenHostArray > 0) {
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"4\">Manage Hosts</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"2%\">Actions</th>\n");
print("				<th align=\"left\" valign=\"middle\" nowrap=\"nowrap\">Host Name</th>\n");
print("				<th align=\"left\" valign=\"middle\" nowrap=\"nowrap\">IP</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">OS</th>\n");
print("			</tr>\n");
foreach my $tempArray (@$hostArray) {
if ($editFlag eq $tempArray->[0] && $sessionObj->param("userMessage2") ne "") {
print("				<tr>\n");
print("					<td class=\"liteGray\" align=\"left\" valign=\"top\" width=\"2%\">&nbsp;</td>\n");
my $formula6=$sessionObj->param("userMessage2");print("					<td colspan=\"3\" align=\"left\" valign=\"top\" class=\"liteGray\"><span class=\"userMessage\">$formula6</span></td>\n");
print("				</tr>\n");
 $sessionObj->param("userMessage2", "");
}
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\" width=\"10\">\n");
print("					<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("						<tr>\n");
$queryString = "hostName=$tempArray->[0]";
if ($editFlag ne $tempArray->[0]) {
my $formula7=$tempArray->[0];print("								<th nowrap=\"nowrap\"><a href=\"index.pl?editFlag=$formula7\">&nbsp;Edit&nbsp;</a></th>\n");
 } else {
print("								<th nowrap=\"nowrap\"><a href=\"index.pl\">Clear</a></th>\n");
}
my $formula8=$queryString;print("							<th nowrap=\"nowrap\"><a href=\"../alerts/index.pl?$formula8\">Alerts</a></th>\n");
my $formula9=$queryString;print("							<th nowrap=\"nowrap\"><a href=\"../metrics/index.pl?$formula9\">Metrics</a></th>\n");
my $formula10=$tempArray->[0];my $formula11=$tempArray->[0];print("							<th nowrap=\"nowrap\"><a href=\"index.pl?action=delete&hostName=$formula10\" onclick=\"return warnOnClickAnchor('Are you sure you want to delete $formula11');\">Delete</a></th>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
print("				<form action=\"index.pl\" method=\"get\">\n");
print("				<input type=\"hidden\" name=\"action\" value=\"edit\">\n");
my $formula12=$tempArray->[0];print("				<input type=\"hidden\" name=\"hostName\" value=\"$formula12\">\n");
print("				<td width=\"25%\" align=\"left\" valign=\"top\" nowrap class=\"liteGray\">\n");
if ($editFlag ne $tempArray->[0]) {
my $formula13=$tempArray->[1];print("						<span class=\"table1Text1\"><span class=\"table1Text1\">$formula13</span>\n");
 } else {
my $formula14=$tempArray->[1];print("						<input type=\"text\" name=\"editName\" value=\"$formula14\" size=\"30\" onKeyPress=\"return submitenter(this,event)\">\n");
}
print("				</td>\n");
print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\">\n");
if ($editFlag ne $tempArray->[0]) {
my $formula15=$tempArray->[2];print("						<span class=\"table1Text2\">$formula15</span>\n");
 } else {
my $formula16=$tempArray->[2];print("						<input type=\"text\" name=\"editipAddress\" value=\"$formula16\" size=\"24\" onKeyPress=\"return submitenter(this,event)\">\n");
}
print("				</td>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
my $formula17=$tempArray->[3];print("					<span class=\"table1Text2\">$formula17</span>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
 }
print("		</table>\n");
}
print("	</body>\n");
print("</html>\n");
