#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $adminName $adminList $hostArray $lenHostArray $newHostName $ipAddress $osName $queryString);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "insertItem")
{
	require("act_insertHost.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "deleteItem")
{
	require("act_deleteHost.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "clearItem")
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_level1.html");}
	$request->delete('itemID');
	$request->delete('itemName');
	$request->delete('ipAddress');
	$request->delete('osName');
	require("act_initLevel1.pl");
	require("dsp_level1.pl");
}
else #default action is display frame
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_level1.html");}
	require("act_initLevel1.pl");
	require("dsp_level1.pl");
}