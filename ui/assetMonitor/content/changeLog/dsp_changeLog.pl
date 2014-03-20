use strict;
package main;
print("<html>
print("	<head>
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">
print("	</head>
print("
print("	<body>
print("		<div class=\"navHeader\">
my $formula0=$sessionObj->param("groupViewStatus") ne "shared" ?  "My HostGroups" : "Shared HostGroups";print("			<div class=\"navHeader\">Asset Monitor :: <a href=\"../level1/index.pl?doToggle=1\">$formula0</a></div>
print("		</div>
print("		<form name=\"insertItem\" action=\"index.pl\" method=\"post\">
if ($action ne "displayUpdateItem") {
print("			<input type=\"hidden\" name=\"action\" value=\"insertItem\">
} else {
print("			<input type=\"hidden\" name=\"action\" value=\"updateItem\">
my $formula1=$request->param('itemID');print("			<input type=\"hidden\" name=\"itemID\" value=\"$formula1\">
}
my $formula2=$sessionObj->param('hgOwner');print("		<input type=\"hidden\" name=\"hgOwner\" value=\"$formula2\">
my $formula3=$sessionObj->param('hostGroupID');print("		<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula3\">
my $formula4=$sessionObj->param('hostName');print("		<input type=\"hidden\" name=\"hostName\" value=\"$formula4\">
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">
print("			<tr>
print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"2\" valign=\"middle\" align=\"left\">
if ($action ne "displayUpdateItem") {
print("						Add Item
} else {
print("						Edit Item
}
print("				</td>
print("			</tr>
 if (length($sessionObj->param("userMessage")) ne 0) {
print("			<tr>
my $formula5=$sessionObj->param("userMessage");print("				<td class=\"liteGray\" valign=\"middle\" align=\"left\" colspan=\"2\"><span class=\"userMessage\">$formula5</span></td>
print("			</tr>
 $sessionObj->param("userMessage", "");
 }
print("			<tr>
print("				<td class=\"liteGray\" valign=\"middle\" align=\"right\"><span class=\"table1Text1\">Date</span></td>
print("					<td class=\"liteGray\" valign=\"middle\" align=\"left\"><span class=\"table1Text1\" style=\"font-size:6pt\">
print("							<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
print("								<tr>
my $formula6=$date;print("									<td><input type=\"text\" name=\"date\"  value=\"$formula6\" size=\"10\"maxlength=\"10\"></td>
print("									<td><span class=\"table1Text1\" style=\"font-size:8pt\">&nbsp;&nbsp;YYYY-MM-DD</span></td>
print("								</tr>
print("							</table>
print("						</span></td>
print("				</tr>
print("			<tr>
print("				<td class=\"liteGray\" valign=\"middle\" align=\"right\"><span class=\"table1Text1\">User</span></td>
my $formula7=$user;print("				<td class=\"liteGray\" valign=\"middle\" align=\"left\"><input type=\"text\" name=\"user\" value=\"$formula7\" size=\"20\"></td>
print("			</tr>
print("				<tr>
print("					<td class=\"liteGray\" valign=\"top\" align=\"right\"><span class=\"table1Text1\">Description</span></td>
my $formula8=$description;print("					<td class=\"liteGray\" valign=\"top\" align=\"left\"><textarea name=\"description\" cols=\"60\" rows=\"2\">$formula8</textarea></td>
print("				</tr>
print("				<tr>
print("				<td class=\"tdBottom\" valign=\"middle\" align=\"right\" colspan=\"2\">
print("					<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" >
print("						<tr>
print("							<td nowrap=\"nowrap\"><input class=\"liteButton\" type=\"submit\" name=\"submit\" value=\"ENTER\"></td>
if ($action eq "displayUpdateItem") {
print("								<td nowrap=\"nowrap\"><input class=\"liteButton\" type=\"submit\" name=\"submit\" value=\"CLEAR\"></td>
}
print("						</tr>
print("					</table>
print("				</td>
print("			</tr>
print("		</table>
print("		</form>
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">
print("			<tr>
my $formula9=$sessionObj->param("hostName");print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\" colspan=\"4\">Change Log :: $formula9</td>
print("			</tr>
print("			<tr>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"1%\"></th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"5%\">Date</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\" width=\"5%\">User</th>
print("				<th valign=\"middle\" align=\"left\">Description</th>
print("			</tr>
if ($changeLogIndexLen == 0) { 
print("			<tr>
print("				<td class=\"liteGray\" nowrap width=\"1%\"></td>
print("				<td class=\"liteGray\" nowrap width=\"5%\">&nbsp;</td>
print("				<td class=\"liteGray\" nowrap width=\"5%\">&nbsp;</td>
print("				<td class=\"liteGray\">&nbsp;</td>
print("			</tr>
} else {
my $hgOwner = $sessionObj->param('hgOwner');
my $hgID = $sessionObj->param('hostGroupID');
my $hostName = $sessionObj->param('hostName');
foreach my $valueArray (@$changeLogArray) {
my $indexValue =  $valueArray->[0];
my $date = $valueArray->[1];
my $user = $valueArray->[2];
my $description = $valueArray->[3];
print("					<tr>
print("						<td class=\"liteGray\" nowrap width=\"1%\" valign=\"top\" align=\"left\">
print("							<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\">
print("								<tr>
my $queryString = "action=displayUpdateItem&hgOwner=$hgOwner&hostGroupID=$hgID&hostName=$hostName&itemID=$indexValue&date=$date&user=$user&description=$description";
my $formula10=$queryString;print("									<td nowrap=\"nowrap\"><span class=\"table1Text2\"><a href=\"index.pl?$formula10\">Edit</a></span></td>
my $formula11=$hgOwner;my $formula12=$hgID;my $formula13=$hostName;my $formula14=$indexValue;print("									<td nowrap=\"nowrap\"><span class=\"table1Text2\"><a href=\"index.pl?action=deleteItem&hgOwner=$formula11&hostGroupID=$formula12&hostName=$formula13&itemID=$formula14\">Delete</a></span></td>
print("								</tr>
print("							</table>
print("						</td>
my $formula15=$date;print("						<td class=\"liteGray\" nowrap width=\"5%\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula15</span></td>
my $formula16=$user;print("						<td class=\"liteGray\" nowrap width=\"5%\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula16</span></td>
my $formula17=$description;print("						<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"table1Text2\">$formula17</span></td>
print("					</tr>
}
}
print("		</table>
print("	</body>
print("</html>\n");