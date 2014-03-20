#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $adminName $adminList $hostArray $lenHostArray
				$newHostName $newipAddress $newosName $editFlag $hostName $editName $editipAddress 
				$queryString);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "add")
{
	require("act_add.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "edit")
{
	require("act_edit.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "delete")
{
	require("act_delete.pl");
	metaRedirect(0, "index.pl?$queryString");
}
else #default action is display frame
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_list.html");}
	require("act_initDisplayList.pl");
	require("dsp_list.pl");
}