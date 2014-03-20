use strict;
package main;
print("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
if ($sessionObj->param("userMessage1") ne "") {
print("	<tr>\n");
my $formula0=$sessionObj->param("userMessage1");print("		<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"userMessage\">$formula0</span></td>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<td class=\"liteGray\" valign=\"top\" align=\"left\"><img name=\"xallHosts_host1\" src=\"../../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("	</tr>\n");
$sessionObj->param("userMessage1", "");
 }
 if (@$hostGroupArray == 0) {
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Host Groups</legend>\n");
print("							<b>There are no host groups to select</b>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
} else {
print("	<tr>\n");
print("		<td>\n");
print("			<form action=\"index.pl\" method=\"post\">\n");
print("			<input type=\"hidden\" name=\"displayMode\" value=\"edit\">\n");
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostAssets\">\n");
my $formula1=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula1\">\n");
my $formula2=$contentID;print("			<input type=\"hidden\" name=\"contentID\" value=\"$formula2\">\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Host Group</legend>\n");
print("							<select name=\"hostGroupID\" size=\"1\" onchange=\"submit();\">\n");
foreach my $hostGroupName (@$hostGroupArray) {
my $formula3=$hostGroupName;my $formula4=$hostGroupName eq $hostGroupID ? 'selected' : ' ';my $formula5=$hostGroupName;print("									<option value=\"$formula3\" $formula4>$formula5</option>\n");
}
print("							</select>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("			</form>\n");
print("		</td>\n");
print("	</tr>\n");
print("	<form action=\"index.pl\" method=\"post\">\n");
print("	<input type=\"hidden\" name=\"action\" value=\"updateHostAssets\">\n");
my $formula6=$hostGroupID;print("	<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula6\">\n");
my $formula7=$reportNameID;print("	<input type=\"hidden\" name=\"reportNameID\" value=\"$formula7\">\n");
my $formula8=$contentID;print("	<input type=\"hidden\" name=\"contentID\" value=\"$formula8\">\n");
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Hosts</legend>\n");
print("								<select name=\"selectHosts\" size=\"1\">\n");
 foreach my $contentStruct (@$hostArray) {
my $value="$contentStruct->{'hostName'}";
my $formula9=$value;my $formula10=searchArray($selectHosts, $value) ? 'selected' : ' ';my $formula11=$value;print("									<option value=\"$formula9\" $formula10>$formula11</option>\n");
}
print("							</select>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">CPU</legend>\n");
print("							<table border=\"0\" cellpadding=\"0\" cellspacing=\"3\">\n");
print("								<tr>\n");
my $formula12=searchArray($cpu, 'model') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"cpu\" value=\"model\" $formula12></td>\n");
print("									<td nowrap>CPU Model</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula13=searchArray($cpu, 'speed') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"cpu\" value=\"speed\" $formula13></td>\n");
print("									<td nowrap>CPU Speed</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula14=searchArray($cpu, 'number') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"cpu\" value=\"number\" $formula14></td>\n");
print("									<td nowrap>CPU Number</td>\n");
print("								</tr>\n");
print("							</table>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Memory</legend>\n");
print("							<table border=\"0\" cellpadding=\"0\" cellspacing=\"3\">\n");
print("								<tr>\n");
my $formula15=searchArray($memory, 'total') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"memory\" value=\"total\" $formula15></td>\n");
print("									<td nowrap>Total Memory</td>\n");
print("								</tr>\n");
print("							</table>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Operating System</legend>\n");
print("							<table border=\"0\" cellpadding=\"0\" cellspacing=\"3\">\n");
print("								<tr>\n");
my $formula16=searchArray($os, 'name') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"os\" value=\"name\" $formula16></td>\n");
print("									<td nowrap>OS Name</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula17=searchArray($os, 'version') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"os\" value=\"version\" $formula17></td>\n");
print("									<td nowrap>OS Version</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula18=searchArray($os, 'kernel') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"os\" value=\"kernel\" $formula18></td>\n");
print("									<td nowrap>Kernel Version</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula19=searchArray($os, 'patchList') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"os\" value=\"patchList\" $formula19></td>\n");
print("									<td nowrap>Patch List</td>\n");
print("								</tr>\n");
print("							</table>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td class=\"liteGray\" valign=\"top\" align=\"center\"><table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n");
print("                <tr> \n");
print("                  <td><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"UPDATE\"></td>\n");
print("                  <td>&nbsp;</td>\n");
my $formula20=$reportNameID;print("                  <td><input class=\"liteButton\" type=\"button\" name=\"clear\" value=\"Go Back\" onclick=\"location='index.pl?reportNameID=$formula20';\"></td>\n");
print("                </tr>\n");
print("              </table></td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
print("	</form>\n");
}
print("</table>\n");
