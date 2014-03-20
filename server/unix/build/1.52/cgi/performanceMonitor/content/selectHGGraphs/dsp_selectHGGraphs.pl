use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/contentFrame.js\"></script>\n");
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/pm.selectHostGroupGraphs.js\"></script>\n");
print("	</head>\n");
print("\n");
my $formula0=$navLinkChosen;print("	<body onLoad=\"parent.navigation.setLinkChosen('$formula0'); drawGraphTable();\">\n");
my $formula1=$sessionObj->param("groupViewStatus") ne "shared" ?  "My HostGroups" : "Shared HostGroups";print("		<div class=\"navHeader\">Performance Monitor :: $formula1 ::  Host Group Graphs</div>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Selected HostGroup</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Select HostGroup</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Action</th>\n");
print("			</tr>\n");
print("			<tr>\n");
my $formula2=$sessionObj->param("hostGroupID");print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">$formula2</td>\n");
print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">\n");
print("					<form action=\"index.pl\" method=\"get\">\n");
my $formula3=$graphSize;print("					<input type=\"hidden\" name=\"graphSize\" value=\"$formula3\">\n");
my $formula4=$graphLayout;print("					<input type=\"hidden\" name=\"graphLayout\" value=\"$formula4\">\n");
print("					<select name=\"hostGroupID\" size=\"1\" onChange=\"submit();\">\n");
foreach my $hostGroupDescHash (@$hostGroupArray) {
my $hgID = $hostGroupDescHash->{'hostGroupID'};
my $formula5=$hgID;my $formula6=$hgID eq $sessionObj->param("hostGroupID") ? "selected" : "";;my $formula7=$hgID;print("							<option value=\"$formula5\" $formula6> $formula7</option>					\n");
}
print("					</select>\n");
print("				</td>\n");
print("				</form>\n");
print("				<td class=\"liteGray\" align=\"center\" valign=\"middle\">\n");
print("					<input class=\"liteButton\" type=\"button\" value=\"Drill Down to Host Graphs\" onclick=\"parent.navigation.location = '../../navigation2/index.pl'\"/>\n");
print("				</td>\n");
print("			</tr>\n");
print("		</table>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("				<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><span class=\"tableHeader\">Select Graph(s)</span></td>\n");
print("				</tr>\n");
print("			<tr>\n");
print("				<td class=\"darkGray\" align=\"left\" valign=\"top\">\n");
print("					<table class=\"smallJSLinkTable\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("						<tr>\n");
print("							<td nowrap><a href=\"javascript:openAll();\">open all</a></td>\n");
print("							<td nowrap><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"6\" border=\"0\"></td>\n");
print("							<td nowrap><a href=\"javascript:closeAll();\">close all</a></td>\n");
print("							<td nowrap><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"5\" width=\"6\" border=\"0\"></td>\n");
print("							<td nowrap><a href=\"javascript:selectAll();\">select all</a></td>\n");
print("							<td nowrap><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"5\" width=\"6\" border=\"0\"></td>\n");
print("							<td nowrap><a href=\"javascript:removeAll();\">remove all</a></td>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"darkGray\" align=\"left\" valign=\"top\">\n");
print("					<table border=\"0\" cellpadding=\"2\" cellspacing=\"2\">\n");
print("						<tr>\n");
foreach my $serviceName (sort(keys(%$serviceHash))) {
my $graphHash = $serviceHash->{$serviceName};
print("							<td width=\"40\" valign=\"top\" align=\"left\">\n");
my $formula8=$serviceName;print("								<div id=\"$formula8-off\" style=\"display:block;\">\n");
print("									<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("										<tr>\n");
my $formula9=$serviceName;my $formula10=$serviceName;my $formula11=$serviceName;my $formula12=$serviceName;print("											<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><a href=\"javascript:toggle('$formula9-off', '$formula10-on');\"><img id=\"x$formula11-off\" src=\"../../../perfStatResources/images/navigation/icon_plusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a>&nbsp;$formula12</th>\n");
print("										</tr>\n");
print("									</table>\n");
print("								</div>\n");
my $formula13=$serviceName;print("								<div id=\"$formula13-on\" style=\"display:none;\">\n");
print("									<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("										<tr>\n");
my $formula14=$serviceName;my $formula15=$serviceName;my $formula16=$serviceName;my $formula17=$serviceName;print("											<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><a href=\"javascript:toggle('$formula14-off', '$formula15-on');\"><img id=\"x$formula16-on\" src=\"../../../perfStatResources/images/navigation/icon_minusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a>&nbsp;$formula17</th>\n");
print("										</tr>\n");
print("										<tr>\n");
print("											<td valign=\"top\">\n");
print("												<table border=\"0\" cellpadding=\"1\" cellspacing=\"1\">\n");
 foreach my $graphName (sort(keys(%$graphHash))) {
print("													<tr>\n");
my $formula18=$sessionObj->param("hostGroupID");my $formula19=$serviceName;my $formula20=$graphName;my $formula21=$sessionObj->param("hostGroupID");my $formula22=$serviceName;my $formula23=$graphName;my $formula24=$graphName;print("														<td nowrap style=\"text-align: left;\" valign=\"middle\" align=\"left\"><a class=\"insertHREF\" ID=\"$formula18^$formula19^$formula20\" href=\"javascript: insertGraph('$formula21', '$formula22', '$formula23');\">$formula24</a></td>\n");
print("													</tr>\n");
 }
print("												</table>\n");
print("											</td>\n");
print("										</tr>\n");
print("									</table>\n");
print("								</div>\n");
print("							</td>\n");
 }
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Select Interval(s) and Graph Type(s)</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"darkGray\" align=\"left\" valign=\"top\">\n");
print("					<table class=\"table3\" id=\"graphTable\" border=\"0\" cellpadding=\"2\" cellspacing=\"2\">\n");
print("						<thead>\n");
print("							<tr>\n");
print("								<th valign=\"middle\" align=\"left\" colspan=\"4\"></th>\n");
print("								<th valign=\"middle\" align=\"left\" colspan=\"4\">Intervals</th>\n");
print("								<th valign=\"middle\" align=\"left\" colspan=\"2\" nowrap>Graph Type</th>\n");
print("							</tr>\n");
print("							<tr>\n");
print("								<th valign=\"middle\" align=\"left\"></th>\n");
print("								<th valign=\"middle\" align=\"left\">HostGroup</th>\n");
print("								<th valign=\"middle\" align=\"left\">Service</th>\n");
print("								<th valign=\"middle\" align=\"left\">Graph Name</th>\n");
print("								<th valign=\"middle\" align=\"center\">Day</th>\n");
print("								<th valign=\"middle\" align=\"center\">Week</th>\n");
print("								<th valign=\"middle\" align=\"center\">Month</th>\n");
print("								<th valign=\"middle\" align=\"center\">Year</th>\n");
print("								<th valign=\"middle\" align=\"center\">Bar</th>\n");
print("								<th valign=\"middle\" align=\"center\">Pie</th>\n");
print("							</tr>\n");
print("							<tr>\n");
print("								<th colspan=\"4\"></th>\n");
print("								<th valign=\"middle\" align=\"center\"><a href=\"javascript:selectColumn('day');\">+</a> | <a href=\"javascript:deSelectColumn('day')\">-</a></th>\n");
print("								<th valign=\"middle\" align=\"center\"><a href=\"javascript:selectColumn('week');\">+</a> | <a href=\"javascript:deSelectColumn('week')\">-</a></th>\n");
print("								<th valign=\"middle\" align=\"center\"><a href=\"javascript:selectColumn('month');\">+</a> | <a href=\"javascript:deSelectColumn('month')\">-</a></th>\n");
print("								<th valign=\"middle\" align=\"center\"><a href=\"javascript:selectColumn('year');\">+</a> | <a href=\"javascript:deSelectColumn('year')\">-</a></th>\n");
print("								<th valign=\"middle\" align=\"center\"><a href=\"javascript:selectColumn('bar');\">+</a> | <a href=\"javascript:deSelectColumn('bar')\">-</a></th>\n");
print("								<th valign=\"middle\" align=\"center\"><a href=\"javascript:selectColumn('pie');\">+</a> | <a href=\"javascript:deSelectColumn('pie')\">-</a></th>\n");
print("							</tr>\n");
print("						</thead>\n");
print("						<tbody>\n");
print("						</tbody>\n");
print("					</table>\n");
print("				</td>\n");
print("			</tr>\n");
print("		</table>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Create Graph(s)</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"darkGray\" align=\"left\" valign=\"top\">\n");
print("					<form name=\"outputHostGroupGraphs\" action=\"../displayHGGraphs/index.pl\" method=\"post\">\n");
my $formula25=$sessionObj->param("hostGroupID");print("					<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula25\">\n");
my $formula26=$sessionObj->param("hostName");print("					<input type=\"hidden\" name=\"hostName\" value=\"$formula26\">\n");
print("					<input type=\"hidden\" name=\"hgGraphHolderArray\" value=\"\">\n");
print("					<table>\n");
print("						<tr>\n");
print("							<td><span class=\"table1Text1\">Layout:</span></td>\n");
print("							<td>\n");
print("								<select name=\"graphLayout\" size=\"1\">\n");
my $formula27=$graphLayout eq "1" ? "selected" : "";;print("									<option value=\"1\" $formula27>1 Column</option>\n");
my $formula28=$graphLayout eq "2" ? "selected" : "";;print("									<option value=\"2\" $formula28>2 Column</option>\n");
my $formula29=$graphLayout eq "3" ? "selected" : "";;print("									<option value=\"3\" $formula29>3 Column</option>\n");
my $formula30=$graphLayout eq "4" ? "selected" : "";;print("									<option value=\"4\" $formula30>4 Column</option>\n");
print("								</select>\n");
print("							</td>\n");
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("							<td nowrap><span class=\"table1Text1\">Graph Size:</span></td>\n");
print("							<td>\n");
print("								<select name=\"graphSize\" size=\"1\" onChange=\"document.outputHostGroupGraphs.customSize.value=''\">\n");
my $formula31=$graphSize eq "custom" ? "selected" : "";;print("									<option value=\"custom\" $formula31>Custom</option>\n");
my $formula32=$graphSize eq "small" ? "selected" : "";;print("									<option value=\"small\" $formula32>Small</option>\n");
my $formula33=$graphSize eq "medium" ? "selected" : "";;print("									<option value=\"medium\" $formula33>Medium</option>\n");
my $formula34=$graphSize eq "large" ? "selected" : "";;print("									<option value=\"large\" $formula34>Large</option>\n");
print("								</select>\n");
print("							</td>\n");
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("							<td nowrap><span class=\"table1Text1\">Custom Size:</span></td>\n");
my $formula35=$customSize;print("							<td><input type=\"text\" name=\"customSize\" value=\"$formula35\" size=\"3\" maxlength=\"3\" onFocus=\"document.outputHostGroupGraphs.graphSize.options[0].selected=true\"></td>\n");
print("								<td><span class=\"table1Text1\">%</span></td>\n");
print("								<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("								<td><input class=\"liteButton\" type=\"button\" value=\"Create\" onClick=\"top.topFrame.displayHostGroupGraphs();\"></td>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
