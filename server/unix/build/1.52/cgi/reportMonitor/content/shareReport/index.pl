#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $adminName $userName $reportName $potentialShareMembers $shareMembers $queryString);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "insertSharedUser")
{
	require("act_insertSharedUser.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "removeSharedUser")
{
	require("act_removeSharedUser.pl");
	metaRedirect(0, "index.pl?$queryString");
}
else #default action is display frame
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_share.html");}
	require("act_initShare.pl");
	require("dsp_share.pl");
}