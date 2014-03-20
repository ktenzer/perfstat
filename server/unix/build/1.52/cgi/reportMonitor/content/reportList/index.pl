#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $navLinkChosen $adminName $userName $reportName $description $myReportArray $sharedReportArray $updateNav);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "insertReport")
{
	require("act_insertReport.pl");
}
elsif ($action eq "deleteReport")
{
	require("act_deleteReport.pl");
	metaRedirect(0, "index.pl?updateNav=1");
}
else #default action is display frame
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_reportList.html");}
	require("act_initReportList.pl");
	require("dsp_reportList.pl");
}