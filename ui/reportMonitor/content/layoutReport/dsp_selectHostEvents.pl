use strict;
package main;
print("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
if ($sessionObj->param("userMessage1") ne "") {
print("	<tr>\n");
my $formula0=$sessionObj->param("userMessage1");print("		<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"userMessage\">$formula0</span></td>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<td class=\"liteGray\" valign=\"top\" align=\"left\"><img name=\"xallHosts_host1\" src=\"../../../appRez/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("	</tr>\n");
$sessionObj->param("userMessage1", "");
 }
 if (@$hostGroupArray == 0) {
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Host Groups</legend>\n");
print("							<b>There are no host groups to select</b>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
} else {
print("	<tr>\n");
print("		<td>\n");
print("			<form action=\"index.pl\" method=\"post\">\n");
my $formula1=$reportNameID;print("			<input type=\"hidden\" name=\"reportNameID\" value=\"$formula1\">\n");
print("			<input type=\"hidden\" name=\"contentType\" value=\"hostEvents\">\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Host Group</legend>\n");
print("							<select name=\"hostGroupID\" size=\"1\" onchange=\"submit();\">\n");
foreach my $hostGroupName (@$hostGroupArray) {
my $formula2=$hostGroupName;my $formula3=$hostGroupName eq $hostGroupID ? 'selected' : ' ';my $formula4=$hostGroupName;print("									<option value=\"$formula2\" $formula3>$formula4</option>\n");
}
print("							</select>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("			</form>\n");
print("		</td>\n");
print("	</tr>\n");
print("	<form name=\"selectHost\" action=\"index.pl\" method=\"get\">\n");
my $formula5=$reportNameID;print("		<input type=\"hidden\" name=\"reportNameID\" value=\"$formula5\">\n");
print("		<input type=\"hidden\" name=\"contentType\" value=\"hostEvents\">\n");
my $formula6=$hostGroupID;print("		<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula6\">\n");
my $formula7=$selectHosts->[0];print("		<input type=\"hidden\" name=\"selectHosts\" value=\"$formula7\">\n");
print("	</form>\n");
print("	<form action=\"index.pl\" method=\"get\">\n");
my $formula8=$reportNameID;print("	<input type=\"hidden\" name=\"reportNameID\" value=\"$formula8\">\n");
print("	<input type=\"hidden\" name=\"contentType\" value=\"hostEvents\">\n");
my $formula9=$hostGroupID;print("	<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula9\">\n");
print("	<input type=\"hidden\" name=\"action\" value=\"insertHostEvents\">\n");
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>		\n");
print("            				<legend align=\"top\">Host</legend>\n");
print("            				<select name=\"selectHosts\" onChange=\"document.forms.selectHost.selectHosts.value=this.options[this.selectedIndex].value; document.forms.selectHost.submit();\">>\n");
 foreach my $contentStruct (@$hostArray) {
my $value="$contentStruct->{'hostName'}";
my $formula10=$value;my $formula11=searchArray($selectHosts, $value) ? 'selected' : ' ';my $formula12=$value;print("									<option value=\"$formula10\" $formula11>$formula12</option>\n");
}
print("							</select>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<td>\n");
print("			<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("				<tr>\n");
print("					<td>\n");
print("						<fieldset>\n");
print("							<legend align=\"top\">Services</legend>\n");
print("							<select name=\"selectServices\"  size=\"3\" multiple>\n");
 foreach my $serviceName (@$serviceArray) {
my $formula13=$serviceName;my $formula14=searchArray($selectServices, $serviceName) ? 'selected' : ' ';my $formula15=$serviceName;print("									<option value=\"$formula13\" $formula14>$formula15</option>\n");
}
print("							</select>\n");
print("						</fieldset>\n");
print("					</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
print("	<tr>\n");
print("		<td align=\"center\">\n");
print("			<table>\n");
print("				<td class=\"liteGray\" valign=\"top\" align=\"right\"><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"ADD\"></td>\n");
print("			</table>\n");
print("		</td>\n");
print("	</tr>\n");
print("	</form>\n");
}
print("</table>\n");
