#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $adminName $userName $reportName $contentArray $contentStruct $logData);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "displayEventLog") 
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_eventLog.html");}
	require("act_initDisplayEventLog.pl");
	require("dsp_eventLog.pl");

} else {
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_viewReport.html");}
	require("act_initViewReport.pl");
	require("dsp_viewReport.pl");
}