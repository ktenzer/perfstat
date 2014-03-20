use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/contentFrame.js\"></script>\n");
print("	</head>\n");

print("	<body>\n");
my $formula0=$templateName;print("		<div class=\"navHeader\"><a href=\"../list/index.pl\">Alert Templates</a> :: $formula0</div>\n");
 my $applyToHostList = $sessionObj->param('applyToHostList');
print("		<table width=\"500\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"3\" valign=\"middle\" align=\"left\">Template applied to the following hosts</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Name</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">IP</th>\n");
print("			</tr>\n");
foreach my $hostName (sort(keys(%$applyToHostList))) {
my $ip = $applyToHostList->{$hostName};
my $queryString = "action=removeHost" . "&templateName=". URLEncode($templateName) . "&hostName=". URLEncode($hostName);
print("			<tr>\n");
my $formula1=$hostName;print("				<td align=\"left\" valign=\"top\" nowrap class=\"liteGray\"><span class=\"table1Text1\">$formula1</span></td>\n");
my $formula2=$ip;print("				<td class=\"liteGray\" nowrap=\"nowrap\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula2</span></td>\n");
print("			</tr>\n");
}
print("	</table>\n");
print("	</body>\n");
print("</html>\n");
