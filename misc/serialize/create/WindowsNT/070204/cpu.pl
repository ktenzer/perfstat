#!/usr/bin/perl

require "/perfstat/build/serialize/create/ServiceConfig.pl";

#add create new service
$service = Service->new(	RRA => "RRA:AVERAGE:0.5:1:288 RRA:AVERAGE:0.5:7:288 RRA:AVERAGE:0.5:30:288 RRA:AVERAGE:0.5:365:288",	
							rrdStep => "300",
							serviceName 	=> "cpu",
							);

#add metric 0
$obj = Metric->new(	rrdIndex => 0,
					metricName => "usrPct",
					friendlyName => "User % Utilization",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					warnThreshold => 75,
					critThreshold => 90,
					thresholdUnit => "Percent",
                                        lowThreshold => "0",
                                        highThreshold => "100",
					);
$service->addMetric($obj);

#add metric 1
$obj = Metric->new(	rrdIndex => 1,
					metricName => "sysPct",
					friendlyName => "System % Utilization",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					warnThreshold => 75,
					critThreshold => 90,
					thresholdUnit => "Percent",
                                        lowThreshold => "0",
                                        highThreshold => "100",
					);
$service->addMetric($obj);

#add metric 2
$obj = Metric->new(	rrdIndex => 2,
					metricName => "idlPct",
					friendlyName => "Idle % Utilization",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => -1,
					warnThreshold => 75,
					critThreshold => 90,
					thresholdUnit => "Percent",
                                        lowThreshold => "0",
                                        highThreshold => "100",
					);
$service->addMetric($obj);

#add metric r32
$obj = Metric->new(	rrdIndex => 3,
					metricName => "queueLength",
					friendlyName => "Queue Length",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					warnThreshold => 3,
					critThreshold => 4,
					thresholdUnit => "Number",
                                        lowThreshold => "0",
                                        highThreshold => "1000",
					);
$service->addMetric($obj);

#add graph 0
$obj = Graph->new(      name => "cpuLoad",
                                        title           => "Queue Length",
                                        comment         => "",
                                        imageFormat     => "png",
                                        width           => "500",
                                        height          => "120",
                                        verticalLabel   => "Queue Length",
                                        upperLimit      => "",
                                        lowerLimit      => "",
                                        rigid           => "",
                                        base            => "1000",
                                        unitsExponent   => "0",
                                        noMinorGrids    => "",
                                        stepValue       => "",
                                        gprintFormat    => "%8.2lf",
                                        metricIndexHash => {},
                                        metricArray     => [],
                                        );

$obj2 = GraphMetric->new(       name => "queueLength",
                                                color           => "#FFFF00",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                );
$obj->addGraphMetric("queueLength", $obj2);

$service->addGraph("cpuLoad", $obj);

#add graph 1
$obj = Graph->new(      name => "cpuUtilization",
                                        title           => "CPU Utilization",
                                        comment         => "",
                                        imageFormat     => "png",
                                        width           => "500",
                                        height          => "120",
                                        verticalLabel   => "Percent",
                                        upperLimit      => "100",
                                        lowerLimit      => "",
                                        rigid           => "Y",
                                        base            => "1000",
                                        unitsExponent   => "0",
                                        noMinorGrids    => "",
                                        stepValue       => "",
                                        gprintFormat    => "%8.2lf",
                                        metricIndexHash => {},
                                        metricArray     => [],
                                        );

$obj2 = GraphMetric->new(       name => "usrPct",
                                                color           => "#FFFF00",
                                                lineType        => "AREA",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                );
$obj->addGraphMetric("usrPct", $obj2);

$obj2 = GraphMetric->new(       name => "sysPct",
                                                color           => "#FF0000",
                                                lineType        => "STACK",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                );
$obj->addGraphMetric("sysPct", $obj2);

$obj2 = GraphMetric->new(       name => "idlPct",
                                                color           => "#32CD32",
                                                lineType        => "STACK",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                );
$obj->addGraphMetric("idlPct", $obj2);

$service->addGraph("cpuUtilization", $obj);

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
	print ("warnThreshold: $warnThreshold\n");
	print ("critThreshold: $critThreshold\n");
	print ("threshUnit: $thresholdUnit\n");
        print ("lowThreshold: $lowThreshold\n");
        print ("highThreshold: $highThreshold\n");
}

#print out this services graphs
$graph = $service->{graphHash};
foreach my $key (keys %{$graph})
{
        $graphObject = $service->{graphHash}->{$key};

        $name = $graphObject->getName();
        $title = $graphObject->getTitle();
        $comment = $graphObject->getComment();
        $imageFormat = $graphObject->getImageFormat();
        $width = $graphObject->getWidth();
        $height = $graphObject->getHeight();
        $verticalLabel = $graphObject->getVerticalLabel();
        $upperLimit = $graphObject->getUpperLimit();
        $lowerLimit = $graphObject->getLowerLimit();
        $rigid = $graphObject->getRigid();
        $base = $graphObject->getBase();
        $unitsExponent = $graphObject->getUnitsExponent();
        $noMinorGrids = $graphObject->getNoMinorGrids();
        $stepValue = $graphObject->getStepValue();
        $gprintFormat = $graphObject->getGprintFormat();
        print ("name: $name\n");
        print ("title: $title\n");
        print ("comment: $comment\n");
        print ("image format: $imageFormat\n");
        print ("width: $width\n");
        print ("height: $height\n");
        print ("vertical label: $verticalLabel\n");
        print ("upper limit: $upperLimit\n");
        print ("lower limit: $lowerLimit\n");
        print ("rigid: $rigid\n");
        print ("base: $base\n");
        print ("units exponent: $unitsExponent\n");
        print ("no minor grids: $noMinorGrids\n");
        print ("step value: $stepValue\n");
        print ("gprint format: $gprintFormat\n");
        print "\n";

        # Via MetricArray
        foreach my $key (@{$graphObject->{metricArray}}) {
                my $metricName = $key->getName();
                my $color = $key->{color};
                my $lineType = $key->getLineType();
                my $cDefinition = $key->getCdefinition();

                print "Graph Metric Name: $metricName\n";
                print "Color: $color\n";
                print "Line Type: $lineType\n";
                print "GPRINT : @{$key->{gprintArray}}\n";
                print "CDEF: $cDefinition\n";
                print "\n";
        }
}

#Store the service
$service->store("$perfhome/etc/configs/WinNT/$service->{serviceName}.ser") or die("can't store $service->{serviceName}.ser?\n");
