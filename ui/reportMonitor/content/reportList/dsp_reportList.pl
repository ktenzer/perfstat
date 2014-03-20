use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/rm.content.js\"></script>\n");
print("	</head>\n");

my $formula0=$navLinkChosen;my $formula1=$updateNav;;print("	<body onLoad=\"parent.navigation.setLinkChosen('$formula0'); $formula1\">\n");
my $formula2=$sessionObj->param("groupViewStatus") ne "shared" ?  "My Reports" : "Shared Reports";print("		<div class=\"navHeader\">Report Monitor :: $formula2</div>\n");
if ($sessionObj->param("groupViewStatus") ne "shared") {

print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Add Report</td>\n");
print("			</tr>\n");
 if ($sessionObj->param("userMessage") ne "") {

print("			<tr>\n");
my $formula3=$sessionObj->param("userMessage");print("				<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"3\"><span class=\"userMessage\">$formula3</span></td>\n");
print("			</tr>\n");
 $sessionObj->param("userMessage", "");
 }

print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Report Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>\n");
print("				<th nowrap=\"nowrap\">Actions</th>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<form name=\"InsertReport\" action=\"index.pl\" method=\"get\">\n");
print("					<input type=\"hidden\" name=\"action\" value=\"insertReport\">\n");
my $formula4=$reportName;print("					<td class=\"liteGray\" align=\"left\" valign=\"middle\"><input type=\"text\" name=\"reportName\" value=\"$formula4\" size=\"24\"></td>\n");
my $formula5=$description;print("					<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><input type=\"text\" name=\"description\" value=\"$formula5\" size=\"35\"></td>\n");
print("					<td class=\"darkGray\" align=\"center\" valign=\"middle\"><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>\n");
print("				</form>\n");
print("			</tr>\n");
print("		</table>\n");
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"3\">Report List</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"2%\">Actions</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Report Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>\n");
print("			</tr>\n");
 if (@$myReportArray == 0) {
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"center\" valign=\"top\" width=\"2%\">&nbsp;</td>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\">&nbsp;</td>\n");
print("				<td class=\"liteGray\" valign=\"top\" align=\"left\">&nbsp;</td>\n");
print("			</tr>\n");
} else {
foreach my $tempArray (@$myReportArray) {
my $reportOwner = $userName;
my $reportName = $tempArray->[0];
my $reportDescription = $tempArray->[1];
my $queryString = "adminName=" . URLEncode($adminName) . "&userName=" . URLEncode($userName) . "&reportOwner=" . URLEncode($reportOwner) . "&reportName=" . URLEncode($reportName);
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"center\" valign=\"top\" width=\"2%\">\n");
print("					<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("						<tr>\n");
my $formula6=$queryString;print("							<th nowrap=\"nowrap\"><a href=\"../viewReport/index.pl?$formula6&updateNav=1\">View</a></th>\n");
my $formula7=$queryString;my $formula8=$reportName;print("							<th nowrap=\"nowrap\"><a href=\"../layoutReport/index.pl?$formula7&reportNameID=$formula8&updateNav=1\">Layout</a></th>\n");
my $formula9=$queryString;my $formula10=$reportName;print("							<th nowrap=\"nowrap\"><a href=\"../editReport/index.pl?$formula9&reportNameID=$formula10\">Edit</a></th>\n");
my $formula11=$queryString;print("							<th nowrap=\"nowrap\"><a href=\"../shareReport/index.pl?$formula11\">Share</a></th>\n");
my $formula12=$queryString;my $formula13=$reportName;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteReport&$formula12\" onclick=\"return warnOnClickAnchor('Are you sure you want to delete $formula13');\">Delete</a></th>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
my $formula14=$reportName;print("				<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">$formula14</span></td>\n");
my $formula15=$reportDescription;print("				<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula15</span></td>\n");
print("			</tr>\n");
}
}
print("		</table>\n");
} else {	
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"4\">Report List</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"2%\">Actions</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Owner</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Report Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>\n");
print("			</tr>\n");
 if (@$sharedReportArray == 0) {
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"center\" valign=\"top\" width=\"2%\">&nbsp;</td>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\">&nbsp;</td>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\">&nbsp;</td>\n");
print("				<td class=\"liteGray\" valign=\"top\" align=\"left\">&nbsp;</td>\n");
print("			</tr>\n");
 } else {
foreach my $tempArray (@$sharedReportArray) {
my $reportOwner = $tempArray->[0];
my $reportName = $tempArray->[1];
my $reportDescription = $tempArray->[2];
my $queryString = "adminName=" . URLEncode($adminName) . "&userName=" . URLEncode($userName) . "&reportOwner=" . URLEncode($reportOwner) . "&reportName=" . URLEncode($reportName);
print("					<tr>\n");
print("						<td class=\"liteGray\" align=\"center\" valign=\"top\" width=\"2%\">\n");
print("							<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("								<tr>\n");
my $formula16=$queryString;print("									<th nowrap=\"nowrap\"><a href=\"../viewReport/index.pl?$formula16\">View</a></th>\n");
print("								</tr>\n");
print("							</table>\n");
print("						</td>\n");
my $formula17=$reportOwner;print("						<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">$formula17</span></td>\n");
my $formula18=$reportName;print("						<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">$formula18</span></td>\n");
my $formula19=$reportDescription;print("						<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula19</span></td>\n");
print("					</tr>\n");
}
}
print("		</table>\n");
}
print("	</body>\n");
print("</html>\n");
