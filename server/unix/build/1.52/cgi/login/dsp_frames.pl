use strict;
package main;
print("<html>\n");
print("	<head>\n");
print("		<meta http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">\n");
print("		<title>PerfStat: Performance And Status Monitor</title>\n");
print("	</head>\n");

print("	<frameset rows=\"68,*\" frameBorder=\"yes\" frameBorder=\"1\" frameSpacing=\"-1\" border=\"1\">\n");
print("		<frame src=\"../header/index.pl\" name=\"topFrame\" noresize scrolling=\"no\" marginHeight=\"0\" marginWidth=\"0\">\n");
print("		<frame src=\"../statusMonitor/index.pl\" name=\"bottomFrame\">\n");
print("	</frameset>\n");

print("	<noframes>\n");
print("		<body bgcolor=\"#ffffff\">\n");
print("			<p>Sorry: This application requires a frames-enabled browser</p>\n");
print("		</body>\n");
print("	</noframes>\n");
print("</html>\n");
