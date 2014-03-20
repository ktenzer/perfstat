#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $serviceHashRefined $serviceMetricArray $newHostName $ipAddress $osName $queryString );

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "setMetricThresholds")
{
	require("act_updateMetricThresholds.pl");
	metaRedirect(0, "index.pl?$queryString");
}
else #default action is display frame
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_metricConfig.html");}
	require("act_initDspMetricConfig.pl");
	require("dsp_metricConfig.pl");
}