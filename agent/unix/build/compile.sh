#!/bin/bash

PERLAPP="/usr/local/ActivePerl-5.8/bin/perlapp"
SRC_DIR="/perfstat/build/1.52/server/src"
DEST_DIR="/perfstat/build/1.52/server/bin"

LANG="en_US"
export $LANG

cd $DEST_DIR

# Compile Client Programs
$PERLAPP $SRC_DIR/cpu.pl --add CGI::Carp\;POSIX\;Sys::Load\;Fcntl
$PERLAPP $SRC_DIR/fs.pl --add CGI::Carp\;POSIX\;Fcntl
$PERLAPP $SRC_DIR/io.pl --add CGI::Carp\;POSIX\;Fcntl
$PERLAPP $SRC_DIR/memory.pl --add CGI::Carp\;POSIX\;Fcntl
$PERLAPP $SRC_DIR/procs.pl --add CGI::Carp\;POSIX\;Fcntl
$PERLAPP $SRC_DIR/tcp.pl --add CGI::Carp\;POSIX\;Fcntl
$PERLAPP $SRC_DIR/socket.pl --add CGI::Carp\;POSIX\;Fcntl
$PERLAPP $SRC_DIR/uptime.pl --add CGI::Carp\;POSIX\;Sys::Load\;Fcntl
$PERLAPP $SRC_DIR/perf.pl --add IO::Socket\;CGI::Carp
$PERLAPP $SRC_DIR/info.pl --add CGI::Carp\;POSIX\;Fcntl

# Compile Server Programs
$PERLAPP $SRC_DIR/perfctl.pl --add CGI::Carp\;POSIX\;Fcntl
$PERLAPP $SRC_DIR/perfd.pl --add warnings\;IO::Socket\;CGI::Carp\;IO::File\;File::Copy\;POSIX\;Fcntl\;Storable\;Service\;Metric\;Graph\;Host\;User\;NotifyRules\;Time::localtime
#$PERLAPP $SRC_DIR/perfd.pl --add warnings\;IO::Socket\;CGI::Carp\;IO::File\;File::Copy\;POSIX\;Fcntl\;Storable\;Service\;Metric\;Graph\;Host\;User\;NotifyRules\;Time::localtime --bind libpng12.so.0[file=/usr/local/lib/libpng12.so.0,extract] --bind libm.so.6[file=/lib/i686/libm.so.6,extract] --bind libgd.so.2[file=/usr/local/lib/libgd.so.2,extract] --bind libc.so.6[file=/lib/i686/libc.so.6,extract] --bind ld-linux.so.2[file=/lib/ld-linux.so.2,extract]

$PERLAPP $SRC_DIR/status.pl --add CGI::Carp\;POSIX\;Fcntl\;Storable\;Service\;Metric\;Graph\;Host\;RRDs\;Time::localtime
$PERLAPP $SRC_DIR/conn.pl --add utf8\;IO::Socket\;CGI::Carp\;POSIX\;Fcntl\;Storable\;Net::Ping\;IO::File\;Service\;Metric\;Graph\;Host\;Time::localtime
$PERLAPP $SRC_DIR/alert.pl --add CGI::Carp\;Mail::SendEasy
$PERLAPP $SRC_DIR/perfconfig.pl --add POSIX
$PERLAPP $SRC_DIR/perfreport.pl --add RRDs
$PERLAPP $SRC_DIR/rrdAPI.pl --add RRDs\;CGI::Carp
$PERLAPP $SRC_DIR/act_graphAPI.pl --add RRDs\;CGI::Carp\;GD::Graph::pie\;GD::Graph::bars\;Storable
