use strict;
package main;
print("<html>
print("	<head>
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">
print("		<title>PerfStat Tool: Perfomance Monitoring & Status Notification</title>
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/forms.css\" media=\"screen\">
print("		<script language=\"javascript\" src=\"../../../appRez/javaScripts/rm.content.js\"></script>
print("	</head>
print("
my $formula0=$updateNav;;print("	<body onLoad=\"$formula0\">
print("	
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
print("	</body>
print("</html>\n");