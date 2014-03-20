#!/usr/bin/perl -w

use strict;

BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $adminName $userName $hgName $description $myHostGroupArray $sharedHostGroupArray $hgName $hgNewName $description $queryString);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "insertHostGroup")
{
	require("act_insertHostGroup.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "deleteHostGroup")
{
	require("act_deleteHostGroup.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "removeSharedHostGroup")
{
	require("act_removeSharedHostGroup.pl");
	metaRedirect(0, "index.pl?$queryString");
}
else #default action is display level1
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_level1.html");}
	require("act_initLevel1.pl");
	require("dsp_level1.pl");
}