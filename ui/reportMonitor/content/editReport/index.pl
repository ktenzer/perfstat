#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $queryString $adminName $userName $updateNav 
			$reportNameID $reportName $description );
$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "editReport")
{
	require("act_updateReportDescriptors.pl");
}

else #default action is display frame
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_editReport.html");}
	
	require("act_initDisplayEditReport.pl");
	require("dsp_editReport.pl");
}
