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
my $formula1=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula1\">
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostGraphs\">
my $formula2=$osName;print("			<input type=\"hidden\" name=\"osName\" value=\"$formula2\">
my $formula3=$graphServiceType;print("			<input type=\"hidden\" name=\"graphServiceType\" value=\"$formula3\">
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("							<legend align=\"top\">Host Group</legend>
print("							<select name=\"hostGroupID\" size=\"1\" onchange=\"submit();\">
foreach my $hostGroupName (@$hostGroupArray) {
my $formula4=$hostGroupName;my $formula5=$hostGroupName eq $hostGroupID ? 'selected' : ' ';my $formula6=$hostGroupName;print("									<option value=\"$formula4\" $formula5>$formula6</option>
}
print("							</select>
print("						</fieldset>
print("					</td>
print("				</tr>
print("			</table>
print("			</form>
print("		</td>
print("	</tr>
print("	<tr>
print("		<td>	
print("			<form name=\"selectOS\" action=\"index.pl\" method=\"post\">
my $formula7=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula7\">
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostGraphs\">
my $formula8=$hostGroupID;print("			<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula8\">
my $formula9=$graphServiceType;print("			<input type=\"hidden\" name=\"graphServiceType\" value=\"$formula9\">
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("						<legend align=\"top\">OS</legend>
print("						<select name=\"osName\" size=\"1\" onchange=\"submit();\">
 foreach my $osNameTemp (sort( @$osList)) {
my $formula10=$osNameTemp;my $formula11=$osNameTemp eq $osName ? "selected" : "";;my $formula12=$osNameTemp;print("								<option value=\"$formula10\" $formula11>$formula12</option>
}
print("						</select>
print("						</fieldset>
print("					</td>
print("				</tr>
print("			</table>
print("			</form>
print("		</td>
print("	</tr>
print("	<tr>
print("		<td>	
print("			<form name=\"selectGraphServiceType\" action=\"index.pl\" method=\"post\">
my $formula13=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula13\">
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostGraphs\">
my $formula14=$hostGroupID;print("			<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula14\">
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("						<legend align=\"top\">Graph Service Type</legend>
print("						<select name=\"graphServiceType\" size=\"1\" onchange=\"submit();\">
my $formula15=$graphServiceType eq "singleService" ? "selected" : "";;print("							<option value=\"singleService\" $formula15>Single Service</option>
my $formula16=$graphServiceType eq "singleSubService" ? "selected" : "";;print("							<option value=\"singleSubService\" $formula16>Single Subservice</option>
my $formula17=$graphServiceType eq "aggregateSubService" ? "selected" : "";;print("							<option value=\"aggregateSubService\" $formula17>Aggregate Subservice</option>
print("						</select>
print("						</fieldset>
print("					</td>
print("				</tr>
print("			</table>
print("			</form>
print("		</td>
print("	</tr>
 if ($graphServiceType eq "singleSubService") {
print("		<form name=\"selectGraphOrHost\" action=\"index.pl\" method=\"get\">
my $formula18=$reportNameID;print("		<input type=\"hidden\" name=\"reportNameID\" value=\"$formula18\">
print("		<input type=\"hidden\" name=\"contentType\" value=\"hostGraphs\">
my $formula19=$hostGroupID;print("		<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula19\">
my $formula20=$osName;print("		<input type=\"hidden\" name=\"osName\" value=\"$formula20\">
print("		<input type=\"hidden\" name=\"graphServiceType\" value=\"singleSubService\">
my $formula21=$selectGraphs->[0];print("		<input type=\"hidden\" name=\"selectGraphs\" value=\"$formula21\">
my $formula22=$selectHosts->[0];print("		<input type=\"hidden\" name=\"selectHosts\" value=\"$formula22\">
print("		</form>
 }
print("	<form name=\"insertHostGraphs\" action=\"index.pl\" method=\"post\">
print("	<input type=\"hidden\" name=\"action\" value=\"insertHostGraphs\">
my $formula23=$reportNameID;print("	<input type=\"hidden\" name=\"reportNameID\" value=\"$formula23\">
my $formula24=$hostGroupID;print("	<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula24\">
my $formula25=$osName;print("	<input type=\"hidden\" name=\"osName\" value=\"$formula25\">
my $formula26=$graphServiceType;print("	<input type=\"hidden\" name=\"graphServiceType\" value=\"$formula26\">
 if ($graphServiceType ne "singleSubService") {
print("	<tr>
print("		<td>
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("							<legend align=\"top\">Graphs</legend>
print("								<select name=\"selectGraphs\" size=\"5\" multiple>
 foreach my $contentStruct (@$graphArray) {
my $value="$contentStruct->{'serviceName'}^$contentStruct->{'graphName'}";
my $formula27=$value;my $formula28=searchArray($selectGraphs, $value) ? 'selected' : ' ';my $formula29=$contentStruct->{'serviceName'};my $formula30=$contentStruct->{'graphName'};print("									<option value=\"$formula27\" $formula28>$formula29 :: $formula30</option>
}
print("							</select>
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
print("							<legend align=\"top\">Graph</legend>
print("								<select name=\"selectGraphs\" onChange=\"document.forms.selectGraphOrHost.selectGraphs.value=this.options[this.selectedIndex].value; document.forms.selectGraphOrHost.submit();\">
 foreach my $contentStruct (@$graphArray) {
my $value="$contentStruct->{'serviceName'}^$contentStruct->{'graphName'}";
my $formula31=$value;my $formula32=searchArray($selectGraphs, $value) ? 'selected' : ' ';my $formula33=$contentStruct->{'serviceName'};my $formula34=$contentStruct->{'graphName'};print("									<option value=\"$formula31\" $formula32>$formula33 :: $formula34</option>
}
print("							</select>
print("						</fieldset>
print("					</td>
print("				</tr>
print("			</table>
print("		</td>
print("	</tr>
 }
 if ($graphServiceType ne "singleSubService") {
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
my $formula35=$value;my $formula36=searchArray($selectHosts, $value) ? 'selected' : ' ';my $formula37=$value;print("									<option value=\"$formula35\" $formula36>$formula37</option>
}
print("							</select>
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
print("							<legend align=\"top\">Host</legend>
print("								<select name=\"selectHosts\" onChange=\"document.forms.selectGraphOrHost.selectHosts.value=this.options[this.selectedIndex].value; document.forms.selectGraphOrHost.submit();\">
 foreach my $contentStruct (@$hostArray) {
my $value="$contentStruct->{'hostName'}";
my $formula38=$value;my $formula39=searchArray($selectHosts, $value) ? 'selected' : ' ';my $formula40=$value;print("									<option value=\"$formula38\" $formula39>$formula40</option>
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
print("							<legend align=\"top\">SubService</legend>
print("							<select name=\"selectSubServices\"  size=\"3\" multiple>
 foreach my $subServiceName (@$subServiceArray) {
my $formula41=$subServiceName;my $formula42=searchArray($selectSubServices, $subServiceName) ? 'selected' : ' ';my $formula43=$subServiceName;print("									<option value=\"$formula41\" $formula42>$formula43</option>
}
print("							</select>
print("						</fieldset>
print("					</td>
print("				</tr>
print("			</table>
print("		</td>
print("	</tr>
 }
print("	<tr>
print("		<td>
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("							<legend align=\"top\">Graph Interval</legend>
print("							<table border=\"0\" cellpadding=\"0\" cellspacing=\"3\">
print("								<tr>
my $formula44=searchArray($graphInterval, 'day') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"day\" $formula44></td>
print("									<td>day</td>
print("									<td>&nbsp;</td>
my $formula45=searchArray($graphInterval, 'week') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"week\" $formula45></td>
print("									<td>week</td>
print("									<td>&nbsp;</td>
my $formula46=searchArray($graphInterval, 'month') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"month\" $formula46></td>
print("									<td>month</td>
print("									<td>&nbsp;</td>
my $formula47=searchArray($graphInterval, 'year') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphInterval\" value=\"year\" $formula47></td>
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
my $formula48=searchArray($graphType, 'line') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphType\" value=\"line\" $formula48></td>
print("									<td>Line</td>
print("									<td>&nbsp;</td>
my $formula49=searchArray($graphType, 'bar') ? 'checked' : ' ';print("									<td><input type=\"checkbox\" name=\"graphType\" value=\"bar\" $formula49></td>
print("									<td>Bar</td>
print("									<td>&nbsp;</td>
my $formula50=searchArray($graphType, 'pie') ? 'checked' : ' ';print("									<td><input type=\"checkbox\"name=\"graphType\" value=\"pie\" $formula50></td>
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
print("		<td align=\"center\">
print("			<table>
print("				<td class=\"liteGray\" valign=\"top\" align=\"right\"><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"ADD\"></td>
print("			</table>
print("		</td>
print("	</tr>
print("	</form>
}
print("</table>\n");