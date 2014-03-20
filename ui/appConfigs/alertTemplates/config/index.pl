#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $adminName $templateName $editFlag $notifyRulesArrayLength $notifyRulesArray $notifyRule $queryString);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "add")
{
	require("act_addNotifyRule.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "edit")
{
	require("act_editNotifyRule.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "delete")
{
	require("act_deleteNotifyRule.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "deleteAll")
{
	require("act_deleteAllRules.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "moveDown")
{
	require("act_moveDown.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "moveUp")
{
	require("act_moveUp.pl");
	metaRedirect(0, "index.pl?$queryString");
}
else #default action is display frame
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_configTemplate.html");}
	require("act_initConfigTemplate.pl");
	require("dsp_configTemplate.pl");
}