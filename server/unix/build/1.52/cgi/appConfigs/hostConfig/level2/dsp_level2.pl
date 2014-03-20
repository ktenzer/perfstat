use strict;
package main;
print("<html>\n");
print("<head>\n");
print("	<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("	<title>PerfStat Tool: Status And Performance Monitoring</title>\n");
print("	<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("	<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/forms.css\" media=\"screen\">\n");
print("	<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/contentFrame.js\"></script>\n");
print("</head>\n");

print("<body>\n");
print("	<div class=\"navHeader\">\n");
my $formula0=$sessionObj->param("selectedAdmin");my $formula1=$sessionObj->param("hostName");print("		<a href=\"../level1/index.pl\">Host Config</a> :: $formula0 :: $formula1
print("	</div>
print("	<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"4\" valign=\"middle\" align=\"left\">Modify Host</td>
print("			</tr>
 if ($sessionObj->param("userMessage1") ne "") {
print("			<tr>
my $formula2=$sessionObj->param("userMessage1");print("				<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"4\"><span class=\"userMessage\">$formula2</span></td>
print("			</tr>
 $sessionObj->param("userMessage1", "");
 }
print("			<tr>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">IP</th>
print("				<th nowrap=\"nowrap\" valign=\"top\" align=\"left\">OS</th>
print("				<th nowrap=\"nowrap\">Actions</th>
print("			</tr>
print("			<tr>
print("				<form  action=\"index.pl\" method=\"post\">
print("				<input type=\"hidden\" name=\"action\" value=\"updateItem\">
my $formula3=$osName;print("				<input type=\"hidden\" name=\"osName\" value=\"$formula3\">
my $formula4=$newHostName;print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><input type=\"text\" name=\"newHostName\" value=\"$formula4\" size=\"24\"></td>
my $formula5=$ipAddress;print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><input type=\"text\" name=\"ipAddress\" value=\"$formula5\" size=\"24\"></td>
my $formula6=$osName;print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\"><span class=\"table1Text1\">$formula6</span></td>
print("					<td class=\"darkGray\" align=\"center\" valign=\"middle\">
print("						<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" >
print("							<tr>
print("								<td nowrap=\"nowrap\"><input class=\"liteButton\" type=\"submit\" name=\"submit\" value=\"ENTER\"></td>
print("							</tr>
print("						</table>
print("					</td>
print("				</form>
print("			</tr>
print("		</table>
print("	<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("			<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Config Services</td>
print("		</tr>
print("			<tr>
print("			<td class=\"darkGray\" align=\"left\" valign=\"top\">
print("				<table border=\"0\" cellpadding=\"2\" cellspacing=\"2\">
print("					<tr>	
 foreach my $serviceName (sort(keys(%$serviceHashRefined))) {
 my $descriptorHash = $serviceHashRefined->{$serviceName};				
 if ($descriptorHash->{'hasSubService'} != 1) {
my $hostName = $sessionObj->param("hostName");
my $queryString = "action=selectMetricConfig&hostName=$hostName&serviceName=$serviceName&newHostName=$newHostName&ipAddress=$ipAddress&osName=$osName";
print("							<td width=\"40\" valign=\"top\" align=\"center\">	
print("								<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" height=\"0%\" width=\"100%\">
print("									<tr>
my $formula7=$queryString;my $formula8=$serviceName;print("										<th nowrap=\"nowrap\"><a href=\"index.pl?$formula7\">$formula8</a></th>
print("									</tr>
print("								</table>
print("							</td>
 } else {
 my $subServiceHash = $descriptorHash->{'subServiceHash'};
print("							<td width=\"40\" valign=\"top\" align=\"center\">	
my $formula9=$serviceName;print("								<div id=\"$formula9-off\" style=\"display:block;\">
print("								<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" width=\"100%\">
print("									<tr>
my $formula10=$serviceName;my $formula11=$serviceName;my $formula12=$serviceName;my $formula13=$serviceName;print("										<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><a href=\"javascript:toggle('$formula10-off', '$formula11-on');\"><img id=\"x$formula12-off\" src=\"../../../perfStatResources/images/navigation/icon_plusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a>&nbsp;$formula13</th>
print("									</tr>
print("								</table>
print("								</div>
my $formula14=$serviceName;print("								<div id=\"$formula14-on\" style=\"display:none;\">
print("								<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" width=\"100%\">
print("									<tr>
my $formula15=$serviceName;my $formula16=$serviceName;my $formula17=$serviceName;my $formula18=$serviceName;print("										<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><a href=\"javascript:toggle('$formula15-off', '$formula16-on');\"><img id=\"x$formula17-on\" src=\"../../../perfStatResources/images/navigation/icon_minusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a>&nbsp;$formula18</th>
print("									</tr>
print("									<tr>
print("										<td valign=\"top\" align=\"center\">
print("											<table border=\"0\" cellpadding=\"1\" cellspacing=\"1\" class=\"table2\">
foreach my $subServiceHashKey (sort(keys(%$subServiceHash))) {
my $hostName = $sessionObj->param("hostName");
my $queryString = "action=selectMetricConfig&hostName=$hostName&serviceName=$serviceName.$subServiceHashKey&newHostName=$newHostName&ipAddress=$ipAddress&osName=$osName";
print("												<tr>
my $formula19=$queryString;my $formula20=$subServiceHashKey;print("													<td style=\"text-align:right;\"><a href=\"index.pl?$formula19\">$formula20</a></td>
print("												</tr>
 }
print("											</table>
print("										</td>
print("									</tr>
print("								</table>
print("								</div>
print("							</td>
 }	
 }
print("					</tr>
print("				</table>
print("			</td>
print("		</tr>
print("		</table>
print("		<div align=\"center\">
print("			<form name=\"configMetrics\" action=\"index.pl\" method=\"post\">
print("				<input type=\"hidden\" name=\"action\" value=\"setMetricThresholds\">
my $formula21=$sessionObj->param("serviceName");print("				<input type=\"hidden\" name=\"serviceName\" value=\"$formula21\">
my $formula22=$newHostName;print("				<input type=\"hidden\" name=\"newHostName\" value=\"$formula22\">
my $formula23=$ipAddress;print("				<input type=\"hidden\" name=\"ipAddress\" value=\"$formula23\">
my $formula24=$osName;print("				<input type=\"hidden\" name=\"osName\" value=\"$formula24\">
print("				<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("					<tr>\n");
my $formula25=$sessionObj->param("serviceName");print("						<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"5\" valign=\"middle\" align=\"left\">$formula25</td>\n");
print("					</tr>
 if ($sessionObj->param("userMessage2") ne "") {
print("						<tr>\n");
my $formula26=$sessionObj->param("userMessage2");print("						<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"5\"><span class=\"userMessage\">$formula26</span></td>\n");
print("					</tr>
 $sessionObj->param("userMessage2", "");
 }
print("					<tr>
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Metric</th>
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Warn</th>
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Crit</th>
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Unit</th>\n");
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Events</th>\n");
print("					</tr>
 my $count = keys(%$serviceHashRefined);
 if ($count != 0) {
my $serviceMetricArrayLen = @$serviceMetricArray;
 for (my $count = 0; $count < $serviceMetricArrayLen; $count++) {
 my $metricObject = $serviceMetricArray->[$count];
 my $hasEvents = $metricObject->getHasEvents();
 #my $hasEvents = 0;
 if ($hasEvents == 1) {
 my $friendlyName = $metricObject->getFriendlyName();
 my $warnThreshold = $metricObject->getWarnThreshold();
 my $critThreshold = $metricObject->getCritThreshold();
 my $thresholdUnit = $metricObject->getThresholdUnit();
print("								<tr>
my $formula27=$friendlyName;print("									<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula27</td>
my $formula28=$count;my $formula29=$warnThreshold;print("									<td class=\"liteGray\" valign=\"top\" align=\"left\"><input type=\"text\" name=\"warnThreshold_$formula28\" size=\"10\" value=\"$formula29\"></td>
my $formula30=$count;my $formula31=$critThreshold;print("									<td class=\"liteGray\" valign=\"top\" align=\"left\"><input type=\"text\" name=\"critThreshold_$formula30\" size=\"10\" value=\"$formula31\"></td>
my $formula32=$count;my $formula33=$thresholdUnit;print("									<td class=\"liteGray\" valign=\"top\" align=\"left\"><input type=\"text\" name=\"thresholdUnit_$formula32\" size=\"10\" value=\"$formula33\"></td>
my $formula34=$count;print("									<td class=\"liteGray\" valign=\"top\" align=\"middle\"><input type=\"checkbox\" name=\"hasEvents_$formula34\" size=\"10\" CHECKED></td>
print("								</tr>
 } elsif ($hasEvents == 0) {
 my $friendlyName = $metricObject->getFriendlyName();
 my $warnThreshold = $metricObject->getWarnThreshold();
 my $critThreshold = $metricObject->getCritThreshold();
 my $thresholdUnit = $metricObject->getThresholdUnit();
print("								<tr>
my $formula35=$friendlyName;print("									<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula35</td>
my $formula36=$warnThreshold;print("									<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula36</td>
my $formula37=$critThreshold;print("									<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula37</td>
my $formula38=$thresholdUnit;print("									<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula38</td>
my $formula39=$count;print("									<td class=\"liteGray\" valign=\"top\" align=\"middle\"><input type=\"checkbox\" name=\"hasEvents_$formula39\" size=\"10\"></td>
print("								</tr>
}
 }
print("						<tr>\n");
print("						<td class=\"liteGray\" valign=\"top\" align=\"right\" colspan=\"5\"><input class=\"liteButton\" type=\"button\" name=\"Delete\" value=\"delete\"><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"update\"></td>\n");
print("					</tr>
 }
print("				</table>
print("			</form>
print("		</div>
print("	</body>\n");
print("</html>\n");