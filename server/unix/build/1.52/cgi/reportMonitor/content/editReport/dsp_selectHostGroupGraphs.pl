use strict;
package main;
print("<form action=\"index.pl\" method=\"post\">\n");
print("<input type=\"hidden\" name=\"action\" value=\"insertHostGroupGraphs\">\n");
my $formula0=$reportNameID;print("<input type=\"hidden\" name=\"reportNameID\" value=\"$formula0\">\n");
print("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
if ($sessionObj->param("userMessage1") ne "") {
print("	<tr>\n");
my $formula1=$sessionObj->param("userMessage1");print("		<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"userMessage\">$formula1</span></td>\n");
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
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Host Groups</legend>\n");
print("							<select name=\"selectHostGroups\" size=\"4\" multiple>\n");
foreach my $hostGroupName (@$hostGroupArray) {
my $formula2=$hostGroupName;my $formula3=searchArray($selectHostGroups, $hostGroupName) ? 'selected' : ' ';my $formula4=$hostGroupName;print("								<option value=\"$formula2\" $formula3>$formula4</option>\n");
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
print("							<legend align=\"top\">Host Group Graphs</legend>\n");
print("							<select name=\"selectGraphs\" size=\"5\" multiple>\n");
 foreach my $contentStruct (@$graphArray) {
my $value="$contentStruct->{'serviceName'}^$contentStruct->{'graphName'}";
my $formula5=$value;my $formula6=searchArray($selectGraphs, $value) ? 'selected' : ' ';my $formula7=$contentStruct->{'serviceName'};my $formula8=$contentStruct->{'graphName'};print("								<option value=\"$formula5\" $formula6>$formula7 :: $formula8</option>\n");
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
print("							<legend align=\"top\">Graph Interval</legend>\n");
print("							<table border=\"0\" cellpadding=\"0\" cellspacing=\"3\">\n");
print("								<tr>\n");
my $formula9=searchArray($graphInterval, 'day') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"day\" $formula9></td>\n");
print("									<td>day</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula10=searchArray($graphInterval, 'week') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"week\" $formula10></td>\n");
print("									<td>week</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula11=searchArray($graphInterval, 'month') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"month\" $formula11></td>\n");
print("									<td>month</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula12=searchArray($graphInterval, 'year') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"year\" $formula12></td>\n");
print("									<td>year</td>\n");
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
print("							<legend align=\"top\">Graph Type</legend>\n");
print("							<table border=\"0\" cellpadding=\"0\" cellspacing=\"3\">\n");
print("								<tr>\n");
my $formula13=searchArray($graphType, 'bar') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphType\" value=\"bar\" $formula13></td>\n");
print("									<td>Bar</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula14=searchArray($graphType, 'pie') ? 'checked' : ' ';print("									<td><input type=\"checkbox\"name=\"graphType\" value=\"pie\" $formula14></td>\n");
print("									<td>Pie</td>\n");
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
print("				<td class=\"liteGray\" valign=\"top\" align=\"center\"><input class=\"liteButton\" type=\"submit\" value=\"ADD\"></td>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
}
print("</table>\n");
print("</form>\n");
