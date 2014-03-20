#!/usr/bin/perl -w

use strict;

BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $updateNavCode $adminName $insertAdminName $insertUserName $updateUserName $password $confirmPassword $userRole $adminList $userList $userID $queryString);

$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "insertAdmin")
{
	require("act_insertAdmin.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "deleteAdmin")
{
	require("act_deleteAdmin.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "insertUser")
{
	require("act_insertUser.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "deleteUser")
{
	require("act_deleteUser.pl");
	metaRedirect(0, "index.pl?$queryString");
}
else
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_level1.html");}
	require("act_initLevel1.pl");
}