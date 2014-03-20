use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../appRez/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("	</head>\n");

print("	<body onLoad=\"parent.navigation.setLinkChosen('clientStatus');\">\n");
print("		<div class=\"navHeader\">\n");
my $formula0=$sessionObj->param("groupViewStatus") ne "shared" ?  "My HostGroups" : "Shared HostGroups";my $formula1=$sessionObj->param('hgOwner');my $formula2=$sessionObj->param('hostGroupID');my $formula3=$sessionObj->param("hostGroupID");my $formula4=$sessionObj->param("hostGroupID");my $formula5=$sessionObj->param("hostName");my $formula6=$sessionObj->param("serviceName");my $formula7=$sessionObj->param("hostName");print("			Status Monitor :: <a href=\"../level1/index.pl\">$formula0</a>  :: <a href=\"../level2/index.pl?hgOwner=$formula1&hostGroupID=$formula2\">$formula3</a> :: <a href=\"../level3/index.pl?hostGroupID=$formula4&hostName=$formula5&serviceName=$formula6\">$formula7</a>\n");
print("		</div>\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table1\">\n");
print("			<tr>\n");
my $formula8=$sessionObj->param("serviceName");print("				<td class=\"tdTop\" nowrap=\"nowrap\" colspan=\"6\" valign=\"middle\" align=\"left\">Event Log :: $formula8 </td>\n");
print("			</tr>\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Date</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Status</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Metric</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Value</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Boundary</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Unit</th>\n");
print("			</tr>\n");
foreach my $logEntry (@$logData) {
$logEntry =~ m/(.*)\s+(OK|WARN|CRIT|nostatus)\s+(.*)\s+\S+\s+(\d+\.?\d*|\S+)\s+\S+\s+(\d+\.?\d*|\S+)\s+\S+\s+(\S+)/;
 my $date=$1; my $status=$2; my $friendlyName=$3; my $value=$4; my $boundary=$5; my $unit=$6;
print("			<tr>\n");
my $formula9=$date;print("				<td class=\"liteGray\" nowrap><span class=\"table1Text2\">$formula9</span></td>\n");
my $formula10=$status;print("				<td class=\"liteGray\" nowrap><span class=\"table1Text2\">$formula10</span></td>\n");
my $formula11=$friendlyName;print("				<td class=\"liteGray\" nowrap><span class=\"table1Text2\">$formula11</span></td>\n");
my $formula12=$value;print("				<td class=\"liteGray\" nowrap><span class=\"table1Text2\">$formula12</span></td>\n");
my $formula13=$boundary;print("				<td class=\"liteGray\" nowrap><span class=\"table1Text2\">$formula13</span></td>\n");
my $formula14=$unit;print("				<td class=\"liteGray\" nowrap><span class=\"table1Text2\">$formula14</span></td>\n");
print("			</tr>\n");
}
print("		</table>\n");
print("	</body>\n");
print("</html>
\n");
