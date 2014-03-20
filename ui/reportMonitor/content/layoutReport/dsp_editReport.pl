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

my $formula0=$updateNav;print("	<body onLoad=\"$formula0\">\n");
print("	\n");
my $formula1=$reportName;print("		<div class=\"navHeader\">Report Monitor :: <a href=\"../reportList/index.pl\">My Reports</a> :: Layout :: $formula1</div>\n");
print("		<table class=\"table1\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\">\n");
print("			<tr>			\n");
print("    			<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Report Layout</td>\n");
print("			</tr>\n");
 if ($sessionObj->param("userMessage3") ne "") {
print("				<tr>\n");
my $formula2=$sessionObj->param("userMessage3");print("					<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"userMessage\">$formula2</span></td>\n");
print("				</tr>\n");
 $sessionObj->param("userMessage3", "");
 }
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"top\">\n");
print("					<table>\n");
print("        <form name=\"outputHostGraphs\" action=\"index.pl\" method=\"post\">\n");
print("          <input type=\"hidden\" name=\"action\" value=\"updateReportLayout\">\n");
my $formula3=$reportNameID;print("          <input type=\"hidden\" name=\"reportNameID\" value=\"$formula3\">\n");
my $formula4=$contentType;print("          <input type=\"hidden\" name=\"contentType\" value=\"$formula4\">\n");
print("          <tr> \n");
print("            <td align=\"right\" nowrap><span class=\"table1Text1\">Num Columns:</span></td>\n");
print("            <td> <select name=\"numColumns\" size=\"1\">\n");
my $formula5=$numColumns eq "1" ? "selected" : "";;print("                <option value=\"1\" $formula5>1 Column</option>\n");
my $formula6=$numColumns eq "2" ? "selected" : "";;print("                <option value=\"2\" $formula6>2 Column</option>\n");
my $formula7=$numColumns eq "3" ? "selected" : "";;print("                <option value=\"3\" $formula7>3 Column</option>\n");
my $formula8=$numColumns eq "4" ? "selected" : "";;print("                <option value=\"4\" $formula8>4 Column</option>\n");
print("              </select> </td>\n");
print("            <td align=\"right\" nowrap><span class=\"table1Text1\"> Custom Graph Size:</span></td>\n");
my $formula9=$customGraphSize;print("            <td><input type=\"text\" name=\"customGraphSize\" value=\"$formula9\" size=\"3\" maxlength=\"3\" onFocus=\"document.outputHostGraphs.graphSize.options[0].selected=true\"> \n");
print("              <span class=\"table1Text1\">%</span></td>\n");
print("          </tr>\n");
print("          <tr> \n");
print("            <td align=\"right\" nowrap><span class=\"table1Text1\">Graph Size:</span></td>\n");
print("            <td><select name=\"graphSize\" size=\"1\" onChange=\"document.outputHostGraphs.customGraphSize.value=''\">\n");
my $formula10=$graphSize eq "custom" ? "selected" : "";;print("                <option value=\"custom\" $formula10>Custom</option>\n");
my $formula11=$graphSize eq "small" ? "selected" : "";;print("                <option value=\"small\" $formula11>Small</option>\n");
my $formula12=$graphSize eq "medium" ? "selected" : "";;print("                <option value=\"medium\" $formula12>Medium</option>\n");
my $formula13=$graphSize eq "large" ? "selected" : "";;print("                <option value=\"large\" $formula13>Large</option>\n");
print("              </select> </td>\n");
print("            <td align=\"right\"><img src=\"../../../appRez/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"><span class=\"table1Text1\">Custom \n");
print("              Font Size:</span></td>\n");
my $formula14=$customFontSize;print("            <td><input type=\"text\" name=\"customFontSize\" value=\"$formula14\" size=\"3\" maxlength=\"3\"> \n");
print("              <span class=\"table1Text1\">px</span></td>\n");
print("          </tr>\n");
print("          <tr> \n");
print("            <td align=\"right\" nowrap><span class=\"table1Text1\">Doman Name:</span></td>\n");
print("            <td> <select name=\"useShortDomainNames\" size=\"1\">\n");
my $formula15=$useShortDomainNames eq "0" ? "selected" : "";;print("                <option value=\"0\" $formula15>Full</option>\n");
my $formula16=$useShortDomainNames eq "1" ? "selected" : "";;print("                <option value=\"1\" $formula16>Short</option>\n");
print("              </select> </td>\n");
print("            <td colspan=\"2\" align=\"right\"><img src=\"../../../appRez/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"> \n");
print("              <input name=\"submit\" type=\"submit\" class=\"liteButton\" value=\"Update\"></td>\n");
print("          </tr>\n");
print("        </form>\n");
print("      </table>\n");
print("				</td>\n");
print("			</tr>\n");
print("		</table>\n");
 if ($displayMode eq "add") {
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"1\" valign=\"middle\" align=\"left\">Add Report Content</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
print("					<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n");
print("						<tr>\n");
print("							<td><img src=\"../../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td>\n");
print("								<form method=\"get\" action=\"index.pl\">\n");
my $formula17=$reportNameID;print("								<input type=\"hidden\" name=\"reportNameID\" value=\"$formula17\">\n");
my $formula18=$reportName;print("								<input type=\"hidden\" name=\"reportName\" value=\"$formula18\">\n");
my $formula19=$description;print("								<input type=\"hidden\" name=\"description\" value=\"$formula19\">\n");
print("								<select name=\"contentType\" size=\"1\" onChange=\"submit();\">\n");
my $formula20=$contentType eq "textComment" ? "selected" : "";;print("									<option value=\"textComment\" $formula20>Text Comment</option>\n");
my $formula21=$contentType eq "hostGroupGraphs" ? "selected" : "";;print("									<option value=\"hostGroupGraphs\" $formula21>Host Group Graphs</option>\n");
my $formula22=$contentType eq "hostAssets" ? "selected" : "";;print("									<option value=\"hostAssets\" $formula22>Host Assets</option>\n");
my $formula23=$contentType eq "hostEvents" ? "selected" : "";;print("									<option value=\"hostEvents\" $formula23>Host Events</option>\n");
my $formula24=$contentType eq "hostGraphs" ? "selected" : "";;print("									<option value=\"hostGraphs\" $formula24>Host Graphs</option>\n");
print("								</select>\n");
print("								</form>\n");
print("							</td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td><img src=\"../../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
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
print("							</td>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
print("			</tr>\n");
print("		</table>\n");
 } elsif ($displayMode eq "edit") {
print("			<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
my $formula25=$editHeaderText;print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"1\" valign=\"middle\" align=\"left\">$formula25</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
print("					<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n");
print("						<tr>\n");
print("							<td><img src=\"../../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td><img src=\"../../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("						</tr>\n");
print("						<tr>\n");
print("							<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
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
print("							</td>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
print("			</tr>\n");
print("		</table>\n");
}
print("		<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"2\">Content List</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"2%\">Actions</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>\n");
print("			</tr>\n");
 if ($contentArrayLen == 0) {
print("			<tr>\n");
print("				<td class=\"liteGray\" colspan=\"2\">&nbsp;</td>\n");
print("			</tr>\n");
 } else {
 if ($contentArrayLen > 1) {
print("				<tr>\n");
print("					<td class=\"liteGray\" colspan=\"2\">\n");
print("						<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("							<tr>\n");
my $formula26=$reportNameID;my $formula27=$contentType;print("								<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteAllContent&reportNameID=$formula26&contentType=$formula27\">Delete All</a></th>\n");
print("							</tr>\n");
print("						</table>\n");
print("					</td>\n");
print("				</tr>\n");
 }
 my $count = 1;
 foreach my $displayStruct (@$contentDisplayArray) {
print("					<tr>\n");
print("						<td class=\"liteGray\" align=\"center\" valign=\"top\" width=\"2%\">\n");
print("							<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("								<tr>\n");
 if ($contentArrayLen > 1) {
 if ($count == 1) {
print("											<th nowrap=\"nowrap\"><img src=\"../../../appRez/images/common/spacer.gif\" width=\"10\" height=\"14\" border=\"0\"/></th>\n");
 } else {
my $formula28=$reportNameID;my $formula29=$contentType;my $formula30=$displayStruct->{'contentID'};print("											<th nowrap=\"nowrap\"><a href=\"index.pl?action=moveContentUp&reportNameID=$formula28&contentType=$formula29&contentID=$formula30\"><img src=\"../../../appRez/images/navigation/arrow_up.gif\" width=\"10\" height=\"14\" border=\"0\"/></a></th>\n");
 }
 if ($count == $contentArrayLen) {
print("											<th nowrap=\"nowrap\"><img src=\"../../../appRez/images/common/spacer.gif\" width=\"10\" height=\"14\" border=\"0\"/></th>\n");
 } else {
my $formula31=$reportNameID;my $formula32=$contentType;my $formula33=$displayStruct->{'contentID'};print("											<th nowrap=\"nowrap\"><a href=\"index.pl?action=moveContentDown&reportNameID=$formula31&contentType=$formula32&contentID=$formula33\"><img src=\"../../../appRez/images/navigation/arrow_down.gif\" width=\"10\" height=\"14\" border=\"0\"/></a></th>\n");
 }
 }
my $formula34=$reportNameID;my $formula35=$displayStruct->{'contentType'};my $formula36=$displayStruct->{'contentID'};print("									<th nowrap=\"nowrap\"><a href=\"index.pl?displayMode=edit&reportNameID=$formula34&contentType=$formula35&contentID=$formula36\">Edit</a></th>\n");
my $formula37=$reportNameID;my $formula38=$contentType;my $formula39=$displayStruct->{'contentID'};print("									<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteContent&reportNameID=$formula37&contentType=$formula38&contentID=$formula39\">Delete</a></th>\n");
print("								</tr>\n");
print("							</table>\n");
print("						</td>\n");
my $formula40=$displayStruct->{'textDisplay'};print("						<td class=\"liteGray\" align=\"left\" valign=\"top\"><span class=\"table1Text1\">$formula40</span></td>\n");
print("					</tr>\n");
 $count++;
 }
 }
print("		</table>\n");
print("		\n");
print("	</body>\n");
print("</html>\n");
