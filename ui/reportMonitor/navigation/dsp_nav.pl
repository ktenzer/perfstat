use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link type=\"text/css\" rel=\"stylesheet\" href=\"../../appRez/styleSheets/navigationFrame.css\">\n");
print("		<script language=\"javascript\" src=\"../../appRez/javaScripts/navigationFrame.js\"></script>\n");
print("	</head>\n");
my $formula0=$doOnBodyLoad;print("	<body onLoad=\"onBodyLoad('$formula0'); closeAll();\">\n");
 if ($sessionObj->param("userName") eq "perfstat" || $sessionObj->param("role") eq "admin") {
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
 if ($sessionObj->param("userName") eq "perfstat") {
print("			<tr>\n");
print("				<form action=\"index.pl\" method=\"post\">\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"right\"><span class=\"table1Text1\">Admin:</span></td>\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"left\">\n");
print("					<select name=\"adminName\" size=\"1\" onChange=\"submit();\">\n");
 foreach my $adminNameTemp (sort (keys(%$adminList))) {
my $formula1=$adminNameTemp;my $formula2=$adminNameTemp eq $sessionObj->param("selectedAdmin") ? "selected" : "";;my $formula3=$adminNameTemp;print("						<option value=\"$formula1\" $formula2>$formula3</option>\n");
 }
print("					</select>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
}
 if ($sessionObj->param("role") eq "admin") {
print("			<tr>\n");
print("				<form action=\"index.pl\" method=\"post\">\n");
my $formula4=$sessionObj->param("selectedAdmin");print("				<input type=\"hidden\" name=\"adminName\" value=\"$formula4\">\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"right\"><span class=\"table1Text1\">User:</span></td>\n");
print("				<td nowrap=\"nowrap\" valign=\"middle\" align=\"left\">\n");
print("					<select name=\"userName\" size=\"1\" onChange=\"submit();\">\n");
 foreach my $userNameTemp (sort (keys(%$userList))) {
my $formula5=$userNameTemp;my $formula6=$userNameTemp eq $sessionObj->param("selectedUser")  ? "selected" : "";;my $formula7=$userNameTemp;print("						<option value=\"$formula5\" $formula6>$formula7</option>\n");
 }
print("					</select>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
}
print("		</table>\n");
}
print("	<table border=\"0\" align=\"center\" cellpadding=\"3\" cellspacing=\"1\" class=\"table1\" width=\"100%\">\n");
print("	<tr> \n");
print("		<td height=\"25\" class=\"header\">Report Monitor</td>\n");
print("	</tr>\n");
print("	<tr> \n");
print("			<td height=\"25\" class=\"subheader\">\n");
print("				<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"table2\" align=\"center\">\n");
print("					<tr>\n");
print("						<td nowrap><a href=\"javascript:openAll();\">open all</a></td>\n");
print("						<td nowrap><img src=\"../../appRez/images/common/spacer.gif\" height=\"6\" width=\"10\" border=\"0\"></td>\n");
print("						<td nowrap><a href=\"javascript:closeAll();\">close all</a></td>\n");
print("					</tr>\n");
print("				</table>\n");
print("			</td>\n");
print("		</tr>\n");
print("	<tr>\n");
print("		<td align=\"left\" valign=\"top\">\n");
print("			<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td><img src=\"../../appRez/images/navigation/icon_reportMonitor2.gif\" border=\"0\" width=\"19\" height=\"19\"></td>\n");
print("					<td nowrap><a id=\"myHostGroups\" href=\"index.pl?groupViewStatus=self\">My Reports</a></td>\n");
print("				</tr>\n");
print("				<tr>\n");
print("					<td><img src=\"../../appRez/images/navigation/icon_reportMonitor2.gif\" border=\"0\" width=\"19\" height=\"19\"></td>\n");
print("					<td nowrap><a id=\"sharedHostGroups\" href=\"index.pl?groupViewStatus=shared\">Shared Reports</a></td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
print("		<tr>\n");
print("			<td align=\"left\" valign=\"top\">\n");
print("			<div id=\"navContainer\" style=\"margin-left:5px\">\n");
foreach my $tempArray (@$reportArray) {
my $reportOwner = $tempArray->[0];
my $reportName = $tempArray->[1];
my $queryString = "adminName=" . URLEncode($adminName) . "&userName=" . URLEncode($userName) . "&reportOwner=" . URLEncode($reportOwner) . "&reportName=" . URLEncode($reportName);
print("			<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("				<tr>\n");
my $formula8=$reportOwner;my $formula9=$reportName;my $formula10=$reportOwner;my $formula11=$reportName;my $formula12=$reportOwner;my $formula13=$reportName;print("					<td><a id=\"x$formula8^$formula9\" href=\"javascript:Toggle('$formula10^$formula11');\"><img name=\"x$formula12^$formula13\" src=\"../../appRez/images/navigation/icon_plusNavBar.gif\" border=\"0\"></a></td>\n");
print("					<td><img src=\"../../appRez/images/navigation/icon_reportMonitor1.gif\" border=\"0\" width=\"19\" height=\"19\"></td>\n");
my $formula14=$reportOwner;my $formula15=$reportName;my $formula16=$reportName;print("					<td nowrap><a href=\"javascript:Toggle('$formula14^$formula15');\">$formula16</a></td>\n");
print("				</tr>\n");
print("			</table>\n");
my $formula17=$reportOwner;my $formula18=$reportName;print("			<div id=\"$formula17^$formula18\" style=\"display:none; margin-left:1em;\">\n");
print("			<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td><img name=\"xallHosts_host1\" src=\"../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
my $formula19=$queryString;print("					<td><a href=\"../content/viewReport/index.pl?$formula19\" target=\"content\">View</a></td>\n");
print("				</tr>\n");
print("			</table>\n");
if ($sessionObj->param("groupViewStatus") ne "shared") {
print("			<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td><img name=\"xallHosts_host1\" src=\"../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
my $formula20=$queryString;my $formula21=$reportName;print("					<td><a href=\"../content/layoutReport/index.pl?$formula20&reportNameID=$formula21\" target=\"content\">Layout</a></td>\n");
print("				</tr>\n");
print("			</table>\n");
print("			<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td><img name=\"xallHosts_host1\" src=\"../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
my $formula22=$queryString;my $formula23=$reportName;print("					<td><a href=\"../content/editReport/index.pl?$formula22&reportNameID=$formula23\" target=\"content\">Edit</a></td>\n");
print("				</tr>\n");
print("			</table>\n");
print("			\n");
print("			<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td><img name=\"xallHosts_host1\" src=\"../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
my $formula24=$queryString;print("					<td><a href=\"../content/shareReport/index.pl?$formula24\" target=\"content\">Share</a></td>\n");
print("				</tr>\n");
print("			</table>\n");
print("			<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td><img name=\"xallHosts_host1\" src=\"../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
my $formula25=$queryString;print("					<td><a href=\"../content/reportList/index.pl?action=deleteReport&$formula25\" target=\"content\">Delete</a></td>\n");
print("				</tr>\n");
print("			</table>\n");
}
print("			</div>\n");
}
print("			</div>\n");
print("			</td>\n");
print("		</tr>\n");
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
