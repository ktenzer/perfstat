#!/bin/sh

# Start script for perf
#set -x

PERFHOME=/path/to/perfhome
PERFOUT="$PERFHOME/logs/perfd.log"

# Source in PerfStat profile
. $PERFHOME/perf.profile

# Set LANGUAGE
LANG="en_US"

# Figure out is this is a PerfStat Server
SERVER=`$GREP_CMD "^SERVER=" $PERFHOME/etc/perf-conf |$SED_CMD 's/SERVER=//'` 

# Get Version number
VER=`$GREP_CMD "^VER=" $PERFHOME/etc/perf-conf |$SED_CMD 's/VER=//'` 

# Get PerfStat user
USER=`$GREP_CMD "^USER=" $PERFHOME/etc/perf-conf |$SED_CMD 's/USER=//'` 

# Get Metrics list
METRICS=`$GREP_CMD METRICS= $PERFHOME/etc/perf-conf |$SED_CMD 's/METRICS=//'`

# Determine OS
OS=`$UNAME_CMD -s`

# Setup echo statements
if [ "$OS" = "SunOS" ];then
	
	# Set Sun speficif variables
	SETPGRP=`which setpgrp`

	# PerfStat echo statements
        ECHO_START_PERFD="PerfStat Daemon Starting...\c"
        ECHO_START_PERFCTL="PerfStat Client Starting...\c"

        ECHO_STOP_PERFD="Stopping PerfStat Daemon...\c"
        ECHO_STOP_PERFCTL="Stopping PerfStat Client...\c"

	# PerfStat startup commands
	PERFD_CMD="$SETPGRP_CMD $PERFHOME/bin/perfd"
	PERFCTL_CMD="$SETPGRP_CMD $PERFHOME/bin/perfctl"

	PS_CMD="$PS_CMD -fp"
elif [ "$OS" = "Linux" ];then

	# PerfStat echo statements
        ECHO_START_PERFD="-n PerfStat Daemon Starting..."
        ECHO_START_PERFCTL="-n PerfStat Client Starting..."

        ECHO_STOP_PERFD="-n Stopping PerfStat Daemon..."
        ECHO_STOP_PERFCTL="-n Stopping PerfStat Client..."

	# PerfStat startup commands
	PERFD_CMD="$PERFHOME/bin/perfd"
	PERFCTL_CMD="$PERFHOME/bin/perfctl"

	PS_CMD="$PS_CMD -f"
fi

# Ensure PerfStat will not run as root
USERID=`$ID_CMD |sed 's/[()=]/ /g' |$AWK_CMD '{print $2}'`
CURRENTUSER=`$ID_CMD |sed 's/[()=]/ /g' |$AWK_CMD '{print $3}'`

if [ "$USERID" -eq "0" ];then
        echo "ERROR: PerfStat Cannot Be Run as root!"
        exit 1
fi

# Ensure PerfStat runs as desired user
if [ "$USER" != "$CURRENTUSER" ];then
	echo "ERROR: Incorrect user! PerfStat must be run by $USER user"
	exit 1
fi

# Define Subroutines

# Sub to check if PerfStat Server processes are running
CheckPerfdProc () {

        PROC_PERFD=0
        PERFD_RUNNING=0

        if [ -f $PERFHOME/tmp/perfd.pid ]; then
                PERFD_PID=`$CAT_CMD $PERFHOME/tmp/perfd.pid`
		PERFD_USER=`$PS_CMD $PERFD_PID |$TAIL_CMD -1 |$AWK_CMD '{print $1}'`
		if [ "x$PERFD_PID" != "x" ] && $PS_CMD $PERFD_PID 1>/dev/null; then
			if [ "$PERFD_USER" = "$USER" ]; then
				PROC_PERFD=1
			else
				if [ "$STOP" = "1" ]; then
					echo "ERROR: PerfStat server process is running under wrong user ($PERFD_USER), Shutdown Aborted!"
					exit 1
				else
					echo "ERROR: PerfStat server process starting under wrong user ($PERFD_USER), Startup Aborted!"
					exit 1
				fi
			fi
		fi
        fi

}

