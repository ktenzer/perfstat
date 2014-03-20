#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "../../../../..");
	require("app_globals.pl");
}

use vars qw($action $os $hostName $serviceName $graphName $period $graphScale);

$request = new CGI;
$action = undef;
$action = $request->param('action');

require("act_initDrawGraph.pl");
require("act_drawGraph.pl");
