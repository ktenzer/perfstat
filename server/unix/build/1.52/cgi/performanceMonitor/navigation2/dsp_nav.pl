use strict;
package main;
print("<html>
print("	<head>
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>
print("		<link type=\"text/css\" rel=\"stylesheet\" href=\"../../perfStatResources/styleSheets/navigationFrame.css\">
print("		<script language=\"javascript\" src=\"../../perfStatResources/javaScripts/navigationFrame.js\"></script>
print("		<script language=\"javascript\" src=\"../../perfStatResources/javaScripts/pm.nav.js\"></script>
print("	</head>
print("	<body onLoad=\"onBodyLoad('performance2');\">
print("	<table border=\"0\" align=\"center\" cellpadding=\"3\" cellspacing=\"1\" class=\"table1\" width=\"100%\">
print("		<tr> 
print("			<td height=\"25\" class=\"header\">Performance Monitor</td>
print("		</tr>
print("		<tr> 
print("			<td height=\"25\" class=\"subheader\">
print("				<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"table2\" align=\"center\">
print("					<tr>
print("						<td nowrap><a href=\"javascript:openAll();\">open all</a></td>
print("						<td nowrap><img src=\"../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"10\" border=\"0\"></td>
print("						<td nowrap><a href=\"javascript:closeAll();\">close all</a></td>
print("					</tr>
print("				</table>
print("			</td>
print("		</tr>
print("		<tr>
print("			<td align=\"left\" valign=\"top\">
print("				<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">
print("					<tr>
print("						<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor1.gif\" border=\"0\"></td>
my $formula0=$hostGroupID;print("						<td nowrap>$formula0</td>
print("					</tr>
print("				</table>
print("			</td>
print("		</tr>
print("			<tr>
print("			<td align=\"left\" valign=\"top\">
print("				<div id=\"navContainer\" style=\"margin-left:5px\">
foreach my $hostGroupMember (sort(keys(%$hgMemberHash))) {
my $hostGroupMemberHash = $hostGroupDescHash->{'hostGroupMemberHash'};
my $hostDescHash = $hostGroupMemberHash->{$hostGroupMember};
my $osType = $hostDescHash->{'OS'};
my $hasGraphs = $hostDescHash->{'hasGraphs'};
print("					<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">
print("						<tr>
print("							<td>
if ($hasGraphs == 0) {
print("									<img src=\"../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\">
} else {
my $formula1=$hostGroupMember;my $formula2=$hostGroupMember;my $formula3=$hostGroupMember;print("									<a id=\"x$formula1\" href=\"javascript:Toggle('$formula2');\"><img name=\"x$formula3\" src=\"../../perfStatResources/images/navigation/icon_plusNavBar.gif\" border=\"0\"></a>
}
print("							</td>
print("							<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor2.gif\" border=\"0\"></td>
print("							<td nowrap>
if ($hasGraphs == 0) {
my $formula4=$hostGroupMember;print("									$formula4
} else {
my $formula5=$hostGroupMember;my $formula6=$hostGroupMember;my $formula7=$hostGroupMember;print("									<a id=\"x$formula5\" href=\"javascript:Toggle('$formula6');\">$formula7</a>
}
print("							</td>
print("						</tr>
print("					</table>
my $formula8=$hostGroupMember;print("					<div id=\"$formula8\" style=\"display:none; margin-left:12px;\">
my $serviceHashRefined = $hostDescHash->{'serviceHash'};
foreach my $serviceHashRefinedKey (sort(keys(%$serviceHashRefined))) {
my $serviceDescHash = $serviceHashRefined->{$serviceHashRefinedKey};
if ($serviceDescHash->{'hasSubService'} == 0) {
print("							<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">
print("								<tr>
my $formula9=$hostGroupMember;my $formula10=$serviceHashRefinedKey;my $formula11=$hostGroupMember;my $formula12=$serviceHashRefinedKey;my $formula13=$hostGroupMember;my $formula14=$serviceHashRefinedKey;print("									<td><a id=\"x$formula9^$formula10\" href=\"javascript:Toggle('$formula11^$formula12');\"><img name=\"x$formula13^$formula14\" src=\"../../perfStatResources/images/navigation/icon_plusNavBar.gif\" border=\"0\"></a></td>
print("									<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor3.gif\" border=\"0\"></td>
my $formula15=$hostGroupMember;my $formula16=$serviceHashRefinedKey;my $formula17=$hostGroupMember;my $formula18=$serviceHashRefinedKey;my $formula19=$serviceHashRefinedKey;print("									<td><a id=\"x$formula15^$formula16\" href=\"javascript:Toggle('$formula17^$formula18');\">$formula19</a></td>
print("								</tr>
print("							</table>
my $formula20=$hostGroupMember;my $formula21=$serviceHashRefinedKey;print("							<div id=\"$formula20^$formula21\" style=\"display:none; margin-left:12px;\">
my $graphHash = $serviceDescHash->{'graphHash'};
foreach my $graphHashName (sort(keys(%$graphHash))) {
print("								<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">
print("									<tr>
print("										<td><img src=\"../../perfStatResources/images/common/spacer.gif\" height=\"10\" width=\"9\" border=\"0\"></td>
print("										<td><img src=\"../../perfStatResources/images/navigation/icon_performanceMonitor2.gif\" border=\"0\"></td>
my $formula22=$osType;my $formula23=$hostGroupMember;my $formula24=$serviceHashRefinedKey;my $formula25=$graphHashName;my $formula26=$graphHashName;print("										<td nowrap><a href=\"javascript:parent.content.insertService('$formula22',  'single', '$formula23', '$formula24', '$formula25');\">$formula26<a></td>
print("									</tr>
print("								</table>
}
print("							</div>
} else {
my $subServiceHash = $serviceDescHash->{'subServiceHash'};
print("							<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">
print("								<tr>
my $formula27=$hostGroupMember;my $formula28=$serviceHashRefinedKey;my $formula29=$hostGroupMember;my $formula30=$serviceHashRefinedKey;my $formula31=$hostGroupMember;my $formula32=$serviceHashRefinedKey;print("									<td><a id=\"x$formula27^$formula28\" href=\"javascript:Toggle('$formula29^$formula30');\"><img name=\"x$formula31^$formula32\" src=\"../../perfStatResources/images/navigation/icon_plusNavBar.gif\" border=\"0\"></a></td>
print("									<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor3.gif\" border=\"0\"></td>
my $formula33=$hostGroupMember;my $formula34=$serviceHashRefinedKey;my $formula35=$hostGroupMember;my $formula36=$serviceHashRefinedKey;my $formula37=$serviceHashRefinedKey;print("									<td nowrap><a id=\"x$formula33^$formula34\" href=\"javascript:Toggle('$formula35^$formula36');\">$formula37</a></td>
print("								</tr>
print("							</table>
my $formula38=$hostGroupMember;my $formula39=$serviceHashRefinedKey;print("							<div id=\"$formula38^$formula39\" style=\"display:none; margin-left:12px;\">
foreach my $subServiceHashKey (sort(keys(%$subServiceHash))) {
my $idString = "$hostGroupMember^$serviceHashRefinedKey^$subServiceHashKey";
print("									<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">
print("										<tr>
my $formula40=$idString;my $formula41=$idString;my $formula42=$idString;print("											<td><a id=\"x$formula40\" href=\"javascript:Toggle('$formula41');\"><img name=\"x$formula42\" src=\"../../perfStatResources/images/navigation/icon_plusNavBar.gif\" border=\"0\"></a></td>
print("											<td><img src=\"../../perfStatResources/images/navigation/icon_statusMonitor3.gif\" border=\"0\"></td>
my $formula43=$idString;my $formula44=$idString;my $formula45=$subServiceHashKey;print("											<td><a id=\"x$formula43\" href=\"javascript:Toggle('$formula44');\">$formula45</a></td>
print("										</tr>
print("									</table>
my $formula46=$idString;print("									<div id=\"$formula46\" style=\"display:none; margin-left:12px;\">
my $graphHash = $subServiceHash->{$subServiceHashKey};
foreach my $graphHashName (sort(keys(%$graphHash))) {
print("											<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">
print("												<tr>
print("													<td><img src=\"../../perfStatResources/images/common/spacer.gif\" height=\"10\" width=\"9\" border=\"0\"></td>
print("													<td><img src=\"../../perfStatResources/images/navigation/icon_performanceMonitor2.gif\" border=\"0\"></td>
my $formula47=$osType;my $formula48=$hostGroupMember;my $formula49=$serviceHashRefinedKey;my $formula50=$subServiceHashKey;my $formula51=$graphHashName;my $formula52=$graphHashName;print("													<td nowrap><a href=\"javascript:parent.content.insertService('$formula47', 'single', '$formula48', '$formula49.$formula50', '$formula51');\">$formula52<a></td>
print("												</tr>
print("											</table>
}
print("									</div>
}
print("							</div>
}
}
print("					</div>
}
print("				</div>
print("			</td>
print("		</tr>
print("		</table>
print("	</body>
print("</html>\n");