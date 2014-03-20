if (!defined($request->param("os"))) {
	die("OS is not defined");
} else {
	$os = $request->param("os");
}

if (!defined($request->param("hostName"))) {
	die("hostName is not defined");
} else {
	$hostName = $request->param("hostName");
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

if (!defined($request->param("graphScale"))) {
	die("graphScale is not defined");
} else {
	$graphScale = trim($request->param('graphScale'));
}

1;