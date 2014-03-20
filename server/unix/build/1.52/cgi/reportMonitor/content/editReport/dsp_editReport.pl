use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/rm.content.js\"></script>\n");
print("	</head>\n");
print("\n");
my $formula0=$updateNav;;print("	<body onLoad=\"$formula0\">\n");
my $formula1=$reportName;print("		<div class=\"navHeader\">Report Monitor :: <a href=\"../reportList/index.pl\">My Reports</a> :: Edit Report :: $formula1</div>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Edit Report Descriptors</td>\n");
print("			</tr>\n");
 if ($sessionObj->param("userMessage") ne "") {
print("				<tr>\n");
my $formula2=$sessionObj->param("userMessage");print("					<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"3\"><span class=\"userMessage\">$formula2</span></td>\n");
print("				</tr>\n");
 $sessionObj->param("userMessage", "");
 }
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Report Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>\n");
print("				<th nowrap=\"nowrap\">Actions</th>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<form name=\"editReport\" action=\"index.pl\" method=\"post\">\n");
print("					<input type=\"hidden\" name=\"action\" value=\"editReport\">\n");
my $formula3=$reportNameID;print("					<input type=\"hidden\" name=\"reportNameID\" value=\"$formula3\">\n");
my $formula4=$reportName;print("					<td class=\"liteGray\" align=\"left\" valign=\"middle\"><input type=\"text\" name=\"reportName\" value=\"$formula4\" size=\"24\"></td>\n");
my $formula5=$description;print("					<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><input type=\"text\" name=\"description\" value=\"$formula5\" size=\"35\"></td>\n");
print("					<td class=\"darkGray\" align=\"center\" valign=\"middle\"><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>\n");
print("				</form>\n");
print("			</tr>\n");
print("		</table>\n");
 if ($displayMode eq "add") {
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"1\" valign=\"middle\" align=\"left\">Add Report Content</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
print("					<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n");
print("						<tr>\n");
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td>\n");
print("								<form method=\"get\" action=\"index.pl\">\n");
my $formula6=$reportNameID;print("								<input type=\"hidden\" name=\"reportNameID\" value=\"$formula6\">\n");
my $formula7=$reportName;print("								<input type=\"hidden\" name=\"reportName\" value=\"$formula7\">\n");
my $formula8=$description;print("								<input type=\"hidden\" name=\"description\" value=\"$formula8\">\n");
print("								<select name=\"contentType\" size=\"1\" onChange=\"submit();\">\n");
my $formula9=$contentType eq "textComment" ? "selected" : "";;print("									<option value=\"textComment\" $formula9>Text Comment</option>\n");
my $formula10=$contentType eq "hostGroupGraphs" ? "selected" : "";;print("									<option value=\"hostGroupGraphs\" $formula10>Host Group Graphs</option>\n");
my $formula11=$contentType eq "hostAssets" ? "selected" : "";;print("									<option value=\"hostAssets\" $formula11>Host Assets</option>\n");
my $formula12=$contentType eq "hostEvents" ? "selected" : "";;print("									<option value=\"hostEvents\" $formula12>Host Events</option>\n");
my $formula13=$contentType eq "hostGraphs" ? "selected" : "";;print("									<option value=\"hostGraphs\" $formula13>Host Graphs</option>\n");
print("								</select>\n");
print("								</form>\n");
print("							</td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
 if ($contentType eq "textComment") {
require("dsp_selectTextComment.pl");
 } elsif ($contentType eq "hostGroupGraphs") {
require("dsp_selectHostGroupGraphs.pl");
 } elsif ($contentType eq "hostAssets") {
require("dsp_selectHostAssets.pl");
 } elsif ($contentType eq "hostEvents") {
require("dsp_selectHostEvents.pl");
 } elsif ($contentType eq "hostGraphs") {
require("dsp_selectHostGraphs.pl");
 }
print("							</td>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
print("			</tr>\n");
print("		</table>\n");
 } elsif ($displayMode eq "edit") {
print("			<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
my $formula14=$editHeaderText;print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"1\" valign=\"middle\" align=\"left\">$formula14</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
print("					<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n");
print("						<tr>\n");
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
 if ($contentType eq "textComment") {
require("dsp_editTextComment.pl");
 } elsif ($contentType eq "hostGroupGraph") {
require("dsp_editHostGroupGraphs.pl");
 } elsif ($contentType eq "hostAssets") {
require("dsp_editHostAssets.pl");
 } elsif ($contentType eq "hostEvent") {
require("dsp_editHostEvents.pl");
 } elsif ($contentType eq "hostGraph") {
require("dsp_editHostGraphs.pl");
 }
print("							</td>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
print("			</tr>\n");
print("		</table>\n");
}
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"2\">Content List</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"2%\">Actions</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>\n");
print("			</tr>\n");
 if ($contentArrayLen == 0) {
print("			<tr>\n");
print("				<td class=\"liteGray\" colspan=\"2\">&nbsp;</td>\n");
print("			</tr>\n");
 } else {
 if ($contentArrayLen > 1) {
print("				<tr>\n");
print("					<td class=\"liteGray\" colspan=\"2\">\n");
print("						<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("							<tr>\n");
my $formula15=$reportNameID;my $formula16=$contentType;print("								<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteAllContent&reportNameID=$formula15&contentType=$formula16\">Delete All</a></th>\n");
print("							</tr>\n");
print("						</table>\n");
print("					</td>\n");
print("				</tr>\n");
 }
 foreach my $displayStruct (@$contentDisplayArray) {
print("					<tr>\n");
print("						<td class=\"liteGray\" align=\"center\" valign=\"top\" width=\"2%\">\n");
print("							<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("								<tr>\n");
my $formula17=$reportNameID;my $formula18=$displayStruct->{'contentType'};my $formula19=$displayStruct->{'contentID'};print("									<th nowrap=\"nowrap\"><a href=\"index.pl?displayMode=edit&reportNameID=$formula17&contentType=$formula18&contentID=$formula19\">Edit</a></th>\n");
my $formula20=$reportNameID;my $formula21=$contentType;my $formula22=$displayStruct->{'contentID'};print("									<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteContent&reportNameID=$formula20&contentType=$formula21&contentID=$formula22\">Delete</a></th>\n");
print("								</tr>\n");
print("							</table>\n");
print("						</td>\n");
my $formula23=$displayStruct->{'textDisplay'};print("						<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">$formula23</span></td>\n");
print("					</tr>\n");
 }
 }
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
