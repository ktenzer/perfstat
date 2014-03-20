#!/usr/local/ActivePerl-5.8/bin/perl
require "../ServiceConfig.pl";

#add create new service
$service = Service->new(	RRA => "RRA:AVERAGE:0.5:1:1728 RRA:AVERAGE:0.5:6:1296 RRA:AVERAGE:0.5:24:996 RRA:AVERAGE:0.5:144:730",	
							rrdStep => "300",
							serviceName => "cpu"
						);

#add metric 0
$obj = Metric->new(	rrdIndex => 0,
					metricName => "usr",
					friendlyName => "User % Utilization",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					metricValue => "null",
					warnThreshold => 75,
					critThreshold => 90,
					thresholdUnit => "Percent",
					lowThreshold => "0",
					highThreshold => "100",
					);
$service->addMetric($obj);

#add metric 1
$obj = Metric->new(	rrdIndex => 1,
					metricName => "sys",
					friendlyName => "System % Utilization",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					metricValue => "null",
					warnThreshold => 75,
					critThreshold => 90,
					thresholdUnit => "Percent",
					lowThreshold => "0",
					highThreshold => "100",
					);
$service->addMetric($obj);

#add metric 2
$obj = Metric->new(	rrdIndex => 2,
					metricName => "idl",
					friendlyName => "Idle % Utilization",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => -1,
					metricValue => "null",
					warnThreshold => 75,
					critThreshold => 90,
					thresholdUnit => "Percent",
					lowThreshold => "0",
					highThreshold => "100",
					);
$service->addMetric($obj);

#add metric 3
$obj = Metric->new(	rrdIndex => 3,
					metricName => "load1",
					friendlyName => "Load Average (1 Minute)",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					metricValue => "null",
					warnThreshold => 3,
					critThreshold => 5,
					thresholdUnit => "Number",
					lowThreshold => "0",
					highThreshold => "1000",
					);
$service->addMetric($obj);

#add metric 4
$obj = Metric->new(	rrdIndex => 4,
					metricName => "load5",
					friendlyName => "Load Average (5 Minute)",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					metricValue => "null",
					warnThreshold => 3,
					critThreshold => 5,
					thresholdUnit => "Number",
					lowThreshold => "0",
					highThreshold => "1000",
					);
$service->addMetric($obj);

#add metric 5
$obj = Metric->new(	rrdIndex => 5,
					metricName => "load15",
					friendlyName => "Load Average (15 Minute)",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					metricValue => "null",
					warnThreshold => 3,
					critThreshold => 5,
					thresholdUnit => "Number",
					lowThreshold => "0",
					highThreshold => "1000",
					);
$service->addMetric($obj);

#print out this service
print ("Ref: ref($service)\n");

$serviceName = $service->getServiceName();
$RRA = $service->getRRA();
$rrdStep = $service->getRRDStep();
$lastUpdate = $service->getLastUpdate();
print ("serviceName: $serviceName\n");
print ("RRA: $RRA\n");
print ("rrdStep: $rrdStep\n");
print ("Last Update: $lastUpdate\n");

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
	$status = $metricObject->getStatus();
	$hasEvents = $metricObject->getHasEvents();
	$metricValue = $metricObject->getMetricValue();
	$warnThreshold = $metricObject->getWarnThreshold();
	$critThreshold = $metricObject->getCritThreshold();
	$thresholdUnit	= $metricObject->getThresholdUnit();
	$lowThreshold = $metricObject->getLowThreshold();
	$highThreshold = $metricObject->getHighThreshold();

	print ("rrdIndex: $rrdIndex\n");
	print ("rrdDST: $rrdDST\n");
	print ("rrdHeartbeat: $rrdHeartbeat\n");
	print ("rrdMin: $rrdMin\n");
	print ("rrdMax: $rrdMax\n");
	print ("metricName: $metricName\n");
	print ("friendlyName: $friendlyName\n");
	print ("status: $status\n");
	print ("hasEvents: $hasEvents\n");
	print ("metricValue: $metricValue\n");
	print ("warnThreshold: $warnThreshold\n");
	print ("critThreshold: $critThreshold\n");
	print ("threshUnit: $thresholdUnit\n\n");
	print ("lowThreshold: $lowThreshold\n");
	print ("highThreshold: $highThreshold\n");
}

#Store the service
$service->store("$perfhome/etc/configs/Linux/$service->{serviceName}.ser") or die("can't store $service->{serviceName}.ser\n");