# Sub to check if PerfStat Client processes are running
CheckPerfctlProc () {

        PROC_PERFCTL=0
        PERFCTL_RUNNING=0
        if [ -f $PERFHOME/tmp/perfctl.pgid ]; then
                PERFCTL_PID=`$CAT_CMD $PERFHOME/tmp/perfctl.pid`
		PERFCTL_USER=`$PS_CMD $PERFCTL_PID |$TAIL_CMD -1 |$AWK_CMD '{print $1}'`
		if [ "x$PERFCTL_PID" != "x" ] && $PS_CMD $PERFCTL_PID 1>/dev/null; then
			if [ "$PERFCTL_USER" = "$USER" ]; then
				PROC_PERFCTL=1
			else
				if [ "$STOP" = "1" ]; then
					echo "ERROR: PerfStat client processes are running under wrong user ($PERFCTL_USER), Shutdown Aborted!"
					exit 1
				else
					echo "ERROR: PerfStat client processes starting under wrong user ($PERFCTL_USER), Startup Aborted!"
					exit 1
				fi
			fi
		fi
        fi
}



case $1 in
stop | restart)

	# Determine if PerfStat is running
	STOP=1

        if [ "$SERVER" = "Y" -o "$SERVER" = "y" ];then

		CheckPerfdProc
		CheckPerfctlProc

                if [ "$PROC_PERFD" -eq "0" -a "$PROC_PERFCTL" -eq "0" ]; then
                        echo "WARNING: PerfStat is not currently runnig, Shutdown Aborted!"
                        exit 1
                elif [ "$PROC_PERFD" -eq "0" -o "$PROC_PERFCTL" -eq "0" ]; then
                        echo "WARNING: Not all PerfStat processes are running"
                fi
	else
		CheckPerfctlProc

                if [ "$PROC_PERFCTL" -eq "0" ];then
                        echo "WARNING: PerfStat is not currently runnig, Shutdown Aborted!"
                        exit 1
                fi
        fi

	# Print output
        echo ""
        echo "Stopping PerfStat $VER"

	# Update appropriate logs
	if [ "$SERVER" = "y" -o "$SERVER" = "Y" ];then
        	echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` Stopping PerfStat Server $VER" >>$PERFHOME/var/logs/perfd.log
        	echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` Stopping PerfStat Client $VER" >>$PERFHOME/var/logs/perfctl.log
	else
        	echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` Stopping PerfStat Client $VER" >>$PERFHOME/var/logs/perfctl.log
	fi

        #Server Shutdown
        if [ "$SERVER" = "y" -o "$SERVER" = "Y" ]; then
                PERFD_PID=`$CAT_CMD $PERFHOME/tmp/perfd.pid`
                PERFCTL_PGID=`$CAT_CMD $PERFHOME/tmp/perfctl.pgid`
        else
                PERFCTL_PGID=`$CAT_CMD $PERFHOME/tmp/perfctl.pgid`
        fi

        if [ "$SERVER" = "y" -o "$SERVER" = "Y" ]; then
                if [ "$PROC_PERFD" -eq "1" ];then
                        echo $ECHO_STOP_PERFD
                        sleep 1
                        $KILL_CMD -15 $PERFD_PID 2>/dev/null
                        if [ "$?" -eq "0" ]; then
                                echo "Done!"
                        else
                                echo "ERROR: Couldn't shutdown PerfStat server gracefully!"
				# Update Log File
        			echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` ERROR: Couldn't Shutdown PerfStat Server $VER" >>$PERFHOME/var/logs/perfd.log

                        fi
		fi
                if [ "$PROC_PERFCTL" -eq "1" ];then
                        echo $ECHO_STOP_PERFCTL
                        sleep 1
                        $KILL_CMD -15 -$PERFCTL_PGID 2>/dev/null
                        if [ "$?" -eq "0" ]; then
                                echo "Done!"
                        else
                                echo "ERROR: Couldn't shutdown PerfStat client gracefully!"
				# Update Log File
        			echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` ERROR: Couldn't Shutdown PerfStat Client $VER" >>$PERFHOME/var/logs/perfctl.log

                        fi

		fi
       else
                # Client Shutdown
                echo $ECHO_STOP_PERFCTL
                sleep 1
                $KILL_CMD -15 -$PERFCTL_PGID 2>/dev/null
                if [ "$?" -eq "0" ]; then
                        echo "Done!"
                else
                       echo "ERROR: Couldn't shutdown PerfStat client gracefully!"

			# Update Log File
        		echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` ERROR: Couldn't Shutdown PerfStat Client $VER" >>$PERFHOME/var/logs/perfctl.log

                fi
       fi

	if [ "$1" = "stop" ]; then
		exit 0
	fi

	# Update appropriate logs
	if [ "$SERVER" = "y" -o "$SERVER" = "Y" ];then
		echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` Restarting PerfStat Server $VER" >>$PERFHOME/var/logs/perfd.log
		echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` Restarting PerfStat Client $VER" >>$PERFHOME/var/logs/perfctl.log
	else
		echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` Restarting PerfStat Client $VER" >>$PERFHOME/var/logs/perfctl.log
	fi

        ;;
start)

        # Determine if PerfStat is running
	START=1
	if [ "$SERVER" = "Y" -o "$SERVER" = "y" ];then
		CheckPerfdProc
		CheckPerfctlProc

        	if [ "$PROC_PERFD" -eq "1" -o "$PROC_PERFCTL" -eq "1" ]; then
                	echo "WARNING: PerfStat processes are running, Startup Aborted!"
                	exit 1
        	fi
	else
		CheckPerfctlProc
                if [ "$PROC_PERFCTL" -eq "1" ]; then
                        echo "WARNING: PerfStat processes are running, Startup Aborted!"
                        exit 1
                fi

	fi

	# Update appropriate logs
	if [ "$SERVER" = "y" -o "$SERVER" = "Y" ];then
		echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` Starting PerfStat Server $VER" >>$PERFHOME/var/logs/perfd.log
		echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` Starting PerfStat Client $VER" >>$PERFHOME/var/logs/perfctl.log
	else
		echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` Starting PerfStat Client $VER" >>$PERFHOME/var/logs/perfctl.log
	fi

        ;;

