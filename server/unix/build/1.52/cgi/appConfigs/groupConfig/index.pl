#!/usr/bin/perl -w

use strict;
BEGIN
{
	unshift(@INC, "../..");
	require("app_globals.pl");
}

use Storable qw(lock_retrieve lock_store);
use User;

use vars qw($action $adminName $queryString);

my $request = new CGI;
my $action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "updateNavBarWidth")
{
	require("act_updateNavBarWidth.pl");
	my $queryString = "navBarWidth=" . $request->param('navBarWidth');
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "updateTimeoutInterval") 
{
	require("act_updateTimeoutInterval.pl");
	my $queryString = "timeoutInterval=" . $request->param('timeoutInterval');
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "updateStatusRefreshInterval") 
{
	require("act_updateStatusRefreshInterval.pl");
	my $queryString = "statusRefreshInterval=" . $request->param('statusRefreshInterval');
	metaRedirect(0, "index.pl?$queryString");
}
else #default action is display frame
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_home.html");}
	use vars qw($navBarWidth $navBarTextLength $timeoutInterval $statusRefreshInterval);
	require("act_initDisplayHome.pl");
	require("dsp_home.pl");
}