#!/usr/bin/perl -w
use strict;
BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $hostGroupArray $navLinkChosen $serviceHash $graphSize $customSize $graphLayout);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_selectHGGraphs.html");}
require("act_initSelectHGGraphs.pl");
require("dsp_selectHGGraphs.pl");