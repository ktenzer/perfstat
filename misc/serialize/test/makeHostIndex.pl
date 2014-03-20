#!/usr/bin/perl

use lib "/perfstat/build/serialize/lib";
use Host;
use Service;
use Metric;
use Graph;
use Storable qw(retrieve);

$perfhome = "/perfstat/build/serialize";

#create an empty hostIndex
$hostIndex = {};

#populate the keys of the index with the hostNames
opendir(DIR1, "$perfhome/var/state") || die("Couldn't open dir $perfhome/var/state: $!\n");
while ($hostName = readdir(DIR1))
{
	if ($hostName ne "." && $hostName ne "..")
	{
		$hostIndex->{$hostName} = undef;
	}
}
closedir(DIR1);

#populate each host key with a host object
foreach $hostName (keys(%$hostIndex))
{
	opendir(DIR2, "$perfhome/var/state/$hostName") || die("Couldn't open dir perfhome/var/state/$hostName: $!\n");
	while ($fileName = readdir(DIR2))
	{
		if ($fileName =~ /$hostName\.ser/)
		{
			#create host object by deserialization
			$hostObject = retrieve("$perfhome/var/state/$hostName/$fileName");
			die("can't retriewe $perfhome/var/state/$hostName/$fileName\n") unless defined($hostObject);
			
			#assign host object to hostIndex
			$hostIndex->{$hostName} = $hostObject;
		}
	}
	closedir(DIR2);
}


#populate each host object with all related services
foreach $hostName (keys(%$hostIndex))
{
	#create an empty serviceHash
	$serviceHash = {};
	
	#populate empty serviceHash with service objects
	opendir(DIR2, "$perfhome/var/state/$hostName") || die("Couldn't open dir perfhome/var/state/$hostName: $!\n");
	while ($serviceName = readdir(DIR2))
	{
		if ($serviceName ne "." && $serviceName ne ".." && $serviceName !~ /$hostName\.ser/)
		{
			if ($serviceName =~ /^([\S]+)\.ser$/)
			{
				#create service object by deserialization
				$serviceObject = retrieve("$perfhome/var/state/$hostName/$serviceName");
				die("can't retriewe $perfhome/var/state/$hostName/$serviceName\n") unless defined($serviceObject);
			
				#assign service object to service hash
				$serviceHash->{$1} = $serviceObject;
			}
		}
	}
	closedir(DIR2);
	
	#assign serviceHash to hostObject
	$hostIndex->{$hostName}->{serviceIndex} = $serviceHash;
}


#############################################################
#print the whole damn thing out just to be sure

foreach $hostName (sort(keys(%$hostIndex)))
{
	print ("_____________________________________________________\n");
	print ("-------------------------------------------- NEW HOST\n");
	print ("-----------------------------------------------------\n");
	print("hostName: $hostName\n");

	
	$hostObject = $hostIndex->{$hostName};
	$OS = $hostObject->getOS();
	$lastUpdate = $hostObject->getLastUpdate();
	print("OS: $OS\n");
	print("lastUpdate: $lastUpdate\n");
	$serviceIndex = $hostObject->{serviceIndex};
	foreach $serviceName (sort(keys(%$serviceIndex)))
	{
		print ("******************************************************\n");
		print("serviceIndexName: $serviceName\n");
		
		#print out this serviceObject params
		$serviceObject = $serviceIndex->{$serviceName};
		$serviceName = $serviceObject->getServiceName();
		$RRA = $serviceObject->getRRA();
		$rrdStep = $serviceObject->getRRDStep();
		
		print ("serviceName: $serviceName\n");
		print ("RRA: $RRA\n");
		print ("rrdStep: $rrdStep\n");

		#print out this services metrics
		$arrayLength = $serviceObject->getMetricArrayLength();
		print ("metric Array Length = $arrayLength\n");
		for ($counter=0; $counter < $arrayLength; $counter++)
		{
			$metricObject = $serviceObject->{metricArray}->[$counter];

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
			print ("threshUnit: $thresholdUnit\n\n");
		}

		#print out this services graphs
		$arrayLength = $serviceObject->getGraphArrayLength();
		print ("\ngraph Array Length = $arrayLength\n");

		for ($counter=0; $counter < $arrayLength; $counter++)
		{
			$graphObject = $serviceObject->{graphArray}->[$counter];

			$name = $graphObject->getName();
			$title = $graphObject->getTitle();
			$y_axis = $graphObject->getYaxis();
			$legend = $graphObject->getLegend();
			$text = $graphObject->getText();
			print ("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
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
		print("\n");
	}
	print("\n");
}
