use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("	</head>\n");

print("	<body>\n");
print("		<div class=\"navHeader\">\n");
my $formula0=$sessionObj->param("groupViewStatus") ne "shared" ?  "My HostGroups" : "Shared HostGroups";print("			<div class=\"navHeader\">Asset Monitor :: <a href=\"../level1/index.pl?doToggle=1\">$formula0</a></div>\n");
print("		</div>\n");
print("		<form name=\"insertItem\" action=\"index.pl\" method=\"post\">\n");
if ($action ne "displayUpdateItem") {
print("			<input type=\"hidden\" name=\"action\" value=\"insertItem\">\n");
} else {
print("			<input type=\"hidden\" name=\"action\" value=\"updateItem\">\n");
my $formula1=$request->param('itemID');print("			<input type=\"hidden\" name=\"itemID\" value=\"$formula1\">\n");
}
my $formula2=$sessionObj->param('hgOwner');print("		<input type=\"hidden\" name=\"hgOwner\" value=\"$formula2\">\n");
my $formula3=$sessionObj->param('hostGroupID');print("		<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula3\">\n");
my $formula4=$sessionObj->param('hostName');print("		<input type=\"hidden\" name=\"hostName\" value=\"$formula4\">\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">\n");
if ($action ne "displayUpdateItem") {
print("						Add Item\n");
} else {
print("						Edit Item\n");
}
print("				</td>\n");
print("			</tr>\n");
 if (length($sessionObj->param("userMessage")) ne 0) {
print("			<tr>\n");
my $formula5=$sessionObj->param("userMessage");print("				<td class=\"liteGray\" valign=\"middle\" align=\"left\" colspan=\"2\"><span class=\"userMessage\">$formula5</span></td>\n");
print("			</tr>\n");
 $sessionObj->param("userMessage", "");
 }
print("			<tr>\n");
print("				<td class=\"liteGray\" valign=\"middle\" align=\"right\"><span class=\"table1Text1\">Date</span></td>\n");
print("					<td class=\"liteGray\" valign=\"middle\" align=\"left\"><span class=\"table1Text1\" style=\"font-size:6pt\">\n");
print("							<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("								<tr>\n");
my $formula6=$date;print("									<td><input type=\"text\" name=\"date\"  value=\"$formula6\" size=\"10\"maxlength=\"10\"></td>\n");
print("									<td><span class=\"table1Text1\" style=\"font-size:8pt\">&nbsp;&nbsp;YYYY-MM-DD</span></td>\n");
print("								</tr>\n");
print("							</table>\n");
print("						</span></td>\n");
print("				</tr>\n");
print("			<tr>\n");
print("				<td class=\"liteGray\" valign=\"middle\" align=\"right\"><span class=\"table1Text1\">User</span></td>\n");
my $formula7=$user;print("				<td class=\"liteGray\" valign=\"middle\" align=\"left\"><input type=\"text\" name=\"user\" value=\"$formula7\" size=\"20\"></td>\n");
print("			</tr>\n");
print("				<tr>\n");
print("					<td class=\"liteGray\" valign=\"top\" align=\"right\"><span class=\"table1Text1\">Description</span></td>\n");
my $formula8=$description;print("					<td class=\"liteGray\" valign=\"top\" align=\"left\"><textarea name=\"description\" cols=\"60\" rows=\"2\">$formula8</textarea></td>\n");
print("				</tr>\n");
print("				<tr>\n");
print("				<td class=\"tdBottom\" valign=\"middle\" align=\"right\" colspan=\"2\">\n");
print("					<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" >\n");
print("						<tr>\n");
print("							<td nowrap=\"nowrap\"><input class=\"liteButton\" type=\"submit\" name=\"submit\" value=\"ENTER\"></td>\n");
if ($action eq "displayUpdateItem") {
print("								<td nowrap=\"nowrap\"><input class=\"liteButton\" type=\"submit\" name=\"submit\" value=\"CLEAR\"></td>\n");
}
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
print("			</tr>\n");
print("		</table>\n");
print("		</form>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("			<tr>\n");
my $formula9=$sessionObj->param("hostName");print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"4\">Change Log :: $formula9</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"1%\"></th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"5%\">Date</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"5%\">User</th>\n");
print("				<th valign=\"middle\" align=\"left\">Description</th>\n");
print("			</tr>\n");
if ($changeLogIndexLen == 0) { 
print("			<tr>\n");
print("				<td class=\"liteGray\" nowrap width=\"1%\"></td>\n");
print("				<td class=\"liteGray\" nowrap width=\"5%\">&nbsp;</td>\n");
print("				<td class=\"liteGray\" nowrap width=\"5%\">&nbsp;</td>\n");
print("				<td class=\"liteGray\">&nbsp;</td>\n");
print("			</tr>\n");
} else {
my $hgOwner = $sessionObj->param('hgOwner');
my $hgID = $sessionObj->param('hostGroupID');
my $hostName = $sessionObj->param('hostName');
foreach my $valueArray (@$changeLogArray) {
my $indexValue =  $valueArray->[0];
my $date = $valueArray->[1];
my $user = $valueArray->[2];
my $description = $valueArray->[3];
print("					<tr>\n");
print("						<td class=\"liteGray\" nowrap width=\"1%\" valign=\"top\" align=\"left\">\n");
print("							<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\">\n");
print("								<tr>\n");
my $queryString = "action=displayUpdateItem&hgOwner=$hgOwner&hostGroupID=$hgID&hostName=$hostName&itemID=$indexValue&date=$date&user=$user&description=$description";
my $formula10=$queryString;print("									<td nowrap=\"nowrap\"><span class=\"table1Text2\"><a href=\"index.pl?$formula10\">Edit</a></span></td>\n");
my $formula11=$hgOwner;my $formula12=$hgID;my $formula13=$hostName;my $formula14=$indexValue;print("									<td nowrap=\"nowrap\"><span class=\"table1Text2\"><a href=\"index.pl?action=deleteItem&hgOwner=$formula11&hostGroupID=$formula12&hostName=$formula13&itemID=$formula14\">Delete</a></span></td>\n");
print("								</tr>\n");
print("							</table>\n");
print("						</td>\n");
my $formula15=$date;print("						<td class=\"liteGray\" nowrap width=\"5%\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula15</span></td>\n");
my $formula16=$user;print("						<td class=\"liteGray\" nowrap width=\"5%\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula16</span></td>\n");
my $formula17=$description;print("						<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula17</span></td>\n");
print("					</tr>\n");
}
}
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
