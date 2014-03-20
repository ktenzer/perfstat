use strict;
package main;
print("<form action=\"index.pl\" method=\"post\">
print("<input type=\"hidden\" name=\"action\" value=\"editHostGroupGraphs\">
my $formula0=$reportNameID;print("<input type=\"hidden\" name=\"reportNameID\" value=\"$formula0\">
my $formula1=$contentID;print("<input type=\"hidden\" name=\"contentID\" value=\"$formula1\">
print("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
if ($sessionObj->param("userMessage1") ne "") {
print("	<tr>
my $formula2=$sessionObj->param("userMessage1");print("		<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"userMessage\">$formula2</span></td>
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
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("							<legend align=\"top\">Host Groups</legend>
print("							<select name=\"selectHostGroups\" size=\"1\">
foreach my $hostGroupName (@$hostGroupArray) {
my $formula3=$hostGroupName;my $formula4=searchArray($selectHostGroups, $hostGroupName) ? 'selected' : ' ';my $formula5=$hostGroupName;print("								<option value=\"$formula3\" $formula4>$formula5</option>
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
print("							<legend align=\"top\">Host Group Graphs</legend>
print("							<select name=\"selectGraphs\" size=\"1\">
 foreach my $contentStruct (@$graphArray) {
my $value="$contentStruct->{'serviceName'}^$contentStruct->{'graphName'}";
my $formula6=$value;my $formula7=searchArray($selectGraphs, $value) ? 'selected' : ' ';my $formula8=$contentStruct->{'serviceName'};my $formula9=$contentStruct->{'graphName'};print("								<option value=\"$formula6\" $formula7>$formula8 :: $formula9</option>
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
print("							<legend align=\"top\">Graph Interval</legend>
print("							<table border=\"0\" cellpadding=\"0\" cellspacing=\"3\">
print("								<tr>
my $formula10=searchArray($graphInterval, 'day') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"day\" $formula10></td>
print("									<td>day</td>
print("									<td>&nbsp;</td>
my $formula11=searchArray($graphInterval, 'week') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"week\" $formula11></td>
print("									<td>week</td>
print("									<td>&nbsp;</td>
my $formula12=searchArray($graphInterval, 'month') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"month\" $formula12></td>
print("									<td>month</td>
print("									<td>&nbsp;</td>
my $formula13=searchArray($graphInterval, 'year') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"year\" $formula13></td>
print("									<td>year</td>
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
print("							<legend align=\"top\">Graph Type</legend>
print("							<table border=\"0\" cellpadding=\"0\" cellspacing=\"3\">
print("								<tr>
my $formula14=searchArray($graphType, 'bar') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphType\" value=\"bar\" $formula14></td>
print("									<td>Bar</td>
print("									<td>&nbsp;</td>
my $formula15=searchArray($graphType, 'pie') ? 'checked' : ' ';print("									<td><input type=\"radio\"name=\"graphType\" value=\"pie\" $formula15></td>
print("									<td>Pie</td>
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
print("				<td class=\"liteGray\" valign=\"top\" align=\"center\">
print("					<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">
print("					  <tr>
print("						<td><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"UPDATE\"></td>
print("						<td>&nbsp;</td>
my $formula16=$reportNameID;print("						<td><input class=\"liteButton\" type=\"button\" name=\"clear\" value=\"Go Back\" onclick=\"location='index.pl?reportNameID=$formula16';\"></td>
print("					  </tr>
print("					</table>
print("				</td>
print("			</table>
print("		</td>
print("	</tr>
}
print("</table>
print("</form>\n");