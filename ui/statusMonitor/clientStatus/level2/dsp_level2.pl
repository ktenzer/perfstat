use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/contentFrame.js\"></script>\n");
print("	</head>\n");

print("	<body onLoad=\"parent.navigation.setLinkChosen('clientStatus');\">\n");
print("		<div class=\"navHeader\">\n");
my $formula0=$sessionObj->param("groupViewStatus") ne "shared" ?  "My HostGroups" : "Shared HostGroups";my $formula1=$sessionObj->param("hostGroupID");print("			Status Monitor :: <a href=\"../level1/index.pl\">$formula0</a> :: $formula1</div>\n");
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Host Status</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" width=\"48\" valign=\"middle\" align=\"center\">OS&nbsp;</th>\n");
print("				<th nowrap=\"nowrap\" width=\"10%\" valign=\"middle\" align=\"left\">Host Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Current Status Details&nbsp;</th>\n");
print("			</tr>\n");
 foreach my $hostName (sort(keys(%$hostHash))) {
 my $hostDescHash = $hostHash->{$hostName};
 my $hasServices = $hostDescHash->{'hasServices'};
print("			<tr>\n");
my $formula2=$hostDescHash->{'OS'};print("				<td class=\"liteGray\" align=\"center\" valign=\"top\" height=\"50\" width=\"48\"><img src=\"../../../appRez/images/osIcons/$formula2/icon.gif\" width=\"36\" height=\"38\" alt=\"No new posts\" title=\"No new posts\" /></td>\n");
print("				<td class=\"liteGray\" height=\"50\" nowrap=\"nowrap\" width=\"10%\" valign=\"top\" align=\"left\">\n");
 if ($hasServices == 0) {
my $formula3=$hostName;print("						<span class=\"table1Text1\">$formula3</span>\n");
 } else {
my $formula4=$sessionObj->param('hostGroupID');my $formula5=$hostName;my $formula6=$hostName;print("						<a href=\"../level3/index.pl?hostGroupID=$formula4&hostName=$formula5\" class=\"table1Text1\">$formula6</a>\n");
}
my $formula7=$hostDescHash->{'lastUpdate'};print("					<br><span class=\"table1Text2\">Last Update:<br>$formula7</span>\n");
print("				</td>\n");
print("				<td class=\"darkGray\" align=\"left\" valign=\"middle\" height=\"50\">\n");
if ($hasServices == 0) {
print("					<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" width=\"100%\" >\n");
print("						<tr>\n");
print("							<td valign=\"middle\" align=\"left\" height=\"25\" style=\"text-align:left; padding-left: 8px\" nowrap>No status data found for host</td>\n");
print("						</tr>\n");
print("					</table>\n");
 } else {
my $hostServiceHash = $hostDescHash->{'hostServiceHash'};
print("					<table border=\"0\" cellpadding=\"2\" cellspacing=\"2\">\n");
print("						<tr>\n");
foreach my $hostServiceHashKey (sort(keys(%$hostServiceHash))) {
my $serviceDescHash = $hostServiceHash->{$hostServiceHashKey};
print("							<td width=\"40\" valign=\"top\" align=\"center\">\n");
if ($serviceDescHash->{'hasSubService'} != 1) {
print("								<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" height=\"0%\" width=\"100%\">\n");
print("									<tr>\n");
my $formula8=$hostServiceHashKey;print("										<th nowrap=\"nowrap\">$formula8</th>\n");
print("									</tr>\n");
print("									<tr>\n");
my $formula9=$sessionObj->param('hostGroupID');my $formula10=$hostName;my $formula11=$hostServiceHashKey;my $formula12=$serviceDescHash->{'status'};print("										<td valign=\"top\" align=\"center\"><a href=\"../level3/index.pl?hostGroupID=$formula9&hostName=$formula10&serviceName=$formula11\" class=\"table1Text1\"><img src=\"../../../appRez/images/content/status_$formula12.gif\" width=\"20\" height=\"20\" border=\"0\"></a></td>\n");
print("									</tr>\n");
print("								</table>\n");
} else {
my $subServiceHash = $serviceDescHash->{'subServiceHash'};
print("								<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" width=\"100%\">\n");
print("									<tr>\n");
my $formula13=$hostName;my $formula14=$hostServiceHashKey;my $formula15=$hostName;my $formula16=$hostServiceHashKey;my $formula17=$hostName;my $formula18=$hostServiceHashKey;my $formula19=$hostServiceHashKey;print("										<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><a href=\"javascript:toggle('$formula13-$formula14-off', '$formula15-$formula16-on');\"><img id=\"x$formula17-$formula18-off\" src=\"../../../appRez/images/navigation/icon_plusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a>&nbsp;$formula19</th>\n");
print("									</tr>\n");
print("									<tr>\n");
print("										<td valign=\"top\" align=\"center\">\n");
my $formula20=$hostName;my $formula21=$hostServiceHashKey;print("											<div id=\"$formula20-$formula21-off\" style=\"display:block;\">\n");
my $formula22=$serviceDescHash->{'status'};print("												<img src=\"../../../appRez/images/content/status_$formula22.gif\" width=\"20\" height=\"20\" /></div>\n");
my $formula23=$hostName;my $formula24=$hostServiceHashKey;print("											<div id=\"$formula23-$formula24-on\" style=\"display:none;\">\n");
print("												<table border=\"0\" cellpadding=\"1\" cellspacing=\"1\" class=\"table2\">\n");
foreach my $subServiceHashKey (sort(keys(%$subServiceHash))) {
print("													<tr>\n");
my $formula25=$sessionObj->param('hostGroupID');my $formula26=$hostName;my $formula27=$hostServiceHashKey;my $formula28=$subServiceHashKey;my $formula29=$subServiceHashKey;print("														<td style=\"text-align:right;\"><a href=\"../level3/index.pl?hostGroupID=$formula25&hostName=$formula26&serviceName=$formula27.$formula28\">$formula29</a></td>\n");
my $formula30=$subServiceHash->{$subServiceHashKey};print("														<td><img src=\"../../../appRez/images/content/status_$formula30.gif\" width=\"20\" height=\"20\" /></td>\n");
print("													</tr>\n");
}
print("												</table>\n");
print("											</div>\n");
print("										</td>\n");
print("									</tr>\n");
print("								</table>\n");
 }
print("							</td>\n");
 }
print("						</tr>\n");
print("					</table>\n");
 }
print("				</td>\n");
print("			</tr>\n");
}
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
