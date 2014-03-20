use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/forms.css\" media=\"screen\">\n");
print("	</head>\n");
print("\n");
my $formula0=$navLinkChosen;print("	<body onLoad=\"parent.navigation.setLinkChosen('$formula0');\">\n");
print("		<div class=\"navHeader\">Host Group Graphs</div>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Groups</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Selected Host Group</th>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
print("					<form action=\"../level1/index.pl\" method=\"get\">\n");
my $formula1=$graphSize;print("					<input type=\"hidden\" name=\"graphSize\" value=\"$formula1\">\n");
my $formula2=$graphLayout;print("					<input type=\"hidden\" name=\"graphLayout\" value=\"$formula2\">\n");
print("					<select name=\"hostGroupID\" size=\"1\" onChange=\"submit();\">\n");
foreach my $hostGroupDescHash (@$hostGroupArray) {
my $hgID = $hostGroupDescHash->{'hostGroupID'};
my $formula3=$hgID;my $formula4=$hgID eq $sessionObj->param("hostGroupID") ? "selected" : "";;my $formula5=$hgID;print("							<option value=\"$formula3\" $formula4> $formula5</option>					\n");
}
print("					</select>\n");
print("				</td>\n");
print("				</form>\n");
print("				<td class=\"liteGray\" align=\"center\" valign=\"middle\">\n");
print("					<form action=\"../level1/index.pl\" method=\"get\">\n");
my $formula6=$sessionObj->param("hostGroupID");print("					<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula6\">\n");
print("					<input class=\"liteButton\" type=\"submit\" value=\"Drill Down to Host Graphs\"/>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
