#!/usr/local/ActivePerl-5.8/bin/perl
require "../HostConfig.pl";

#add create new host
$host = Host->new(	OS			=> "Linux",
			IP			=> "0.0.0.0",
			Owner			=> "nobody",
			cpuNum			=> "null",
			cpuModel		=> "null",
			cpuSpeed		=> "null",
			memTotal		=> "null",
			swapTotal		=> "null",
			osVer			=> "null",
			kernelVer		=> "null",
		 );

#print out this Host
print ("Host: ref($host)\n");

$OS = $host->getOS();
$IP = $host->getIP();
$owner = $host->getOwner();
$cpuNum = $host->getCpuNum();
$cpuModel = $host->getCpuModel();
$cpuSpeed = $host->getCpuSpeed();
$memTotal = $host->getMemTotal();
$swapTotal = $host->getSwapTotal();
$osVer = $host->getOsVer();
$kernelVer = $host->getKernelVer();
$lastUpdate = $host->getLastUpdate();

print ("OS: $OS\n");
print ("IP: $IP\n");
print ("Owner: $owner\n");
print ("Last Update: $lastUpdate\n");
print ("CPU Number: $cpuNum\n");
print ("CPU Model: $cpuModel\n");
print ("CPU Speed: $cpuSpeed\n");
print ("Mem Total: $memTotal\n");
print ("Swap Total: $swapTotal\n");
print ("OS Version: $osVer\n");
print ("Kernel Version: $kernelVer\n");


#Store the host
$host->store("$perfhome/etc/configs/Linux/host.ser") or die("can't store host.ser?\n");
