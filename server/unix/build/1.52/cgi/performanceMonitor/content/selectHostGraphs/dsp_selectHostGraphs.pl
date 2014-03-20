use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/forms.css\" media=\"screen\">\n");
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/contentFrame.js\"></script>\n");
print("		<script language=\"javascript\" src=\"../../../perfStatResources/javaScripts/pm.selectHostGraphs.js\"></script>\n");
print("	</head>\n");

print("	<body onload=\"drawGraphTable();\">\n");
my $formula0=$sessionObj->param("groupViewStatus") ne "shared" ?  "My HostGroups" : "Shared HostGroups";print("		<div class=\"navHeader\"><div class=\"navHeader\">Performance Monitor :: <a href=\"../../navigation1/index.pl\" target=\"navigation\">$formula0</a> :: Host Graphs</div>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Host Group</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Selected Host</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Select Host</th>\n");
print("			</tr>\n");
print("			<tr>\n");
my $formula1=$sessionObj->param("hostGroupID");print("				<td class=\"liteGray\" align=\"center\" valign=\"middle\">$formula1</td>\n");
my $formula2=$sessionObj->param("hostName");print("				<td class=\"liteGray\" align=\"left\" valign=\"middle\">$formula2</td>\n");
print("				<td class=\"liteGray\" align=\"center\" valign=\"middle\">\n");
print("					<form action=\"index.pl\" method=\"get\">\n");
my $formula3=$graphSize;print("					<input type=\"hidden\" name=\"graphSize\" value=\"$formula3\">\n");
my $formula4=$graphLayout;print("					<input type=\"hidden\" name=\"graphLayout\" value=\"$formula4\">\n");
my $formula5=$sessionObj->param("hostGroupID");print("					<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula5\">\n");
print("					<select name=\"hostName\" size=\"1\" onChange=\"submit();\">\n");
foreach my $hostName (@$hostArray) {
my $formula6=$hostName;my $formula7=$sessionObj->param("hostName") eq $hostName ? "selected" : "";;my $formula8=$hostName;print("						<option value=\"$formula6\" $formula7>$formula8</option>					\n");
}
print("					</select>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
print("		</table>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("				<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><span class=\"tableHeader\">Select Graph(s)</span></td>\n");
print("				</tr>\n");
print("			<tr>\n");
print("				<td class=\"darkGray\" align=\"left\" valign=\"top\">\n");
print("					<table class=\"smallJSLinkTable\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
print("						<tr>\n");
print("							<td nowrap><a href=\"javascript:openAll();\">open all</a></td>\n");
print("							<td nowrap><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"6\" border=\"0\"></td>\n");
print("							<td nowrap><a href=\"javascript:closeAll();\">close all</a></td>\n");
print("							<td nowrap><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"5\" width=\"6\" border=\"0\"></td>\n");
print("							<td nowrap><a href=\"javascript:selectAll();\">select all</a></td>\n");
print("							<td nowrap><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"5\" width=\"6\" border=\"0\"></td>\n");
print("							<td nowrap><a href=\"javascript:removeAll();\">remove all</a></td>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"darkGray\" align=\"left\" valign=\"top\">\n");
print("					<table border=\"0\" cellpadding=\"2\" cellspacing=\"2\">\n");
print("						<tr>\n");
foreach my $serviceName (sort(keys(%$serviceHashRefined))) {
my $descriptorHash = $serviceHashRefined->{$serviceName};
if ( $descriptorHash->{'hasSubService'} == 0) {
my $graphHash = $descriptorHash->{'graphHash'};
print("							<td width=\"40\" valign=\"top\" align=\"left\">\n");
my $formula9=$serviceName;print("								<div id=\"$formula9-off\" style=\"display:block;\">\n");
print("									<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("										<tr>\n");
my $formula10=$serviceName;my $formula11=$serviceName;my $formula12=$serviceName;my $formula13=$serviceName;print("											<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><a href=\"javascript:toggle('$formula10-off', '$formula11-on');\"><img id=\"x$formula12-off\" src=\"../../../perfStatResources/images/navigation/icon_plusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a>&nbsp;$formula13</th>\n");
print("										</tr>\n");
print("									</table>\n");
print("								</div>\n");
my $formula14=$serviceName;print("								<div id=\"$formula14-on\" style=\"display:none;\">\n");
print("									<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("										<tr>\n");
my $formula15=$serviceName;my $formula16=$serviceName;my $formula17=$serviceName;my $formula18=$serviceName;print("											<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><a href=\"javascript:toggle('$formula15-off', '$formula16-on');\"><img id=\"x$formula17-on\" src=\"../../../perfStatResources/images/navigation/icon_minusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a>&nbsp;$formula18</th>\n");
print("										</tr>\n");
print("										<tr>\n");
print("											<td valign=\"top\">\n");
print("												<table border=\"0\" cellpadding=\"1\" cellspacing=\"1\">\n");
 foreach my $graphName (sort(keys(%$graphHash))) {
print("													<tr>\n");
my $formula19=$selectedHostOS;my $formula20=$sessionObj->param("hostName");my $formula21=$serviceName;my $formula22=$graphName;my $formula23=$selectedHostOS;my $formula24=$sessionObj->param("hostName");my $formula25=$serviceName;my $formula26=$graphName;my $formula27=$graphName;print("														<td nowrap style=\"text-align: left;\" valign=\"middle\" align=\"left\"><a class=\"insertHREF\" ID=\"$formula19^single^$formula20^$formula21^$formula22\" href=\"javascript: insertGraph('$formula23', 'single', '$formula24', '$formula25', '$formula26');\">$formula27</a></td>\n");
print("													</tr>\n");
 }
print("												</table>\n");
print("											</td>\n");
print("										</tr>\n");
print("									</table>\n");
print("								</div>\n");
print("							</td>\n");
 } else {
 my $subServiceHash = $descriptorHash->{'subServiceHash'};
print("							<td width=\"40\" valign=\"top\" align=\"left\">\n");
my $formula28=$serviceName;print("								<div id=\"$formula28-off\" style=\"display:block;\">\n");
print("									<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("										<tr>\n");
my $formula29=$serviceName;my $formula30=$serviceName;my $formula31=$serviceName;my $formula32=$serviceName;print("											<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><a href=\"javascript:toggle('$formula29-off', '$formula30-on');\"><img id=\"x$formula31-off\" src=\"../../../perfStatResources/images/navigation/icon_plusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a>&nbsp;$formula32</th>\n");
print("										</tr>\n");
print("									</table>\n");
print("								</div>\n");
my $formula33=$serviceName;print("								<div id=\"$formula33-on\" style=\"display:none;\">\n");
print("									<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" class=\"table2\">\n");
print("										<tr>\n");
my $formula34=$serviceName;my $formula35=$serviceName;my $formula36=$serviceName;my $formula37=$serviceName;print("											<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\"><a href=\"javascript:toggle('$formula34-off', '$formula35-on');\"><img id=\"x$formula36-on\" src=\"../../../perfStatResources/images/navigation/icon_minusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a>&nbsp;$formula37</th>\n");
print("										</tr>\n");
 if (defined($descriptorHash->{'multiServiceGraphNames'})) {
print("										<tr>\n");
print("											<td style=\"text-align: left;\">\n");
my $formula38=$serviceName;print("												<div id=\"$formula38-all-off\" style=\"display:block;\">\n");
print("												<table border=\"0\" cellpadding=\"1\" cellspacing=\"1\">\n");
print("													<tr>\n");
my $formula39=$serviceName;my $formula40=$serviceName;my $formula41=$serviceName;print("														<td><a href=\"javascript:toggle('$formula39-all-off', '$formula40-all-on');\"><img id=\"x$formula41-all-off\" src=\"../../../perfStatResources/images/navigation/icon_plusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a></td>\n");
print("														<td nowrap>ALL</td>\n");
print("													</tr>\n");
print("												</table>\n");
print("												</div>\n");
my $formula42=$serviceName;print("												<div id=\"$formula42-all-on\" style=\"display:none;\">\n");
print("												<table border=\"0\" cellpadding=\"1\" cellspacing=\"1\">\n");
print("													<tr>\n");
my $formula43=$serviceName;my $formula44=$serviceName;my $formula45=$serviceName;print("														<td><a href=\"javascript:toggle('$formula43-all-off', '$formula44-all-on');\"><img id=\"x$formula45-all-on\" src=\"../../../perfStatResources/images/navigation/icon_minusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a></td>\n");
print("														<td nowrap>ALL</td>\n");
print("													</tr>\n");
print("												</table>\n");
 my $graphNameArray = $descriptorHash->{'multiServiceGraphNames'};
 foreach my $graphName (@$graphNameArray) {
print("												<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\">\n");
print("													<tr>\n");
print("														<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" width=\"12\" height=\"9\" border=\"0\"></td>\n");
my $formula46=$selectedHostOS;my $formula47=$sessionObj->param("hostName");my $formula48=$serviceName;my $formula49=$graphName;my $formula50=$selectedHostOS;my $formula51=$sessionObj->param("hostName");my $formula52=$serviceName;my $formula53=$graphName;my $formula54=$graphName;print("														<td style=\"text-align: left;\" nowrap><a class=\"insertHREF\" ID=\"$formula46^multi^$formula47^$formula48.all^$formula49\" href=\"javascript:insertGraph('$formula50', 'multi', '$formula51', '$formula52.all', '$formula53');\">$formula54</a></td>\n");
print("													</tr>\n");
print("												</table>\n");
}
print("												</div>\n");
}
print("											</td>\n");
print("										</tr>			\n");
foreach my $subServiceName (keys(%$subServiceHash)) {
 my $graphHash = $subServiceHash->{$subServiceName};
print("										<tr>\n");
print("											<td style=\"text-align: left;\">\n");
my $formula55=$serviceName;my $formula56=$subServiceName;print("												<div id=\"$formula55-$formula56-off\" style=\"display:block;\">\n");
print("												<table border=\"0\" cellpadding=\"1\" cellspacing=\"1\">\n");
print("													<tr>\n");
my $formula57=$serviceName;my $formula58=$subServiceName;my $formula59=$serviceName;my $formula60=$subServiceName;my $formula61=$serviceName;my $formula62=$subServiceName;print("														<td><a href=\"javascript:toggle('$formula57-$formula58-off', '$formula59-$formula60-on');\"><img id=\"x$formula61-$formula62-off\" src=\"../../../perfStatResources/images/navigation/icon_plusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a></td>\n");
my $formula63=$subServiceName;print("														<td nowrap>$formula63</td>\n");
print("													</tr>\n");
print("												</table>\n");
print("												</div>\n");
my $formula64=$serviceName;my $formula65=$subServiceName;print("												<div id=\"$formula64-$formula65-on\" style=\"display:none;\">\n");
print("												<table border=\"0\" cellpadding=\"1\" cellspacing=\"1\">\n");
print("													<tr>\n");
my $formula66=$serviceName;my $formula67=$subServiceName;my $formula68=$serviceName;my $formula69=$subServiceName;my $formula70=$serviceName;my $formula71=$subServiceName;print("														<td><a href=\"javascript:toggle('$formula66-$formula67-off', '$formula68-$formula69-on');\"><img id=\"x$formula70-$formula71-on\" src=\"../../../perfStatResources/images/navigation/icon_minusNavBar.gif\" width=\"9\" height=\"9\" border=\"0\"></a></td>\n");
my $formula72=$subServiceName;print("														<td nowrap>$formula72</td>\n");
print("													</tr>\n");
print("												</table>\n");
 foreach my $graphName (keys(%$graphHash)) {
print("												<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\">\n");
print("													<tr>\n");
print("														<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" width=\"12\" height=\"9\" border=\"0\"></td>\n");
my $formula73=$selectedHostOS;my $formula74=$sessionObj->param("hostName");my $formula75=$serviceName;my $formula76=$subServiceName;my $formula77=$graphName;my $formula78=$selectedHostOS;my $formula79=$sessionObj->param("hostName");my $formula80=$serviceName;my $formula81=$subServiceName;my $formula82=$graphName;my $formula83=$graphName;print("														<td style=\"text-align: left;\" nowrap><a class=\"insertHREF\" ID=\"$formula73^single^$formula74^$formula75.$formula76^$formula77\" href=\"javascript:insertGraph('$formula78', 'single', '$formula79', '$formula80.$formula81', '$formula82');\">$formula83</a></td>\n");
print("													</tr>\n");
print("												</table>\n");
}
print("												</div>\n");
print("											</td>\n");
print("										</tr>\n");
}
print("									</table>\n");
print("								</div>\n");
print("							</td>\n");
 }
 }
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
print("				</tr>\n");
print("			</table>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Select Interval(s) and Graph Type(s)</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"darkGray\" align=\"left\" valign=\"top\">\n");
print("					<table class=\"table3\" id=\"graphTable\" border=\"0\" cellpadding=\"2\" cellspacing=\"2\">\n");
print("						<thead>\n");
print("							<tr>\n");
print("								<th valign=\"middle\" align=\"left\" colspan=\"4\"></th>\n");
print("								<th valign=\"middle\" align=\"left\" colspan=\"4\">Intervals</th>\n");
print("								<th valign=\"middle\" align=\"left\" colspan=\"3\">Graph Type</th>\n");
print("							</tr>\n");
print("							<tr>\n");
print("								<th valign=\"middle\" align=\"left\"></th>\n");
print("								<th valign=\"middle\" align=\"left\">Host</th>\n");
print("								<th valign=\"middle\" align=\"left\">Service</th>\n");
print("								<th valign=\"middle\" align=\"left\">Graph Name</th>\n");
print("								<th valign=\"middle\" align=\"center\">Day</th>\n");
print("								<th valign=\"middle\" align=\"center\">Week</th>\n");
print("								<th valign=\"middle\" align=\"center\">Month</th>\n");
print("								<th valign=\"middle\" align=\"center\">Year</th>\n");
print("								<th valign=\"middle\" align=\"center\">Line</th>\n");
print("								<th valign=\"middle\" align=\"center\">Bar</th>\n");
print("								<th valign=\"middle\" align=\"center\">Pie</th>\n");
print("							</tr>\n");
print("							<tr>\n");
print("								<th colspan=\"4\"></th>\n");
print("								<th valign=\"middle\" align=\"center\"><a href=\"javascript:selectColumn('day');\">+</a> | <a href=\"javascript:deSelectColumn('day')\">-</a></th>\n");
print("								<th valign=\"middle\" align=\"center\"><a href=\"javascript:selectColumn('week');\">+</a> | <a href=\"javascript:deSelectColumn('week')\">-</a></th>\n");
print("								<th valign=\"middle\" align=\"center\"><a href=\"javascript:selectColumn('month');\">+</a> | <a href=\"javascript:deSelectColumn('month')\">-</a></th>\n");
print("								<th valign=\"middle\" align=\"center\"><a href=\"javascript:selectColumn('year');\">+</a> | <a href=\"javascript:deSelectColumn('year')\">-</a></th>\n");
print("								<th valign=\"middle\" align=\"center\"><a href=\"javascript:selectColumn('line');\">+</a> | <a href=\"javascript:deSelectColumn('line')\">-</a></th>\n");
print("								<th valign=\"middle\" align=\"center\"><a href=\"javascript:selectColumn('bar');\">+</a> | <a href=\"javascript:deSelectColumn('bar')\">-</a></th>\n");
print("								<th valign=\"middle\" align=\"center\"><a href=\"javascript:selectColumn('pie');\">+</a> | <a href=\"javascript:deSelectColumn('pie')\">-</a></th>\n");
print("							</tr>\n");
print("						</thead>\n");
print("						<tbody>\n");
print("						</tbody>\n");
print("					</table>\n");
print("				</td>\n");
print("			</tr>\n");
print("		</table>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\" width=\"100%\">\n");
print("			<tr>\n");
print("				<td class=\"tdTop\" nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Create Graph(s)</td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<td class=\"darkGray\" align=\"left\" valign=\"top\">\n");
print("					<form name=\"outputHostGraphs\" action=\"../displayHostGraphs/index.pl\" method=\"post\">\n");
my $formula84=$sessionObj->param("hostGroupID");print("					<input type=\"hidden\" name=\"hostGroupID\" value=\"$formula84\">\n");
my $formula85=$sessionObj->param("hostName");print("					<input type=\"hidden\" name=\"hostName\" value=\"$formula85\">\n");
print("					<input type=\"hidden\" name=\"hostGraphHolderArray\" value=\"\">\n");
print("					<table>\n");
print("						<tr>\n");
print("							<td><span class=\"table1Text1\">Layout:</span></td>\n");
print("							<td>\n");
print("								<select name=\"graphLayout\" size=\"1\">\n");
my $formula86=$graphLayout eq "1" ? "selected" : "";;print("									<option value=\"1\" $formula86>1 Column</option>\n");
my $formula87=$graphLayout eq "2" ? "selected" : "";;print("									<option value=\"2\" $formula87>2 Column</option>\n");
my $formula88=$graphLayout eq "3" ? "selected" : "";;print("									<option value=\"3\" $formula88>3 Column</option>\n");
my $formula89=$graphLayout eq "4" ? "selected" : "";;print("									<option value=\"4\" $formula89>4 Column</option>\n");
print("								</select>\n");
print("							</td>\n");
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("							<td nowrap><span class=\"table1Text1\">Graph Size:</span></td>\n");
print("							<td>\n");
print("								<select name=\"graphSize\" size=\"1\" onChange=\"document.outputHostGraphs.customSize.value=''\">\n");
my $formula90=$graphSize eq "custom" ? "selected" : "";;print("									<option value=\"custom\" $formula90>Custom</option>\n");
my $formula91=$graphSize eq "small" ? "selected" : "";;print("									<option value=\"small\" $formula91>Small</option>\n");
my $formula92=$graphSize eq "medium" ? "selected" : "";;print("									<option value=\"medium\" $formula92>Medium</option>\n");
my $formula93=$graphSize eq "large" ? "selected" : "";;print("									<option value=\"large\" $formula93>Large</option>\n");
print("								</select>\n");
print("							</td>\n");
print("							<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("							<td nowrap><span class=\"table1Text1\">Custom Size:</span></td>\n");
my $formula94=$customSize;print("							<td><input type=\"text\" name=\"customSize\" value=\"$formula94\" size=\"3\" maxlength=\"3\" onFocus=\"document.outputHostGraphs.graphSize.options[0].selected=true\"></td>\n");
print("								<td><span class=\"table1Text1\">%</span></td>\n");
print("								<td><img src=\"../../../perfStatResources/images/common/spacer.gif\" height=\"6\" width=\"4\" border=\"0\"></td>\n");
print("								<td><input class=\"liteButton\" type=\"button\" value=\"Create\" onClick=\"top.topFrame.displayHostGraphs();\"></td>\n");
print("						</tr>\n");
print("					</table>\n");
print("				</td>\n");
print("				</form>\n");
print("			</tr>\n");
print("		</table>\n");
print("	</body>\n");
print("</html>\n");
