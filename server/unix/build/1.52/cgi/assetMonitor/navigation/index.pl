#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "../..");
	unshift(@INC, "..");
	require("app_globals.pl");
}

use vars qw($action $adminList $userList $hostGroupArray);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_nav.html");}
require("act_initNav.pl");
require("dsp_nav.pl");