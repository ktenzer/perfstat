#!/usr/bin/perl -w

use strict;



BEGIN

{

	unshift(@INC, "..");

	require("app_globals.pl");

}



my $request = new CGI;

my $action = $request->param('action');



if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_frames.html");}

require("dsp_frames.pl");