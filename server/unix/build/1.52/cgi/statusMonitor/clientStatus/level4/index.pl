#!/usr/bin/perl -w
use strict;
BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $hostGroupName $logData);

$request = new CGI;
$action = undef;
$action = $request->param('action');

if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_level4.html");}
require("act_initLevel4.pl");
require("dsp_level4.pl");