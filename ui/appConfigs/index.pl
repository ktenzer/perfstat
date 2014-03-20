#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "..");
	require("app_globals.pl");
}

if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_frames.html");}
require("dsp_frames.pl");