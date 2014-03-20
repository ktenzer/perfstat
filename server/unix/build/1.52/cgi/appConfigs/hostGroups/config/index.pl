#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $adminName $userName $hgName $hgNewName $description $hostListLen $hostHash $hostGroupMemberArray $selectName $queryString);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "updateHostGroup")
{
	require("act_updateHostGroup.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "insertHost")
{
	require("act_insertHost.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "removeHost")
{
	require("act_removeHost.pl");
	metaRedirect(0, "index.pl?$queryString");
}
else #default action is display frame
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_config.html");}
	require("act_initConfig.pl");
	require("dsp_config.pl");
}