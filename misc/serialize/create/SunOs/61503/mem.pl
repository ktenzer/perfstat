#!/usr/bin/perl

use lib "/usr/local/perf-dev/storable/lib";

use Service;
use Metric;
use Graph;

$perfhome = "/usr/local/perf-dev/storable";

#create new service
$service = Service->new(	operatingSystem	=> "SunOS",
							serviceName 	=> "mem",
						);

#add metric 0
$obj = Metric->new(	rrdIndex => 0,
					metricName => "page_in",
					friendlyName => "Memory Pages In",
					hasEvents => 1,
					warnThreshold => 1024,
					critThreshold => 2000,
					thresholdUnit => "KB",
					);
$service->addMetric($obj);

#add metric 1
$obj = Metric->new(	rrdIndex => 1,
					metricName => "page_out",
					friendlyName => "Memory Pages Out",
					hasEvents => 1,
					warnThreshold => 1024,
					critThreshold => 2000,
					thresholdUnit => "KB",
					);
$service->addMetric($obj);

#add metric 2
$obj = Metric->new(	rrdIndex => 2,
					metricName => "page_free",
					friendlyName => "Mem Page Free",
					hasEvents => 0,
					warnThreshold => 0,
					critThreshold => 0,
					thresholdUnit => "?",
					);
$service->addMetric($obj);

#add metric 3
$obj = Metric->new(	rrdIndex => 3,
					metricName => "page_scan",
					friendlyName => "Mem Page Scan",
					hasEvents => 0,
					warnThreshold => 0,
					critThreshold => 0,
					thresholdUnit => "?",
					);
$service->addMetric($obj);

#add metric 4
$obj = Metric->new(	rrdIndex => 4,
					metricName => "page_flt",
					friendlyName => "Mem Page Flt",
					hasEvents => 0,
					warnThreshold => 0,
					critThreshold => 0,
					thresholdUnit => "?",
					);
$service->addMetric($obj);

#add metric 5
$obj = Metric->new(	rrdIndex => 5,
					metricName => "vflt",
					friendlyName => "Mem vflt",
					hasEvents => 0,
					warnThreshold => 0,
					critThreshold => 0,
					thresholdUnit => "?",
					);
$service->addMetric($obj);

#add metric 6
$obj = Metric->new(	rrdIndex => 6,
					metricName => "buffer_read",
					friendlyName => "Mem Buffer Read",
					hasEvents => 0,
					warnThreshold => 0,
					critThreshold => 0,
					thresholdUnit => "?",
					);
$service->addMetric($obj);

#add metric 7
$obj = Metric->new(	rrdIndex => 7,
					metricName => "buffer_write",
					friendlyName => "Mem Buffer Write",
					hasEvents => 0,
					warnThreshold => 0,
					critThreshold => 0,
					thresholdUnit => "?",
					);
$service->addMetric($obj);

#add metric 8
$obj = Metric->new(	rrdIndex => 8,
					metricName => "read_cache_pct",
					friendlyName => "Mem Read Cache Pct",
					hasEvents => 0,
					warnThreshold => 0,
					critThreshold => 0,
					thresholdUnit => "?",
					);
$service->addMetric($obj);

#add metric 9
$obj = Metric->new(	rrdIndex => 9,
					metricName => "write_cache_pct",
					friendlyName => "Mem Write Cache Pct",
					hasEvents => 0,
					warnThreshold => 0,
					critThreshold => 0,
					thresholdUnit => "?",
					);
$service->addMetric($obj);

#add metric 10
$obj = Metric->new(	rrdIndex => 10,
					metricName => "memory_free",
					friendlyName => "Mem Memory Free",
					hasEvents => 0,
					warnThreshold => 0,
					critThreshold => 0,
					thresholdUnit => "?",
					);
$service->addMetric($obj);

#add metric 11
$obj = Metric->new(	rrdIndex => 11,
					metricName => "swap_free",
					friendlyName => "Mem Swap Free",
					hasEvents => 0,
					warnThreshold => 0,
					critThreshold => 0,
					thresholdUnit => "?",
					);
$service->addMetric($obj);

#add graph 0
$obj = Graph->new(	name => "paging",
					title   => "Paging Activity on",
					y_axis  => "KB",
					legend  => "",
					optionsArray => [qq{-u 100},qq{-r}],,
					defArray => [q{DEF:page_in=$RRD:mem_page_in:AVERAGE},q{DEF:page_out=$RRD:mem_page_out:AVERAGE}],
					cdefArray => [],
					lineArray => [qq{LINE2:page_in#FF0000:Pages In},qq{LINE2:page_out#00CC00:Pages Out}],
					text    => "",
					);
$service->addGraph($obj);

#print out this service
print ("Ref: ref($service)\n");

$os = $service->getOS();
$serviceName = $service->getServiceName();
print ("OS: $os\n");
print ("serviceName: $serviceName\n");

#print out this services metrics
$arrayLength = $service->getMetricArrayLength();
print ("metric Array Length = $arrayLength\n\n");

for ($counter=0; $counter < $arrayLength; $counter++)
{
	$metricObject = $service->{metricArray}->[$counter];

	$rrdIndex = $metricObject->getRRDIndex();
	$metricName = $metricObject->getMetricName();
	$friendlyName = $metricObject->getFriendlyName();
	$hasEvents = $metricObject->getHasEvents();
	$warnThreshold = $metricObject->getWarnThreshold();
	$critThreshold = $metricObject->getCritThreshold();
	$thresholdUnit	= $metricObject->getThresholdUnit();

	print ("rrdIndex: $rrdIndex\n");
	print ("metricName: $metricName\n");
	print ("friendlyName: $friendlyName\n");
	print ("hasEvents: $hasEvents\n");
	print ("warnThreshold: $warnThreshold\n");
	print ("critThreshold: $critThreshold\n");
	print ("threshUnit: $thresholdUnit\n\n");
}

#print out this services graphs
$arrayLength = $service->getGraphArrayLength();
print ("graph Array Length = $arrayLength\n\n");

for ($counter=0; $counter < $arrayLength; $counter++)
{
	$graphObject = $service->{graphArray}->[$counter];

	$name = $graphObject->getName();
	$title = $graphObject->getTitle();
	$y_axis = $graphObject->getYaxis();
	$legend = $graphObject->getLegend();
	$text = $graphObject->getText();

	print ("name: $name\n");
	print ("title: $title\n");
	print ("y_axis: $y_axis\n");
	print ("legend: $legend\n");
	print ("text: $text\n");

	$arrayLength2 = $graphObject->getOptionsArrayLength();
	for ($counter2=0; $counter2 < $arrayLength2; $counter2++)
	{
		print ("option: $graphObject->{optionsArray}->[$counter2]\n");
	}
	$arrayLength2 = $graphObject->getDefArrayLength();
	for ($counter2=0; $counter2 < $arrayLength2; $counter2++)
	{
		print ("def: $graphObject->{defArray}->[$counter2]\n");
	}
	$arrayLength2 = $graphObject->getCdefArrayLength();
	for ($counter2=0; $counter2 < $arrayLength2; $counter2++)
	{
		print ("cdef: $graphObject->{cdefArray}->[$counter2]\n");
	}
	$arrayLength2 = $graphObject->getLineArrayLength();
	for ($counter2=0; $counter2 < $arrayLength2; $counter2++)
	{
		print ("line: $graphObject->{lineArray}->[$counter2]\n");
	}
	print ("\n");
}

#Store the service
$service->store("$perfhome/etc/configs/$service->{operatingSystem}/$service->{serviceName}.ser") or die("can't store $service->{serviceName}.ser?\n");
