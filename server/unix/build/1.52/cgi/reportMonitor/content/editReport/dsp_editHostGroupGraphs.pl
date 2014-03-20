use strict;
package main;
print("<form action=\"index.pl\" method=\"post\">\n");
print("<input type=\"hidden\" name=\"action\" value=\"editHostGroupGraphs\">\n");
my $formula0=$reportNameID;print("<input type=\"hidden\" name=\"reportNameID\" value=\"$formula0\">\n");
my $formula1=$contentID;print("<input type=\"hidden\" name=\"contentID\" value=\"$formula1\">\n");
print("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
if ($sessionObj->param("userMessage1") ne "") {
print("	<tr>\n");
my $formula2=$sessionObj->param("userMessage1");print("		<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"userMessage\">$formula2</span></td>\n");
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
print("							<select name=\"selectHostGroups\" size=\"1\">\n");
foreach my $hostGroupName (@$hostGroupArray) {
my $formula3=$hostGroupName;my $formula4=searchArray($selectHostGroups, $hostGroupName) ? 'selected' : ' ';my $formula5=$hostGroupName;print("								<option value=\"$formula3\" $formula4>$formula5</option>\n");
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
print("							<select name=\"selectGraphs\" size=\"1\">\n");
 foreach my $contentStruct (@$graphArray) {
my $value="$contentStruct->{'serviceName'}^$contentStruct->{'graphName'}";
my $formula6=$value;my $formula7=searchArray($selectGraphs, $value) ? 'selected' : ' ';my $formula8=$contentStruct->{'serviceName'};my $formula9=$contentStruct->{'graphName'};print("								<option value=\"$formula6\" $formula7>$formula8 :: $formula9</option>\n");
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
my $formula10=searchArray($graphInterval, 'day') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"day\" $formula10></td>\n");
print("									<td>day</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula11=searchArray($graphInterval, 'week') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"week\" $formula11></td>\n");
print("									<td>week</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula12=searchArray($graphInterval, 'month') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"month\" $formula12></td>\n");
print("									<td>month</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula13=searchArray($graphInterval, 'year') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"year\" $formula13></td>\n");
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
my $formula14=searchArray($graphType, 'bar') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphType\" value=\"bar\" $formula14></td>\n");
print("									<td>Bar</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula15=searchArray($graphType, 'pie') ? 'checked' : ' ';print("									<td><input type=\"radio\"name=\"graphType\" value=\"pie\" $formula15></td>\n");
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
print("				<td class=\"liteGray\" valign=\"top\" align=\"center\">\n");
print("					<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n");
print("					  <tr>\n");
print("						<td><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"UPDATE\"></td>\n");
print("						<td>&nbsp;</td>\n");
my $formula16=$reportNameID;print("						<td><input class=\"liteButton\" type=\"button\" name=\"clear\" value=\"Go Back\" onclick=\"location='index.pl?reportNameID=$formula16';\"></td>\n");
print("					  </tr>\n");
print("					</table>\n");
print("				</td>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
}
print("</table>\n");
print("</form>\n");
