use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>Perfstat Performance and Status Monitor</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/contentFrame.js\"></script>\n");
print("	</head>\n");
print("<body>\n");
my $formula0=$templateName;print("<div class=\"navHeader\"><a href=\"../list/index.pl\">Metric Templates</a> :: $formula0</div>\n");
print("<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("  <tr>\n");
print("    <td colspan=\"6\" class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Select Service </td>\n");
print("  </tr>\n");
print("  <tr>\n");
print("    <th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">OS</th>\n");
print("	 <th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Service</th>\n");
print("  </tr>\n");
print("   <form name=\"selectMetric\" action=\"index.pl\" method=\"post\">\n");
my $formula1=$templateName;print("   <input type=\"hidden\" name=\"templateName\" value=\"$formula1\">\n");
print("  <tr>\n");
print("		<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
print("			<select name=\"osName\" size=\"1\" onchange=\"submit();\">\n");
 foreach my $osNameTemp (@$osList) {
my $formula2=$osNameTemp;my $formula3=$osNameTemp eq $osName ? "selected" : "";;my $formula4=$osNameTemp;print("					<option value=\"$formula2\" $formula3>$formula4</option>\n");
}
print("			</select>\n");
print("		</td>\n");
print("		<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
print("			<select name=\"serviceName\" size=\"1\" onchange=\"submit();\">\n");
 foreach my $serviceNameTemp (@$serviceList) {
my $formula5=$serviceNameTemp;my $formula6=$serviceNameTemp eq $serviceName ? "selected" : "";;my $formula7=$serviceNameTemp;print("					<option value=\"$formula5\" $formula6>$formula7</option>\n");
}
print("			</select>\n");
print("		</td>\n");
print("  </tr>\n");
print("  </form>\n");
print("</table>\n");
print("<form name=\"configMetrics\" action=\"index.pl\" method=\"post\">\n");
print("<input type=\"hidden\" name=\"action\" value=\"add\">\n");
my $formula8=$templateName;print("<input type=\"hidden\" name=\"templateName\" value=\"$formula8\">\n");
my $formula9=$osName;print("<input type=\"hidden\" name=\"osName\" value=\"$formula9\">\n");
my $formula10=$serviceName;print("<input type=\"hidden\" name=\"serviceName\" value=\"$formula10\">\n");
print("<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("	<tr>\n");
my $formula11=$osName;my $formula12=$serviceName;print("		<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"6\" valign=\"middle\" align=\"left\">$formula11 :: $formula12</td>\n");
print("	</tr>\n");
 if ($sessionObj->param("userMessage") ne "") {
print("	<tr>\n");
my $formula13=$sessionObj->param("userMessage");print("		<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"6\"><span class=\"userMessage\">$formula13</span></td>\n");
print("	</tr>\n");
 $sessionObj->param("userMessage", "");
 }
print("	<tr>\n");
print("		<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Metric</th>\n");
print("		<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Warn</th>\n");
print("		<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Crit</th>\n");
print("		<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Unit</th>\n");
print("		<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Events</th>\n");
print("	</tr>\n");
 foreach  my $metricObject (@$metricList) {
 if ($metricObject->getHasEvents() =~ m/-1/) { next; } 
 my $metricName = $metricObject->getMetricName();
 my $friendlyName = $metricObject->getFriendlyName();
 my $thresholdUnit = $metricObject->getThresholdUnit();
 my $hasEvents = $metricObject->getHasEvents();
 my $checkHasEvents = "";
 my $inputStruct = $inputHash->{$metricName};
 if ($inputStruct->{'hasEvents'}) {$checkHasEvents = "checked"};
print("		<tr>\n");
print("			<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\">\n");
my $formula14=$friendlyName;print("				<span class=\"table1Text2\">$formula14</span>\n");
print("			</td>\n");
print("			<td class=\"liteGray\" valign=\"middle\" align=\"left\">\n");
 if (defined($inputStruct->{'warnThreshold'})) {
my $formula15=$metricName;my $formula16=$inputStruct->{'warnThreshold'};print("					<input type=\"text\" name=\"warnThreshold^$formula15\" size=\"10\" value=\"$formula16\">\n");
 } else {
print("					<span class=\"table1Text2\">N/A</span>\n");
}
print("			</td>\n");
print("			<td class=\"liteGray\" valign=\"middle\" align=\"left\">\n");
 if (defined($inputStruct->{'critThreshold'})) {
my $formula17=$metricName;my $formula18=$inputStruct->{'critThreshold'};print("					<input type=\"text\" name=\"critThreshold^$formula17\" size=\"10\" value=\"$formula18\">\n");
 } else {
print("					<span class=\"table1Text2\">N/A</span>\n");
}
print("			</td>\n");
print("			<td class=\"liteGray\" valign=\"middle\" align=\"left\">\n");
 if (defined($thresholdUnit)) {
my $formula19=$thresholdUnit;print("					<span class=\"table1Text2\">$formula19</span>\n");
 } else {
print("					<span class=\"table1Text2\">N/A</span>\n");
}
print("			</td>\n");
print("			<td class=\"liteGray\" valign=\"middle\" align=\"middle\">\n");
my $formula20=$metricName;my $formula21=$checkHasEvents;print("				<input type=\"checkbox\" name=\"hasEvents^$formula20\" size=\"10\" $formula21>\n");
print("			</td>\n");
print("		</tr>\n");
 }
print("	<tr>\n");
print("		<td class=\"liteGray\" valign=\"top\" align=\"right\" colspan=\"5\">\n");
if ($ruleSetExists) {
print("				<input class=\"liteButton\" type=\"submit\" value=\"update\">\n");
} else {
print("				<input class=\"liteButton\" type=\"submit\" value=\"add\">\n");
}
print("		</td>\n");
print("	</tr>\n");
print("</table>\n");
print("</form>\n");
print("<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("  <tr>\n");
print("	<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"8\">Alert Rule Set</td>\n");
print("  </tr>\n");
print("  <tr>\n");
print("	<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Actions</th>\n");
print("	<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">OS</th>\n");
print("	<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Service</th>\n");
print("	<th align=\"left\" valign=\"middle\" nowrap=\"nowrap\">Metric</th>\n");
print("	<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Warn</th>\n");
print("	<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Crit</th>\n");
print("	<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Unit</th>\n");
print("   <th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Events</th>\n");
print("  </tr>\n");
 if ($ruleSetIndexLength == 0) {
print("		<tr>\n");
print("			<td class=\"liteGray\" colspan=\"8\">&nbsp;</td>\n");
print("		</tr>\n");
 } else { 
 if ($ruleSetIndexLength > 1) {
print("			<tr>\n");
print("				<td class=\"liteGray\" colspan=\"8\">\n");
print("					<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("						<tr>\n");
my $formula22=$templateName;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteAll&templateName=$formula22\" onclick=\"return warnOnClickAnchor('Are you sure you want to delete all rules');\">Delete All</a></th>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
print("			</tr>\n");
}
 }
print("		  \n");
foreach my $osName (sort(keys(%$ruleSetIndex))) {
my $serviceList = $ruleSetIndex->{$osName};
foreach my $serviceName (sort(keys(%$serviceList))) {
my $newService = 1;
my $metricList = $serviceList->{$serviceName};
my $metricListLength = keys(%$metricList);
foreach my $metricName ( sort {$metricList->{$a}->{'order'} <=> $metricList->{$b}->{'order'}} (keys(%$metricList))) {
print("				<tr>\n");
if ($newService) {
my $formula23=$metricListLength;print("					<td rowspan=\"$formula23\" align=\"center\" valign=\"top\" class=\"liteGray\">\n");
print("						<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("							<tr> \n");
my $formula24=$templateName;my $formula25=$osName;my $formula26=$serviceName;print("								<th nowrap=\"nowrap\"><a href=\"index.pl?templateName=$formula24&osName=$formula25&serviceName=$formula26\">&nbsp;Edit&nbsp;</a></th>\n");
my $formula27=$templateName;my $formula28=$osName;my $formula29=$serviceName;my $formula30=$osName;my $formula31=$serviceName;print("								<th nowrap=\"nowrap\"><a href=\"index.pl?action=delete&templateName=$formula27&osName=$formula28&serviceName=$formula29\" onclick=\"return warnOnClickAnchor('Are you sure you want to delete $formula30 :: $formula31');\">Delete</a></th>\n");
print("							</tr>\n");
print("						</table>\n");
print("					</td>\n");
my $formula32=$metricListLength;my $formula33=$osName;print("					<td rowspan=\"$formula32\" align=\"left\" valign=\"top\" nowrap class=\"liteGray\"><span class=\"table1Text1\">$formula33</span></td>\n");
my $formula34=$metricListLength;my $formula35=$serviceName;print("					<td rowspan=\"$formula34\" align=\"left\" valign=\"top\" nowrap class=\"liteGray\"><span class=\"table1Text1\">$formula35</span></td>\n");
$newService = 0;
}
my $metricStruct = $metricList->{$metricName};
my $friendlyName = $metricStruct->{'friendlyName'};
my $warnThreshold = $metricStruct->{'warnThreshold'};
my $critThreshold = $metricStruct->{'critThreshold'};
my $thresholdUnit = $metricStruct->{'thresholdUnit'};
my $hasEvents;
if ($metricStruct->{'hasEvents'}){$hasEvents = "on"} else {$hasEvents = "off"}
my $formula36=$friendlyName;print("					<td align=\"left\" valign=\"top\" nowrap class=\"liteGray\"><span class=\"table1Text1\">$formula36</span></td>\n");
my $formula37=$warnThreshold;print("					<td align=\"left\" valign=\"top\" nowrap class=\"liteGray\"><span class=\"table1Text1\">$formula37</span></td>\n");
my $formula38=$critThreshold;print("					<td align=\"left\" valign=\"top\" nowrap class=\"liteGray\"><span class=\"table1Text1\">$formula38</span></td>\n");
my $formula39=$thresholdUnit;print("					<td align=\"left\" valign=\"top\" nowrap class=\"liteGray\"><span class=\"table1Text1\">$formula39</span></td>\n");
my $formula40=$hasEvents;print("					<td align=\"left\" valign=\"top\" nowrap class=\"liteGray\"><span class=\"table1Text1\">$formula40</span></td>\n");
print("				</tr>\n");
}
}
}
print("</table>\n");
print("</body>\n");
print("</html>\n");
