use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/contentFrame.js\"></script>\n");
print("	</head>\n");

my $formula0=$navLinkChosen;my $formula1=$toggleScript;print("	<body onLoad=\"parent.navigation.setLinkChosen('$formula0'); $formula1\">\n");
my $formula2=$sessionObj->param("groupViewStatus") ne "shared" ?  "My HostGroups" : "Shared HostGroups";print("		<div class=\"navHeader\">Asset Monitor :: $formula2</div>\n");
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Host Group Assets</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" width=\"5%\" valign=\"middle\" align=\"left\">Host Group</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Assets</th>\n");
print("			</tr>\n");
foreach my $hostGroupDescHash (@$hostGroupArray) {
my $hasHosts = $hostGroupDescHash->{'hasHosts'};
my $hgOwner = $hostGroupDescHash->{'hostGroupOwner'};
my $hgID = $hostGroupDescHash->{'hostGroupID'};
my $description = $hostGroupDescHash->{'hostGroupDescription'};
my $hostCount = $hostGroupDescHash->{'hostCount'};
my $linuxCount = $hostGroupDescHash->{'linuxCount'};
my $sunCount = $hostGroupDescHash->{'sunCount'};
my $windowsCount = $hostGroupDescHash->{'windowsCount'};
my $hostGroupMemberHash = $hostGroupDescHash->{'hostGroupMemberHash'};
print("				<tr>\n");
print("					<td class=\"liteGray\" width=\"5%\" valign=\"top\" align=\"left\" nowrap>\n");
if ($hostCount == 0) {
my $formula3=$hgID;print("							<span class=\"table1Text1\">$formula3</span>\n");
} else {
my $formula4=$hgID;my $formula5=$hgID;my $formula6=$hgID;print("							<a href=\"javascript:toggle2('$formula4-less', '$formula5-more');\" class=\"table1Text1\">$formula6</a>\n");
}
print("					</td>\n");
print("					<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\">\n");
my $formula7=$hgID;print("						<div id=\"$formula7-less\" style=\"display:block;\">\n");
print("							<table class=\"table2\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\">\n");
print("								<tr>\n");
print("									<th nowrap=\"nowrap\">Host Count</th>\n");
print("									<th nowrap=\"nowrap\">Linux</th>\n");
print("									<th nowrap=\"nowrap\">Solaris</th>\n");
print("									<th nowrap=\"nowrap\">Windows</th>\n");
print("									<th nowrap=\"nowrap\" style=\"text-align:left\">Description</th>\n");
print("								</tr>\n");
print("								<tr>\n");
my $formula8=$hostCount;print("									<td style=\"vertical-align:top\"><span class=\"table1Text2\">$formula8</td>\n");
my $formula9=$linuxCount;print("									<td style=\"vertical-align:top\"><span class=\"table1Text2\">$formula9</td>\n");
my $formula10=$sunCount;print("									<td style=\"vertical-align:top\"><span class=\"table1Text2\">$formula10</td>\n");
my $formula11=$windowsCount;print("									<td style=\"vertical-align:top\"><span class=\"table1Text2\">$formula11</td>\n");
my $formula12=$description;print("									<td style=\"text-align:left\"><span class=\"table1Text2\">$formula12</span></td>\n");
print("								</tr>\n");
print("							</table>\n");
print("						</div>\n");
if ($hostCount != 0) {
my $formula13=$hgID;print("						<div id=\"$formula13-more\" style=\"display:none;\">\n");
print("							<table class=\"table4\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\">\n");
print("								<tr>\n");
print("									<th nowrap=\"nowrap\" width=\"2%\"></th>\n");
print("									<th nowrap=\"nowrap\" width=\"5%\">Host Name</th>\n");
print("									<th nowrap=\"nowrap\" width=\"5%\">IP</th>\n");
print("									<th nowrap=\"nowrap\">OS</th>\n");
print("									<th nowrap=\"nowrap\">CPU Model</th>\n");
print("								</tr>\n");
foreach my $hostName (sort(keys(%$hostGroupMemberHash))) {
my $hostDescHash = $hostGroupMemberHash->{$hostName};
print("									<tr>\n");
print("										<td width=\"2%\">\n");
print("											<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\">\n");
print("												<tr>\n");
my $formula14=$hgOwner;my $formula15=$hgID;my $formula16=$hostName;print("													<td nowrap=\"nowrap\"><span class=\"table1Text2\"><a href=\"../detailView/index.pl?hgOwner=$formula14&hostGroupID=$formula15&hostName=$formula16\">View</a></span></td>\n");
my $formula17=$hgOwner;my $formula18=$hgID;my $formula19=$hostName;print("													<td nowrap=\"nowrap\"><span class=\"table1Text2\"><a href=\"../changeLog/index.pl?hgOwner=$formula17&hostGroupID=$formula18&hostName=$formula19\">Log</a></span></td>\n");
print("												</tr>\n");
print("											</table>\n");
print("										</td>\n");
my $formula20=$hostName;print("										<td width=\"5%\"nowrap><span class=\"table1Text2\">$formula20</span></td>\n");
my $formula21=$hostDescHash->{'ip'};print("										<td width=\"5%\"><span class=\"table1Text2\">$formula21</span></td>\n");
my $formula22=$hostDescHash->{'os'};print("										<td><span class=\"table1Text2\">$formula22</span></td>\n");
my $formula23=$hostDescHash->{'cpuModel'};print("										<td><span class=\"table1Text2\">$formula23</span></td>\n");
print("									</tr>\n");
}
print("							</table>\n");
print("						</div>\n");
}
print("					</td>\n");
print("				</tr>\n");
}
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
