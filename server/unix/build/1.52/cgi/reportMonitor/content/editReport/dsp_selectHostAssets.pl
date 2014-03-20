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
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostAssets\">\n");
my $formula1=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula1\">\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Host Group</legend>\n");
print("							<select name=\"hostGroupID\" size=\"1\" onchange=\"submit();\">\n");
foreach my $hostGroupName (@$hostGroupArray) {
my $formula2=$hostGroupName;my $formula3=$hostGroupName eq $hostGroupID ? 'selected' : ' ';my $formula4=$hostGroupName;print("									<option value=\"$formula2\" $formula3>$formula4</option>\n");
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
print("	<input type=\"hidden\" name=\"action\" value=\"insertHostAssets\">\n");
my $formula5=$reportNameID;print("	<input type=\"hidden\" name=\"reportNameID\" value=\"$formula5\">\n");
my $formula6=$hostGroupID;print("	<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula6\">\n");
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Hosts</legend>\n");
print("								<select name=\"selectHosts\" size=\"5\" multiple>\n");
 foreach my $contentStruct (@$hostArray) {
my $value="$contentStruct->{'hostName'}";
my $formula7=$value;my $formula8=searchArray($selectHosts, $value) ? 'selected' : ' ';my $formula9=$value;print("									<option value=\"$formula7\" $formula8>$formula9</option>\n");
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
my $formula10=searchArray($cpu, 'model') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"cpu\" value=\"model\" $formula10></td>\n");
print("									<td nowrap>CPU Model</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula11=searchArray($cpu, 'speed') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"cpu\" value=\"speed\" $formula11></td>\n");
print("									<td nowrap>CPU Speed</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula12=searchArray($cpu, 'number') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"cpu\" value=\"number\" $formula12></td>\n");
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
my $formula13=searchArray($memory, 'total') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"memory\" value=\"total\" $formula13></td>\n");
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
my $formula14=searchArray($os, 'name') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"os\" value=\"name\" $formula14></td>\n");
print("									<td nowrap>OS Name</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula15=searchArray($os, 'version') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"os\" value=\"version\" $formula15></td>\n");
print("									<td nowrap>OS Version</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula16=searchArray($os, 'kernel') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"os\" value=\"kernel\" $formula16></td>\n");
print("									<td nowrap>Kernel Version</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula17=searchArray($os, 'patchList') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"os\" value=\"patchList\" $formula17></td>\n");
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
print("					<td class=\"liteGray\" valign=\"top\" align=\"center\"><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"ADD\"></td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
print("	</form>\n");
}
print("</table>\n");
