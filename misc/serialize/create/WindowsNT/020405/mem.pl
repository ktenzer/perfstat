#!/usr/bin/perl

require "/perfstat/build/serialize/create/ServiceConfig.pl";

#create new service
$service = Service->new(	RRA => "RRA:AVERAGE:0.5:1:288 RRA:AVERAGE:0.5:7:288 RRA:AVERAGE:0.5:30:288 RRA:AVERAGE:0.5:365:288",	
							rrdStep => "300",
							serviceName  => "mem",
							);

#add metric 0
$obj = Metric->new(	rrdIndex => 0,
					metricName => "memUsed",
					friendlyName => "Memory Used",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					metricValue => "null",
					warnThreshold => 90,
					critThreshold => 95,
					thresholdUnit => "Percent",
					lowThreshold => "0",
					highThreshold => "100",
					);
$service->addMetric($obj);

#add metric 1
$obj = Metric->new(	rrdIndex => 1,
					metricName => "memFree",
					friendlyName => "Memory Free",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => -1,
					metricValue => "null",
					warnThreshold => 90,
					critThreshold => 95,
					thresholdUnit => "Percent",
					lowThreshold => "0",
					highThreshold => "100",
					);
$service->addMetric($obj);

#add metric 2
$obj = Metric->new(	rrdIndex => 2,
					metricName => "swapUsed",
					friendlyName => "Swap Used",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					metricValue => "null",
					warnThreshold => 80,
					critThreshold => 90,
					thresholdUnit => "Percent",
					lowThreshold => "0",
					highThreshold => "100",
					);
$service->addMetric($obj);

#add metric 3
$obj = Metric->new(	rrdIndex => 3,
					metricName => "swapFree",
					friendlyName => "Swap Free",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => -1,
					metricValue => "null",
					warnThreshold => 90,
					critThreshold => 95,
					thresholdUnit => "Percent",
					lowThreshold => "0",
					highThreshold => "100",
					);
$service->addMetric($obj);

#add metric 4
$obj = Metric->new(	rrdIndex => 4,
					metricName => "pageIn",
					friendlyName => "Pages In",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					metricValue => "null",
					warnThreshold => 1000,
					critThreshold => 5000,
					thresholdUnit => "KB/Sec",
					lowThreshold => "0",
					highThreshold => "10000",
					);
$service->addMetric($obj);

#add metric 5
$obj = Metric->new(	rrdIndex => 5,
					metricName => "pageOut",
					friendlyName => "Pages Out",
					status => "nostatus",
					rrdDST => GAUGE,
					rrdHeartbeat => 600,
					rrdMin => 0,
					rrdMax => U,
					hasEvents => 1,
					metricValue => "null",
					warnThreshold => 500,
					critThreshold => 1000,
					thresholdUnit => "KB/Sec",
					lowThreshold => "0",
					highThreshold => "10000",
					);
$service->addMetric($obj);

#add graph 0
$obj = Graph->new(      name => "memUtilization",
                                        title           => "Memory Utilization",
                                        comment         => "",
                                        imageFormat     => "png",
                                        width           => "500",
                                        height          => "120",
                                        verticalLabel   => "Percent",
                                        upperLimit      => "100",
                                        lowerLimit      => "0",
                                        rigid           => "Y",
                                        base            => "1000",
                                        unitsExponent   => "0",
                                        noMinorGrids    => "",
                                        stepValue       => "",
                                        gprintFormat    => "%8.2lf",
                                        pieWidth        => "200",
                                        pieHeight       => "150",
                                        pie3d           => "1",
                                        barWidth        => "200",
                                        barHeight       => "150",
					barSpacing	=> "10",
                                        metricIndexHash => {},
                                        metricArray     => [],
                                        );

$obj2 = GraphMetric->new(       name => "memUsed",
                                                color           => "#0000FF",
                                                lineType        => "AREA",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => "",
                                                );
$obj->addGraphMetric("memUsed", $obj2);

$obj2 = GraphMetric->new(       name => "memFree",
                                                color           => "#00CC00",
                                                lineType        => "STACK",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => "1",
                                                );
$obj->addGraphMetric("memFree", $obj2);

$service->addGraph("memUtilization", $obj);

#add graph 1
$obj = Graph->new(      name => "swapUtilization",
                                        title           => "Swap Utilization",
                                        comment         => "",
                                        imageFormat     => "png",
                                        width           => "500",
                                        height          => "120",
                                        verticalLabel   => "Percent",
                                        upperLimit      => "100",
                                        lowerLimit      => "0",
                                        rigid           => "Y",
                                        base            => "1000",
                                        unitsExponent   => "0",
                                        noMinorGrids    => "",
                                        stepValue       => "",
                                        gprintFormat    => "%8.2lf",
                                        pieWidth        => "200",
                                        pieHeight       => "150",
                                        pie3d           => "1",
                                        barWidth        => "200",
                                        barHeight       => "150",
					barSpacing	=> "10",
                                        metricIndexHash => {},
                                        metricArray     => [],
                                        );

$obj2 = GraphMetric->new(       name => "swapUsed",
                                                color           => "#FFFF00",
                                                lineType        => "AREA",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => "",
                                                );
$obj->addGraphMetric("swapUsed", $obj2);

$obj2 = GraphMetric->new(       name => "swapFree",
                                                color           => "#32CD32",
                                                lineType        => "STACK",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => "1",
                                                );
$obj->addGraphMetric("swapFree", $obj2);

$service->addGraph("swapUtilization", $obj);

#add graph 2
$obj = Graph->new(      name => "memPaging",
                                        title           => "Memory Paging",
                                        comment         => "",
                                        imageFormat     => "png",
                                        width           => "500",
                                        height          => "120",
                                        verticalLabel   => "KB/sec",
                                        upperLimit      => "",
                                        lowerLimit      => "0",
                                        rigid           => "",
                                        base            => "1024",
                                        unitsExponent   => "0",
                                        noMinorGrids    => "",
                                        stepValue       => "",
                                        gprintFormat    => "%8.2lf",
                                        pieWidth        => "200",
                                        pieHeight       => "150",
                                        pie3d           => "1",
                                        barWidth        => "200",
                                        barHeight       => "150",
					barSpacing	=> "10",
                                        metricIndexHash => {},
                                        metricArray     => [],
                                        );
                                        
$obj2 = GraphMetric->new(       name => "pageIn",
                                                color           => "#FF0000",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => "",
                                                );
$obj->addGraphMetric("pageIn", $obj2);

$obj2 = GraphMetric->new(       name => "pageOut",
                                                color           => "#FFFF00",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => "",
                                                );
$obj->addGraphMetric("pageOut", $obj2);

$service->addGraph("memPaging", $obj);

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
	print ("threshUnit: $thresholdUnit\n");
	print ("lowThreshold: $lowThreshold\n");
	print ("highThreshold: $highThreshold\n\n");
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
