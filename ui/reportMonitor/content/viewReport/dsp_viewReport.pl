use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/contentFrame.js\"></script>\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/rm.content.js\"></script>\n");
print("	</head>\n");
print("\n");
my $formula0=$updateNav;;print("<body onLoad=\"$formula0\">\n");
print("<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">\n");
 foreach my $tempColArray (@$displayRowArray) {
print("		<tr>\n");
 foreach my $tempStruct (@$tempColArray) {
 my $colSpan = $tempStruct->{'colSpan'};
 my $contentStruct = $tempStruct->{'payload'};
my $formula1=$colSpan;print("			<td valign=\"top\" colspan=\"$formula1\">\n");
if ($contentStruct->{'contentType'} eq "textComment") {
print("				<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("					<tr>\n");
print("						<td class=\"liteGray\" style=\"padding:5px;\"> \n");
my $formula2=$contentStruct->{'textComment'};print("		  					<span style=\"font:normal normal normal 15px Arial, Helvetica, sans-serif;\">$formula2</span>\n");
print("						</td>\n");
print("					</tr>\n");
print("				</table>\n");
} elsif ($contentStruct->{'contentType'} eq "hostGroupGraph") {
my $hgName = $contentStruct->{'hgName'};
my $serviceName = $contentStruct->{'serviceName'};
my $graphName = $contentStruct->{'graphName'};
my $intervalName = $contentStruct->{'intervalName'};
my $graphType = $contentStruct->{'graphType'};
print("				<table class=\"table1\" style=\"margin-right:3px;\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">\n");
print("					<tr>\n");
my $formula3=$fontSize;my $formula4=$hgName;my $formula5=$serviceName;my $formula6=$graphName;my $formula7=$intervalName;print("						<td class=\"tdTop\" style=\"font-size: $formula3\" nowrap=\"nowrap\">$formula4 :: $formula5 :: $formula6 :: $formula7</td>\n");
print("					</tr>\n");
print("					<tr>\n");
print("						<td class=\"liteGray\" nowrap valign=\"middle\" align=\"center\">\n");
if ($graphType eq "bar") {
my $formula8=$hgName;my $formula9=$serviceName;my $formula10=$graphName;my $formula11=$intervalName;my $formula12=$graphScale;print("								<img src=\"../../../appLib/graphs/hostgroupGraphs/singleServiceGraphs/drawGDGraph/index.pl?action=drawGraph&hgName=$formula8&serviceName=$formula9&graphName=$formula10&intervalName=$formula11&graphScale=$formula12&graphType=bar\" border=\"0\">\n");
} elsif ($graphType eq "pie") {
my $formula13=$hgName;my $formula14=$serviceName;my $formula15=$graphName;my $formula16=$intervalName;my $formula17=$graphScale;print("								<img src=\"../../../appLib/graphs/hostgroupGraphs/singleServiceGraphs/drawGDGraph/index.pl?action=drawGraph&hgName=$formula13&serviceName=$formula14&graphName=$formula15&intervalName=$formula16&graphScale=$formula17&graphType=pie\" border=\"0\">\n");
}
print("						</td>\n");
print("					</tr>\n");
print("				</table>\n");
} elsif ($contentStruct->{'contentType'} eq "hostAssets") {
my $hostName = $contentStruct->{'hostName'};
my $displayHostName = $contentStruct->{'displayHostName'};
my $cpuAssets = $contentStruct->{'cpuAssets'};
my $numCPUassets = @$cpuAssets;
my $memAssets = $contentStruct->{'memoryAssets'};
my $numMemAssets = @$memAssets;
my $osAssets = $contentStruct->{'osAssets'};
my $numOSassets = @$osAssets;
my $hostObject = populateHostObject($hostName);
print("				<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"table1\">\n");
print("					<tr>\n");
my $formula18=$displayHostName;print("						<td class=\"tdTop\" nowrap=\"nowrap\">$formula18</td>\n");
print("					</tr>\n");
print("					<tr>\n");
print("						<td class=\"liteGray\" nowrap valign=\"middle\" align=\"left\">&nbsp;</td>\n");
print("					</tr>\n");
print("					<tr>\n");
print("						<td class=\"liteGray\" nowrap valign=\"middle\" align=\"left\">\n");
print("							<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">\n");
print("								<tr>\n");
if ($numCPUassets) {
print("									<td valign=\"top\">\n");
print("										<table class=\"table2\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\">\n");
print("											<tr align=\"left\">\n");
print("												<th colspan=\"2\" nowrap=\"nowrap\">CPU</th>\n");
print("											</tr>\n");
if (searchArray($cpuAssets, 'model')) {
 my $cpuModel = $hostObject->getCpuModel();
print("											<tr>\n");
print("												<td style=\"text-align:right;\"><span class=\"table1Text2\"><b>Model:</b></td>\n");
my $formula19=$cpuModel;print("												<td style=\"text-align:left;\"><span class=\"table1Text2\">$formula19</td>\n");
print("											</tr>\n");
}
if (searchArray($cpuAssets, 'speed')) {
 my $cpuSpeed = $hostObject->getCpuSpeed();
print("											<tr>\n");
print("												<td style=\"text-align:right;\"><span class=\"table1Text2\"><b>Speed:</b></td>\n");
my $formula20=$cpuSpeed;print("												<td nowrap style=\"text-align:left;\"><span class=\"table1Text2\">$formula20 MHZ</td>\n");
print("											</tr>\n");
}
if (searchArray($cpuAssets, 'number')) {
 my $cpuNum = $hostObject->getCpuNum();
print("											<tr>\n");
print("												<td style=\"text-align:right;\"><span class=\"table1Text2\"><b>Number:</b></td>\n");
my $formula21=$cpuNum;print("												<td style=\"text-align:left;\"><span class=\"table1Text2\">$formula21</td>\n");
print("											</tr>\n");
}
print("										</table>\n");
print("									</td>\n");
print("									<td>&nbsp;<td>\n");
}
if ($numMemAssets) {
print("									<td valign=\"top\">\n");
print("										<table class=\"table2\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\">\n");
print("											<tr align=\"left\">\n");
print("												<th colspan=\"2\" nowrap=\"nowrap\">Mem</th>\n");
print("											</tr>\n");
if (searchArray($memAssets, 'total')) {
 my $memTotal = $hostObject->getMemTotal();
print("											<tr>\n");
print("												<td style=\"text-align:right;\"><span class=\"table1Text2\"><b>Total:</b></td>\n");
my $formula22=$memTotal;print("												<td nowrap style=\"text-align:left;\"><span class=\"table1Text2\">$formula22 MB</td>\n");
print("											</tr>\n");
}
print("										</table>\n");
print("									</td>\n");
print("									<td>&nbsp;<td>\n");
}
if ($numOSassets) {
print("									<td valign=\"top\">\n");
print("										<table class=\"table2\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\">\n");
print("											<tr align=\"left\">\n");
print("												<th colspan=\"2\" nowrap=\"nowrap\">OS</th>\n");
print("											</tr>\n");
if (searchArray($osAssets, 'name')) {
 my $os = $hostObject->getOS();
print("											<tr>\n");
print("												<td style=\"text-align:right;\"><span class=\"table1Text2\"><b>Name:</b></td>\n");
my $formula23=$os;print("												<td style=\"text-align:left;\"><span class=\"table1Text2\">$formula23</td>\n");
print("											</tr>\n");
}
if (searchArray($osAssets, 'version')) {
 my $osVer = $hostObject->getOsVer();
print("											<tr>\n");
print("												<td style=\"text-align:right;\"><span class=\"table1Text2\"><b>Version:</b></td>\n");
my $formula24=$osVer;print("												<td style=\"text-align:left;\"><span class=\"table1Text2\">$formula24</td>\n");
print("											</tr>\n");
}
if (searchArray($osAssets, 'kernel')) {
 my $kernelVer = $hostObject->getKernelVer();
print("											<tr>\n");
print("												<td style=\"text-align:right;\"><span class=\"table1Text2\"><b>Kernel:</b></td>\n");
my $formula25=$kernelVer;print("												<td style=\"text-align:left;\"><span class=\"table1Text2\">$formula25</td>\n");
print("											</tr>\n");
}
if (searchArray($osAssets, 'patchList')) {
 my $patchArray = $hostObject->getPatchesArray();
print("											<tr>\n");
print("												<td valign=\"top\" style=\"text-align:right;\"><span class=\"table1Text2\"><b>Patch List:</b></td>\n");
print("												<td style=\"text-align:left;\"><span class=\"table1Text2\">\n");
foreach my $patchName (sort(@$patchArray)) {
my $formula26=$patchName;print("														$formula26,&nbsp;\n");
}
print("												</td>\n");
print("											</tr>\n");
}
print("										</table>\n");
print("									</td>\n");
}
print("								</tr>\n");
print("							</table>\n");
print("						</td>\n");
print("					</tr>\n");
print("					<tr>\n");
print("						<td class=\"liteGray\" nowrap valign=\"middle\" align=\"left\">&nbsp;</td>\n");
print("					</tr>\n");
print("				</table>\n");
} elsif ($contentStruct->{'contentType'} eq "hostEvent") {
my $hostName = $contentStruct->{'hostName'};
my $displayHostName = $contentStruct->{'displayHostName'};
my $serviceName = $contentStruct->{"serviceName"};
print("				<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"table1\">\n");
print("					<tr>\n");
my $formula27=$displayHostName;my $formula28=$serviceName;print("						<td class=\"tdTop\" nowrap=\"nowrap\">Event Log :: $formula27 :: $formula28</td>\n");
print("					</tr>\n");
print("					<tr>\n");
print("						<td class=\"liteGray\" nowrap valign=\"middle\" align=\"center\" style=\"padding:10px;\">\n");
my $formula29=$hostName;my $formula30=$serviceName;print("							<iframe scrolling=\"auto\" width=\"600\" height=\"150\" frameborder=\"0\" src=\"index.pl?action=displayEventLog&hostName=$formula29&serviceName=$formula30\"></iframe>\n");
print("						</td>\n");
print("					</tr>\n");
print("				</table>\n");
} elsif ($contentStruct->{'contentType'} eq "hostGraph") {
my $os = $contentStruct->{'osName'};
my $hostName = $contentStruct->{'hostName'};
my $displayHostName = $contentStruct->{'displayHostName'};
my $serviceName = $contentStruct->{'serviceName'};
my $graphName = $contentStruct->{'graphName'};
my $intervalName = $contentStruct->{'intervalName'};
my $graphType = $contentStruct->{'graphType'};
my $graphIndex = "multiServiceGraphs";
if ( $contentStruct->{'graphServiceType'} eq "singleService") {
$graphIndex = "singleServiceGraphs";
} elsif ($contentStruct->{'graphServiceType'} eq "aggregateSubService" && $serviceName =~ /^.+\.Total\b/) {						
$graphIndex = "singleServiceGraphs";
};
print("				<table class=\"table1\" style=\"margin-right:3px;\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">\n");
print("					<tr>\n");
my $formula31=$fontSize;my $formula32=$displayHostName;my $formula33=$serviceName;my $formula34=$graphName;my $formula35=$intervalName;print("						<td class=\"tdTop\" style=\"font-size: $formula31\" nowrap=\"nowrap\">$formula32 :: $formula33 :: $formula34 :: $formula35</td>\n");
print("					</tr>\n");
print("					<tr>\n");
print("						<td class=\"liteGray\" nowrap valign=\"middle\" align=\"center\" style=\"padding:6px 8px 6px 6px;\">\n");
if ($graphType eq "line") {
my $formula36=$graphIndex;my $formula37=$os;my $formula38=$hostName;my $formula39=$serviceName;my $formula40=$graphName;my $formula41=$intervalName;my $formula42=$graphScale;print("								<img src=\"../../../appLib/graphs/hostGraphs/$formula36/drawLineGraph/index.pl?action=drawGraph&os=$formula37&hostName=$formula38&serviceName=$formula39&graphName=$formula40&intervalName=$formula41&graphScale=$formula42\" border=\"0\">\n");
} elsif ($graphType eq "bar") {
my $formula43=$graphIndex;my $formula44=$os;my $formula45=$hostName;my $formula46=$serviceName;my $formula47=$graphName;my $formula48=$intervalName;my $formula49=$graphScale;print("								<img src=\"../../../appLib/graphs/hostGraphs/$formula43/drawGDGraph/index.pl?action=drawGraph&os=$formula44&hostName=$formula45&serviceName=$formula46&graphName=$formula47&intervalName=$formula48&graphScale=$formula49&graphType=bar\" border=\"0\">\n");
} elsif ($graphType eq "pie") {
my $formula50=$graphIndex;my $formula51=$os;my $formula52=$hostName;my $formula53=$serviceName;my $formula54=$graphName;my $formula55=$intervalName;my $formula56=$graphScale;print("								<img src=\"../../../appLib/graphs/hostGraphs/$formula50/drawGDGraph/index.pl?action=drawGraph&os=$formula51&hostName=$formula52&serviceName=$formula53&graphName=$formula54&intervalName=$formula55&graphScale=$formula56&graphType=pie\" border=\"0\">\n");
}
print("						</td>\n");
print("					</tr>\n");
print("				</table>\n");
} elsif ($contentStruct->{'contentType'} eq "blank") {
print("				&nbsp;\n");
}
print("			</td>\n");
 }
print("		</tr>\n");
}
print("</table>\n");
print("</body>\n");
print("</html>\n");
