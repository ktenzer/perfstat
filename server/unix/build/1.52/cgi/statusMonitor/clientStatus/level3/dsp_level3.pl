use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/contentFrame.js\"></script>\n");
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/sm.level3.js\"></script>\n");
print("	</head>\n");
print("\n");
my $formula0=$sessionObj->param("serviceName");print("	<body onLoad=\"parent.navigation.setLinkChosen('clientStatus'); statusLevel3InitialToggle('$formula0');\">\n");
print("		<div class=\"navHeader\">\n");
my $formula1=$sessionObj->param("groupViewStatus") ne "shared" ?  "My HostGroups" : "Shared HostGroups";my $formula2=$sessionObj->param('hgOwner');my $formula3=$sessionObj->param('hostGroupID');my $formula4=$sessionObj->param("hostGroupID");my $formula5=$sessionObj->param("hostName");print("			Status Monitor :: <a href=\"../level1/index.pl\">$formula1</a>  :: <a href=\"../level2/index.pl?hgOwner=$formula2&hostGroupID=$formula3\">$formula4</a> :: $formula5\n");
print("		</div>\n");
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Service Status</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"darkGray\" align=\"left\" valign=\"top\" height=\"50\">\n");
 if (keys(%$serviceHashRefined) == 0) {
print("						<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" width=\"100%\">\n");
print("							<tr>\n");
print("								<td>No status metrics currently available</td>\n");
print("							</tr>\n");
print("						</table>\n");
 } else {
print("						<table border=\"0\" cellpadding=\"2\" cellspacing=\"2\">\n");
print("							<tr>\n");
 foreach my $serviceHashRefinedKey (sort(keys(%$serviceHashRefined))) {
my $serviceDescHash = $serviceHashRefined->{$serviceHashRefinedKey};
print("								<td width=\"40\" valign=\"top\" align=\"center\">					\n");
if ($serviceDescHash->{'hasSubService'} != 1) {
print("									<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" width=\"100%\">\n");
print("										<tr>\n");
my $formula6=$serviceHashRefinedKey;print("											<th nowrap=\"nowrap\">$formula6</th>\n");
print("										</tr>\n");
print("										<tr>\n");
my $formula7=$sessionObj->param("hostGroupID");my $formula8=$sessionObj->param("hostName");my $formula9=$serviceHashRefinedKey;my $formula10=$serviceDescHash->{'status'};print("											<td valign=\"top\" align=\"center\"><a href=\"index.pl?hostGroupID=$formula7&hostName=$formula8&serviceName=$formula9\"><img src=\"../../../perfStatResources/images/content/status_$formula10.gif\" width=\"20\" height=\"20\" /></a></td>\n");
print("										</tr>\n");
print("									</table>\n");
} else {
my $subServiceHash = $serviceDescHash->{'subServiceHash'};
print("									<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" width=\"100%\">\n");
print("										<tr>\n");
my $formula11=$serviceHashRefinedKey;my $formula12=$serviceHashRefinedKey;my $formula13=$serviceHashRefinedKey;my $formula14=$serviceHashRefinedKey;print("											<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><a href=\"javascript:toggle('$formula11-off', '$formula12-on');\"><img id=\"x$formula13-off\" src=\"../../../perfStatResources/images/navigation/icon_plusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a>&nbsp;$formula14</th>\n");
print("										</tr>\n");
print("										<tr>\n");
print("											<td valign=\"top\" align=\"center\">\n");
my $formula15=$serviceHashRefinedKey;print("												<div id=\"$formula15-off\" style=\"display:block;\">\n");
my $formula16=$serviceDescHash->{'status'};print("													<img src=\"../../../perfStatResources/images/content/status_$formula16.gif\" width=\"20\" height=\"20\" />\n");
print("												</div>\n");
my $formula17=$serviceHashRefinedKey;print("												<div id=\"$formula17-on\" style=\"display:none;\">\n");
print("													<table border=\"0\" cellpadding=\"1\" cellspacing=\"1\" class=\"table2\">\n");
foreach my $subServiceHashKey (sort(keys(%$subServiceHash))) {
print("														<tr>\n");
my $formula18=$sessionObj->param("hostGroupID");my $formula19=$sessionObj->param("hostName");my $formula20=$serviceHashRefinedKey;my $formula21=$subServiceHashKey;my $formula22=$subServiceHashKey;print("															<td style=\"text-align:right;\"><a href=\"index.pl?hostGroupID=$formula18&hostName=$formula19&serviceName=$formula20.$formula21\">$formula22</a></td>\n");
my $formula23=$subServiceHash->{$subServiceHashKey};print("															<td><img src=\"../../../perfStatResources/images/content/status_$formula23.gif\" width=\"20\" height=\"20\" /></td>\n");
print("														</tr>\n");
}
print("													</table>\n");
print("												</div>\n");
print("											</td>\n");
print("										</tr>\n");
print("									</table>\n");
 }
print("								</td>\n");
}
print("							</tr>\n");
print("						</table>\n");
}
print("				</td>\n");
print("			</tr>\n");
print("		</table>\n");
 if (length($sessionObj->param("serviceName")) != 0) {
print("		<div align=\"center\">\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
my $formula24=$sessionObj->param("serviceName");print("					<td class=\"tdTop\" nowrap colspan=\"6\" valign=\"middle\" align=\"left\">$formula24</td>\n");
print("				</tr>\n");
print("			<tr>\n");
print("					<th nowrap valign=\"middle\" align=\"left\">Metric</th>\n");
print("					<th nowrap valign=\"middle\" align=\"left\">Warn</th>\n");
print("					<th nowrap valign=\"middle\" align=\"left\">Crit</th>\n");
print("					<th nowrap valign=\"middle\" align=\"left\">Unit</th>\n");
print("					<th nowrap valign=\"middle\" align=\"left\">Value</th>\n");
print("					<th nowrap valign=\"middle\" align=\"left\">Status</th>\n");
print("				</tr>\n");
my $serviceMetricArray = $hostObject->{'serviceIndex'}->{$sessionObj->param("serviceName")}->{'metricArray'};
foreach my $metricObject (@$serviceMetricArray) {
 my $hasEvents = $metricObject->getHasEvents();
 if ($hasEvents == 1) {
 my $friendlyName = $metricObject->getFriendlyName();
 my $warnThreshold = $metricObject->getWarnThreshold();
 if (! defined $warnThreshold) { $warnThreshold="null"; };
 my $critThreshold = $metricObject->getCritThreshold();
 if (! defined $critThreshold) { $critThreshold="null"; };
 my $thresholdUnit = $metricObject->getThresholdUnit();
 if (! defined $thresholdUnit) { $thresholdUnit="null"; };
 my $metricValue = $metricObject->getMetricValue();
 #my $metricValue = 0;
 if (! defined $metricValue) { $metricValue="null"; };
 my $status = $metricObject->getStatus();
print("			<tr>\n");
my $formula25=$friendlyName;print("				<td class=\"liteGray\"><span class=\"table1Text2\">$formula25</span></td>\n");
my $formula26=$warnThreshold;print("				<td class=\"liteGray\"><span class=\"table1Text2\">$formula26</span></td>\n");
my $formula27=$critThreshold;print("				<td class=\"liteGray\"><span class=\"table1Text2\">$formula27</span></td>\n");
 #<td class="liteGray" valign="middle" align="center"><%$thresholdUnit%></td>
my $formula28=$thresholdUnit;print("				<td class=\"liteGray\"> <span class=\"table1Text2\">$formula28</span></td>\n");
my $formula29=$metricValue;print("				<td class=\"liteGray\"> <span class=\"table1Text2\">$formula29</span></td>\n");
my $formula30=$status;print("				<td class=\"darkGray\" valign=\"middle\" align=\"center\"><img src=\"../../../perfStatResources/images/content/status_$formula30.gif\" width=\"20\" height=\"20\"></td>\n");
print("			</tr>\n");
}
}
print("			<tr>\n");
print("				<form action=\"../level4/index.pl\" method=\"post\">\n");
my $formula31=$sessionObj->param("hostGroupID");print("					<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula31\">\n");
my $formula32=$sessionObj->param("hostName");print("					<input type=\"hidden\" name=\"hostName\" value=\"$formula32\">\n");
my $formula33=$sessionObj->param("serviceName");print("					<input type=\"hidden\" name=\"serviceName\" value=\"$formula33\">\n");
print("					<td class=\"tdBottom\" colspan=\"6\" valign=\"middle\" align=\"center\"><input class=\"liteButton\" type=\"submit\" value=\"View Event Log\" /></td>\n");
print("				</form>\n");
print("			</tr>\n");
print("			</table>\n");
print("		</div>\n");
}
print("	</body>\n");
print("</html>\n");
