#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "..");
	require("app_globals.pl");
}
use Storable qw(lock_retrieve);
use User;
use GroupPolicy;
use vars qw($userErrorMessage $userName $password);

my $action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "doLogin") 
{
	$userName = defined($request->param('userName')) ? $request->param('userName') : "";
	$password = defined($request->param('password')) ? $request->param('password') : "";
	require("act_doLogin.pl");
}
elsif ($action eq "doLogoff") 
{
	$sessionObj->param("isLoggedIn", "0");
	$userErrorMessage = "";
	$userName = "";
	$password = "";
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_login.html");}
	require("dsp_login.pl");
}
else #default action is display login screen
{
	$userErrorMessage = "";
	$userName = "";
	$password = "";
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_login.html");}
	require("dsp_login.pl");
}