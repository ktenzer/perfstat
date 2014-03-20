CHANGES

-------------
/docs
 - hostIndex Class Diagram updated
 - hostIndex Data Structure Chart updated
 - hostIndex Directory Structure Chart updated

-------------
/lib directory
 - Host.pm added
 - Service.pm updated to remove OS
 - metric.pm updated to include status

-------------
/etc/configs/linux
 - ahost.pl - add file to add create default linux host

 - cpu.pl - update to contain status: default = "nostatus"
 - fs.pl - update to contain status: default = "nostatus"
 - io.pl - update to contain status: default = "nostatus"
 - mem.pl - update to contain status: default = "nostatus"
 - procs.pl - update to contain status: default = "nostatus"
 - socket.pl - update to contain status: default = "nostatus"
 - tcp.pl - update to contain status: default = "nostatus"
 - uptime.pl - update to contain status: default = "nostatus"

 - create all default *.ser files

/etc/configs/solaris
 - ahost.pl  - add file to add create default solaris host

 - cpu.pl - update to contain status: default = "nostatus"
 - fs.pl - update to contain status: default = "nostatus"
 - io.pl - update to contain status: default = "nostatus"
 - mem.pl - update to contain status: default = "nostatus"
 - procs.pl - update to contain status: default = "nostatus"
 - socket.pl - update to contain status: default = "nostatus"
 - tcp.pl - update to contain status: default = "nostatus"
 - uptime.pl - update to contain status: default = "nostatus"

 - create all default *.ser files

/etc/configs/winnt
 - ahost.pl - add file to add create default winnt host

 - cpu.pl - update to contain status: default = "nostatus"
 - fs.pl - update to contain status: default = "nostatus"
 - io.pl - update to contain status: default = "nostatus"
 - mem.pl - update to contain status: default = "nostatus"
 - procs.pl - update to contain status: default = "nostatus"
 - socket.pl - update to contain status: default = "nostatus"
 - tcp.pl - update to contain status: default = "nostatus"
 - uptime.pl - update to contain status: default = "nostatus"

 - create all default *.ser files

-------------

/var/state/host1
 - add new .ser files corresponding to linux host1

/var/state/host2
 - add new .ser files corresponding to linux host2

/testProgram
 - makeHostIndex.pl - that looks in /var/state and /var/state/$hostname to create the hostIndex data structure, then print it out