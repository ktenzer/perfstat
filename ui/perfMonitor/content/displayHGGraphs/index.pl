#!/usr/bin/perl -w
use strict;
BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $refinedGraphHolderArray $graphSize $customSize $graphScale $graphLayout);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_hostGroupGraphs.html");}
require("act_initDisplayHGGraphs.pl");
require("dsp_hostGroupGraphs.pl");