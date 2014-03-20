#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $adminName $templateName $hostList $hostListLen $queryString);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "insertHosts")
{
	require("act_insertHosts.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "removeHost")
{
	require("act_removeHost.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "applyTemplate2Hosts")
{
	require("act_applyTemplate2Hosts.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "displayApplied")
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_applied.html");}
	require("act_initApplied.pl");
	require("dsp_applied.pl");
}
else #default action is display frame
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_apply.html");}
	require("act_initApply.pl");
	require("dsp_apply.pl");
}