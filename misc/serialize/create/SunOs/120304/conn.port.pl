#!/usr/bin/perl


require "/perfstat/build/serialize/create/ServiceConfig.pl";

#add create new service
$service = Service->new(	serviceName => "conn",
							);

#add metric 0
$obj = Metric->new(	rrdIndex => 0,
					metricName => "http",
					friendlyName => "Web Server",
					status => "nostatus",
					servicePort => "80",
					hasEvents => 1,
					);
$service->addMetric($obj);

#print out this service
print ("Ref: ref($service)\n");
$serviceName = $service->getServiceName();
$lastUpdate = $service->getLastUpdate();
print ("serviceName: $serviceName\n");
print ("Last Update: $lastUpdate\n");

#print out this services metrics
$arrayLength = $service->getMetricArrayLength();
print ("metric Array Length = $arrayLength\n\n");

for ($counter=0; $counter < $arrayLength; $counter++)
{
	$metricObject = $service->{metricArray}->[$counter];

	$rrdIndex = $metricObject->getRRDIndex();
	$metricName = $metricObject->getMetricName();
	$friendlyName = $metricObject->getFriendlyName();
	$status = $metricObject->getStatus();
	$hasEvents = $metricObject->getHasEvents();
	$servicePort = $metricObject->getServicePort();

	print ("metricName: $metricName\n");
	print ("friendlyName: $friendlyName\n");
	print ("status: $status\n");
	print ("hasEvents: $hasEvents\n");
	print ("servicePort: $servicePort\n");
}

#Store the service
$service->store("$perfhome/etc/configs/SunOs/conn.port.ser") or die("can't store $service->conn.port.ser?\n");
