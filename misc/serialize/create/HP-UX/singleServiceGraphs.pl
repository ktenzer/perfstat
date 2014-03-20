#!/usr/local/ActivePerl-5.8/bin/perl
require "../GraphConfig.pl";

my $singleServiceGraphs = lock_retrieve("$perfhome/var/db/mappings/singleServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/singleServiceGraphs.ser");

#--------------------------------------------------------------------------CPU
#add graph
$obj = Graph->new(      name => "cpuLoad",
                                        title           => "Load Average",
                                        comment         => "",
                                        imageFormat     => "png",
                                        rrdWidth        => "360",
                                        rrdHeight       => "90",
                                        verticalLabel   => "Load Average",
                                        upperLimit      => "",
                                        lowerLimit      => "",
                                        rigid           => "",
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
                                        barSpacing      => "10",
                                        metricIndexHash => {},
                                        metricArray     => []
                                        );

$obj2 = GraphMetric->new(       name => "load1",
                                                color           => "#FFFF00",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("load1", $obj2);

$obj2 = GraphMetric->new(       name => "load5",
                                                color           => "#FF0000",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("load5", $obj2);

$obj2 = GraphMetric->new(       name => "load15",
                                                color           => "#32CD32",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("load15", $obj2);

$singleServiceGraphs->{'HP-UX'}->{cpu}->{cpuLoad} = $obj;

#add graph
$obj = Graph->new(      name => "cpuUtilization",
                                        title           => "CPU Utilization",
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
                                        barSpacing      => "10",
                                        metricIndexHash => {},
                                        metricArray     => []
                                        );

$obj2 = GraphMetric->new(       name => "usr",
                                                color           => "#FFFF00",
                                                lineType        => "AREA",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("usr", $obj2);

$obj2 = GraphMetric->new(       name => "sys",
                                                color           => "#FF0000",
                                                lineType        => "STACK",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("sys", $obj2);

$obj2 = GraphMetric->new(       name => "wait",
                                                color           => "#008080",
                                                lineType        => "STACK",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("wait", $obj2);

$obj2 = GraphMetric->new(       name => "idl",
                                                color           => "#32CD32",
                                                lineType        => "STACK",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("idl", $obj2);

$singleServiceGraphs->{'HP-UX'}->{cpu}->{cpuUtilization} = $obj;

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
                                        metricArray     => []
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

$singleServiceGraphs->{'HP-UX'}->{fs}->{fsUtilization} = $obj;

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
                                        metricArray     => []
                                        );

$obj2 = GraphMetric->new(       name => "readWrite",
                                                color           => "#0000FF",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("read", $obj2);

#$obj2 = GraphMetric->new(       name => "write",
#                                                color           => "#FF0000",
#                                                lineType        => "LINE2",
#                                                gprintArray     => [qw{AVERAGE LAST}],
#                                                cDefinition     => "",
#                                                subGraphExclude => ""
#                                                );
#$obj->addGraphMetric("write", $obj2);

$singleServiceGraphs->{'HP-UX'}->{io}->{ioActivity} = $obj;

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
                                        metricArray     => []
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

$singleServiceGraphs->{'HP-UX'}->{io}->{ioUtilization} = $obj;

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
                                        metricArray     => []
                                        );      
                                                
$obj2 = GraphMetric->new(       name => "aWait",
                                                color           => "#32CD32",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("aWait", $obj2);

$singleServiceGraphs->{'HP-UX'}->{io}->{ioWait} = $obj;

#--------------------------------------------------------------------------MEM
#add graph 0
$obj = Graph->new(      name => "memUtilization",
                                        title           => "Memory Utilization",
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
                                        metricArray     => []
                                        );

$obj2 = GraphMetric->new(       name => "memUsed",
                                                color           => "#0000FF",
                                                lineType        => "AREA",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("memUsed", $obj2);

$obj2 = GraphMetric->new(       name => "memFree",
                                                color           => "#00CC00",
                                                lineType        => "STACK",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => "1"
                                                );
$obj->addGraphMetric("memFree", $obj2);

$singleServiceGraphs->{'HP-UX'}->{mem}->{memUtilization} = $obj;

#add graph
$obj = Graph->new(      name => "swapUtilization",
                                        title           => "Swap Utilization",
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
                                        metricArray     => []
                                        );

$obj2 = GraphMetric->new(       name => "swapUsed",
                                                color           => "#FFFF00",
                                                lineType        => "AREA",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("swapUsed", $obj2);

$obj2 = GraphMetric->new(       name => "swapFree",
                                                color           => "#32CD32",
                                                lineType        => "STACK",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => "1"
                                                );
$obj->addGraphMetric("swapFree", $obj2);

$singleServiceGraphs->{'HP-UX'}->{mem}->{swapUtilization} = $obj;

#add graph
$obj = Graph->new(      name => "memPaging",
                                        title           => "Memory Paging",
                                        comment         => "",
                                        imageFormat     => "png",
                                        rrdWidth        => "360",
                                        rrdHeight       => "90",
                                        verticalLabel   => "KB/sec",
                                        upperLimit      => "",
                                        lowerLimit      => "0",
                                        rigid           => "",
                                        base            => "1024",
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
                                        metricArray     => []
                                        );
                                        
$obj2 = GraphMetric->new(       name => "pageIn",
                                                color           => "#FF0000",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("pageIn", $obj2);

$obj2 = GraphMetric->new(       name => "pageOut",
                                                color           => "#FFFF00",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("pageOut", $obj2);

$singleServiceGraphs->{'HP-UX'}->{mem}->{memPaging} = $obj;

#--------------------------------------------------------------------------PROCS
#add graph 0
$obj = Graph->new(      name => "procsActivity",
                                        title           => "Process Activity",
                                        comment         => "",
                                        imageFormat     => "png",
                                        rrdWidth        => "360",
                                        rrdHeight       => "90",
                                        verticalLabel   => "Number",
                                        upperLimit      => "",
                                        lowerLimit      => "0",
                                        rigid           => "",
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
                                        metricArray     => []
                                        );

$obj2 = GraphMetric->new(       name => "procs",
                                                color           => "#000080",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("procs", $obj2);

$singleServiceGraphs->{'HP-UX'}->{procs}->{procsActivity} = $obj;

#--------------------------------------------------------------------------SOCKET
#add graph
$obj = Graph->new(      name => "socketActivity",
                                        title           => "Socket Activity",
                                        comment         => "",
                                        imageFormat     => "png",
                                        rrdWidth        => "360",
                                        rrdHeight       => "90",
                                        verticalLabel   => "Number",
                                        upperLimit      => "",
                                        lowerLimit      => "0",
                                        rigid           => "",
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
                                        barSpacing      => "10",
                                        metricIndexHash => {},
                                        metricArray     => []
                                        );

$obj2 = GraphMetric->new(       name => "actOpen",
                                                color           => "#FFA500",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("actOpen", $obj2);

$obj2 = GraphMetric->new(       name => "pasOpen",
                                                color           => "#FF0000",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("pasOpen", $obj2);

$obj2 = GraphMetric->new(       name => "estConn",
                                                color           => "#0000FF",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("estConn", $obj2);

$singleServiceGraphs->{'HP-UX'}->{'socket'}->{socketActivity} = $obj;

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
                                        metricArray     => []
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

$singleServiceGraphs->{'HP-UX'}->{tcp}->{tcpUtilization} = $obj;

#--------------------------------------------------------------------------UPTIME
#add graph 0
$obj = Graph->new(      name => "uptime",
                                        title           => "System Uptime",
                                        comment         => "",
                                        imageFormat     => "png",
                                        rrdWidth        => "360",
                                        rrdHeight       => "90",
                                        verticalLabel   => "Hours",
                                        upperLimit      => "",
                                        lowerLimit      => "",
                                        rigid           => "",
                                        base            => "1000",
                                        unitsExponent   => "0",
                                        noMinorGrids    => "",
                                        stepValue       => "",
                                        pieWidth        => "360",
                                        pieHeight       => "180",
                                        pie3d           => "1",
                                        barWidth        => "360",
                                        barHeight       => "180",
                                        barSpacing      => "10",
                                        gprintFormat    => "%8.2lf",
                                        metricIndexHash => {},
                                        metricArray     => []
                                        );

$obj2 = GraphMetric->new(       name => "uptime",
                                                color           => "#800000",
                                                lineType        => "LINE2",
                                                gprintArray     => [qw{AVERAGE LAST}],
                                                cDefinition     => "",
                                                subGraphExclude => ""
                                                );
$obj->addGraphMetric("uptime", $obj2);

$singleServiceGraphs->{'HP-UX'}->{uptime}->{uptime} = $obj;

#--------------------------------------------------------------------------
lock_store($singleServiceGraphs, "$perfhome/var/db/mappings/singleServiceGraphs.ser") || die("can't store $singleServiceGraphs in singleServiceGraphs.ser\n");
