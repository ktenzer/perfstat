#!/usr/bin/perl -w
use strict;
BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $queryString $date $user $description $changeLogArray $changeLogIndexLen);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "insertItem")
{
	require("act_insertItem.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "updateItem")
{
	if ($request->param("submit") eq "CLEAR")
	{
		if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_changeLog.html");}
		$request->delete('itemID');
		$request->delete('time');
		$request->delete('user');
		$request->delete('description');
		require("act_initChangeLog.pl");
		require("dsp_changeLog.pl");
	}
	else
	{
		require("act_updateItem.pl");
		metaRedirect(0, "index.pl?$queryString");
	}
}
elsif ($action eq "deleteItem")
{
	require("act_deleteItem.pl");
	metaRedirect(0, "index.pl?$queryString");
}
else #default action
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_changeLog.html");}
	require("act_initChangeLog.pl");
	require("dsp_changeLog.pl");
}