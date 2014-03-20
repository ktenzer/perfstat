#!/usr/bin/perl -w
use strict;

BEGIN
{
	unshift(@INC, "../../..");
	require("app_globals.pl");
}

use vars qw($action $queryString $adminName $userName $updateNav $displayMode $contentType
			$contentArrayLen $contentDisplayArray
			$reportNameID $reportName $description
			$cpu $memory $os
			$graphInterval $graphType $hostGroupArray $selectHostGroups $graphArray $selectGraphs 
			$hostGroupID $hostArray $selectHosts $serviceArray $selectServices $subServiceArray $selectSubServices
			$eventInterval $osName $graphServiceType
			$reportObject $editHeaderText $contentID $textComment
			);
$request = new CGI;
$action = defined($request->param('action')) ? $request->param('action') : "";

if ($action eq "editReport")
{
	require("act_updateReportDescriptors.pl");
}
elsif ($action eq "insertTextComment")
{
	require("act_insertTextComment.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "editTextComment")
{
	require("act_updateTextComment.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "insertHostGroupGraphs")
{
	require("act_insertHostGroupGraphs.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "editHostGroupGraphs")
{
	require("act_updateHostGroupGraph.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "insertHostAssets")
{
	require("act_insertHostAssets.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "updateHostAssets")
{
	require("act_updateHostAssets.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "insertHostEvents")
{
	require("act_insertHostEvents.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "updateHostEvents")
{
	require("act_updateHostEvents.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "insertHostGraphs")
{
	require("act_insertHostGraphs.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "updateHostGraph")
{
	require("act_updateHostGraph.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "deleteAllContent")
{
	require("act_deleteAllContent.pl");
	metaRedirect(0, "index.pl?$queryString");
}
elsif ($action eq "deleteContent")
{
	require("act_deleteContent.pl");
	metaRedirect(0, "index.pl?$queryString");
}
else #default action is display frame
{
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_selectTextComment.html");}
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_selectHostGroupGraphs.html");}
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_selectHostAssets.html");}
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_selectHostEvents.html");}
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_selectHostGraphs.html");}
	
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_editTextComment.html");}
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_editHostGroupGraphs.html");}
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_editHostAssets.html");}
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_editHostEvents.html");}
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_editHostGraphs.html");}
	
	if ($doParse) {PerfStatCGI::Parser->html2Perl("dsp_editReport.html");}
	
	require("act_initDisplayEditReport.pl");
	require("dsp_editReport.pl");
}
