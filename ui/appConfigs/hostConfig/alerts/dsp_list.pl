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
my $formula0=$sessionObj->param("hostName");print("<div class=\"navHeader\"><a href=\"../list/index.pl\">Host Config</a> :: Alert Rules :: $formula0</div>\n");
print("<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("  <tr>\n");
print("    <td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Add Alert Rule </td>\n");
print("  </tr>\n");
if ($sessionObj->param("userMessage") ne "") {
print("  <tr>\n");
print("    <td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"2\"><span class=\"userMessage\">\n");
my $formula1=$sessionObj->param("userMessage");print("      $formula1\n");
print("    </span></td>\n");
print("  </tr>\n");
$sessionObj->param("userMessage", "");
}
print("  <tr>\n");
print("    <th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Rule</th>\n");
print("  </tr>\n");
print("  <tr>\n");
print("    <form action=\"index.pl\" method=\"post\">\n");
print("      <input type=\"hidden\" name=\"action\" value=\"add\">\n");
my $formula2=$notifyRule;print("      <td class=\"liteGray\" align=\"left\" valign=\"middle\"><input style=\"font-family:'Courier New', Courier, mono\" type=\"text\" name=\"notifyRule\" value=\"$formula2\" size=\"100\"></td>\n");
print("    </form>\n");
print("  </tr>\n");
print("</table>\n");
print("<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("  <tr>\n");
print("	<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"2\">Alert Rule Set </td>\n");
print("  </tr>\n");
print("  <tr>\n");
print("	<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"2%\">Actions</th>\n");
print("	<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Rule</th>\n");
print("  </tr>\n");
 if ($notifyRulesArrayLength == 0) {
print("	  <tr>\n");
print("		<td class=\"liteGray\" colspan=\"2\">&nbsp;</td>\n");
print("	  </tr>\n");
 } else { 
 if ($notifyRulesArrayLength > 1) {
print("		  <tr>\n");
print("			<td class=\"liteGray\" colspan=\"2\">\n");
print("				<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("					<tr>\n");
print("						<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteAll\">Delete All</a></th>\n");
print("					</tr>\n");
print("				</table>\n");
print("			</td>\n");
print("		  </tr>\n");
 } 
 my $count = 0; 
 foreach my $notifyRule (@$notifyRulesArray) {
print("	  <tr>\n");
print("		<td class=\"liteGray\" align=\"center\" valign=\"top\" width=\"2%\">\n");
print("			<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("				<tr> \n");
 if ($notifyRulesArrayLength > 1) { 
 if (($count + 1) == 1) {
print("							<th nowrap=\"nowrap\"><img src=\"../../../appRez/images/common/spacer.gif\" width=\"10\" height=\"14\" border=\"0\"/></th>\n");
 } else {
my $formula3=$count;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?action=moveUp&contentID=$formula3\"><img src=\"../../../appRez/images/navigation/arrow_up.gif\" width=\"10\" height=\"14\" border=\"0\"/></a></th>\n");
 } 
 if (($count + 1) == $notifyRulesArrayLength) {
print("							<th nowrap=\"nowrap\"><img src=\"../../../appRez/images/common/spacer.gif\" width=\"10\" height=\"14\" border=\"0\"/></th>\n");
 } else {
my $formula4=$count;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?action=moveDown&contentID=$formula4\"><img src=\"../../../appRez/images/navigation/arrow_down.gif\" width=\"10\" height=\"14\" border=\"0\"/></a></th>\n");
 } 
 }
if ($editFlag != $count) {
my $formula5=$sessionObj->param('hostName');my $formula6=$count;print("						<th nowrap=\"nowrap\"><a href=\"index.pl?hostName=$formula5&editFlag=$formula6\">&nbsp;Edit&nbsp;</a></th>\n");
 } else {
my $formula7=$sessionObj->param('hostName');print("						<th nowrap=\"nowrap\"><a href=\"index.pl?hostName=$formula7\">Clear</a></th>\n");
}
my $formula8=$count;print("					<th nowrap=\"nowrap\"><a href=\"index.pl?action=delete&contentID=$formula8\">Delete</a></th>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("		<form action=\"index.pl\" method=\"post\">\n");
print("		<td class=\"liteGray\" align=\"left\" valign=\"top\">\n");
if ($editFlag != $count) {
my $formula9=$notifyRule;print("				<span class=\"table1Text1\">$formula9</span>\n");
 } else {
print("				<input type=\"hidden\" name=\"action\" value=\"edit\">\n");
my $formula10=$count;print("				<input type=\"hidden\" name=\"contentID\" value=\"$formula10\">\n");
my $formula11=$notifyRule;print("				<input type=\"text\" style=\"font-family:'Courier New', Courier, mono\" name=\"notifyRule\" value=\"$formula11\" size=\"90\">\n");
}
print("		</td>\n");
print("		</form>\n");
print("	  </tr>\n");
 $count++; 
 } 
 }
print("</table>\n");
print("</body>\n");
print("</html>\n");
