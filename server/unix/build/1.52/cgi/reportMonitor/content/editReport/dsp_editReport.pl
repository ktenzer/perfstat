use strict;
package main;
print("<html>
print("	<head>
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/forms.css\" media=\"screen\">
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/rm.content.js\"></script>
print("	</head>
print("
my $formula0=$updateNav;;print("	<body onLoad=\"$formula0\">
my $formula1=$reportName;print("		<div class=\"navHeader\">Report Monitor :: <a href=\"../reportList/index.pl\">My Reports</a> :: Edit Report :: $formula1</div>
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Edit Report Descriptors</td>
print("			</tr>
 if ($sessionObj->param("userMessage") ne "") {
print("				<tr>
my $formula2=$sessionObj->param("userMessage");print("					<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"3\"><span class=\"userMessage\">$formula2</span></td>
print("				</tr>
 $sessionObj->param("userMessage", "");
 }
print("			<tr>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Report Name</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>
print("				<th nowrap=\"nowrap\">Actions</th>
print("			</tr>
print("			<tr>
print("				<form name=\"editReport\" action=\"index.pl\" method=\"post\">
print("					<input type=\"hidden\" name=\"action\" value=\"editReport\">
my $formula3=$reportNameID;print("					<input type=\"hidden\" name=\"reportNameID\" value=\"$formula3\">
my $formula4=$reportName;print("					<td class=\"liteGray\" align=\"left\" valign=\"middle\"><input type=\"text\" name=\"reportName\" value=\"$formula4\" size=\"24\"></td>
my $formula5=$description;print("					<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><input type=\"text\" name=\"description\" value=\"$formula5\" size=\"35\"></td>
print("					<td class=\"darkGray\" align=\"center\" valign=\"middle\"><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>
print("				</form>
print("			</tr>
print("		</table>
 if ($displayMode eq "add") {
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"1\" valign=\"middle\" align=\"left\">Add Report Content</td>
print("			</tr>
print("			<tr>
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">
print("					<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">
print("						<tr>
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>
print("						</tr>
print("						<tr>
print("							<td>
print("								<form method=\"get\" action=\"index.pl\">
my $formula6=$reportNameID;print("								<input type=\"hidden\" name=\"reportNameID\" value=\"$formula6\">
my $formula7=$reportName;print("								<input type=\"hidden\" name=\"reportName\" value=\"$formula7\">
my $formula8=$description;print("								<input type=\"hidden\" name=\"description\" value=\"$formula8\">
print("								<select name=\"contentType\" size=\"1\" onChange=\"submit();\">
my $formula9=$contentType eq "textComment" ? "selected" : "";;print("									<option value=\"textComment\" $formula9>Text Comment</option>
my $formula10=$contentType eq "hostGroupGraphs" ? "selected" : "";;print("									<option value=\"hostGroupGraphs\" $formula10>Host Group Graphs</option>
my $formula11=$contentType eq "hostAssets" ? "selected" : "";;print("									<option value=\"hostAssets\" $formula11>Host Assets</option>
my $formula12=$contentType eq "hostEvents" ? "selected" : "";;print("									<option value=\"hostEvents\" $formula12>Host Events</option>
my $formula13=$contentType eq "hostGraphs" ? "selected" : "";;print("									<option value=\"hostGraphs\" $formula13>Host Graphs</option>
print("								</select>
print("								</form>
print("							</td>
print("						</tr>
print("						<tr>
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>
print("						</tr>
print("						<tr>
print("							<td class=\"liteGray\" align=\"left\" valign=\"middle\">
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
print("							</td>
print("						</tr>
print("					</table>
print("				</td>
print("			</tr>
print("		</table>
 } elsif ($displayMode eq "edit") {
print("			<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
my $formula14=$editHeaderText;print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"1\" valign=\"middle\" align=\"left\">$formula14</td>
print("			</tr>
print("			<tr>
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">
print("					<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">
print("						<tr>
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>
print("						</tr>
print("						<tr>
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>
print("						</tr>
print("						<tr>
print("							<td class=\"liteGray\" align=\"left\" valign=\"middle\">
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
print("							</td>
print("						</tr>
print("					</table>
print("				</td>
print("			</tr>
print("		</table>
}
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"2\">Content List</td>
print("			</tr>
print("			<tr>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"2%\">Actions</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>
print("			</tr>
 if ($contentArrayLen == 0) {
print("			<tr>
print("				<td class=\"liteGray\" colspan=\"2\">&nbsp;</td>
print("			</tr>
 } else {
 if ($contentArrayLen > 1) {
print("				<tr>
print("					<td class=\"liteGray\" colspan=\"2\">
print("						<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">
print("							<tr>
my $formula15=$reportNameID;my $formula16=$contentType;print("								<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteAllContent&reportNameID=$formula15&contentType=$formula16\">Delete All</a></th>
print("							</tr>
print("						</table>
print("					</td>
print("				</tr>
 }
 foreach my $displayStruct (@$contentDisplayArray) {
print("					<tr>
print("						<td class=\"liteGray\" align=\"center\" valign=\"top\" width=\"2%\">
print("							<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">
print("								<tr>
my $formula17=$reportNameID;my $formula18=$displayStruct->{'contentType'};my $formula19=$displayStruct->{'contentID'};print("									<th nowrap=\"nowrap\"><a href=\"index.pl?displayMode=edit&reportNameID=$formula17&contentType=$formula18&contentID=$formula19\">Edit</a></th>
my $formula20=$reportNameID;my $formula21=$contentType;my $formula22=$displayStruct->{'contentID'};print("									<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteContent&reportNameID=$formula20&contentType=$formula21&contentID=$formula22\">Delete</a></th>
print("								</tr>
print("							</table>
print("						</td>
my $formula23=$displayStruct->{'textDisplay'};print("						<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">$formula23</span></td>
print("					</tr>
 }
 }
print("		</table>
print("	</body>
print("</html>\n");