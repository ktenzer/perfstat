#!/usr/bin/perl

require "/perfstat/build/serialize/create/HostConfig.pl";

#add create new host
$host = Host->new(	OS    => "WindowsNT",
			IP    => "0.0.0.0",
			Owner => "nobody",
		 );

#print out this Host
print ("Host: ref($host)\n");

$OS = $host->getOS();
$IP = $host->getIP();
$owner = $host->getOwner();
$lastUpdate = $host->getLastUpdate();

print ("OS: $OS\n");
print ("IP: $IP\n");
print ("Owner: $owner\n");
print ("Last Update: $lastUpdate\n");


#Store the host
$host->store("$perfhome/etc/configs/WinNT/host.ser") or die("can't store host.ser?\n");
