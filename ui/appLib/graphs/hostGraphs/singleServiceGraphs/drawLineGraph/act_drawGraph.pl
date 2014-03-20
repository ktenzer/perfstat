#use strict;
package main;

# Determine unique ser file
my $pid=$$;
my $serFile="$perfhome/cgi/appLib/graphs/graphData/$pid.ser";

my @LINE=();
my @DEF=();
my $width;
my $height;

my $RRD="$perfhome/rrd/$hostName/$hostName.$serviceName.rrd";

# Convert period into seconds
if ($period =~ m/day/) {
	$period="end-1d";
} elsif ($period =~ m/week/) {
	$period="end-1w";
} elsif ($period =~ m/month/) {
	$period="end-1m";
} elsif ($period =~ m/year/) {
	$period="end-1y";
}

# Get Graph Object
my $singleServiceGraphs = lock_retrieve("$perfhome/var/db/mappings/singleServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/singleServiceGraphs.ser");
my $prefix = $serviceName;
$prefix =~ s/\..*//;
my $graphObject = $singleServiceGraphs->{$os}->{$prefix}->{$graphName};

# Set Graph Options
my $title = $graphObject->getTitle();
$title = "$title ($serviceName) on $hostName";
my $comment = $graphObject->getComment();
my $imageFormat="PNG";

# Get graph width/height
$width = $graphObject->getRRDWidth() * $graphScale;
$height = $graphObject->getRRDHeight() * $graphScale;
my $gdWidth = $graphObject->getBarWidth() * $graphScale;
my $rrdDelta = ($gdWidth - $width) - 96;
$width = $width + $rrdDelta;

my $verticalLabel	= $graphObject->getVerticalLabel();
my $upperLimit	= $graphObject->getUpperLimit();
my $lowerLimit	= $graphObject->getLowerLimit();
my $rigid 		= $graphObject->getRigid();
my $base 		= $graphObject->getBase();
my $unitsExponent = $graphObject->getUnitsExponent();
my $noMinorGrids 	= $graphObject->getNoMinorGrids();
my $stepValue 	= $graphObject->getStepValue();
my $gprintFormat 	= $graphObject->getGprintFormat();

# Build Options Array
my @optionsArray = ();

# Add required options
push(@optionsArray,"--start=$period");
push(@optionsArray,"--imgformat=$imageFormat");
push(@optionsArray,"--width=$width");
push(@optionsArray,"--height=$height");
#push(@optionsArray,"--title=$title");
push(@optionsArray,"--vertical-label=$verticalLabel");
push(@optionsArray,"--base=$base");

# Add optional options
if ($upperLimit ne "") {
        push(@optionsArray,"--upper-limit=$upperLimit");
}

if ($lowerLimit ne "") {
        push(@optionsArray,"--lower-limit=$lowerLimit");
}

if ($unitsExponent ne "") {
        push(@optionsArray,"--units-exponent=$unitsExponent");
}

if ($rigid ne "") {
        push(@optionsArray,"--rigid");
}

if ($noMinorGrids ne "") {
        push(@optionsArray,"--no-minor");
}

if ($stepValue ne "") {
        push(@optionsArray,"--step=$stepValue");
}

# Get definition and line for every metric
push(@LINE,"COMMENT:\\n");

my $metricCount="0";
foreach my $metric (@{$graphObject->{metricArray}}) {
        my $metricName = $metric->getName();
        my $color = $metric->getColor();
	#my $color="#FFFF00";
        my $lineType = $metric->getLineType();

	# Create Virtual Name
	my $vName="$metricCount$metricName";
        push(@DEF,"DEF:$vName=$RRD:$metricName:AVERAGE");
        push(@LINE,"$lineType:$vName$color:$metricName");

        my $i="0";
        my $data_ref=\@{$metric->{gprintArray}};
        foreach my $line (@{$metric->{gprintArray}}) {
                my $gprint="GPRINT:$vName:$line: $line  \\:$gprintFormat";
                if ($i eq $#$data_ref) {
                        push(@LINE,$gprint . "\\n");
                } else {
			my $gprint2="$gprint";
                        push(@LINE,$gprint2);
                }
                $i++;
        }
	$metricCount++;
}

# Serialize Graph Data
&StoreData;

### Send Graph Data to graph API
#die("$perfhome/cgi/appLib/graphs/act_graphAPI.pl RRD,$pid");
my $graphAPI=`$perfhome/cgi/appLib/graphs/act_graphAPI.pl RRD,$pid`;

# DEBUG
#my $graphAPI=`$perfhome/cgi/appLib/graphs/act_graphAPI.pl RRD,@optionsArray,@DEF,@LINE`;

###DEBUG Print###
#print $request->header();
#print("test: $graphAPI");
#print "RRDs::graph( '-', @optionsArray, @DEF, @LINE)";
#print("Graph Output: @optionsArray @DEF @LINE");

###Print to STDOUT###
print header({-type =>'image/png',-expires=>'-1d',-pragma=>'nocache'});
print $graphAPI;

# OLD: NO GRPAH API
#RRDs::graph( '-', @optionsArray, @DEF, @LINE);
#my $err1 = RRDs::error;
#if ( $err1 ) {
#	print ("RRD ERROR: $err1");
#}

sub StoreData {
	# Create array refs
	my $optionsArrayRef=\@optionsArray;
	my $defArrayRef=\@DEF;
	my $lineArrayRef=\@LINE;

	my $hashArray=();

	$hashArray->{optionsArray}=$optionsArrayRef;
	$hashArray->{DEF}=$defArrayRef;
	$hashArray->{LINE}=$lineArrayRef;

	# Serialize graph data
	lock_store $hashArray, "$serFile"
		or die "ERROR: Can't serialize $serFile: $!\n";
}

1;