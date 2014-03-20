use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/rm.content.js\"></script>\n");
print("	</head>\n");
print("\n");
my $formula0=$updateNav;;print("	<body onLoad=\"$formula0\">\n");
print("	\n");
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
print("	</body>\n");
print("</html>\n");
