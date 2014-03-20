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
	require("act_addRule.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "edit")
{
	require("act_editRule.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "delete")
{
	require("act_deleteRule.pl");
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
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_list.html");}
	require("act_initList.pl");
	require("dsp_list.pl");
}