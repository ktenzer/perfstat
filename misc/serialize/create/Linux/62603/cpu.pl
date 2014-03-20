#!/usr/bin/perl

use lib "/perfstat/dev/1.40/lib";

use Service;
use Metric;
use Graph;

$perfhome = "/perfstat/dev/1.40";

#add create new service
$service = Service->new(	 RRA => "RRA:AVERAGE:0.5:1:288 RRA:AVERAGE:0.5:7:288 RRA:AVERAGE:0.5:30:288 RRA:AVERAGE:0.5:365:288",	
					operatingSystem	=> "Linux",
						serviceName 	=> "cpu",
						);

#add metric 0
$obj = Metric->new(	rrdIndex => 0,
					metricName => "usrPct",
					friendlyName => "User % Utilization",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					warnThreshold => 75,
					critThreshold => 90,
					thresholdUnit => "Percent",
					);
$service->addMetric($obj);

#add metric 1
$obj = Metric->new(	rrdIndex => 1,
					metricName => "sysPct",
					friendlyName => "System % Utilization",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					warnThreshold => 75,
					critThreshold => 90,
					thresholdUnit => "Percent",
					);
$service->addMetric($obj);

#add metric 2
$obj = Metric->new(	rrdIndex => 2,
					metricName => "idlePct",
					friendlyName => "Idle % Utilization",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					warnThreshold => 75,
					critThreshold => 90,
					thresholdUnit => "Percent",
					);
$service->addMetric($obj);

#add metric 3
$obj = Metric->new(	rrdIndex => 3,
					metricName => "load1",
					friendlyName => "Load Average (1 Minute)",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					warnThreshold => 3,
					critThreshold => 5,
					thresholdUnit => "Number",
					);
$service->addMetric($obj);

#add metric 4
$obj = Metric->new(	rrdIndex => 4,
					metricName => "load5",
					friendlyName => "Load Average (5 Minute)",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					warnThreshold => 3,
					critThreshold => 5,
					thresholdUnit => "Number",
					);
$service->addMetric($obj);

#add metric 5
$obj = Metric->new(	rrdIndex => 5,
					metricName => "load15",
					friendlyName => "Load Average (15 Minute)",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					warnThreshold => 3,
					critThreshold => 5,
					thresholdUnit => "Number",
					);
$service->addMetric($obj);

#add graph 0
$obj = Graph->new(	name   => "load",
					title   => "load average on",
					y_axis  => "Number",
					legend  => "",
					optionsArray => [qq{-u 1.0}],
					defArray => [q{DEF:load1=$RRD:load1:AVERAGE},q{DEF:load5=$RRD:load5:AVERAGE},q{DEF:load15=$RRD:load15:AVERAGE}],
					cdefArray => [],
					lineArray => [qq{LINE2:load1#FF0000:1 Min Load},qq{LINE2:load5#FFFF00:5 Min Load},qq{LINE2:load15#00CC00:15 Min Load}],
					text    => "",
					);
$service->addGraph($obj);

#add graph 1
$obj = Graph->new(	name => "usage",
					title   => "CPU usage on",
					y_axis  => "Number",
					legend  => "",
					optionsArray => [qq{-u 100},qq{-r}],,
					defArray => [q{DEF:idlePct=$RRD:idlePct:AVERAGE},q{DEF:usrPct=$RRD:usrPct:AVERAGE},q{DEF:sysPct=$RRD:sysPct:AVERAGE}],
					cdefArray => [],
					lineArray => [qq{AREA:sysPct#FF0000:System},qq{STACK:usrPct#FFFF00:User},qq{STACK:idlePct#00FF00:Idle}],
					text    => "",
					);
$service->addGraph($obj);

#print out this service
print ("Ref: ref($service)\n");

$os = $service->getOS();
$serviceName = $service->getServiceName();
$RRA = $service->getRRA();
print ("OS: $os\n");
print ("serviceName: $serviceName\n");
print ("RRA: $RRA\n");

#print out this services metrics
$arrayLength = $service->getMetricArrayLength();
print ("metric Array Length = $arrayLength\n\n");

for ($counter=0; $counter < $arrayLength; $counter++)
{
	$metricObject = $service->{metricArray}->[$counter];

	$rrdIndex = $metricObject->getRRDIndex();
        $rrdDST = $metricObject->getRRDDST();
        $rrdHeartbeat = $metricObject->getRRDHeartbeat();
        $rrdMin = $metricObject->getRRDMin();
        $rrdMax = $metricObject->getRRDMax();
	$metricName = $metricObject->getMetricName();
	$friendlyName = $metricObject->getFriendlyName();
	$hasEvents = $metricObject->getHasEvents();
	$warnThreshold = $metricObject->getWarnThreshold();
	$critThreshold = $metricObject->getCritThreshold();
	$thresholdUnit	= $metricObject->getThresholdUnit();

	print ("rrdIndex: $rrdIndex\n");
        print ("rrdDST: $rrdDST\n");
        print ("rrdHeartbeat: $rrdHeartbeat\n");
        print ("rrdMin: $rrdMin\n");
        print ("rrdMax: $rrdMax\n");
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
