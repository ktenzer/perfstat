use strict;
package main;

if (!defined($sessionObj->param("hostGroupID"))) {
	die("hostGroupID is not defined");
}

if (!defined($sessionObj->param("hostName"))) {
	die("hostName is not defined");
}

if (!defined($request->param('serviceName'))) {
	die("serviceName is not defined");
}

if (!defined($request->param('graphID'))) {
	die("graphID is not defined");
}

my $graphArray = [];
$graphArray->[0] = $sessionObj->param("hostName");
$graphArray->[1] = $request->param('serviceName');
$graphArray->[2] = $request->param('graphName');
$graphArray->[3] = [];

my $graphHolderArray = $sessionObj->param("graphHolderArray");
splice(@$graphHolderArray, $request->param('graphID'), 1);
$sessionObj->param("graphHolderArray", $graphHolderArray);

$queryString = 	"serviceName=". URLEncode($request->param('serviceName')) .
				"&graphName=" . URLEncode($request->param('graphName'));

1;