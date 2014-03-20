#!/usr/local/ActivePerl-5.8/bin/perl
require "../GraphConfig.pl";

my $multiServiceGraphs = lock_retrieve("$perfhome/var/db/mappings/multiServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/multiServiceGraphs.ser");

#--------------------------------------------------------------------------FS
#add graph
$obj = Graph->new(      name => "fsUtilization",
                                        title           => "File System Utilization",
                                        comment         => "",
                                        imageFormat     => "png",
                                        rrdWidth        => "360",
                                        rrdHeight       => "90",
                                        verticalLabel   => "Percent",
                                        upperLimit      => "100",
                                        lowerLimit      => "0",
                                        rigid           => "Y",
                                        base            => "1000",
                                        unitsExponent   => "0",
                                        noMinorGrids    => "",
                                        stepValue       => "",
                                        gprintFormat    => "%8.2lf",
                                        pieWidth        => "360",
                                        pieHeight       => "180",
                                        pie3d           => "1",
                                        barWidth        => "360",
                                        barHeight       => "180",
					barSpacing	=> "10",
                                        metricIndexHash => {},
                                        metricArray     => [],
					colorsArray     => [qw{#FF0000 #00FF00 #0000FF #FFFF00 #00FFFF #CC0000 #00CC00 #0000CC #CCCC00 #00CCCC #CCCCCC}],
                                        );

$obj2 = GraphMetric->new(       name => "fsUsed",
                                                color           => "#0000FF",
                                                lineType        => "AREA",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
																subGraphExclude => ""
                                                );
$obj->addGraphMetric("fsUsed", $obj2);

$obj2 = GraphMetric->new(       name => "fsFree",
                                                color           => "#32CD32",
                                                lineType        => "STACK",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => "1"
                                                );
$obj->addGraphMetric("fsFree", $obj2);

$multiServiceGraphs->{SunOS}->{fs}->{fsUtilization} = $obj;

#--------------------------------------------------------------------------IO
#add graph
$obj = Graph->new(      name => "ioActivity",
                                        title           => "IO Activity",
                                        comment         => "",
                                        imageFormat     => "png",
                                        rrdWidth        => "360",
                                        rrdHeight       => "90",
                                        verticalLabel   => "KB/sec",
                                        upperLimit      => "",
                                        lowerLimit      => "0",
                                        rigid           => "",
                                        base            => "1024",
                                        unitsExponent   => "",
                                        noMinorGrids    => "",
                                        stepValue       => "",
                                        gprintFormat    => "%8.2lf",
                                        pieWidth        => "360",
                                        pieHeight       => "180",
                                        pie3d           => "1",
                                        barWidth        => "360",
                                        barHeight       => "180",
					barSpacing	=> "10",
                                        metricIndexHash => {},
                                        metricArray     => [],
					colorsArray     => [qw{#FF0000 #00FF00 #0000FF #FFFF00 #00FFFF #CC0000 #00CC00 #0000CC #CCCC00 #00CCCC #CCCCCC}],
                                        );

$obj2 = GraphMetric->new(       name => "read",
                                                color           => "#0000FF",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("read", $obj2);

$obj2 = GraphMetric->new(       name => "write",
                                                color           => "#FF0000",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("write", $obj2);

$multiServiceGraphs->{SunOS}->{io}->{ioActivity} = $obj;

#add graph
$obj = Graph->new(      name => "ioUtilization",
                                        title           => "IO Utilization",
                                        comment         => "",
                                        imageFormat     => "png",
                                        rrdWidth        => "360",
                                        rrdHeight       => "90",
                                        verticalLabel   => "Percent",
                                        upperLimit      => "100",
                                        lowerLimit      => "0",
                                        rigid           => "Y",
                                        base            => "1000",
                                        unitsExponent   => "0",
                                        noMinorGrids    => "",
                                        stepValue       => "",
                                        gprintFormat    => "%8.2lf",
                                        pieWidth        => "360",
                                        pieHeight       => "180",
                                        pie3d           => "1",
                                        barWidth        => "360",
                                        barHeight       => "180",
					barSpacing	=> "10",
                                        metricIndexHash => {},
                                        metricArray     => [],
					colorsArray     => [qw{#FF0000 #00FF00 #0000FF #FFFF00 #00FFFF #CC0000 #00CC00 #0000CC #CCCC00 #00CCCC #CCCCCC}],
                                        );
                                        
$obj2 = GraphMetric->new(       name => "ioUtil",
                                                color           => "#FF0000",
                                                lineType        => "AREA",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("ioUtil", $obj2);

$obj2 = GraphMetric->new(       name => "ioIdle",
                                                color           => "#00CC00",
                                                lineType        => "STACK",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => "1"
                                                );
$obj->addGraphMetric("ioIdle", $obj2);

$multiServiceGraphs->{SunOS}->{io}->{ioUtilization} = $obj;

#add graph
$obj = Graph->new(      name => "ioWait",
                                        title           => "IO Wait",
                                        comment         => "",
                                        imageFormat     => "png",
                                        rrdWidth        => "360",
                                        rrdHeight       => "90",
                                        verticalLabel   => "Milliseconds",
                                        upperLimit      => "",
                                        lowerLimit      => "0",
                                        rigid           => "",
                                        base            => "1000",
                                        unitsExponent   => "",
                                        noMinorGrids    => "",
                                        stepValue       => "",
                                        gprintFormat    => "%8.2lf",
                                        pieWidth        => "360",
                                        pieHeight       => "180",
                                        pie3d           => "1",
                                        barWidth        => "360",
                                        barHeight       => "180",
					barSpacing	=> "10",
                                        metricIndexHash => {},
                                        metricArray     => [],
					colorsArray     => [qw{#FF0000 #00FF00 #0000FF #FFFF00 #00FFFF #CC0000 #00CC00 #0000CC #CCCC00 #00CCCC #CCCCCC}],
                                        );      
                                                
$obj2 = GraphMetric->new(       name => "aWait",
                                                color           => "#32CD32",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("aWait", $obj2);

$multiServiceGraphs->{SunOS}->{io}->{ioWait} = $obj;

#--------------------------------------------------------------------------TCP
#add graph 0
$obj = Graph->new(      name => "tcpUtilization",
                                        title           => "Network Utilization",
                                        comment         => "",
                                        imageFormat     => "png",
                                        rrdWidth        => "360",
                                        rrdHeight       => "90",
                                        verticalLabel   => "Bytes/sec",
                                        upperLimit      => "",
                                        lowerLimit      => "0",
                                        rigid           => "",
                                        base            => "1024",
                                        unitsExponent   => "",
                                        noMinorGrids    => "",
                                        stepValue       => "",
                                        gprintFormat    => "%8.2lf",
                                        pieWidth        => "360",
                                        pieHeight       => "180",
                                        pie3d           => "1",
                                        barWidth        => "360",
                                        barHeight       => "180",
                                        barSpacing      => "10",
                                        metricIndexHash => {},
                                        metricArray     => [],
					colorsArray     => [qw{#FF0000 #00FF00 #0000FF #FFFF00 #00FFFF #CC0000 #00CC00 #0000CC #CCCC00 #00CCCC #CCCCCC}],
                                        );

$obj2 = GraphMetric->new(       name => "bytesIn",
                                                color           => "#0000FF",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("bytesIn", $obj2);

$obj2 = GraphMetric->new(       name => "bytesOut",
                                                color           => "#FF0000",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("bytesOut", $obj2);

$multiServiceGraphs->{SunOS}->{tcp}->{tcpUtilization} = $obj;

#--------------------------------------------------------------------------
lock_store($multiServiceGraphs, "$perfhome/var/db/mappings/multiServiceGraphs.ser") || die("can't store $multiServiceGraphs in multiServiceGraphs.ser\n");
