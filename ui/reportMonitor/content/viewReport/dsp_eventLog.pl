use strict;
package main;
print("<html>
print("	<head>
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">
print("	</head>
print("
print("	<body style=\"background-color:#EFEFEF;\">
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table3\">
print("			<tr>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Date</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Status</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Metric</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Value</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Boundary</th>
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Unit</th>
print("			</tr>
foreach my $logEntry (@$logData) {
$logEntry =~ m/(.*)\s+(OK|WARN|CRIT|nostatus)\s+(.*)\s+\S+\s+(\d+\.?\d*|\S+)\s+\S+\s+(\d+\.?\d*|\S+)\s+\S+\s+(\S+)/;
 my $date=$1; my $status=$2; my $friendlyName=$3; my $value=$4; my $boundary=$5; my $unit=$6;
print("			<tr>
my $formula0=$date;print("				<td class=\"liteGray\" nowrap><span class=\"table3Text1\">$formula0</span></td>
my $formula1=$status;print("				<td class=\"liteGray\" nowrap><span class=\"table3Text1\">$formula1</span></td>
my $formula2=$friendlyName;print("				<td class=\"liteGray\" nowrap><span class=\"table3Text1\">$formula2</span></td>
my $formula3=$value;print("				<td class=\"liteGray\" nowrap><span class=\"table3Text1\">$formula3</span></td>
my $formula4=$boundary;print("				<td class=\"liteGray\" nowrap><span class=\"table3Text1\">$formula4</span></td>
my $formula5=$unit;print("				<td class=\"liteGray\" nowrap><span class=\"table3Text1\">$formula5</span></td>
print("			</tr>
}
print("		</table>
print("	</body>
print("</html>
\n");