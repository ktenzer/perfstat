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
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostGraph\">
my $formula1=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula1\">
my $formula2=$contentID;print("			<input type=\"hidden\" name=\"contentID\" value=\"$formula2\">
my $formula3=$osName;print("			<input type=\"hidden\" name=\"osName\" value=\"$formula3\">
my $formula4=$graphServiceType;print("			<input type=\"hidden\" name=\"graphServiceType\" value=\"$formula4\">
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("							<legend align=\"top\">Host Group</legend>
print("							<select name=\"hostGroupID\" size=\"1\" onchange=\"submit();\">
foreach my $hostGroupName (@$hostGroupArray) {
my $formula5=$hostGroupName;my $formula6=$hostGroupName eq $hostGroupID ? 'selected' : ' ';my $formula7=$hostGroupName;print("									<option value=\"$formula5\" $formula6>$formula7</option>
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
print("			<input type=\"hidden\" name=\"displayMode\" value=\"edit\">
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostGraph\">
my $formula8=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula8\">
my $formula9=$contentID;print("			<input type=\"hidden\" name=\"contentID\" value=\"$formula9\">
my $formula10=$hostGroupID;print("			<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula10\">
my $formula11=$graphServiceType;print("			<input type=\"hidden\" name=\"graphServiceType\" value=\"$formula11\">
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("						<legend align=\"top\">OS</legend>
print("						<select name=\"osName\" size=\"1\" onchange=\"submit();\">
 foreach my $osNameTemp (sort( @$osList)) {
my $formula12=$osNameTemp;my $formula13=$osNameTemp eq $osName ? "selected" : "";;my $formula14=$osNameTemp;print("								<option value=\"$formula12\" $formula13>$formula14</option>
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
print("			<input type=\"hidden\" name=\"displayMode\" value=\"edit\">
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostGraph\">
my $formula15=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula15\">
my $formula16=$contentID;print("			<input type=\"hidden\" name=\"contentID\" value=\"$formula16\">
my $formula17=$hostGroupID;print("			<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula17\">
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("						<legend align=\"top\">Graph Service Type</legend>
print("						<select name=\"graphServiceType\" size=\"1\" onchange=\"submit();\">
my $formula18=$graphServiceType eq "singleService" ? "selected" : "";;print("							<option value=\"singleService\" $formula18>Single Service</option>
my $formula19=$graphServiceType eq "singleSubService" ? "selected" : "";;print("							<option value=\"singleSubService\" $formula19>Single Subservice</option>
my $formula20=$graphServiceType eq "aggregateSubService" ? "selected" : "";;print("							<option value=\"aggregateSubService\" $formula20>Aggregate Subservice</option>
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
print("		<input type=\"hidden\" name=\"displayMode\" value=\"edit\">
print("		<input type=\"hidden\" name=\"contentType\" value=\"hostGraph\">
my $formula21=$reportNameID;print("		<input type=\"hidden\" name=\"reportNameID\" value=\"$formula21\">
my $formula22=$contentID;print("		<input type=\"hidden\" name=\"contentID\" value=\"$formula22\">
my $formula23=$hostGroupID;print("		<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula23\">
my $formula24=$osName;print("		<input type=\"hidden\" name=\"osName\" value=\"$formula24\">
print("		<input type=\"hidden\" name=\"graphServiceType\" value=\"singleSubService\">
my $formula25=$selectGraphs->[0];print("		<input type=\"hidden\" name=\"selectGraphs\" value=\"$formula25\">
my $formula26=$selectHosts->[0];print("		<input type=\"hidden\" name=\"selectHosts\" value=\"$formula26\">
print("		</form>
 }
print("	<form name=\"updateHostGraphs\" action=\"index.pl\" method=\"post\">
print("	<input type=\"hidden\" name=\"action\" value=\"updateHostGraph\">
my $formula27=$hostGroupID;print("	<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula27\">
my $formula28=$reportNameID;print("	<input type=\"hidden\" name=\"reportNameID\" value=\"$formula28\">
my $formula29=$contentID;print("	<input type=\"hidden\" name=\"contentID\" value=\"$formula29\">
my $formula30=$osName;print("	<input type=\"hidden\" name=\"osName\" value=\"$formula30\">
my $formula31=$graphServiceType;print("	<input type=\"hidden\" name=\"graphServiceType\" value=\"$formula31\">
 if ($graphServiceType ne "singleSubService") {
print("	<tr>
print("		<td>
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("				<tr>
print("					<td>
print("						<fieldset>
print("							<legend align=\"top\">Graphs</legend>
print("								<select name=\"selectGraphs\" size=\"1\">
 foreach my $contentStruct (@$graphArray) {
my $value="$contentStruct->{'serviceName'}^$contentStruct->{'graphName'}";
my $formula32=$value;my $formula33=searchArray($selectGraphs, $value) ? 'selected' : ' ';my $formula34=$contentStruct->{'serviceName'};my $formula35=$contentStruct->{'graphName'};print("									<option value=\"$formula32\" $formula33>$formula34 :: $formula35</option>
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
my $formula36=$value;my $formula37=searchArray($selectGraphs, $value) ? 'selected' : ' ';my $formula38=$contentStruct->{'serviceName'};my $formula39=$contentStruct->{'graphName'};print("									<option value=\"$formula36\" $formula37>$formula38 :: $formula39</option>
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
print("								<select name=\"selectHosts\" size=\"1\">
 foreach my $contentStruct (@$hostArray) {
my $value="$contentStruct->{'hostName'}";
my $formula40=$value;my $formula41=searchArray($selectHosts, $value) ? 'selected' : ' ';my $formula42=$value;print("									<option value=\"$formula40\" $formula41>$formula42</option>
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
my $formula43=$value;my $formula44=searchArray($selectHosts, $value) ? 'selected' : ' ';my $formula45=$value;print("									<option value=\"$formula43\" $formula44>$formula45</option>
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
print("							<select name=\"selectSubServices\"  size=\"1\">
 foreach my $subServiceName (@$subServiceArray) {
my $formula46=$subServiceName;my $formula47=searchArray($selectSubServices, $subServiceName) ? 'selected' : ' ';my $formula48=$subServiceName;print("									<option value=\"$formula46\" $formula47>$formula48</option>
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
my $formula49=searchArray($graphInterval, 'day') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"day\" $formula49></td>
print("									<td>day</td>
print("									<td>&nbsp;</td>
my $formula50=searchArray($graphInterval, 'week') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"week\" $formula50></td>
print("									<td>week</td>
print("									<td>&nbsp;</td>
my $formula51=searchArray($graphInterval, 'month') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"month\" $formula51></td>
print("									<td>month</td>
print("									<td>&nbsp;</td>
my $formula52=searchArray($graphInterval, 'year') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphInterval\" value=\"year\" $formula52></td>
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
my $formula53=searchArray($graphType, 'line') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphType\" value=\"line\" $formula53></td>
print("									<td>Line</td>
print("									<td>&nbsp;</td>
my $formula54=searchArray($graphType, 'bar') ? 'checked' : ' ';print("									<td><input type=\"radio\" name=\"graphType\" value=\"bar\" $formula54></td>
print("									<td>Bar</td>
print("									<td>&nbsp;</td>
my $formula55=searchArray($graphType, 'pie') ? 'checked' : ' ';print("									<td><input type=\"radio\"name=\"graphType\" value=\"pie\" $formula55></td>
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
print("		
print("      <td align=\"center\"> <table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">
print("          <tr> 
print("            <td><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"UPDATE\"></td>
print("            <td>&nbsp;</td>
my $formula56=$reportNameID;print("            <td><input class=\"liteButton\" type=\"button\" name=\"clear\" value=\"Go Back\" onclick=\"location='index.pl?reportNameID=$formula56';\"></td>
print("          </tr>
print("        </table></td>
print("	</tr>
print("	</form>
}
print("</table>\n");