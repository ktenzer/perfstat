if (!defined($request->param("hgName"))) {
	die("Host Group Name is not defined");
} else {
	$hgName = $request->param("hgName");
}

if (!defined($request->param("serviceName"))) {
	die("serviceName is not defined");
} else {
	$serviceName = $request->param("serviceName");
}

if (!defined($request->param("graphName"))) {
	die("graphName is not defined");
} else {
	$graphName = $request->param("graphName");
}

if (!defined($request->param("intervalName"))) {
	die("intervalName is not defined");
} else {
	$period = $request->param("intervalName");
}

if (!defined($request->param("graphType"))) {
	die("graphType is not defined");
} else {
	$graphType = $request->param("graphType");
}

if (!defined($request->param("graphScale"))) {
	die("graphScale is not defined");
} else {
	$graphScale = trim($request->param('graphScale'));
}

1;