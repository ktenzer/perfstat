use strict;
package main;
print("<html>
print("	<head>
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/forms.css\" media=\"screen\">
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/contentFrame.js\"></script>
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/pm.displayHostGraphs.js\"></script>
print("	</head>
print("
print("	<body>
print("		<div class=\"navHeader\">
my $formula0=$sessionObj->param("groupViewStatus") ne "shared" ?  "My HostGroups" : "Shared HostGroups";my $formula1=$sessionObj->param("hostGroupID");my $formula2=$sessionObj->param("hostGroupID");my $formula3=$sessionObj->param("hostName");my $formula4=$graphSize;my $formula5=$customSize;my $formula6=$graphLayout;print("			<div class=\"navHeader\">Performance Monitor :: $formula0 :: $formula1 :: <a onclick=\"top.bottomFrame.document.getElementById('perfmonFrameset').cols='250,*';\" href=\"../selectHostGraphs/index.pl?hostGroupID=$formula2&hostName=$formula3&graphSize=$formula4&customSize=$formula5&graphLayout=$formula6\">Host Graphs</a>
print("		</div>
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Create Graph(s)</td>
print("			</tr>
print("			<tr>
print("				<td class=\"darkGray\" align=\"left\" valign=\"top\">
print("					<form name=\"outputHostGraphs\" action=\"index.pl\" method=\"post\">
my $formula7=$sessionObj->param("hostGroupID");print("						<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula7\">
my $formula8=$sessionObj->param("hostName");print("						<input type=\"hidden\" name=\"hostName\" value=\"$formula8\">
print("						<input type=\"hidden\" name=\"hostGraphHolderArray\" value=\"\">\n");
print("						<table>\n");
print("							<tr>\n");
print("								<td><span class=\"table1Text1\">Layout:</span></td>\n");
print("								<td><select name=\"graphLayout\" size=\"1\">\n");
my $formula9=$graphLayout eq "1" ? "selected" : "";;print("										<option value=\"1\" $formula9>1 Column</option>\n");
my $formula10=$graphLayout eq "2" ? "selected" : "";;print("										<option value=\"2\" $formula10>2 Column</option>\n");
my $formula11=$graphLayout eq "3" ? "selected" : "";;print("										<option value=\"3\" $formula11>3 Column</option>\n");
my $formula12=$graphLayout eq "4" ? "selected" : "";;print("										<option value=\"4\" $formula12>4 Column</option>\n");
print("									</select></td>\n");
print("								<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("								<td nowrap><span class=\"table1Text1\">Graph Size:</span></td>\n");
print("								<td><select name=\"graphSize\" size=\"1\" onChange=\"document.outputHostGraphs.customSize.value=''\">\n");
my $formula13=$graphSize eq "custom" ? "selected" : "";;print("										<option value=\"custom\" $formula13>Custom</option>\n");
my $formula14=$graphSize eq "small" ? "selected" : "";;print("										<option value=\"small\" $formula14>Small</option>\n");
my $formula15=$graphSize eq "medium" ? "selected" : "";;print("										<option value=\"medium\" $formula15>Medium</option>\n");
my $formula16=$graphSize eq "large" ? "selected" : "";;print("										<option value=\"large\" $formula16>Large</option>\n");
print("									</select></td>\n");
print("								<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("								<td nowrap><span class=\"table1Text1\">Custom Size:</span></td>\n");
my $formula17=$customSize;print("								<td><input type=\"text\" name=\"customSize\" value=\"$formula17\" size=\"3\" maxlength=\"3\" onFocus=\"document.outputHostGraphs.graphSize.options[0].selected=true\"></td>\n");
print("								<td><span class=\"table1Text1\">%</span></td>\n");
print("								<td></td>\n");
print("								<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("								<td><input class=\"liteButton\" type=\"button\" value=\"Create\" onClick=\"top.topFrame.displayHostGraphs();\"></td>\n");
print("							</tr>\n");
print("						</table>\n");
print("				</td>
print("				</form>
print("			</tr>
print("		</table>
print("		<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">
my $refinedGraphHolderArrayLen = @$refinedGraphHolderArray;
my $graphDrawCounter = $graphLayout;
for (my $count = 0; $count < $refinedGraphHolderArrayLen; $count++) {
my $graphHash = $refinedGraphHolderArray->[$count];
my $os = $graphHash->{'os'};
my $graphIndex = $graphHash->{'graphIndex'};
$graphIndex = $graphIndex . "ServiceGraphs";
my $hostName = $graphHash->{'hostName'};
my $serviceName = $graphHash->{'serviceName'};
my $graphName = $graphHash->{'graphName'};
my $intervalName = $graphHash->{'intervalName'};
my $graphType = $graphHash->{'graphType'};
 if ($graphDrawCounter % $graphLayout == 0) {
print("			<tr valign=\"top\" align=\"center\">
print("				<td>
print("					<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"table1\">
print("						<tr>
my $formula18=$hostName;my $formula19=$serviceName;my $formula20=$graphName;my $formula21=$intervalName;print("							<td class=\"tdTop\" nowrap=\"nowrap\">$formula18 :: $formula19 :: $formula20 :: $formula21</td>
print("						</tr>
print("						<tr>
print("							<td class=\"liteGray\" nowrap valign=\"middle\" align=\"center\">
if ($graphType eq "line") {
my $formula22=$graphIndex;my $formula23=$os;my $formula24=$hostName;my $formula25=$serviceName;my $formula26=$graphName;my $formula27=$intervalName;my $formula28=$graphScale;print("									<img src=\"$formula22/drawLineGraph/index.pl?action=drawGraph&os=$formula23&hostName=$formula24&serviceName=$formula25&graphName=$formula26&intervalName=$formula27&graphScale=$formula28\" border=\"0\">
} elsif ($graphType eq "bar") {
my $formula29=$graphIndex;my $formula30=$os;my $formula31=$hostName;my $formula32=$serviceName;my $formula33=$graphName;my $formula34=$intervalName;my $formula35=$graphScale;print("									<img src=\"$formula29/drawGDGraph/index.pl?action=drawGraph&os=$formula30&hostName=$formula31&serviceName=$formula32&graphName=$formula33&intervalName=$formula34&graphScale=$formula35&graphType=bar\" border=\"0\">
} elsif ($graphType eq "pie") {
my $formula36=$graphIndex;my $formula37=$os;my $formula38=$hostName;my $formula39=$serviceName;my $formula40=$graphName;my $formula41=$intervalName;my $formula42=$graphScale;print("									<img src=\"$formula36/drawGDGraph/index.pl?action=drawGraph&os=$formula37&hostName=$formula38&serviceName=$formula39&graphName=$formula40&intervalName=$formula41&graphScale=$formula42&graphType=pie\" border=\"0\">
}
print("							</td>
print("						</tr>
print("					</table>
print("				</td>
 } else {
print("				<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>
print("				<td>
print("					<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"table1\">
print("						<tr>
my $formula43=$hostName;my $formula44=$serviceName;my $formula45=$graphName;my $formula46=$intervalName;print("							<td class=\"tdTop\" nowrap=\"nowrap\">$formula43 :: $formula44 :: $formula45 :: $formula46 </td>
print("						</tr>
print("						<tr>
print("							<td class=\"liteGray\" nowrap valign=\"middle\" align=\"center\">
if ($graphType eq "line") {
my $formula47=$graphIndex;my $formula48=$os;my $formula49=$hostName;my $formula50=$serviceName;my $formula51=$graphName;my $formula52=$intervalName;my $formula53=$graphScale;print("									<img src=\"$formula47/drawLineGraph/index.pl?action=drawGraph&os=$formula48&hostName=$formula49&serviceName=$formula50&graphName=$formula51&intervalName=$formula52&graphScale=$formula53\" border=\"0\">
} elsif ($graphType eq "bar") {
my $formula54=$graphIndex;my $formula55=$os;my $formula56=$hostName;my $formula57=$serviceName;my $formula58=$graphName;my $formula59=$intervalName;my $formula60=$graphScale;print("									<img src=\"$formula54/drawGDGraph/index.pl?action=drawGraph&os=$formula55&hostName=$formula56&serviceName=$formula57&graphName=$formula58&intervalName=$formula59&graphScale=$formula60&graphType=bar\" border=\"0\">
} elsif ($graphType eq "pie") {
my $formula61=$graphIndex;my $formula62=$os;my $formula63=$hostName;my $formula64=$serviceName;my $formula65=$graphName;my $formula66=$intervalName;my $formula67=$graphScale;print("									<img src=\"$formula61/drawGDGraph/index.pl?action=drawGraph&os=$formula62&hostName=$formula63&serviceName=$formula64&graphName=$formula65&intervalName=$formula66&graphScale=$formula67&graphType=pie\" border=\"0\">
}
print("							</td>		
print("						</tr>
print("					</table>
print("				</td>
}
 $graphDrawCounter++;
}
print("			</tr>
print("		</table>
print("	</body>
print("</html>\n");