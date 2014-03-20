#!/usr/bin/perl -w
use strict;
BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $queryString $hostArray $selectedHostOS $serviceHashRefined $graphSize $customSize $graphLayout);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "insertGraph")
{
	require("act_insertGraph.pl");
	metaRedirect(0, "index.pl?$queryString");
}

elsif ($action eq "deleteGraph")
{
	require("act_deleteGraph.pl");
	metaRedirect(0, "index.pl?$queryString");
}
else #default action is display frame
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_selectHostGraphs.html");}
	require("act_initSelectHostGraphs.pl");
	require("dsp_selectHostGraphs.pl");
}