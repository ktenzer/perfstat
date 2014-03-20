PerfStat - Perl Systems Monitoring Framework
=====================================
This document contains information about the following: version control,
installation of perfmon tool, and configuration summary.

Installation
============
Installing perfmon is a simple process.  There are two different types
of installation (Client or Server).  The server installation requires
the rrdtool, perl 5.005 (or higher), added perl modules, and the PerfStat
application.  The client installation requires perl 5.005 (or higher),
added perl modules, and the PerfStat application.

Install the RRDTOOL (Server Only):
1.  Build Makefile
      sh configure
    If you prefer to install RRDTOOL in another location besides default:
    /usr/local/rrdtool, use
      sh configure --prefix=/some/other/RRDtool-dir
2.  Compile RRDTOOL
      make
3.  Install RRDTOOL
      make install  

Verify/Install perl 5.005 (or higher) (Client/Server)
1.  Check version of Perl.
      perl -v.

Install Required Perl Modules (Client/Server):
1.  Under the /path/to/perfmon/install directory extract all tar files.
      tar xvf <filename>
2.  Change directory to newly formed directory.
3.  Build makefile 
      perl Makefile.PL
4.  Compile Perl Module
      make
5.  Test Compile of Perl Module
      make test
6.  Install Perl Module
      make install
7.  Repeat steps 2-6 for every Perl Module.

Install the PerfStat application (Client and Server):
1.  Create desired base directory for PerfStat ie: /usr/local/perfmon
2.  Copy tarfile to above directory
3.  When installing PerfStat you will be asked the following:
  a.  Location of the PerfStat application
  b.  location of the RRDTOOL Lib Directory.  Usually located
      under /path/to/rrdtool/lib/perl.
  c.  The PerfStat user/group uid/gid that you wish to run the PerfMon
      application.
4.  Execute the perf-install.sh script located under 
    /path/to/perfmon/install
5.  Check the install.log under the install directory to ensure no 
    errors were generated. 


Configuration
=============
Configuring PerfStat is very simple for both client and server.  Follow
the below steps after the client/server installation is complete.

1.  Edit the perf-profile.pl under /path/to/perfmon/etc.  Enter the
    IP of your PerfStat server in the $perfserver variable (Client/Server).
2.  Edit the perf-hosts file located under /path/to/perfmon/etc.  You
    need to enter the IP and Hostname of all hosts in the perfmon
    environment (Server only).
3.  Start PerfStat application by executing the following command located
    under /path/to/perfmon: perf.sh (start|restart|stop) (Client/Server).

