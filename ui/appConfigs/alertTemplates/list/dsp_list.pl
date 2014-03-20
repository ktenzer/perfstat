use strict;
package main;
print("<html>\n");
print("<head>\n");
print("	<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("	<title>Perfstat Performance and Status Monitor</title>\n");
print("	<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("	<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">\n");
print("	<script language=\"javascript\" src=\"../../../appRez/javaScripts/contentFrame.js\"></script>\n");
print("</head>\n");

print("<body onLoad=\"parent.navigation.setLinkChosen('alertTemplates');\">\n");
print("<div class=\"navHeader\">Alert Templates</div>\n");
print("<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("	<tr>\n");
print("		<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"4\" valign=\"middle\" align=\"left\">Add Template</td>\n");
print("	</tr>\n");
 if ($sessionObj->param("userMessage") ne "") {
print("	<tr>\n");
my $formula0=$sessionObj->param("userMessage");print("		<td class=\"liteGray\" valign=\"top\" align=\"left\" colspan=\"4\"><span class=\"userMessage\">$formula0</span></td>\n");
print("	</tr>\n");
 $sessionObj->param("userMessage", "");
 }
print("	<tr>\n");
print("		<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Template Name</th>\n");
print("		<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>\n");
print("		<th nowrap=\"nowrap\">&nbsp;</th>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<form name=\"insertTemplate\" action=\"index.pl\" method=\"post\">\n");
print("		<input type=\"hidden\" name=\"action\" value=\"add\">\n");
my $formula1=$addName;print("		<td class=\"liteGray\" align=\"left\" valign=\"middle\"><input type=\"text\" name=\"addName\" value=\"$formula1\" size=\"24\"></td>\n");
my $formula2=$addDescription;print("		<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><input type=\"text\" name=\"addDescription\" value=\"$formula2\" size=\"40\"></td>\n");
print("		<td class=\"darkGray\" align=\"center\" valign=\"middle\"><input class=\"liteButton\" type=\"submit\" value=\"ENTER\"></td>\n");
print("		</form>\n");
print("	</tr>\n");
print("</table>\n");
print("<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("	<tr>\n");
print("		<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"4\">Template List </td>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"2%\">Actions</th>\n");
print("		<th width=\"2%\" align=\"left\" valign=\"middle\" nowrap=\"nowrap\">Name</th>\n");
print("		<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Description</th>\n");
print("	</tr>\n");
foreach my $notificationStruct (@$notificationTemplateArray) {
if ($editFlag eq $notificationStruct->{'name'} && $sessionObj->param("userMessage2") ne "") {
print("		<tr>\n");
print("			<td class=\"liteGray\" align=\"left\" valign=\"top\" width=\"2%\">&nbsp;</td>\n");
my $formula3=$sessionObj->param("userMessage2");print("			<td colspan=\"2\" align=\"left\" valign=\"top\" class=\"liteGray\"><span class=\"userMessage\">$formula3</span></td>\n");
print("		</tr>\n");
 $sessionObj->param("userMessage2", "");
}
print("	<tr>\n");
print("		<td class=\"liteGray\" align=\"left\" valign=\"top\" width=\"2%\">\n");
print("			<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("				<tr>\n");
 my $queryString = "templateName=$notificationStruct->{'name'}";
if ($editFlag ne $notificationStruct->{'name'}) {
my $formula4=$notificationStruct->{'name'};print("						<th nowrap=\"nowrap\"><a href=\"index.pl?editFlag=$formula4\">&nbsp;Edit&nbsp;</a></th>\n");
} else {
print("						<th nowrap=\"nowrap\"><a href=\"index.pl\">Clear</a></th>\n");
}
my $formula5=$queryString;print("					<th nowrap=\"nowrap\"><a href=\"../config/index.pl?$formula5\">Config</a></th>\n");
my $formula6=$queryString;print("					<th nowrap=\"nowrap\"><a href=\"../apply/index.pl?$formula6&start=1\">Apply</a></th>\n");
my $formula7=$queryString;my $formula8=$notificationStruct->{'name'};print("					<th nowrap=\"nowrap\"><a href=\"index.pl?action=delete&$formula7\" onclick=\"return warnOnClickAnchor('Are you sure you want to delete $formula8');\">Delete</a></th>\n");
print("				</tr>\n");
print("			</table>\n");
print("	  </td>\n");
print("		<form action=\"index.pl\" method=\"post\">\n");
print("		<input type=\"hidden\" name=\"action\" value=\"edit\">\n");
my $formula9=$notificationStruct->{'name'};print("		<input type=\"hidden\" name=\"templateName\" value=\"$formula9\">\n");
print("		<td class=\"liteGray\" width=\"2%\" align=\"left\" valign=\"top\" nowrap>\n");
if ($editFlag ne $notificationStruct->{'name'}) {
my $formula10=$notificationStruct->{'editName'};print("				<span class=\"table1Text1\">$formula10</span>\n");
 } else {
my $formula11=$notificationStruct->{'editName'};print("				<input type=\"text\" name=\"editName\" value=\"$formula11\" size=\"24\" onKeyPress=\"return submitenter(this,event)\">\n");
}
print("		</td>\n");
print("		<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
if ($editFlag ne $notificationStruct->{'name'}) {
my $formula12=$notificationStruct->{'editDescription'};print("				<span class=\"table1Text2\">$formula12</span>\n");
 } else {
my $formula13=$notificationStruct->{'editDescription'};print("				<input type=\"text\" name=\"editDescription\" value=\"$formula13\" size=\"40\" onKeyPress=\"return submitenter(this,event)\">\n");
}
print("		</td>\n");
print("		</form>\n");
print("	</tr>\n");
 }
print("</table>\n");
print("</body>\n");
print("</html>\n");
