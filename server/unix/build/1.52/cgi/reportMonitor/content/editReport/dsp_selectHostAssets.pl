use strict;
package main;
print("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
if ($sessionObj->param("userMessage1") ne "") {
print("	<tr>
my $formula0=$sessionObj->param("userMessage1");print("		<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"userMessage\">$formula0</span></td>
print("	</tr>
print("	<tr>
print("		<td class=\"liteGray\" valign=\"top\" align=\"left\"><img name=\"xallHosts_host1\" src=\"../../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>
print("	</tr>
$sessionObj->param("userMessage1", "");
 }
 if (@$hostGroupArray == 0) {
print("	<tr>
print("		<td>
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("							<legend align=\"top\">Host Groups</legend>
print("							<b>There are no host groups to select</b>
print("						</fieldset>
print("					</td>
print("				</tr>
print("			</table>
print("		</td>
print("	</tr>
} else {
print("	<tr>
print("		<td>
print("			<form action=\"index.pl\" method=\"post\">
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostAssets\">
my $formula1=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula1\">
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("							<legend align=\"top\">Host Group</legend>
print("							<select name=\"hostGroupID\" size=\"1\" onchange=\"submit();\">
foreach my $hostGroupName (@$hostGroupArray) {
my $formula2=$hostGroupName;my $formula3=$hostGroupName eq $hostGroupID ? 'selected' : ' ';my $formula4=$hostGroupName;print("									<option value=\"$formula2\" $formula3>$formula4</option>
}
print("							</select>
print("						</fieldset>
print("					</td>
print("				</tr>
print("			</table>
print("			</form>
print("		</td>
print("	</tr>
print("	<form action=\"index.pl\" method=\"post\">
print("	<input type=\"hidden\" name=\"action\" value=\"insertHostAssets\">
my $formula5=$reportNameID;print("	<input type=\"hidden\" name=\"reportNameID\" value=\"$formula5\">
my $formula6=$hostGroupID;print("	<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula6\">
print("	<tr>
print("		<td>
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("							<legend align=\"top\">Hosts</legend>
print("								<select name=\"selectHosts\" size=\"5\" multiple>
 foreach my $contentStruct (@$hostArray) {
my $value="$contentStruct->{'hostName'}";
my $formula7=$value;my $formula8=searchArray($selectHosts, $value) ? 'selected' : ' ';my $formula9=$value;print("									<option value=\"$formula7\" $formula8>$formula9</option>
}
print("							</select>
print("						</fieldset>
print("					</td>
print("				</tr>
print("			</table>
print("		</td>
print("	</tr>
print("	<tr>
print("		<td>
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("							<legend align=\"top\">CPU</legend>
print("							<table border=\"0\" cellpadding=\"0\" cellspacing=\"3\">
print("								<tr>
my $formula10=searchArray($cpu, 'model') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"cpu\" value=\"model\" $formula10></td>
print("									<td nowrap>CPU Model</td>
print("									<td>&nbsp;</td>
my $formula11=searchArray($cpu, 'speed') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"cpu\" value=\"speed\" $formula11></td>
print("									<td nowrap>CPU Speed</td>
print("									<td>&nbsp;</td>
my $formula12=searchArray($cpu, 'number') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"cpu\" value=\"number\" $formula12></td>
print("									<td nowrap>CPU Number</td>
print("								</tr>
print("							</table>
print("						</fieldset>
print("					</td>
print("				</tr>
print("			</table>
print("		</td>
print("	</tr>
print("	<tr>
print("		<td>
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("							<legend align=\"top\">Memory</legend>
print("							<table border=\"0\" cellpadding=\"0\" cellspacing=\"3\">
print("								<tr>
my $formula13=searchArray($memory, 'total') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"memory\" value=\"total\" $formula13></td>
print("									<td nowrap>Total Memory</td>
print("								</tr>
print("							</table>
print("						</fieldset>
print("					</td>
print("				</tr>
print("			</table>
print("		</td>
print("	</tr>
print("	<tr>
print("		<td>
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("							<legend align=\"top\">Operating System</legend>
print("							<table border=\"0\" cellpadding=\"0\" cellspacing=\"3\">
print("								<tr>
my $formula14=searchArray($os, 'name') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"os\" value=\"name\" $formula14></td>
print("									<td nowrap>OS Name</td>
print("									<td>&nbsp;</td>
my $formula15=searchArray($os, 'version') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"os\" value=\"version\" $formula15></td>
print("									<td nowrap>OS Version</td>
print("									<td>&nbsp;</td>
my $formula16=searchArray($os, 'kernel') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"os\" value=\"kernel\" $formula16></td>
print("									<td nowrap>Kernel Version</td>
print("									<td>&nbsp;</td>
my $formula17=searchArray($os, 'patchList') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"os\" value=\"patchList\" $formula17></td>
print("									<td nowrap>Patch List</td>
print("								</tr>
print("							</table>
print("						</fieldset>
print("					</td>
print("				</tr>
print("			</table>
print("		</td>
print("	</tr>
print("	<tr>
print("		<td>
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td class=\"liteGray\" valign=\"top\" align=\"center\"><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"ADD\"></td>
print("				</tr>
print("			</table>
print("		</td>
print("	</tr>
print("	</form>
}
print("</table>\n");