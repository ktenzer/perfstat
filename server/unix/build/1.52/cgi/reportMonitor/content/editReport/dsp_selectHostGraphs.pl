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
my $formula1=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula1\">\n");
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostGraphs\">\n");
my $formula2=$osName;print("			<input type=\"hidden\" name=\"osName\" value=\"$formula2\">\n");
my $formula3=$graphServiceType;print("			<input type=\"hidden\" name=\"graphServiceType\" value=\"$formula3\">\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Host Group</legend>\n");
print("							<select name=\"hostGroupID\" size=\"1\" onchange=\"submit();\">\n");
foreach my $hostGroupName (@$hostGroupArray) {
my $formula4=$hostGroupName;my $formula5=$hostGroupName eq $hostGroupID ? 'selected' : ' ';my $formula6=$hostGroupName;print("									<option value=\"$formula4\" $formula5>$formula6</option>\n");
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
my $formula7=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula7\">\n");
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostGraphs\">\n");
my $formula8=$hostGroupID;print("			<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula8\">\n");
my $formula9=$graphServiceType;print("			<input type=\"hidden\" name=\"graphServiceType\" value=\"$formula9\">\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("						<legend align=\"top\">OS</legend>\n");
print("						<select name=\"osName\" size=\"1\" onchange=\"submit();\">\n");
 foreach my $osNameTemp (sort( @$osList)) {
my $formula10=$osNameTemp;my $formula11=$osNameTemp eq $osName ? "selected" : "";;my $formula12=$osNameTemp;print("								<option value=\"$formula10\" $formula11>$formula12</option>\n");
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
my $formula13=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula13\">\n");
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostGraphs\">\n");
my $formula14=$hostGroupID;print("			<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula14\">\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("						<legend align=\"top\">Graph Service Type</legend>\n");
print("						<select name=\"graphServiceType\" size=\"1\" onchange=\"submit();\">\n");
my $formula15=$graphServiceType eq "singleService" ? "selected" : "";;print("							<option value=\"singleService\" $formula15>Single Service</option>\n");
my $formula16=$graphServiceType eq "singleSubService" ? "selected" : "";;print("							<option value=\"singleSubService\" $formula16>Single Subservice</option>\n");
my $formula17=$graphServiceType eq "aggregateSubService" ? "selected" : "";;print("							<option value=\"aggregateSubService\" $formula17>Aggregate Subservice</option>\n");
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
my $formula18=$reportNameID;print("		<input type=\"hidden\" name=\"reportNameID\" value=\"$formula18\">\n");
print("		<input type=\"hidden\" name=\"contentType\" value=\"hostGraphs\">\n");
my $formula19=$hostGroupID;print("		<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula19\">\n");
my $formula20=$osName;print("		<input type=\"hidden\" name=\"osName\" value=\"$formula20\">\n");
print("		<input type=\"hidden\" name=\"graphServiceType\" value=\"singleSubService\">\n");
my $formula21=$selectGraphs->[0];print("		<input type=\"hidden\" name=\"selectGraphs\" value=\"$formula21\">\n");
my $formula22=$selectHosts->[0];print("		<input type=\"hidden\" name=\"selectHosts\" value=\"$formula22\">\n");
print("		</form>\n");
 }
print("	<form name=\"insertHostGraphs\" action=\"index.pl\" method=\"post\">\n");
print("	<input type=\"hidden\" name=\"action\" value=\"insertHostGraphs\">\n");
my $formula23=$reportNameID;print("	<input type=\"hidden\" name=\"reportNameID\" value=\"$formula23\">\n");
my $formula24=$hostGroupID;print("	<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula24\">\n");
my $formula25=$osName;print("	<input type=\"hidden\" name=\"osName\" value=\"$formula25\">\n");
my $formula26=$graphServiceType;print("	<input type=\"hidden\" name=\"graphServiceType\" value=\"$formula26\">\n");
 if ($graphServiceType ne "singleSubService") {
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Graphs</legend>\n");
print("								<select name=\"selectGraphs\" size=\"5\" multiple>\n");
 foreach my $contentStruct (@$graphArray) {
my $value="$contentStruct->{'serviceName'}^$contentStruct->{'graphName'}";
my $formula27=$value;my $formula28=searchArray($selectGraphs, $value) ? 'selected' : ' ';my $formula29=$contentStruct->{'serviceName'};my $formula30=$contentStruct->{'graphName'};print("									<option value=\"$formula27\" $formula28>$formula29 :: $formula30</option>\n");
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
my $formula31=$value;my $formula32=searchArray($selectGraphs, $value) ? 'selected' : ' ';my $formula33=$contentStruct->{'serviceName'};my $formula34=$contentStruct->{'graphName'};print("									<option value=\"$formula31\" $formula32>$formula33 :: $formula34</option>\n");
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
print("								<select name=\"selectHosts\" size=\"5\" multiple>\n");
 foreach my $contentStruct (@$hostArray) {
my $value="$contentStruct->{'hostName'}";
my $formula35=$value;my $formula36=searchArray($selectHosts, $value) ? 'selected' : ' ';my $formula37=$value;print("									<option value=\"$formula35\" $formula36>$formula37</option>\n");
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
my $formula38=$value;my $formula39=searchArray($selectHosts, $value) ? 'selected' : ' ';my $formula40=$value;print("									<option value=\"$formula38\" $formula39>$formula40</option>\n");
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
print("							<select name=\"selectSubServices\"  size=\"3\" multiple>\n");
 foreach my $subServiceName (@$subServiceArray) {
my $formula41=$subServiceName;my $formula42=searchArray($selectSubServices, $subServiceName) ? 'selected' : ' ';my $formula43=$subServiceName;print("									<option value=\"$formula41\" $formula42>$formula43</option>\n");
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
my $formula44=searchArray($graphInterval, 'day') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"day\" $formula44></td>\n");
print("									<td>day</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula45=searchArray($graphInterval, 'week') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"week\" $formula45></td>\n");
print("									<td>week</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula46=searchArray($graphInterval, 'month') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"month\" $formula46></td>\n");
print("									<td>month</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula47=searchArray($graphInterval, 'year') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"year\" $formula47></td>\n");
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
my $formula48=searchArray($graphType, 'line') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphType\" value=\"line\" $formula48></td>\n");
print("									<td>Line</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula49=searchArray($graphType, 'bar') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphType\" value=\"bar\" $formula49></td>\n");
print("									<td>Bar</td>\n");
print("									<td>&nbsp;</td>\n");
my $formula50=searchArray($graphType, 'pie') ? 'checked' : ' ';print("									<td><input type=\"checkbox\"name=\"graphType\" value=\"pie\" $formula50></td>\n");
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
print("		<td align=\"center\">\n");
print("			<table>\n");
print("				<td class=\"liteGray\" valign=\"top\" align=\"right\"><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"ADD\"></td>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
print("	</form>\n");
}
print("</table>\n");
