use strict;
package main;
print("<html>\n");
print("<head>\n");
print("	<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("	<title>PerfStat Tool: Status And Performance Monitoring</title>\n");
print("	<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("	<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">\n");
print("	<script language=\"javascript\" src=\"../../../appRez/javaScripts/contentFrame.js\"></script>\n");
print("</head>\n");

print("<body>\n");
print("	<div class=\"navHeader\">\n");
my $formula0=$sessionObj->param("hostName");print("		<a href=\"../list/index.pl\">Host Config</a> :: Service Metrics :: $formula0\n");
print("	</div>\n");
print("	<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("			<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Config Services</td>\n");
print("		</tr>\n");
print("			<tr>\n");
print("			<td class=\"darkGray\" align=\"left\" valign=\"top\">\n");
print("				<table border=\"0\" cellpadding=\"2\" cellspacing=\"2\">\n");
print("					<tr>	\n");
 foreach my $serviceName (sort(keys(%$serviceHashRefined))) {
 my $descriptorHash = $serviceHashRefined->{$serviceName};				
 if ($descriptorHash->{'hasSubService'} != 1) {
my $hostName = $sessionObj->param("hostName");
my $queryString = "action=selectMetricConfig&hostName=$hostName&serviceName=$serviceName&newHostName=$newHostName&ipAddress=$ipAddress&osName=$osName";
print("							<td width=\"40\" valign=\"top\" align=\"center\">	\n");
print("								<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" height=\"0%\" width=\"100%\">\n");
print("									<tr>\n");
my $formula1=$queryString;my $formula2=$serviceName;print("										<th nowrap=\"nowrap\"><a href=\"index.pl?$formula1\">$formula2</a></th>\n");
print("									</tr>\n");
print("								</table>\n");
print("							</td>\n");
 } else {
 my $subServiceHash = $descriptorHash->{'subServiceHash'};
print("							<td width=\"40\" valign=\"top\" align=\"center\">	\n");
my $formula3=$serviceName;print("								<div id=\"$formula3-off\" style=\"display:block;\">\n");
print("								<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" width=\"100%\">\n");
print("									<tr>\n");
my $formula4=$serviceName;my $formula5=$serviceName;my $formula6=$serviceName;my $formula7=$serviceName;print("										<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><a href=\"javascript:toggle('$formula4-off', '$formula5-on');\"><img id=\"x$formula6-off\" src=\"../../../appRez/images/navigation/icon_plusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a>&nbsp;$formula7</th>\n");
print("									</tr>\n");
print("								</table>\n");
print("								</div>\n");
my $formula8=$serviceName;print("								<div id=\"$formula8-on\" style=\"display:none;\">\n");
print("								<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" width=\"100%\">\n");
print("									<tr>\n");
my $formula9=$serviceName;my $formula10=$serviceName;my $formula11=$serviceName;my $formula12=$serviceName;print("										<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><a href=\"javascript:toggle('$formula9-off', '$formula10-on');\"><img id=\"x$formula11-on\" src=\"../../../appRez/images/navigation/icon_minusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a>&nbsp;$formula12</th>\n");
print("									</tr>\n");
print("									<tr>\n");
print("										<td valign=\"top\" align=\"center\">\n");
print("											<table border=\"0\" cellpadding=\"1\" cellspacing=\"1\" class=\"table2\">\n");
foreach my $subServiceHashKey (sort(keys(%$subServiceHash))) {
my $hostName = $sessionObj->param("hostName");
my $queryString = "action=selectMetricConfig&hostName=$hostName&serviceName=$serviceName.$subServiceHashKey&newHostName=$newHostName&ipAddress=$ipAddress&osName=$osName";
print("												<tr>\n");
my $formula13=$queryString;my $formula14=$subServiceHashKey;print("													<td style=\"text-align:right;\"><a href=\"index.pl?$formula13\">$formula14</a></td>\n");
print("												</tr>\n");
 }
print("											</table>\n");
print("										</td>\n");
print("									</tr>\n");
print("								</table>\n");
print("								</div>\n");
print("							</td>\n");
 }	
 }
print("					</tr>\n");
print("				</table>\n");
print("			</td>\n");
print("		</tr>\n");
print("		</table>\n");
print("		<div align=\"center\">\n");
print("			<form name=\"configMetrics\" action=\"index.pl\" method=\"post\">\n");
print("				<input type=\"hidden\" name=\"action\" value=\"setMetricThresholds\">\n");
my $formula15=$sessionObj->param("serviceName");print("				<input type=\"hidden\" name=\"serviceName\" value=\"$formula15\">\n");
my $formula16=$newHostName;print("				<input type=\"hidden\" name=\"newHostName\" value=\"$formula16\">\n");
my $formula17=$ipAddress;print("				<input type=\"hidden\" name=\"ipAddress\" value=\"$formula17\">\n");
my $formula18=$osName;print("				<input type=\"hidden\" name=\"osName\" value=\"$formula18\">\n");
print("				<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("					<tr>\n");
my $formula19=$sessionObj->param("serviceName");print("						<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"6\" valign=\"middle\" align=\"left\">$formula19</td>\n");
print("					</tr>\n");
 if ($sessionObj->param("userMessage2") ne "") {
print("						<tr>\n");
my $formula20=$sessionObj->param("userMessage2");print("						<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"6\"><span class=\"userMessage\">$formula20</span></td>\n");
print("					</tr>\n");
 $sessionObj->param("userMessage2", "");
 }
print("					<tr>\n");
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Metric</th>\n");
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Warn</th>\n");
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Crit</th>\n");
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Last&nbsp;</th>\n");
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Unit</th>\n");
print("						<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Events</th>\n");
print("					</tr>\n");
 my $count = keys(%$serviceHashRefined);
 if ($count != 0) {
my $serviceMetricArrayLen = @$serviceMetricArray;
 for (my $count = 0; $count < $serviceMetricArrayLen; $count++) {
 my $metricObject = $serviceMetricArray->[$count];
 my $hasEvents = $metricObject->getHasEvents();
 if ($hasEvents == 1) {
 my $friendlyName = $metricObject->getFriendlyName();
 my $warnThreshold = $metricObject->getWarnThreshold();
 my $critThreshold = $metricObject->getCritThreshold();
 my $metricValue = $metricObject->getMetricValue();
 my $thresholdUnit = $metricObject->getThresholdUnit();
print("								<tr>\n");
my $formula21=$friendlyName;print("									<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula21</span></td>\n");
my $formula22=$count;my $formula23=$warnThreshold;print("									<td class=\"liteGray\" valign=\"top\" align=\"left\"><input type=\"text\" name=\"warnThreshold_$formula22\" size=\"10\" value=\"$formula23\"></td>\n");
my $formula24=$count;my $formula25=$critThreshold;print("									<td class=\"liteGray\" valign=\"top\" align=\"left\"><input type=\"text\" name=\"critThreshold_$formula24\" size=\"10\" value=\"$formula25\"></td>\n");
my $formula26=$metricValue;print("									<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula26</span></td>\n");
my $formula27=$thresholdUnit;print("									<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula27</span></td>\n");
my $formula28=$count;print("									<td class=\"liteGray\" valign=\"top\" align=\"middle\"><input type=\"checkbox\" name=\"hasEvents_$formula28\" size=\"10\" CHECKED></td>\n");
print("								</tr>\n");
 } elsif ($hasEvents == 0) {
 my $friendlyName = $metricObject->getFriendlyName();
 my $warnThreshold = $metricObject->getWarnThreshold();
 my $critThreshold = $metricObject->getCritThreshold();
 my $metricValue = $metricObject->getMetricValue();
 my $thresholdUnit = $metricObject->getThresholdUnit();
print("								<tr>\n");
my $formula29=$friendlyName;print("									<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula29</td>\n");
my $formula30=$warnThreshold;print("									<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula30</td>\n");
my $formula31=$critThreshold;print("									<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula31</td>\n");
my $formula32=$metricValue;print("									<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula32</span></td>\n");
my $formula33=$thresholdUnit;print("									<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula33</td>\n");
my $formula34=$count;print("									<td class=\"liteGray\" valign=\"top\" align=\"middle\"><input type=\"checkbox\" name=\"hasEvents_$formula34\" size=\"10\"></td>\n");
print("								</tr>\n");
}
 }
print("						<tr>\n");
print("							<td class=\"liteGray\" valign=\"top\" align=\"right\" colspan=\"6\"><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"update\"></td>\n");
print("						</tr>\n");
 }
print("				</table>\n");
print("			</form>\n");
print("		</div>\n");
print("	</body>\n");
print("</html>\n");
