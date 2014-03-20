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
my $formula0=$templateName;print("<div class=\"navHeader\"><a href=\"../list/index.pl\">Alert Templates</a> :: $formula0</div>\n");
print("<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("  <tr>\n");
print("    <td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">Add Notify Rule </td>\n");
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
my $formula2=$templateName;print("      <input type=\"hidden\" name=\"templateName\" value=\"$formula2\">\n");
my $formula3=$notifyRule;print("      <td class=\"liteGray\" align=\"left\" valign=\"middle\"><input style=\"font-family:'Courier New', Courier, mono\" type=\"text\" name=\"notifyRule\" value=\"$formula3\" size=\"100\"></td>\n");
print("    </form>\n");
print("  </tr>\n");
print("</table>\n");
print("<table width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("  <tr>\n");
print("	<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"2\">Notify Rule Set </td>\n");
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
my $formula4=$templateName;print("						<th nowrap=\"nowrap\"><a href=\"index.pl?action=deleteAll&templateName=$formula4\">Delete All</a></th>\n");
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
my $formula5=$templateName;my $formula6=$count;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?action=moveUp&templateName=$formula5&contentID=$formula6\"><img src=\"../../../appRez/images/navigation/arrow_up.gif\" width=\"10\" height=\"14\" border=\"0\"/></a></th>\n");
 } 
 if (($count + 1) == $notifyRulesArrayLength) {
print("							<th nowrap=\"nowrap\"><img src=\"../../../appRez/images/common/spacer.gif\" width=\"10\" height=\"14\" border=\"0\"/></th>\n");
 } else {
my $formula7=$templateName;my $formula8=$count;print("							<th nowrap=\"nowrap\"><a href=\"index.pl?action=moveDown&templateName=$formula7&contentID=$formula8\"><img src=\"../../../appRez/images/navigation/arrow_down.gif\" width=\"10\" height=\"14\" border=\"0\"/></a></th>\n");
 } 
 }
if ($editFlag != $count) {
my $formula9=$templateName;my $formula10=$count;print("						<th nowrap=\"nowrap\"><a href=\"index.pl?templateName=$formula9&editFlag=$formula10\">&nbsp;Edit&nbsp;</a></th>\n");
 } else {
my $formula11=$templateName;print("						<th nowrap=\"nowrap\"><a href=\"index.pl?templateName=$formula11\">Clear</a></th>\n");
}
my $formula12=$templateName;my $formula13=$count;print("					<th nowrap=\"nowrap\"><a href=\"index.pl?action=delete&templateName=$formula12&contentID=$formula13\">Delete</a></th>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("		<form action=\"index.pl\" method=\"post\">\n");
print("		<td class=\"liteGray\" align=\"left\" valign=\"top\">\n");
if ($editFlag != $count) {
my $formula14=$notifyRule;print("				<span class=\"table1Text1\">$formula14</span>\n");
 } else {
print("				<input type=\"hidden\" name=\"action\" value=\"edit\">\n");
my $formula15=$count;print("				<input type=\"hidden\" name=\"contentID\" value=\"$formula15\">\n");
my $formula16=$templateName;print("				<input type=\"hidden\" name=\"templateName\" value=\"$formula16\">\n");
my $formula17=$notifyRule;print("				<input type=\"text\" style=\"font-family:'Courier New', Courier, mono\" name=\"notifyRule\" value=\"$formula17\" size=\"100\">\n");
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
