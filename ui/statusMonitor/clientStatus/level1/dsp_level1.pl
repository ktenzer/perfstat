use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("	</head>\n");
my $formula0=$navLinkChosen;print("	<body onLoad=\"parent.navigation.setLinkChosen('$formula0');\">\n");
my $formula1=$sessionObj->param("groupViewStatus") ne "shared" ?  "My HostGroups" : "Shared HostGroups";print("		<div class=\"navHeader\">Status Monitor :: $formula1</div>\n");
print("			<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("				<tr>\n");
print("					<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Host Group Status</td>\n");
print("				</tr>\n");
print("				<tr>\n");
print("					<th nowrap=\"nowrap\" width=\"10%\" valign=\"middle\" align=\"left\">Host Group</th>\n");
print("					<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Current Status</th>\n");
print("				</tr>\n");
foreach my $hostGroupDescHash (@$hostGroupArray) {
my $hasHosts = $hostGroupDescHash->{'hasHosts'};
my $hostGroupServiceHash = $hostGroupDescHash->{'hostGroupServiceHash'};
my $hgOwner = $hostGroupDescHash->{'hostGroupOwner'};
my $hgID = $hostGroupDescHash->{'hostGroupID'};
print("				<tr>\n");
print("					<td class=\"liteGray\" height=\"50\" nowrap=\"nowrap\" width=\"10%\" valign=\"top\" align=\"left\">\n");
 if ($hasHosts == 0) {
my $formula2=$hgID;print("							<span class=\"table1Text1\">$formula2</span>\n");
 } else {
my $formula3=URLEncode($hgOwner);my $formula4=URLEncode($hgID);my $formula5=$hgID;print("						<a href=\"../level2/index.pl?hgOwner=$formula3&hostGroupID=$formula4\" class=\"table1Text1\">$formula5</a>\n");
 }
print("					</td>\n");
print("					<td class=\"darkGray\" align=\"left\" valign=\"middle\" height=\"50\">\n");
 if (%$hostGroupDescHash->{'hasHosts'} == 0) {
print("							<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" width=\"100%\">\n");
print("								<tr>\n");
print("									<td valign=\"middle\" align=\"left\" height=\"25\" style=\"text-align:left; padding-left: 8px\" nowrap>No hosts found in host group</td>\n");
print("								</tr>\n");
print("							</table>\n");
 } elsif (keys(%$hostGroupServiceHash) == 0) {
print("							<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" width=\"100%\">\n");
print("								<tr>\n");
print("									<td valign=\"middle\" align=\"left\" height=\"25\" style=\"text-align:left; padding-left: 8px\" nowrap>No status data found in host group</td>\n");
print("								</tr>\n");
print("							</table>\n");
 } else {
print("							<table border=\"0\" cellpadding=\"2\" cellspacing=\"2\">\n");
print("								<tr>\n");
foreach my $hostGroupServiceHashKey (sort(keys(%$hostGroupServiceHash))) {
print("									<td width=\"40\" valign=\"top\" align=\"center\">\n");
print("										<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\" height=\"0%\" width=\"100%\">\n");
print("											<tr>\n");
my $formula6=$hostGroupServiceHashKey;print("												<th nowrap=\"nowrap\">$formula6</th>\n");
print("											</tr>\n");
print("											<tr>\n");
my $formula7=$hostGroupServiceHash->{$hostGroupServiceHashKey};print("												<td><img src=\"../../../appRez/images/content/status_$formula7.gif\" width=\"20\" height=\"20\"></td>\n");
print("											</tr>\n");
print("										</table>\n");
print("									</td>\n");
}
print("								</tr>\n");
print("							</table>\n");
}
print("						</td>\n");
print("					</tr>\n");
}
print("			</table>\n");
print("	</body>\n");
print("</html>\n");
