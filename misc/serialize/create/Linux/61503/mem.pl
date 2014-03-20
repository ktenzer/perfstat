#!/usr/bin/perl

use lib "/perfstat/dev/1.40/lib";

use Service;
use Metric;
use Graph;

$perfhome = "/perfstat/dev/1.40";

#create new service
$service = Service->new(	operatingSystem	=> "Linux",
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
					friendlyName =>"Memory Pages Out",
					hasEvents => 1,
					warnThreshold => 25,
					critThreshold => 50,
					thresholdUnit => "KB",
					);
$service->addMetric($obj);

#add metric 2
$obj = Metric->new(	rrdIndex => 2,
					metricName => "mem_pct",
					friendlyName => "Memory Used",
					hasEvents => 1,
					warnThreshold => 80,
					critThreshold => 90,
					thresholdUnit => "percent",
					);
$service->addMetric($obj);

#add metric 3
$obj = Metric->new(	rrdIndex => 3,
					metricName => "shared_kb",
					friendlyName => "Mem Shared Kilobytes",
					hasEvents => 1,
					warnThreshold => 100000,
					critThreshold => 250000,
					thresholdUnit => "KB",
					);
$service->addMetric($obj);

#add metric 4
$obj = Metric->new(	rrdIndex => 4,
					metricName => "buffers_kb",
					friendlyName => "Mem Buffers Kilobytes",
					hasEvents => 1,
					warnThreshold => 100000,
					critThreshold => 250000,
					thresholdUnit => "KB",
					);
$service->addMetric($obj);

#add metric 5
$obj = Metric->new(	rrdIndex => 5,
					metricName => "cached_kb",
					friendlyName => "Mem Cached Kilobytes",
					hasEvents => 1,
					warnThreshold => 50000,
					critThreshold => 100000,
					thresholdUnit => "KB",
					);
$service->addMetric($obj);

#add metric 6
$obj = Metric->new(	rrdIndex => 6,
					metricName => "swap_pct",
					friendlyName => "Mem Swap Used",
					hasEvents => 1,
					warnThreshold => 50,
					critThreshold => 75,
					thresholdUnit => "percent",
					);
$service->addMetric($obj);

#add graph 0
$obj = Graph->new(	name   => "usage",
					title   => "Memory usage on",
					y_axis  => "MB",
					legend  => "",
					optionsArray => [],
					defArray => [q{DEF:mem_pct=$RRD:mem_pct:AVERAGE},q{DEF:swap_pct=$RRD:swap_pct:AVERAGE}],
					cdefArray => [],
					lineArray => [qq{LINE2:mem_pct#FF0000:mem_pct},qq{LINE2:swap_pct#0000ff:swap_pct}],
					text    => "",
					);
$service->addGraph($obj);

#add graph 1
$obj = Graph->new(	name => "paging",
					title   => "Paging Activity on",
					y_axis  => "KB",
					legend  => "",
					optionsArray => [qq{-u 100},qq{-r}],,
					defArray => [q{DEF:page_in=$RRD:page_in:AVERAGE},q{DEF:page_out=$RRD:page_out:AVERAGE}],
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
