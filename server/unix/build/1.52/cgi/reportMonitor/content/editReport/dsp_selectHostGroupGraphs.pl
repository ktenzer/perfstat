use strict;
package main;
print("<form action=\"index.pl\" method=\"post\">
print("<input type=\"hidden\" name=\"action\" value=\"insertHostGroupGraphs\">
my $formula0=$reportNameID;print("<input type=\"hidden\" name=\"reportNameID\" value=\"$formula0\">
print("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
if ($sessionObj->param("userMessage1") ne "") {
print("	<tr>
my $formula1=$sessionObj->param("userMessage1");print("		<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"userMessage\">$formula1</span></td>
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
print("							<select name=\"selectHostGroups\" size=\"4\" multiple>
foreach my $hostGroupName (@$hostGroupArray) {
my $formula2=$hostGroupName;my $formula3=searchArray($selectHostGroups, $hostGroupName) ? 'selected' : ' ';my $formula4=$hostGroupName;print("								<option value=\"$formula2\" $formula3>$formula4</option>
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
print("							<select name=\"selectGraphs\" size=\"5\" multiple>
 foreach my $contentStruct (@$graphArray) {
my $value="$contentStruct->{'serviceName'}^$contentStruct->{'graphName'}";
my $formula5=$value;my $formula6=searchArray($selectGraphs, $value) ? 'selected' : ' ';my $formula7=$contentStruct->{'serviceName'};my $formula8=$contentStruct->{'graphName'};print("								<option value=\"$formula5\" $formula6>$formula7 :: $formula8</option>
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
my $formula9=searchArray($graphInterval, 'day') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"day\" $formula9></td>
print("									<td>day</td>
print("									<td>&nbsp;</td>
my $formula10=searchArray($graphInterval, 'week') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"week\" $formula10></td>
print("									<td>week</td>
print("									<td>&nbsp;</td>
my $formula11=searchArray($graphInterval, 'month') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"month\" $formula11></td>
print("									<td>month</td>
print("									<td>&nbsp;</td>
my $formula12=searchArray($graphInterval, 'year') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"year\" $formula12></td>
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
my $formula13=searchArray($graphType, 'bar') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphType\" value=\"bar\" $formula13></td>
print("									<td>Bar</td>
print("									<td>&nbsp;</td>
my $formula14=searchArray($graphType, 'pie') ? 'checked' : ' ';print("									<td><input type=\"checkbox\"name=\"graphType\" value=\"pie\" $formula14></td>
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
print("				<td class=\"liteGray\" valign=\"top\" align=\"center\"><input class=\"liteButton\" type=\"submit\" value=\"ADD\"></td>
print("			</table>
print("		</td>
print("	</tr>
}
print("</table>
print("</form>\n");