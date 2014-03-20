package main;
use strict;
use vars qw($perfhome $doParse $claimedSessionID $sessionObj $doStoreSessionObject $request $hostIndex $userIndex $osList);
BEGIN
{
	$perfhome = "/perfstat/dev/1.52/server";
}
use CGI;
use CGI qw (:standard);
use CGI::Carp qw(carpout fatalsToBrowser warningsToBrowser);
# use CGI::Carp qw(carpout);
use CGI::Cookie;
use IO::File;
use Storable qw(lock_retrieve lock_store);

# Perfstat Objects
use lib "$perfhome/lib";
use lib "$perfhome/cgi/appLib/modules";
use User;
use AlertTemplate;
use NotifyRules;
use MetricTemplate;
use Report;
use HostGroup;
use Host;
use Service;
use Metric;
use Graph;
use GraphMetric;

#PerfStat CGI lib
use Perfstat::Parser;
use Perfstat::Session;
use Perfstat::Utilities1;
use Perfstat::Utilities2;

# Set umask
umask(0007);

# Send error messages to log file
my $cgiLog = new IO::File;
$cgiLog->open(">>$perfhome/var/logs/cgi.log") || die("Unable to open cgi.log: $!\n");
carpout($cgiLog);

# GLOBALS
# $doParse:
# Parse html to perl file before requiring the perl file.
# Needed when developing or editing the HTML content with inline Perl
$doParse = 1;

# Session Management
$doStoreSessionObject = 1;

# Get the http request
$request = new CGI;

# Get the perfstatID cookie
my %cookies = fetch CGI::Cookie;

if (defined($cookies{'perfstatID'})) {
	$claimedSessionID = $cookies{'perfstatID'}->value;
}

if (!defined($cookies{'perfstatID'}) || !defined($claimedSessionID)) {
	# no perfstat cookie exists OR no cookie claimedSessionID exists (bad cookie)
	$sessionObj = new PerfStatCGI::Session(undef, undef, {Directory=>"$perfhome/var/sessions"});
	my $newSessionID = $sessionObj->id();
	$sessionObj->store();
	$doStoreSessionObject = 0;
	my $cookie = new CGI::Cookie(	-name => "perfstatID",
								-value   =>  "$newSessionID",
								-expires =>  "+1y");

	if ($ENV{SCRIPT_NAME} ne "/perfstat/login/index.pl") {
		my $perfstatLogin = "http://$ENV{SERVER_NAME}/perfstat/login/index.pl";
		print $request->header(	-status => "302 (Found) Moved Temporarily",
							-cookie => $cookie,
							-location => $perfstatLogin,
							-type => "text/html");
		CGI::Carp->warningsToBrowser(1);
	} else {
		print $request->header(-cookie => $cookie);
		CGI::Carp->warningsToBrowser(1);
	}
} else {
	#perfstat cookie exist and claimedSessionID exists
	$sessionObj = new PerfStatCGI::Session(undef, $claimedSessionID, {Directory=>"$perfhome/var/sessions"});
	my $newSessionID = $sessionObj->id();
	my $isLoggedIn = $sessionObj->param("isLoggedIn");

	if ($newSessionID ne $claimedSessionID) {
	# claimedSessionID was corrupt or session was expired
		#Reset Session
		$sessionObj->store();
		$doStoreSessionObject = 0;
		my $cookie = new CGI::Cookie(	-name => "perfstatID",
									-value   =>  "$newSessionID",
									-expires =>  "+1y");

		if ($ENV{SCRIPT_NAME} ne "/perfstat/login/index.pl") {
			my $perfstatLogin = "http://$ENV{SERVER_NAME}/perfstat/login/index.pl";
			print $request->header(	-status => "302 (Found) Moved Temporarily",
								-cookie => $cookie,
								-location => $perfstatLogin,
								-type => "text/html");
			CGI::Carp->warningsToBrowser(1);
		} else {
			print $request->header(	-cookie => $cookie );
			CGI::Carp->warningsToBrowser(1);
		}
	} elsif (!(defined($isLoggedIn)) || $isLoggedIn != 1)  {
	# cookie claimedSessionID is not logged in
		$doStoreSessionObject = 0;
		if ($ENV{SCRIPT_NAME} ne "/perfstat/login/index.pl") {
			my $perfstatLogin = "http://$ENV{SERVER_NAME}/perfstat/login/index.pl";
			print $request->redirect($perfstatLogin);
			CGI::Carp->warningsToBrowser(1);
		} else {
			print $request->header();
			CGI::Carp->warningsToBrowser(1);
		}
	} else {
	# cookie claimedSessionID is OK and session is loggedIn
		if ($ENV{SCRIPT_NAME} ne "/perfstat/appLib/graphs/hostGraphs/singleServiceGraphs/drawLineGraph/index.pl"
		&&
		$ENV{SCRIPT_NAME} ne "/perfstat/appLib/graphs/hostGraphs/singleServiceGraphs/drawGDGraph/index.pl"
		&&
		$ENV{SCRIPT_NAME} ne "/perfstat/appLib/graphs/hostGraphs/multiServiceGraphs/drawLineGraph/index.pl"
		&&
		$ENV{SCRIPT_NAME} ne "/perfstat/appLib/graphs/hostGraphs/multiServiceGraphs/drawGDGraph/index.pl"
		&&
		$ENV{SCRIPT_NAME} ne "/perfstat/appLib/graphs/hostgroupGraphs/singleServiceGraphs/drawGDGraph/index.pl")		
		{
			print $request->header();
			CGI::Carp->warningsToBrowser(1);
		}
	}
}

END
{
	if (defined($sessionObj) && $doStoreSessionObject == 1) {
		$sessionObj->store();
	}
}

1;
