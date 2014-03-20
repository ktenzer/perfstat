#!/usr/bin/perl -w

use strict;
BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use Storable qw(lock_retrieve lock_store);
use User;

use vars qw($action $navHeaderText $adminName $updateUserName $updateUserRole $updateUserShowAllHosts $password $confirmPassword  $queryString);

my $request = new CGI;
my $action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "updateUserPassword")
{
	require("act_updateUserPassword.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "updateShowAllHosts") 
{
	require("act_updateShowAllHosts.pl");
	metaRedirect(0, "index.pl?$queryString");
}
else #default action is display frame
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_level2.html");}
	require("act_initLevel2.pl");
	require("dsp_level2.pl");
}