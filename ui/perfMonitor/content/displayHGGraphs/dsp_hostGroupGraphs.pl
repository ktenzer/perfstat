use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/contentFrame.js\"></script>\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/pm.displayHostGroupGraphs.js\"></script>\n");
print("	</head>\n");

print("	<body>\n");
print("		<div class=\"navHeader\">\n");
my $formula0=$sessionObj->param("groupViewStatus") ne "shared" ?  "My HostGroups" : "Shared HostGroups";my $formula1=$sessionObj->param("hostGroupID");my $formula2=$graphSize;my $formula3=$customSize;my $formula4=$graphLayout;print("			Performance Monitor :: $formula0 :: <a onclick=\"top.bottomFrame.document.getElementById('perfmonFrameset').cols='250,*';\" href=\"../selectHGGraphs/index.pl?hostGroupID=$formula1&graphSize=$formula2&customSize=$formula3&graphLayout=$formula4\">Host Group Graphs</a>\n");
print("		</div>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Create Graph(s)</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<form name=\"outputHostGroupGraphs\" action=\"index.pl\" method=\"post\">\n");
print("				<td class=\"darkGray\" align=\"left\" valign=\"top\">\n");
my $formula5=$sessionObj->param("hostGroupID");print("					<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula5\">\n");
my $formula6=$sessionObj->param("hostName");print("					<input type=\"hidden\" name=\"hostName\" value=\"$formula6\">\n");
print("					<input type=\"hidden\" name=\"hgGraphHolderArray\" value=\"\">\n");
print("					<table>\n");
print("						<tr>\n");
print("							<td><span class=\"table1Text1\">Layout:</span></td>\n");
print("							<td>\n");
print("								<select name=\"graphLayout\" size=\"1\">\n");
my $formula7=$graphLayout eq "1" ? "selected" : "";;print("									<option value=\"1\" $formula7>1 Column</option>\n");
my $formula8=$graphLayout eq "2" ? "selected" : "";;print("									<option value=\"2\" $formula8>2 Column</option>\n");
my $formula9=$graphLayout eq "3" ? "selected" : "";;print("									<option value=\"3\" $formula9>3 Column</option>\n");
my $formula10=$graphLayout eq "4" ? "selected" : "";;print("									<option value=\"4\" $formula10>4 Column</option>\n");
print("								</select>\n");
print("							</td>\n");
print("							<td><img src=\"../../../appRez/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("							<td nowrap><span class=\"table1Text1\">Graph Size:</span></td>\n");
print("							<td>\n");
print("								<select name=\"graphSize\" size=\"1\" onChange=\"document.outputHostGroupGraphs.customSize.value=''\">\n");
my $formula11=$graphSize eq "custom" ? "selected" : "";;print("									<option value=\"custom\" $formula11>Custom</option>\n");
my $formula12=$graphSize eq "small" ? "selected" : "";;print("									<option value=\"small\" $formula12>Small</option>\n");
my $formula13=$graphSize eq "medium" ? "selected" : "";;print("									<option value=\"medium\" $formula13>Medium</option>\n");
my $formula14=$graphSize eq "large" ? "selected" : "";;print("									<option value=\"large\" $formula14>Large</option>\n");
print("								</select>\n");
print("							</td>\n");
print("							<td><img src=\"../../../appRez/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("							<td nowrap><span class=\"table1Text1\">Custom Size:</span></td>\n");
my $formula15=$customSize;print("							<td><input type=\"text\" name=\"customSize\" value=\"$formula15\" size=\"3\" maxlength=\"3\" onFocus=\"document.outputHostGroupGraphs.graphSize.options[0].selected=true\"></td>\n");
print("								<td><span class=\"table1Text1\">%</span></td>\n");
print("								<td><img src=\"../../../appRez/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("								<td><input class=\"liteButton\" type=\"button\" value=\"Create\" onClick=\"top.topFrame.displayHostGroupGraphs();\"></td>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
print("		</table>\n");
print("		<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">\n");
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
print("			<tr valign=\"top\" align=\"center\">\n");
print("				<td>\n");
print("					<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"table1\">\n");
print("						<tr>\n");
my $formula16=$hgName;my $formula17=$serviceName;my $formula18=$graphName;my $formula19=$intervalName;print("							<td class=\"tdTop\" nowrap=\"nowrap\">$formula16 :: $formula17 :: $formula18 :: $formula19</td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td class=\"liteGray\" nowrap valign=\"middle\" align=\"center\">\n");
if ($graphType eq "bar") {
my $formula20=$hgName;my $formula21=$serviceName;my $formula22=$graphName;my $formula23=$intervalName;my $formula24=$graphScale;print("									<img src=\"../../../appLib/graphs/hostgroupGraphs/singleServiceGraphs/drawGDGraph/index.pl?action=drawGraph&hgName=$formula20&serviceName=$formula21&graphName=$formula22&intervalName=$formula23&graphScale=$formula24&graphType=bar\" border=\"0\">\n");
} elsif ($graphType eq "pie") {
my $formula25=$hgName;my $formula26=$serviceName;my $formula27=$graphName;my $formula28=$intervalName;my $formula29=$graphScale;print("									<img src=\"../../../appLib/graphs/hostgroupGraphs/singleServiceGraphs/drawGDGraph/index.pl?action=drawGraph&hgName=$formula25&serviceName=$formula26&graphName=$formula27&intervalName=$formula28&graphScale=$formula29&graphType=pie\" border=\"0\">\n");
}
print("							</td>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
 } else {
print("				<td><img src=\"../../../appRez/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("				<td>\n");
print("					<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"table1\">\n");
print("						<tr>\n");
my $formula30=$hgName;my $formula31=$serviceName;my $formula32=$graphName;my $formula33=$intervalName;print("							<td class=\"tdTop\" nowrap=\"nowrap\">$formula30 :: $formula31 :: $formula32 :: $formula33</td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td class=\"liteGray\" nowrap valign=\"middle\" align=\"center\">\n");
if ($graphType eq "bar") {
my $formula34=$hgName;my $formula35=$serviceName;my $formula36=$graphName;my $formula37=$intervalName;my $formula38=$graphScale;print("									<img src=\"../../../appLib/graphs/hostgroupGraphs/singleServiceGraphs/drawGDGraph/index.pl?action=drawGraph&hgName=$formula34&serviceName=$formula35&graphName=$formula36&intervalName=$formula37&graphScale=$formula38&graphType=bar\" border=\"0\">\n");
} elsif ($graphType eq "pie") {
my $formula39=$hgName;my $formula40=$serviceName;my $formula41=$graphName;my $formula42=$intervalName;my $formula43=$graphScale;print("									<img src=\"../../../appLib/graphs/hostgroupGraphs/singleServiceGraphs/drawGDGraph/index.pl?action=drawGraph&hgName=$formula39&serviceName=$formula40&graphName=$formula41&intervalName=$formula42&graphScale=$formula43&graphType=pie\" border=\"0\">\n");
}
print("							</td>		\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
}
 $graphDrawCounter++;
}
print("			</tr>\n");
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
