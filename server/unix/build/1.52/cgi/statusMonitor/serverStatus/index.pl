#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "../..");
	require("app_globals.pl");
}

my $request = new CGI;
my $action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "whatever")
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_level1.html");}
	require("dsp_level1.pl");
}
else #default action is display frame
{
	use vars qw($serverStatus $uptime);
	require("act_setHome.pl");
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_home.html");}
	require("dsp_home.pl");
}