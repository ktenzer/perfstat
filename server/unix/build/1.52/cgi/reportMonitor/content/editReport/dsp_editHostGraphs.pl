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
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostGraph\">\n");
my $formula1=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula1\">\n");
my $formula2=$contentID;print("			<input type=\"hidden\" name=\"contentID\" value=\"$formula2\">\n");
my $formula3=$osName;print("			<input type=\"hidden\" name=\"osName\" value=\"$formula3\">\n");
my $formula4=$graphServiceType;print("			<input type=\"hidden\" name=\"graphServiceType\" value=\"$formula4\">\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Host Group</legend>\n");
print("							<select name=\"hostGroupID\" size=\"1\" onchange=\"submit();\">\n");
foreach my $hostGroupName (@$hostGroupArray) {
my $formula5=$hostGroupName;my $formula6=$hostGroupName eq $hostGroupID ? 'selected' : ' ';my $formula7=$hostGroupName;print("									<option value=\"$formula5\" $formula6>$formula7</option>\n");
}
print("							</select>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("			</form>\n");
print("		</td>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<td>	\n");
print("			<form name=\"selectOS\" action=\"index.pl\" method=\"post\">\n");
print("			<input type=\"hidden\" name=\"displayMode\" value=\"edit\">\n");
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostGraph\">\n");
my $formula8=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula8\">\n");
my $formula9=$contentID;print("			<input type=\"hidden\" name=\"contentID\" value=\"$formula9\">\n");
my $formula10=$hostGroupID;print("			<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula10\">\n");
my $formula11=$graphServiceType;print("			<input type=\"hidden\" name=\"graphServiceType\" value=\"$formula11\">\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("						<legend align=\"top\">OS</legend>\n");
print("						<select name=\"osName\" size=\"1\" onchange=\"submit();\">\n");
 foreach my $osNameTemp (sort( @$osList)) {
my $formula12=$osNameTemp;my $formula13=$osNameTemp eq $osName ? "selected" : "";;my $formula14=$osNameTemp;print("								<option value=\"$formula12\" $formula13>$formula14</option>\n");
}
print("						</select>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("			</form>\n");
print("		</td>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<td>	\n");
print("			<form name=\"selectGraphServiceType\" action=\"index.pl\" method=\"post\">\n");
print("			<input type=\"hidden\" name=\"displayMode\" value=\"edit\">\n");
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostGraph\">\n");
my $formula15=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula15\">\n");
my $formula16=$contentID;print("			<input type=\"hidden\" name=\"contentID\" value=\"$formula16\">\n");
my $formula17=$hostGroupID;print("			<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula17\">\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("						<legend align=\"top\">Graph Service Type</legend>\n");
print("						<select name=\"graphServiceType\" size=\"1\" onchange=\"submit();\">\n");
my $formula18=$graphServiceType eq "singleService" ? "selected" : "";;print("							<option value=\"singleService\" $formula18>Single Service</option>\n");
my $formula19=$graphServiceType eq "singleSubService" ? "selected" : "";;print("							<option value=\"singleSubService\" $formula19>Single Subservice</option>\n");
my $formula20=$graphServiceType eq "aggregateSubService" ? "selected" : "";;print("							<option value=\"aggregateSubService\" $formula20>Aggregate Subservice</option>\n");
print("						</select>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("			</form>\n");
print("		</td>\n");
print("	</tr>\n");
 if ($graphServiceType eq "singleSubService") {
print("		<form name=\"selectGraphOrHost\" action=\"index.pl\" method=\"get\">\n");
print("		<input type=\"hidden\" name=\"displayMode\" value=\"edit\">\n");
print("		<input type=\"hidden\" name=\"contentType\" value=\"hostGraph\">\n");
my $formula21=$reportNameID;print("		<input type=\"hidden\" name=\"reportNameID\" value=\"$formula21\">\n");
my $formula22=$contentID;print("		<input type=\"hidden\" name=\"contentID\" value=\"$formula22\">\n");
my $formula23=$hostGroupID;print("		<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula23\">\n");
my $formula24=$osName;print("		<input type=\"hidden\" name=\"osName\" value=\"$formula24\">\n");
print("		<input type=\"hidden\" name=\"graphServiceType\" value=\"singleSubService\">\n");
my $formula25=$selectGraphs->[0];print("		<input type=\"hidden\" name=\"selectGraphs\" value=\"$formula25\">\n");
my $formula26=$selectHosts->[0];print("		<input type=\"hidden\" name=\"selectHosts\" value=\"$formula26\">\n");
print("		</form>\n");
 }
print("	<form name=\"updateHostGraphs\" action=\"index.pl\" method=\"post\">\n");
print("	<input type=\"hidden\" name=\"action\" value=\"updateHostGraph\">\n");
my $formula27=$hostGroupID;print("	<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula27\">\n");
my $formula28=$reportNameID;print("	<input type=\"hidden\" name=\"reportNameID\" value=\"$formula28\">\n");
my $formula29=$contentID;print("	<input type=\"hidden\" name=\"contentID\" value=\"$formula29\">\n");
my $formula30=$osName;print("	<input type=\"hidden\" name=\"osName\" value=\"$formula30\">\n");
my $formula31=$graphServiceType;print("	<input type=\"hidden\" name=\"graphServiceType\" value=\"$formula31\">\n");
 if ($graphServiceType ne "singleSubService") {
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Graphs</legend>\n");
print("								<select name=\"selectGraphs\" size=\"1\">\n");
 foreach my $contentStruct (@$graphArray) {
my $value="$contentStruct->{'serviceName'}^$contentStruct->{'graphName'}";
my $formula32=$value;my $formula33=searchArray($selectGraphs, $value) ? 'selected' : ' ';my $formula34=$contentStruct->{'serviceName'};my $formula35=$contentStruct->{'graphName'};print("									<option value=\"$formula32\" $formula33>$formula34 :: $formula35</option>\n");
}
print("							</select>\n");
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
print("							<legend align=\"top\">Graph</legend>\n");
print("								<select name=\"selectGraphs\" onChange=\"document.forms.selectGraphOrHost.selectGraphs.value=this.options[this.selectedIndex].value; document.forms.selectGraphOrHost.submit();\">\n");
 foreach my $contentStruct (@$graphArray) {
my $value="$contentStruct->{'serviceName'}^$contentStruct->{'graphName'}";
my $formula36=$value;my $formula37=searchArray($selectGraphs, $value) ? 'selected' : ' ';my $formula38=$contentStruct->{'serviceName'};my $formula39=$contentStruct->{'graphName'};print("									<option value=\"$formula36\" $formula37>$formula38 :: $formula39</option>\n");
}
print("							</select>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
 }
 if ($graphServiceType ne "singleSubService") {
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
my $formula40=$value;my $formula41=searchArray($selectHosts, $value) ? 'selected' : ' ';my $formula42=$value;print("									<option value=\"$formula40\" $formula41>$formula42</option>\n");
}
print("							</select>\n");
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
print("							<legend align=\"top\">Host</legend>\n");
print("								<select name=\"selectHosts\" onChange=\"document.forms.selectGraphOrHost.selectHosts.value=this.options[this.selectedIndex].value; document.forms.selectGraphOrHost.submit();\">\n");
 foreach my $contentStruct (@$hostArray) {
my $value="$contentStruct->{'hostName'}";
my $formula43=$value;my $formula44=searchArray($selectHosts, $value) ? 'selected' : ' ';my $formula45=$value;print("									<option value=\"$formula43\" $formula44>$formula45</option>\n");
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
print("							<legend align=\"top\">SubService</legend>\n");
print("							<select name=\"selectSubServices\"  size=\"1\">\n");
 foreach my $subServiceName (@$subServiceArray) {
my $formula46=$subServiceName;my $formula47=searchArray($selectSubServices, $subServiceName) ? 'selected' : ' ';my $formula48=$subServiceName;print("									<option value=\"$formula46\" $formula47>$formula48</option>\n");
}
print("							</select>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
 }
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Graph Interval</legend>\n");
print("							<table border=\"0\" cellpadding=\"0\" cellspacing=\"3\">\n");
print("								<tr>\n");
my $formula49=searchArray($graphInterval, 'day') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"day\" $formula49></td>\n");
print("									<td>day</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula50=searchArray($graphInterval, 'week') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"week\" $formula50></td>\n");
print("									<td>week</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula51=searchArray($graphInterval, 'month') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"month\" $formula51></td>\n");
print("									<td>month</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula52=searchArray($graphInterval, 'year') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"year\" $formula52></td>\n");
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
my $formula53=searchArray($graphType, 'line') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphType\" value=\"line\" $formula53></td>\n");
print("									<td>Line</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula54=searchArray($graphType, 'bar') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphType\" value=\"bar\" $formula54></td>\n");
print("									<td>Bar</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula55=searchArray($graphType, 'pie') ? 'checked' : ' ';print("									<td><input type=\"radio\"name=\"graphType\" value=\"pie\" $formula55></td>\n");
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
print("		\n");
print("      <td align=\"center\"> <table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n");
print("          <tr> \n");
print("            <td><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"UPDATE\"></td>\n");
print("            <td>&nbsp;</td>\n");
my $formula56=$reportNameID;print("            <td><input class=\"liteButton\" type=\"button\" name=\"clear\" value=\"Go Back\" onclick=\"location='index.pl?reportNameID=$formula56';\"></td>\n");
print("          </tr>\n");
print("        </table></td>\n");
print("	</tr>\n");
print("	</form>\n");
}
print("</table>\n");
