use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/contentFrame.js\"></script>\n");
print("	</head>\n");

print("	<body>\n");
print("		<div class=\"navHeader\">\n");
my $formula0=$sessionObj->param("hostGroupID");my $formula1=$sessionObj->param("hostName");my $formula2=$graphSize;my $formula3=$graphLayout;print("			<a href=\"../level1/index.pl?hostGroupID=$formula0&hostName=$formula1&graphSize=$formula2&graphLayout=$formula3\">Select Graphs</a>\n");
print("		</div>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Create Graph(s)</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"darkGray\" align=\"left\" valign=\"top\">\n");
print("					<form name=\"outputGraphs\" action=\"index.pl\" method=\"get\">\n");
my $formula4=$sessionObj->param("hostGroupID");print("						<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula4\">\n");
my $formula5=$sessionObj->param("hostName");print("						<input type=\"hidden\" name=\"hostName\" value=\"$formula5\">\n");
print("						<input type=\"hidden\" name=\"graphHolderArray\" value=\"\">\n");
print("						<table>\n");
print("							<tr>\n");
print("								<td><span class=\"table1Text1\">Graph Size:</span></td>\n");
print("								<td><select name=\"graphSize\" size=\"1\">\n");
my $formula6=$graphSize eq "small" ? "selected" : "";;print("										<option value=\"small\" $formula6>Small</option>\n");
my $formula7=$graphSize eq "medium" ? "selected" : "";;print("										<option value=\"medium\" $formula7>Medium</option>\n");
my $formula8=$graphSize eq "large" ? "selected" : "";;print("										<option value=\"large\" $formula8>Large</option>\n");
print("									</select></td>\n");
print("								<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("								<td><span class=\"table1Text1\">Layout:</span></td>\n");
print("								<td><select name=\"graphLayout\" size=\"1\">\n");
my $formula9=$graphLayout eq "1" ? "selected" : "";;print("										<option value=\"1\" $formula9>1 Column</option>\n");
my $formula10=$graphLayout eq "2" ? "selected" : "";;print("										<option value=\"2\" $formula10>2 Column</option>\n");
my $formula11=$graphLayout eq "3" ? "selected" : "";;print("										<option value=\"3\" $formula11>3 Column</option>\n");
my $formula12=$graphLayout eq "4" ? "selected" : "";;print("										<option value=\"4\" $formula12>4 Column</option>\n");
print("									</select></td>\n");
print("								<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("								<td><input class=\"liteButton\" type=\"button\" value=\"Create\" onClick=\"displayGraphs();\"></td>\n");
print("							</tr>\n");
print("						</table>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
print("		</table>\n");
print("		<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">\n");
 my $graphHolderArrayLen = @$graphHolderArray;
 my $graphDrawCounter = $graphLayout;
for (my $count = 0; $count < $graphHolderArrayLen; $count++) {
my $graphArray = $graphHolderArray->[$count];
my $hostName = $graphArray->[0];
my $serviceName = $graphArray->[1];
my $graphName = $graphArray->[2];
my @intervalArray = @$graphArray[3, 4, 5, 6];
for (my $count = 0; $count < 5; $count++) {
if ($intervalArray[$count] != 0) {
my $intervalName = "";
if ($count == 0) {
$intervalName = "hourly";
} elsif  ($count == 1) {
$intervalName = "daily";
} elsif  ($count == 2) {
$intervalName = "weekly";
} elsif  ($count == 3) {
$intervalName = "monthly";
} else {
die('Error: invalid value for $count');
}
 if ($graphDrawCounter % $graphLayout == 0) {
print("						<tr valign=\"top\" align=\"center\">\n");
print("							<td>\n");
print("								<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"table1\">\n");
print("									<tr>\n");
my $formula13=$hostName;my $formula14=$serviceName;my $formula15=$graphName;my $formula16=$intervalName;print("										<td class=\"tdTop\" nowrap=\"nowrap\">$formula13 :: $formula14 :: $formula15 :: $formula16</td>\n");
print("									</tr>\n");
print("									<tr>\n");
print("										<td class=\"liteGray\" nowrap valign=\"middle\" align=\"center\">\n");
my $formula17=$hostName;my $formula18=$serviceName;my $formula19=$graphName;my $formula20=$intervalName;my $formula21=$graphHeight;my $formula22=$graphWidth;print("											<img src=\"drawGraph/index.pl?action=drawGraph&hostName=$formula17&serviceName=$formula18&graphName=$formula19&intervalName=$formula20&graphHeight=$formula21&graphWidth=$formula22\" border=\"0\">\n");
print("										</td>\n");
print("									</tr>\n");
print("								</table>\n");
print("							</td>\n");
 $graphDrawCounter++;
 } else {
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("							<td>\n");
print("								<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"table1\">\n");
print("									<tr>\n");
my $formula23=$hostName;my $formula24=$serviceName;my $formula25=$graphName;my $formula26=$intervalName;print("										<td class=\"tdTop\" nowrap=\"nowrap\">$formula23 :: $formula24 :: $formula25 :: $formula26</td>\n");
print("									</tr>\n");
print("									<tr>\n");
print("										<td class=\"liteGray\" nowrap valign=\"middle\" align=\"center\">\n");
my $formula27=$hostName;my $formula28=$serviceName;my $formula29=$graphName;my $formula30=$intervalName;my $formula31=$graphHeight;my $formula32=$graphWidth;print("											<img src=\"drawGraph/index.pl?action=drawGraph&hostName=$formula27&serviceName=$formula28&graphName=$formula29&intervalName=$formula30&graphHeight=$formula31&graphWidth=$formula32\" border=\"0\">\n");
print("										</td>		\n");
print("									</tr>\n");
print("								</table>\n");
print("							</td>	\n");
 $graphDrawCounter++;		
}
 if ($graphDrawCounter % $graphLayout == 0) {
print("						</tr>\n");
 }
}
}
}
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
