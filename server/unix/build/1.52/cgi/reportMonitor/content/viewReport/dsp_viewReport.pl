use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/contentFrame.js\"></script>\n");
print("	</head>\n");
print("\n");
print("	<body>\n");
foreach $contentStruct (@$contentArray) {
if ($contentStruct->{'contentType'} eq "textComment") {
print("					<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"table1\">\n");
print("						<tr>\n");
print("							<td class=\"liteGray\" style=\"padding:5px;\">\n");
my $formula0=$contentStruct->{'textComment'};print("								<span style=\"font:normal normal normal 15px Times, TimesNR, serif;\">$formula0</span>\n");
print("							</td>\n");
print("						</tr>\n");
print("					</table>\n");
} elsif ($contentStruct->{'contentType'} eq "hostGroupGraph") {
my $hgName = $contentStruct->{'hgName'};
my $serviceName = $contentStruct->{'serviceName'};
my $graphName = $contentStruct->{'graphName'};
my $intervalName = $contentStruct->{'intervalName'};
my $graphType = $contentStruct->{'graphType'};
print("					<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"table1\">\n");
print("						<tr>\n");
my $formula1=$hgName;my $formula2=$serviceName;my $formula3=$graphName;my $formula4=$intervalName;print("							<td class=\"tdTop\" nowrap=\"nowrap\">$formula1 :: $formula2 :: $formula3 :: $formula4</td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td class=\"liteGray\" nowrap valign=\"middle\" align=\"center\">\n");
if ($graphType eq "bar") {
my $formula5=$hgName;my $formula6=$serviceName;my $formula7=$graphName;my $formula8=$intervalName;print("									<img src=\"../../../performanceMonitor/content/displayHGGraphs/singleServiceGraphs/drawGDGraph/index.pl?action=drawGraph&hgName=$formula5&serviceName=$formula6&graphName=$formula7&intervalName=$formula8&graphScale=1&graphType=bar\" border=\"0\">\n");
} elsif ($graphType eq "pie") {
my $formula9=$hgName;my $formula10=$serviceName;my $formula11=$graphName;my $formula12=$intervalName;print("									<img src=\"../../../performanceMonitor/content/displayHGGraphs/singleServiceGraphs/drawGDGraph/index.pl?action=drawGraph&hgName=$formula9&serviceName=$formula10&graphName=$formula11&intervalName=$formula12&graphScale=1&graphType=pie\" border=\"0\">\n");
}
print("							</td>\n");
print("						</tr>\n");
print("					</table>\n");
} elsif ($contentStruct->{'contentType'} eq "hostAssets") {
my $hostName = $contentStruct->{'hostName'};
my $cpuAssets = $contentStruct->{'cpuAssets'};
my $numCPUassets = @$cpuAssets;
my $memAssets = $contentStruct->{'memoryAssets'};
my $numMemAssets = @$memAssets;
my $osAssets = $contentStruct->{'osAssets'};
my $numOSassets = @$osAssets;
my $hostObject = populateHostObject($hostName);
print("					<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"table1\">\n");
print("						<tr>\n");
my $formula13=$hostName;print("							<td class=\"tdTop\" nowrap=\"nowrap\">$formula13</td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td class=\"liteGray\" nowrap valign=\"middle\" align=\"left\">&nbsp;</td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td class=\"liteGray\" nowrap valign=\"middle\" align=\"left\">\n");
print("								<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">\n");
print("									<tr>\n");
if ($numCPUassets) {
print("										<td valign=\"top\">\n");
print("											<table class=\"table2\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\">\n");
print("												<tr align=\"left\">\n");
print("													<th colspan=\"2\" nowrap=\"nowrap\">CPU</th>\n");
print("												</tr>\n");
if (searchArray($cpuAssets, 'model')) {
 my $cpuModel = $hostObject->getCpuModel();
print("												<tr>\n");
print("													<td style=\"text-align:right;\"><span class=\"table1Text2\"><b>Model:</b></td>\n");
my $formula14=$cpuModel;print("													<td style=\"text-align:left;\"><span class=\"table1Text2\">$formula14</td>\n");
print("												</tr>\n");
}
if (searchArray($cpuAssets, 'speed')) {
 my $cpuSpeed = $hostObject->getCpuSpeed();
print("												<tr>\n");
print("													<td style=\"text-align:right;\"><span class=\"table1Text2\"><b>Speed:</b></td>\n");
my $formula15=$cpuSpeed;print("													<td nowrap style=\"text-align:left;\"><span class=\"table1Text2\">$formula15 MHZ</td>\n");
print("												</tr>\n");
}
if (searchArray($cpuAssets, 'number')) {
 my $cpuNum = $hostObject->getCpuNum();
print("												<tr>\n");
print("													<td style=\"text-align:right;\"><span class=\"table1Text2\"><b>Number:</b></td>\n");
my $formula16=$cpuNum;print("													<td style=\"text-align:left;\"><span class=\"table1Text2\">$formula16</td>\n");
print("												</tr>\n");
}
print("											</table>\n");
print("										</td>\n");
print("										<td>&nbsp;<td>\n");
}
if ($numMemAssets) {
print("										<td valign=\"top\">\n");
print("											<table class=\"table2\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\">\n");
print("												<tr align=\"left\">\n");
print("													<th colspan=\"2\" nowrap=\"nowrap\">Mem</th>\n");
print("												</tr>\n");
if (searchArray($memAssets, 'total')) {
 my $memTotal = $hostObject->getMemTotal();
print("												<tr>\n");
print("													<td style=\"text-align:right;\"><span class=\"table1Text2\"><b>Total:</b></td>\n");
my $formula17=$memTotal;print("													<td nowrap style=\"text-align:left;\"><span class=\"table1Text2\">$formula17 MB</td>\n");
print("												</tr>\n");
}
print("											</table>\n");
print("										</td>\n");
print("										<td>&nbsp;<td>\n");
}
if ($numOSassets) {
print("										<td valign=\"top\">\n");
print("											<table class=\"table2\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\">\n");
print("												<tr align=\"left\">\n");
print("													<th colspan=\"2\" nowrap=\"nowrap\">OS</th>\n");
print("												</tr>\n");
if (searchArray($osAssets, 'name')) {
 my $os = $hostObject->getOS();
print("												<tr>\n");
print("													<td style=\"text-align:right;\"><span class=\"table1Text2\"><b>Name:</b></td>\n");
my $formula18=$os;print("													<td style=\"text-align:left;\"><span class=\"table1Text2\">$formula18</td>\n");
print("												</tr>\n");
}
if (searchArray($osAssets, 'version')) {
 my $osVer = $hostObject->getOsVer();
print("												<tr>\n");
print("													<td style=\"text-align:right;\"><span class=\"table1Text2\"><b>Version:</b></td>\n");
my $formula19=$osVer;print("													<td style=\"text-align:left;\"><span class=\"table1Text2\">$formula19</td>\n");
print("												</tr>\n");
}
if (searchArray($osAssets, 'kernel')) {
 my $kernelVer = $hostObject->getKernelVer();
print("												<tr>\n");
print("													<td style=\"text-align:right;\"><span class=\"table1Text2\"><b>Kernel:</b></td>\n");
my $formula20=$kernelVer;print("													<td style=\"text-align:left;\"><span class=\"table1Text2\">$formula20</td>\n");
print("												</tr>\n");
}
if (searchArray($osAssets, 'patchList')) {
 my $patchArray = $hostObject->getPatchesArray();
print("												<tr>\n");
print("													<td valign=\"top\" style=\"text-align:right;\"><span class=\"table1Text2\"><b>Patch List:</b></td>\n");
print("													<td style=\"text-align:left;\"><span class=\"table1Text2\">\n");
foreach my $patchName (sort(@$patchArray)) {
my $formula21=$patchName;print("								 							$formula21,&nbsp;\n");
}
print("													</td>\n");
print("												</tr>\n");
}
print("											</table>\n");
print("										</td>\n");
}
print("									</tr>\n");
print("								</table>\n");
print("							</td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td class=\"liteGray\" nowrap valign=\"middle\" align=\"left\">&nbsp;</td>\n");
print("						</tr>\n");
print("					</table>\n");
} elsif ($contentStruct->{'contentType'} eq "hostEvent") {
my $hostName = $contentStruct->{'hostName'};
my $serviceName = $contentStruct->{"serviceName"};
print("					<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"table1\">\n");
print("						<tr>\n");
my $formula22=$hostName;my $formula23=$serviceName;print("							<td class=\"tdTop\" nowrap=\"nowrap\">Event Log :: $formula22 :: $formula23</td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td class=\"liteGray\" nowrap valign=\"middle\" align=\"center\" style=\"padding:10px;\">\n");
my $formula24=$hostName;my $formula25=$serviceName;print("								<iframe scrolling=\"auto\" width=\"600\" height=\"150\" frameborder=\"0\" src=\"index.pl?action=displayEventLog&hostName=$formula24&serviceName=$formula25\"></iframe>\n");
print("							</td>\n");
print("						</tr>\n");
print("					</table>\n");
} elsif ($contentStruct->{'contentType'} eq "hostGraph") {
my $os = $contentStruct->{'osName'};
my $hostName = $contentStruct->{'hostName'};
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
print("\n");
print("					<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"table1\">\n");
print("						<tr>\n");
my $formula26=$hostName;my $formula27=$serviceName;my $formula28=$graphName;my $formula29=$intervalName;print("							<td class=\"tdTop\" nowrap=\"nowrap\">$formula26 :: $formula27 :: $formula28 :: $formula29</td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td class=\"liteGray\" nowrap valign=\"middle\" align=\"center\" style=\"padding:6px 8px 6px 6px;\">\n");
if ($graphType eq "line") {
my $formula30=$graphIndex;my $formula31=$os;my $formula32=$hostName;my $formula33=$serviceName;my $formula34=$graphName;my $formula35=$intervalName;print("									<img src=\"../../../performanceMonitor/content/displayHostGraphs/$formula30/drawLineGraph/index.pl?action=drawGraph&os=$formula31&hostName=$formula32&serviceName=$formula33&graphName=$formula34&intervalName=$formula35&graphScale=1\" border=\"0\">\n");
} elsif ($graphType eq "bar") {
my $formula36=$graphIndex;my $formula37=$os;my $formula38=$hostName;my $formula39=$serviceName;my $formula40=$graphName;my $formula41=$intervalName;print("									<img src=\"../../../performanceMonitor/content/displayHostGraphs/$formula36/drawGDGraph/index.pl?action=drawGraph&os=$formula37&hostName=$formula38&serviceName=$formula39&graphName=$formula40&intervalName=$formula41&graphScale=1&graphType=bar\" border=\"0\">\n");
} elsif ($graphType eq "pie") {
my $formula42=$graphIndex;my $formula43=$os;my $formula44=$hostName;my $formula45=$serviceName;my $formula46=$graphName;my $formula47=$intervalName;print("									<img src=\"../../../performanceMonitor/content/displayHostGraphs/$formula42/drawGDGraph/index.pl?action=drawGraph&os=$formula43&hostName=$formula44&serviceName=$formula45&graphName=$formula46&intervalName=$formula47&graphScale=1&graphType=pie\" border=\"0\">\n");
}
print("							</td>\n");
print("						</tr>\n");
print("					</table>\n");
}
}
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
