#!/usr/bin/perl -w
use strict;
BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $hostGroupName $hostObject $serviceHashRefined);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_level3.html");}
require("act_initLevel3.pl");
require("dsp_level3.pl");