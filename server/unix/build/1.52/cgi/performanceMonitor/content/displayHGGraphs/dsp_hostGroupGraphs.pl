use strict;
package main;
print("<html>
print("	<head>
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/forms.css\" media=\"screen\">
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/contentFrame.js\"></script>
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/pm.displayHostGroupGraphs.js\"></script>
print("	</head>
print("
print("	<body>
print("		<div class=\"navHeader\">
my $formula0=$sessionObj->param("groupViewStatus") ne "shared" ?  "My HostGroups" : "Shared HostGroups";my $formula1=$sessionObj->param("hostGroupID");my $formula2=$graphSize;my $formula3=$customSize;my $formula4=$graphLayout;print("			Performance Monitor :: $formula0 :: <a onclick=\"top.bottomFrame.document.getElementById('perfmonFrameset').cols='250,*';\" href=\"../selectHGGraphs/index.pl?hostGroupID=$formula1&graphSize=$formula2&customSize=$formula3&graphLayout=$formula4\">Host Group Graphs</a>
print("		</div>
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Create Graph(s)</td>
print("			</tr>
print("			<tr>
print("				<td class=\"darkGray\" align=\"left\" valign=\"top\">
print("					<form name=\"outputHostGroupGraphs\" action=\"index.pl\" method=\"post\">
my $formula5=$sessionObj->param("hostGroupID");print("						<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula5\">
my $formula6=$sessionObj->param("hostName");print("						<input type=\"hidden\" name=\"hostName\" value=\"$formula6\">
print("						<input type=\"hidden\" name=\"hgGraphHolderArray\" value=\"\">
print("						<table>
print("						<tr>
print("							<td><span class=\"table1Text1\">Layout:</span></td>
print("							<td>
print("								<select name=\"graphLayout\" size=\"1\">
my $formula7=$graphLayout eq "1" ? "selected" : "";;print("									<option value=\"1\" $formula7>1 Column</option>
my $formula8=$graphLayout eq "2" ? "selected" : "";;print("									<option value=\"2\" $formula8>2 Column</option>
my $formula9=$graphLayout eq "3" ? "selected" : "";;print("									<option value=\"3\" $formula9>3 Column</option>
my $formula10=$graphLayout eq "4" ? "selected" : "";;print("									<option value=\"4\" $formula10>4 Column</option>
print("								</select>
print("							</td>
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>
print("							<td nowrap><span class=\"table1Text1\">Graph Size:</span></td>
print("							<td>
print("								<select name=\"graphSize\" size=\"1\" onChange=\"document.outputHostGroupGraphs.customSize.value=''\">
my $formula11=$graphSize eq "custom" ? "selected" : "";;print("									<option value=\"custom\" $formula11>Custom</option>
my $formula12=$graphSize eq "small" ? "selected" : "";;print("									<option value=\"small\" $formula12>Small</option>
my $formula13=$graphSize eq "medium" ? "selected" : "";;print("									<option value=\"medium\" $formula13>Medium</option>
my $formula14=$graphSize eq "large" ? "selected" : "";;print("									<option value=\"large\" $formula14>Large</option>
print("								</select>
print("							</td>
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>
print("							<td nowrap><span class=\"table1Text1\">Custom Size:</span></td>
my $formula15=$customSize;print("							<td><input type=\"text\" name=\"customSize\" value=\"$formula15\" size=\"3\" maxlength=\"3\" onFocus=\"document.outputHostGroupGraphs.graphSize.options[0].selected=true\"></td>
print("								<td><span class=\"table1Text1\">%</span></td>
print("								<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>
print("								<td><input class=\"liteButton\" type=\"button\" value=\"Create\" onClick=\"top.topFrame.displayHostGroupGraphs();\"></td>
print("						</tr>
print("					</table>
print("				</td>
print("				</form>
print("			</tr>
print("		</table>
print("		<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">
my $refinedGraphHolderArrayLen = @$refinedGraphHolderArray;
my $graphDrawCounter = $graphLayout;
for (my $count = 0; $count < $refinedGraphHolderArrayLen; $count++) {
my $graphHash = $refinedGraphHolderArray->[$count];
my $hgName = $graphHash->{'hgName'};
my $serviceName = $graphHash->{'serviceName'};
my $graphName = $graphHash->{'graphName'};
my $intervalName = $graphHash->{'intervalName'};
my $graphType = $graphHash->{'graphType'};
 if ($graphDrawCounter % $graphLayout == 0) {
print("			<tr valign=\"top\" align=\"center\">
print("				<td>
print("					<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"table1\">
print("						<tr>
my $formula16=$hgName;my $formula17=$serviceName;my $formula18=$graphName;my $formula19=$intervalName;print("							<td class=\"tdTop\" nowrap=\"nowrap\">$formula16 :: $formula17 :: $formula18 :: $formula19</td>
print("						</tr>
print("						<tr>
print("							<td class=\"liteGray\" nowrap valign=\"middle\" align=\"center\">
if ($graphType eq "bar") {
my $formula20=$hgName;my $formula21=$serviceName;my $formula22=$graphName;my $formula23=$intervalName;my $formula24=$graphScale;print("									<img src=\"singleServiceGraphs/drawGDGraph/index.pl?action=drawGraph&hgName=$formula20&serviceName=$formula21&graphName=$formula22&intervalName=$formula23&graphScale=$formula24&graphType=bar\" border=\"0\">
} elsif ($graphType eq "pie") {
my $formula25=$hgName;my $formula26=$serviceName;my $formula27=$graphName;my $formula28=$intervalName;my $formula29=$graphScale;print("									<img src=\"singleServiceGraphs/drawGDGraph/index.pl?action=drawGraph&hgName=$formula25&serviceName=$formula26&graphName=$formula27&intervalName=$formula28&graphScale=$formula29&graphType=pie\" border=\"0\">
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
my $formula30=$hgName;my $formula31=$serviceName;my $formula32=$graphName;my $formula33=$intervalName;print("							<td class=\"tdTop\" nowrap=\"nowrap\">$formula30 :: $formula31 :: $formula32 :: $formula33</td>
print("						</tr>
print("						<tr>
print("							<td class=\"liteGray\" nowrap valign=\"middle\" align=\"center\">
if ($graphType eq "bar") {
my $formula34=$hgName;my $formula35=$serviceName;my $formula36=$graphName;my $formula37=$intervalName;my $formula38=$graphScale;print("									<img src=\"singleServiceGraphs/drawGDGraph/index.pl?action=drawGraph&hgName=$formula34&serviceName=$formula35&graphName=$formula36&intervalName=$formula37&graphScale=$formula38&graphType=bar\" border=\"0\">
} elsif ($graphType eq "pie") {
my $formula39=$hgName;my $formula40=$serviceName;my $formula41=$graphName;my $formula42=$intervalName;my $formula43=$graphScale;print("									<img src=\"singleServiceGraphs/drawGDGraph/index.pl?action=drawGraph&hgName=$formula39&serviceName=$formula40&graphName=$formula41&intervalName=$formula42&graphScale=$formula43&graphType=pie\" border=\"0\">
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