*)
        echo "Usage: $0 ( start|restart|stop )"
        exit 1
        ;;
esac

# Clean up temporary Sar files before starting
$RM_CMD -f $PERFHOME/tmp/sar.out.*

# Server startup
if [ "$SERVER" = "y" -o "$SERVER" = "Y" ]; then

	# PerfStat startup
	echo ""
	echo "Starting PerfStat $VER"

       	if [ -x $PERFHOME/bin/perfd ]; then

               	echo $ECHO_START_PERFD

		$PERFD_CMD 2>/dev/null &

		# Determine if PerfStat Client is running
		sleep 3
		CheckPerfdProc
	else
		echo "ERROR: PerfStat daemon does not have executable permission, Startup Aborted!"
		exit 1
	fi

	if [ "$PROC_PERFD" -ne "0" ];then
		echo "Done!"
	else
		echo "Error: Failed to start!"

		# Update Log File
       		echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` ERROR: Couldn't Startup PerfStat Server $VER" >>$PERFHOME/var/logs/perfd.log

	fi

       	if [ -x $PERFHOME/bin/perfctl ]; then

               	echo $ECHO_START_PERFCTL

		$PERFCTL_CMD 2>/dev/null &

		sleep 3
		CheckPerfctlProc
	else
		echo "ERROR: PerfStat client does not have executable permission, Startup Aborted!"
		exit 1
	fi
		
	if [ "$PROC_PERFCTL" -ne "0" ];then
		echo "Done!"
		echo "Collecting data for: $METRICS"
	else
		echo "Error: Failed to start!"

		# Update Log File
        	echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` ERROR: Couldn't Startup PerfStat Client $VER" >>$PERFHOME/var/logs/perfctl.log
	fi

else

	# PerfStat startup
	echo ""
	echo "Starting PerfStat $VER"

	# Client Startup
	if [ -x $PERFHOME/bin/perfctl ]; then
		echo $ECHO_START_PERFCTL

        	$PERFCTL_CMD 2>/dev/null &
		# Determine if PerfStat Client is running
		sleep 3
		CheckPerfctlProc
	else
		echo "ERROR: PerfStat client does not have executable permission, Startup Aborted!"
		exit 1
	fi
	
	if [ "$PROC_PERFCTL" -ne "0" ];then
		echo "Done!"
		echo "Collecting data for: $METRICS"
	else
		echo "Error: Failed to start!"

		# Update Log File
       		echo "`$DATE_CMD '+[%a %b %d %H:%M:%S %Y]'` ERROR: Couldn't Startup PerfStat Client $VER" >>$PERFHOME/var/logs/perfctl.log

	fi
fi

exit 0
