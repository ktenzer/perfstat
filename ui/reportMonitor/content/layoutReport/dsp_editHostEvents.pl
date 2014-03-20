use strict;
package main;
print("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
if ($sessionObj->param("userMessage1") ne "") {
print("	<tr>\n");
my $formula0=$sessionObj->param("userMessage1");print("		<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"userMessage\">$formula0</span></td>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<td class=\"liteGray\" valign=\"top\" align=\"left\"><img name=\"xallHosts_host1\" src=\"../../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("	</tr>\n");
$sessionObj->param("userMessage1", "");
 }
 if (@$hostGroupArray == 0) {
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Host Groups</legend>\n");
print("							<b>There are no host groups to select</b>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
} else {
print("	<tr>\n");
print("		<td>\n");
print("			<form action=\"index.pl\" method=\"post\">\n");
print("			<input type=\"hidden\" name=\"displayMode\" value=\"edit\">\n");
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostEvent\">\n");
my $formula1=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula1\">\n");
my $formula2=$contentID;print("			<input type=\"hidden\" name=\"contentID\" value=\"$formula2\">\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Host Group</legend>\n");
print("							<select name=\"hostGroupID\" size=\"1\" onchange=\"submit();\">\n");
foreach my $hostGroupName (@$hostGroupArray) {
my $formula3=$hostGroupName;my $formula4=$hostGroupName eq $hostGroupID ? 'selected' : ' ';my $formula5=$hostGroupName;print("									<option value=\"$formula3\" $formula4>$formula5</option>\n");
}
print("							</select>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("			</form>\n");
print("		</td>\n");
print("	</tr>\n");
print("	<form name=\"selectHost\" action=\"index.pl\" method=\"get\">\n");
print("		<input type=\"hidden\" name=\"displayMode\" value=\"edit\">\n");
print("		<input type=\"hidden\" name=\"contentType\" value=\"hostEvent\">\n");
my $formula6=$reportNameID;print("		<input type=\"hidden\" name=\"reportNameID\" value=\"$formula6\">\n");
my $formula7=$contentID;print("		<input type=\"hidden\" name=\"contentID\" value=\"$formula7\">\n");
my $formula8=$hostGroupID;print("		<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula8\">\n");
my $formula9=$selectHosts->[0];print("		<input type=\"hidden\" name=\"selectHosts\" value=\"$formula9\">\n");
print("	</form>\n");
print("	<form action=\"index.pl\" method=\"post\">\n");
print("	<input type=\"hidden\" name=\"action\" value=\"updateHostEvents\">\n");
my $formula10=$hostGroupID;print("	<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula10\">\n");
my $formula11=$reportNameID;print("	<input type=\"hidden\" name=\"reportNameID\" value=\"$formula11\">\n");
my $formula12=$contentID;print("	<input type=\"hidden\" name=\"contentID\" value=\"$formula12\">\n");
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>		\n");
print("            				<legend align=\"top\">Host</legend>\n");
print("            				<select name=\"selectHosts\" onChange=\"document.forms.selectHost.selectHosts.value=this.options[this.selectedIndex].value; document.forms.selectHost.submit();\">>\n");
 foreach my $contentStruct (@$hostArray) {
my $value="$contentStruct->{'hostName'}";
my $formula13=$value;my $formula14=searchArray($selectHosts, $value) ? 'selected' : ' ';my $formula15=$value;print("									<option value=\"$formula13\" $formula14>$formula15</option>\n");
}
print("							</select>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Services</legend>\n");
print("							<select name=\"selectServices\"  size=\"1\">\n");
 foreach my $serviceName (@$serviceArray) {
my $formula16=$serviceName;my $formula17=searchArray($selectServices, $serviceName) ? 'selected' : ' ';my $formula18=$serviceName;print("									<option value=\"$formula16\" $formula17>$formula18</option>\n");
}
print("							</select>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<td align=\"center\"><table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n");
print("          <tr> \n");
print("            <td><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"UPDATE\"></td>\n");
print("            <td>&nbsp;</td>\n");
my $formula19=$reportNameID;print("            <td><input class=\"liteButton\" type=\"button\" name=\"clear\" value=\"Go Back\" onclick=\"location='index.pl?reportNameID=$formula19';\"></td>\n");
print("          </tr>\n");
print("        </table></td>\n");
print("	</tr>\n");
print("	</form>\n");
}
print("</table>\n");
