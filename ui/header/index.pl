#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "..");
	require("app_globals.pl");
}

my $request = new CGI;

if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_header.html");}
require("dsp_header.pl");