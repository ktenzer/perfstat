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
print("			<input type=\"hidden\" name=\"displayMode\" value=\"edit\">
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostEvent\">
my $formula1=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula1\">
my $formula2=$contentID;print("			<input type=\"hidden\" name=\"contentID\" value=\"$formula2\">
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("							<legend align=\"top\">Host Group</legend>
print("							<select name=\"hostGroupID\" size=\"1\" onchange=\"submit();\">
foreach my $hostGroupName (@$hostGroupArray) {
my $formula3=$hostGroupName;my $formula4=$hostGroupName eq $hostGroupID ? 'selected' : ' ';my $formula5=$hostGroupName;print("									<option value=\"$formula3\" $formula4>$formula5</option>
}
print("							</select>
print("						</fieldset>
print("					</td>
print("				</tr>
print("			</table>
print("			</form>
print("		</td>
print("	</tr>
print("	<form name=\"selectHost\" action=\"index.pl\" method=\"get\">
print("		<input type=\"hidden\" name=\"displayMode\" value=\"edit\">
print("		<input type=\"hidden\" name=\"contentType\" value=\"hostEvent\">
my $formula6=$reportNameID;print("		<input type=\"hidden\" name=\"reportNameID\" value=\"$formula6\">
my $formula7=$contentID;print("		<input type=\"hidden\" name=\"contentID\" value=\"$formula7\">
my $formula8=$hostGroupID;print("		<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula8\">
my $formula9=$selectHosts->[0];print("		<input type=\"hidden\" name=\"selectHosts\" value=\"$formula9\">
print("	</form>
print("	<form action=\"index.pl\" method=\"post\">
print("	<input type=\"hidden\" name=\"action\" value=\"updateHostEvents\">
my $formula10=$hostGroupID;print("	<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula10\">
my $formula11=$reportNameID;print("	<input type=\"hidden\" name=\"reportNameID\" value=\"$formula11\">
my $formula12=$contentID;print("	<input type=\"hidden\" name=\"contentID\" value=\"$formula12\">
print("	<tr>
print("		<td>
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>		
print("            				<legend align=\"top\">Host</legend>
print("            				<select name=\"selectHosts\" onChange=\"document.forms.selectHost.selectHosts.value=this.options[this.selectedIndex].value; document.forms.selectHost.submit();\">>
 foreach my $contentStruct (@$hostArray) {
my $value="$contentStruct->{'hostName'}";
my $formula13=$value;my $formula14=searchArray($selectHosts, $value) ? 'selected' : ' ';my $formula15=$value;print("									<option value=\"$formula13\" $formula14>$formula15</option>
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
print("							<legend align=\"top\">Services</legend>
print("							<select name=\"selectServices\"  size=\"1\">
 foreach my $serviceName (@$serviceArray) {
my $formula16=$serviceName;my $formula17=searchArray($selectServices, $serviceName) ? 'selected' : ' ';my $formula18=$serviceName;print("									<option value=\"$formula16\" $formula17>$formula18</option>
}
print("							</select>
print("						</fieldset>
print("					</td>
print("				</tr>
print("			</table>
print("		</td>
print("	</tr>
print("	<tr>
print("		<td align=\"center\"><table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">
print("          <tr> 
print("            <td><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"UPDATE\"></td>
print("            <td>&nbsp;</td>
my $formula19=$reportNameID;print("            <td><input class=\"liteButton\" type=\"button\" name=\"clear\" value=\"Go Back\" onclick=\"location='index.pl?reportNameID=$formula19';\"></td>
print("          </tr>
print("        </table></td>
print("	</tr>
print("	</form>
}
print("</table>\n");