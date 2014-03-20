use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat Tool: Status And Performance Monitoring</title>\n");
print("		<link rel=\"stylesheet\" type=\"text/css\" href=\"../../../perfStatResources/styleSheets/contentFrame.css\" media=\"screen\">\n");
print("	</head>\n");
print("\n");
print("	<body style=\"background-color:#EFEFEF;\">\n");
print("		<table cellpadding=\"2\" cellspacing=\"1\" border=\"0\" class=\"table3\">\n");
print("			<tr>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Date</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Status</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Metric</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Value</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Boundary</th>\n");
print("				<th nowrap=\"nowrap\" valign=\"middle\" align=\"left\">Unit</th>\n");
print("			</tr>\n");
foreach my $logEntry (@$logData) {
$logEntry =~ m/(.*)\s+(OK|WARN|CRIT|nostatus)\s+(.*)\s+\S+\s+(\d+\.?\d*|\S+)\s+\S+\s+(\d+\.?\d*|\S+)\s+\S+\s+(\S+)/;
 my $date=$1; my $status=$2; my $friendlyName=$3; my $value=$4; my $boundary=$5; my $unit=$6;
print("			<tr>\n");
my $formula0=$date;print("				<td class=\"liteGray\" nowrap><span class=\"table3Text1\">$formula0</span></td>\n");
my $formula1=$status;print("				<td class=\"liteGray\" nowrap><span class=\"table3Text1\">$formula1</span></td>\n");
my $formula2=$friendlyName;print("				<td class=\"liteGray\" nowrap><span class=\"table3Text1\">$formula2</span></td>\n");
my $formula3=$value;print("				<td class=\"liteGray\" nowrap><span class=\"table3Text1\">$formula3</span></td>\n");
my $formula4=$boundary;print("				<td class=\"liteGray\" nowrap><span class=\"table3Text1\">$formula4</span></td>\n");
my $formula5=$unit;print("				<td class=\"liteGray\" nowrap><span class=\"table3Text1\">$formula5</span></td>\n");
print("			</tr>\n");
}
print("		</table>\n");
print("	</body>\n");
print("</html>
\n");
