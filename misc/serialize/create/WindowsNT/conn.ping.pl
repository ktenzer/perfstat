#!/usr/local/ActivePerl-5.8/bin/perl
require "../ServiceConfig.pl";

#add create new service
$service = Service->new(	serviceName => "conn");

#add metric 0
$obj = Metric->new(	rrdIndex => 0,
					metricName => "ping",
					friendlyName => "Host Ping",
					status => "nostatus",
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

	print ("metricName: $metricName\n");
	print ("friendlyName: $friendlyName\n");
	print ("status: $status\n");
	print ("hasEvents: $hasEvents\n");
}

#Store the service
$service->store("$perfhome/etc/configs/WindowsNT/conn.ping.ser") or die("can't store $service->conn.ping.ser?\n");
