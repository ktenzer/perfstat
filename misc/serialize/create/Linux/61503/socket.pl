#!/usr/bin/perl

use lib "/perfstat/dev/1.40/lib";

use Service;
use Metric;
use Graph;

$perfhome = "/perfstat/dev/1.40";

#add create new service
$service = Service->new(	operatingSystem	=> "Linux",
							serviceName 	=> "socket",
						);

#add metric 0
$obj = Metric->new(	rrdIndex => 0,
					metricName => "total",
					friendlyName => "Socket: total",
					hasEvents => 1,
					warnThreshold => 150,
					critThreshold => 300,
					thresholdUnit => "total sockets",
					);
$service->addMetric($obj);

#add metric 1
$obj = Metric->new(	rrdIndex => 1,
					metricName => "in_use",
					friendlyName => "Socket: in use",
					hasEvents => 1,
					warnThreshold => 100,
					critThreshold => 200,
					thresholdUnit => "total sockets in use",
					);
$service->addMetric($obj);

#add metric 2
$obj = Metric->new(	rrdIndex => 2,
					metricName => "max_sim",
					friendlyName => "Socket: max",
					hasEvents => 1,
					warnThreshold => 100,
					critThreshold => 200,
					thresholdUnit => "socket max sim",
					);
$service->addMetric($obj);

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