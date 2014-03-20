#use strict;
package main;

# Determine unique ser file
my $pid=$$;
my $serFile="$perfhome/cgi/appLib/graphs/graphData/$pid.ser";

my @optionsArray=();
my @DEF=();
my @LINE=();
my @subServices=();
my $width;
my $height;

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
my $multiServiceGraphs = lock_retrieve("$perfhome/var/db/mappings/multiServiceGraphs.ser") or die("Could not lock_retrieve from $perfhome/var/db/mappings/multiServiceGraphs.ser");
my $prefix = $serviceName;
$prefix =~ s/\..*//;
my $graphObject = $multiServiceGraphs->{$os}->{$prefix}->{$graphName};

# Find subservices for host obects
&FindSubServices;

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

my $verticalLabel       = $graphObject->getVerticalLabel();
my $upperLimit          = $graphObject->getUpperLimit();
my $lowerLimit          = $graphObject->getLowerLimit();
my $rigid               = $graphObject->getRigid();
my $base                = $graphObject->getBase();
my $unitsExponent       = $graphObject->getUnitsExponent();
my $noMinorGrids        = $graphObject->getNoMinorGrids();
my $stepValue           = $graphObject->getStepValue();
my $gprintFormat        = $graphObject->getGprintFormat();

# Build Options Array

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

# Setup color counter
my $counter="0";

# Determine colors array length
my $ref_colors=\@{$graphObject->{colorsArray}};
my $colorsLength=$#$ref_colors - 1;

# Get definition and line for every metric in every sub service
my $metricCount="0";
foreach my $serviceName (@subServices) {

	my $RRD="$perfhome/rrd/$hostName/$hostName.$serviceName.rrd";
	my $subService="$serviceName";
	$subService =~ m/\S+\.(\S+)/;
	$subService=$1;

	push(@LINE,"COMMENT:\\n");

	foreach my $metric (@{$graphObject->{metricArray}}) {
		my $metricName = $metric->getName();
			
		# Determine metric color from colorsArray
		my $color=();
                        
		# Reset colors counter if all colors have been used
		if ($colorsLength < $counter) {
                     $color=@{$graphObject->{colorsArray}}[$counter];
                      $counter="0";
               } else {
                      $color=@{$graphObject->{colorsArray}}[$counter];
                      $counter++;
               }

		# Determine if metric is to be excluded from graph
        	my $subGraphExclude = $metric->getSubGraphExclude();

		next if ($subGraphExclude =~ m/1/);

		# Set lineType to always be LINE2
        	#my $lineType = $metric->getLineType();
        	my $lineType = "LINE2";
	
		my $metricServiceName="$subService\_$metricName";

		# Create virtual name
		my $vName="$metricCount$metricName";

        	push(@DEF,"DEF:$vName=$RRD:$metricName:AVERAGE");
        	push(@LINE,"$lineType:$vName$color:$metricServiceName");

        	my $i="0";
        	my $data_ref=\@{$metric->{gprintArray}};
        	foreach my $line (@{$metric->{gprintArray}}) {
                	my $gprint="GPRINT:$vName:$line: $line  \\:$gprintFormat";

                	if ($i eq $#$data_ref) {
                        	#push(@LINE,$gprint . "\\n");
                        	push(@LINE,$gprint);
                	} else {
                        	push(@LINE,$gprint);
                	}
                	$i++;
        	}
		$metricCount ++;
	}
}

# Serialize Graph Data
&StoreData;

### Send Graph Data to graph AIP
my $graphAPI=`$perfhome/cgi/appLib/graphs/act_graphAPI.pl RRD,$pid`;

###DEBUG Print###
#print $request->header();
#print("test: $graphAPI");

###Print to STDOUT###
print header({-type =>'image/png',-expires=>'-1d',-pragma=>'nocache'});
print $graphAPI;
#RRDs::graph( '-', @optionsArray, @DEF, @LINE);
#my $err1 = RRDs::error;
#if ( $err1 ) {
#	print ("RRD ERROR: $err1");
#}

