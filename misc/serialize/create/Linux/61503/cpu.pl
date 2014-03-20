#!/usr/bin/perl

use lib "/perfstat/dev/1.40/lib";

use Service;
use Metric;
use Graph;

$perfhome = "/perfstat/dev/1.40";

#add create new service
$service = Service->new(	operatingSystem	=> "Linux",
							serviceName 	=> "cpu",
						);

#add metric 0
$obj = Metric->new(	rrdIndex => 0,
					metricName => "usr_pct",
					friendlyName => "CPU Load:User",
					hasEvents => 1,
					warnThreshold => 75,
					critThreshold => 90,
					thresholdUnit => "percent",
					);
$service->addMetric($obj);

#add metric 1
$obj = Metric->new(	rrdIndex => 1,
					metricName => "sys_pct",
					friendlyName => "CPU Load:System",
					hasEvents => 1,
					warnThreshold => 75,
					critThreshold => 90,
					thresholdUnit => "percent",
					);
$service->addMetric($obj);

#add metric 2
$obj = Metric->new(	rrdIndex => 2,
					metricName => "idl_pct",
					friendlyName => "CPU Load:Idle",
					hasEvents => 0,
					warnThreshold => 0,
					critThreshold => 0,
					thresholdUnit => "percent",
					);
$service->addMetric($obj);

#add metric 3
$obj = Metric->new(	rrdIndex => 3,
					metricName => "load_1",
					friendlyName => "CPU Load:1 Minute",
					hasEvents => 1,
					warnThreshold => 3,
					critThreshold => 5,
					thresholdUnit => "integer",
					);
$service->addMetric($obj);

#add metric 4
$obj = Metric->new(	rrdIndex => 4,
					metricName => "load_5",
					friendlyName => "CPU Load:5 Minute",
					hasEvents => 1,
					warnThreshold => 3,
					critThreshold => 5,
					thresholdUnit => "integer",
					);
$service->addMetric($obj);

#add metric 5
$obj = Metric->new(	rrdIndex => 5,
					metricName => "load_15",
					friendlyName => "CPU Load:15 Minute",
					hasEvents => 1,
					warnThreshold => 3,
					critThreshold => 5,
					thresholdUnit => "integer",
					);
$service->addMetric($obj);

#add graph 0
$obj = Graph->new(	name   => "load",
					title   => "load average on",
					y_axis  => "Number",
					legend  => "",
					optionsArray => [qq{-u 1.0}],
					defArray => [q{DEF:load_1=$RRD:load_1:AVERAGE},q{DEF:load_5=$RRD:load_5:AVERAGE},q{DEF:load_15=$RRD:load_15:AVERAGE}],
					cdefArray => [],
					lineArray => [qq{LINE2:load_1#FF0000:1 Min Load},qq{LINE2:load_5#FFFF00:5 Min Load},qq{LINE2:load_15#00CC00:15 Min Load}],
					text    => "",
					);
$service->addGraph($obj);

#add graph 1
$obj = Graph->new(	name => "usage",
					title   => "CPU usage on",
					y_axis  => "Number",
					legend  => "",
					optionsArray => [qq{-u 100},qq{-r}],,
					defArray => [q{DEF:idl_pct=$RRD:idl_pct:AVERAGE},q{DEF:usr_pct=$RRD:usr_pct:AVERAGE},q{DEF:sys_pct=$RRD:sys_pct:AVERAGE}],
					cdefArray => [],
					lineArray => [qq{AREA:sys_pct#FF0000:System},qq{STACK:usr_pct#FFFF00:User},qq{STACK:idl_pct#00FF00:Idle}],
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
}

#Store the service
$service->store("$perfhome/etc/configs/$service->{operatingSystem}/$service->{serviceName}.ser") or die("can't store $service->{serviceName}.ser?\n");
