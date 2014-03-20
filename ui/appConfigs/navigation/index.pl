#!/usr/bin/perl -w

use strict;

BEGIN
{
	unshift(@INC, "../..");
	require("app_globals.pl");
}

use vars qw($action $listState $adminList $userList $allHostHash $hostGroupHash $doRelocation);

my $request = new CGI;
$action = $request->param('action');

if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_nav.html");}
require("act_initNav.pl");
require("dsp_nav.pl");