# Get options
sub GraphOptions {
	my $title = $graphObject->getTitle();
	$title = "$title ($serviceName) on $hostName";
	my $comment = $graphObject->getComment();
	my $imageFormat="PNG";
	my $width="";
	my $height="";
	my $graphWidth="";
	my $graphHeight="";

	# Get graph width/height if they aren't already set
	if ($graphWidth eq "") {
        	$width = $graphObject->getWidth();
	} else {
        	$width=$graphWidth;
	}
	if ($graphHeight eq "") {
        	$height=$graphObject->getHeight();
	} else {
        	$height=$graphHeight;
	}

	my $verticalLabel       = $graphObject->getVerticalLabel();
	my $upperLimit          = $graphObject->getUpperLimit();
	my $lowerLimit          = $graphObject->getLowerLimit();
	my $rigid               = $graphObject->getRigid();
	my $base                = $graphObject->getBase();
	my $unitsExponent       = $graphObject->getUnitsExponent();
	my $noMinorGrids        = $graphObject->getNoMinorGrids();
	my $stepValue           = $graphObject->getStepValue();
	my $gprintFormat        = $graphObject->getGprintFormat();

	# Build Options Array

	# Add required options
	push(@optionsArray,"--start=$period");
	push(@optionsArray,"--imgformat=$imageFormat");
	push(@optionsArray,"--width=$width");
	push(@optionsArray,"--height=$height");
	push(@optionsArray,"--title=$title");
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

	# Setup color counter
	my $counter="0";

	# Determine colors array length
	#my $ref_colors=\@colors;
	my $ref_colors=\@{$graphObject->{colorsArray}};
	my $colorsLength=$#$ref_colors - 1;

	# Get definition and line for every metric in every sub service
	foreach my $serviceName (@subServices) {

		my $RRD="$perfhome/rrd/$hostName/$hostName.$serviceName.rrd";
		my $subService="$serviceName";
		$subService =~ m/\S+\.(\S+)/;
		$subService=$1;

		push(@LINE,"COMMENT:\\n");

		foreach my $metric (@{$graphObject->{metricArray}}) {
        		my $metricName = $metric->getName();
			
			# Determine metric color from colorsArray
			my $color=();
                        
			# Reset colors counter if all colors have been used
                     if ($colorsLength < $counter) {
				#$color = $colors[$counter];
                     	$color=@{$graphObject->{colorsArray}}[$counter];
                            $counter="0";
                     } else {
				#$color = $colors[$counter];
                            $color=@{$graphObject->{colorsArray}}[$counter];
                            $counter++;
                     }

			# Determine if metric is to be excluded from graph
        		my $subGraphExclude = $metric->getSubGraphExclude();

			next if ($subGraphExclude =~ m/1/);

			# Set lineType to always be LINE2
        		#my $lineType = $metric->getLineType();
        		my $lineType = "LINE2";
	
			my $metricServiceName="$subService\_$metricName";

        		push(@DEF,"DEF:$metricServiceName=$RRD:$metricName:AVERAGE");
        		push(@LINE,"$lineType:$metricServiceName$color:$metricServiceName");

        		my $i="0";
        		my $data_ref=\@{$metric->{gprintArray}};
        		foreach my $line (@{$metric->{gprintArray}}) {
                		my $gprint="GPRINT:$metricServiceName:$line: $line  \\:$gprintFormat";

                		if ($i eq $#$data_ref) {
                        		#push(@LINE,$gprint . "\\n");
                        		push(@LINE,$gprint);
                		} else {
                        		push(@LINE,$gprint);
                		}
                		$i++;
        		}
		}
	}
}

# Determine sub services based on service
sub FindSubServices {
	my $hostObject = populateHostObject($hostName);
	my $serviceIndex = $hostObject->{serviceIndex};

	foreach my $service (keys (%$serviceIndex)) {
		# Skip if not correct service.subservice
		next if ($service !~ m/$prefix.\S+/);

		# Skip Totals
		next if ($service =~ m/$prefix\.Total/);

		push(@subServices, $service);
	}
}

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
