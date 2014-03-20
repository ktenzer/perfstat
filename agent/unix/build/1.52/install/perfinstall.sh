#!/bin/sh

# PerfStat Installation Script

if [ $# -lt 1 ]; then
	echo "ERROR: invalid parameters for $0"
	echo "Usage: $0 /path/to/perfhome [-automated] [-startup]"
	exit 1
else
	PERFHOME=$1
fi

# Source in PerfStat profile
. $PERFHOME/perf.profile

# Grab PerfStat Environmental Variables
SERVER=`$GREP_CMD "^SERVER=" $PERFHOME/etc/perf-conf |$SED_CMD 's/SERVER=//'`
VER=`$GREP_CMD "^VER=" $PERFHOME/etc/perf-conf |$SED_CMD 's/VER=//'`
USER=`$GREP_CMD "^USER=" $PERFHOME/etc/perf-conf |$SED_CMD 's/USER=//'`
GROUP=`$GREP_CMD "^GROUP=" $PERFHOME/etc/perf-conf |$SED_CMD 's/GROUP=//'`

### SubRoutines ###
VerifyUser () {

	# Verify User
	$CAT_CMD /etc/passwd |$GREP_CMD $USER 1> /dev/null

	if [ "$?" -ne "0" ]; then
		echo "ERROR: PerfStat user $USER doesn't exist, aborting installation"
		exit 1
	fi

	# Verify Group
	$CAT_CMD /etc/group |$GREP_CMD $GROUP 1> /dev/null
	if [ "$?" -ne "0" ]; then
		echo "ERROR: PerfStat group $GROUP doesn't exist, aborting installation"
		exit 1
	fi
}

SetPermissions () {

	$CHMOD_CMD -R 770 $PERFHOME
	if [ "$?" -ne "0" ]; then
		echo "ERROR: couldn't set permissions for $PERFHOME"
		exit 1
	fi

}

SetOwnership () {

	$CHOWN_CMD -R $USER:$GROUP $PERFHOME
	if [ "$?" -ne "0" ]; then
		echo "ERROR: couldn't set ownership for $PERFHOME"
		exit 1
	fi
}

SetVars () {

	# Get IP
	IP=`$CAT_CMD /etc/hosts |$GREP_CMD $HOSTNAME |$AWK_CMD '{print $1}'`

	# Set Perfhome/IP
	PERFHOME_SED=`echo $PERFHOME |$SED_CMD 's/\//\\\\\//g'`
	IP_SED=`echo $IP |$SED_CMD 's/\./\\\\\./g'`

	# Set OS Metrics
	if [ "$OS" = "SunOS" ]; then
		PS_CMD_SED=`echo $PS_CMD |$SED_CMD 's/\//\\\\\//g'`
		VMSTAT_CMD_SED=`echo $VMSTAT_CMD |$SED_CMD 's/\//\\\\\//g'`
		SWAP_CMD_SED=`echo $SWAP_CMD |$SED_CMD 's/\//\\\\\//g'`
		PRTCONF_CMD_SED=`echo $PRTCONF_CMD |$SED_CMD 's/\//\\\\\//g'`
		IOSTAT_CMD_SED=`echo $IOSTAT_CMD |$SED_CMD 's/\//\\\\\//g'`
		NETSTAT_CMD_SED=`echo $NETSTAT_CMD |$SED_CMD 's/\//\\\\\//g'`
		IFCONFIG_CMD_SED=`echo $IFCONFIG_CMD |$SED_CMD 's/\//\\\\\//g'`
		KSTAT_CMD_SED=`echo $KSTAT_CMD |$SED_CMD 's/\//\\\\\//g'`
		DF_CMD_SED=`echo $DF_CMD |$SED_CMD 's/\//\\\\\//g'`
	elif [ "$OS" = "Linux" ]; then
		PS_CMD_SED=`echo $PS_CMD |$SED_CMD 's/\//\\\\\//g'`
		VMSTAT_CMD_SED=`echo $VMSTAT_CMD |$SED_CMD 's/\//\\\\\//g'`
		IOSTAT_CMD_SED=`echo $IOSTAT_CMD |$SED_CMD 's/\//\\\\\//g'`
		DF_CMD_SED=`echo $DF_CMD |$SED_CMD 's/\//\\\\\//g'`
		NETSTAT_CMD_SED=`echo $NETSTAT_CMD |$SED_CMD 's/\//\\\\\//g'`
	fi

	# Set PerfStat Startup
	$CAT_CMD $PERFHOME/perf.sh |$SED_CMD "s/PERFHOME=.*/PERFHOME=$PERFHOME_SED/" > $PERFHOME/perf.sh.save
	$MV_CMD $PERFHOME/perf.sh.save $PERFHOME/perf.sh

	# Set PerfStat init script
	$CAT_CMD $PERFHOME/install/perf |$SED_CMD "s/PERFHOME=.*/PERFHOME=$PERFHOME_SED/" > $PERFHOME/install/perf.save
	$MV_CMD $PERFHOME/install/perf.save $PERFHOME/install/perf

	# Set APP Globals PerfStat Configuration
	if [ "$SERVER" = "y" -o "$SERVER" = "Y" ]; then
		if [ -f "$PERFHOME/cgi.tar" ];then
			cd $PERFHOME;$TAR_CMD -xf cgi.tar
			$RM_CMD -f cgi.tar
		fi
		if [ -f "$PERFHOME/bin.tar" ];then
			cd $PERFHOME;$TAR_CMD -xf bin.tar
			$RM_CMD -f bin.tar
		fi
		if [ -f "$PERFHOME/lib.tar" ];then
			cd $PERFHOME;$TAR_CMD -xf lib.tar
			$RM_CMD -f lib.tar
		fi
		if [ -f "$PERFHOME/src.tar" ];then
			cd $PERFHOME;$TAR_CMD -xf src.tar
			$RM_CMD -f src.tar
		fi
		$CAT_CMD $PERFHOME/etc/perf-conf |$SED_CMD "s/PERFHOME=.*/PERFHOME=$PERFHOME_SED/" |$SED_CMD "s/SERVERIP=.*/SERVERIP=$IP_SED/" |$SED_CMD "s/PERFSERVER=.*/PERFSERVER=$IP_SED/" > $PERFHOME/etc/perf-conf.save
		$MV_CMD $PERFHOME/etc/perf-conf.save $PERFHOME/etc/perf-conf

		$CAT_CMD $PERFHOME/cgi/app_globals.pl |$SED_CMD "s/\$perfhome = .*/\$perfhome = \"$PERFHOME_SED\"\;/" > $PERFHOME/cgi/app_globals.pl.save
		$MV_CMD $PERFHOME/cgi/app_globals.pl.save $PERFHOME/cgi/app_globals.pl

		# OS Specific Settings
		if [ "$OS" = "SunOS" ]; then
			$CAT_CMD $PERFHOME/etc/perf-conf |$SED_CMD "s/PS_CMD=.*/PS_CMD=$PS_CMD_SED/" |$SED_CMD "s/VMSTAT_CMD=.*/VMSTAT_CMD=$VMSTAT_CMD_SED/" |$SED_CMD "s/SWAP_CMD=.*/SWAP_CMD=$SWAP_CMD_SED/" |$SED_CMD "s/PRTCONF_CMD=.*/PRTCONF_CMD=$PRTCONF_CMD_SED/" |$SED_CMD "s/IOSTAT_CMD=.*/IOSTAT_CMD=$IOSTAT_CMD_SED/" |$SED_CMD "s/NETSTAT_CMD=.*/NETSTAT_CMD=$NETSTAT_CMD_SED/" |$SED_CMD "s/IFCONFIG_CMD=.*/IFCONFIG_CMD=$IFCONFIG_CMD_SED/" |$SED_CMD "s/KSTAT_CMD=.*/KSTAT_CMD=$KSTAT_CMD_SED/" |$SED_CMD "s/DF_CMD=.*/DF_CMD=$DF_CMD_SED/" > $PERFHOME/etc/perf-conf.save
			$MV_CMD $PERFHOME/etc/perf-conf.save $PERFHOME/etc/perf-conf
		elif [ "$OS" = "Linux" ]; then
			$CAT_CMD $PERFHOME/etc/perf-conf |$SED_CMD "s/PS_CMD=.*/PS_CMD=$PS_CMD_SED/" |$SED_CMD "s/VMSTAT_CMD=.*/VMSTAT_CMD=$VMSTAT_CMD_SED/" |$SED_CMD "s/IOSTAT_CMD=.*/IOSTAT_CMD=$IOSTAT_CMD_SED/" |$SED_CMD "s/NETSTAT_CMD=.*/NETSTAT_CMD=$NETSTAT_CMD_SED/" |$SED_CMD "s/DF_CMD=.*/DF_CMD=$DF_CMD_SED/" > $PERFHOME/etc/perf-conf.save
			$MV_CMD $PERFHOME/etc/perf-conf.save $PERFHOME/etc/perf-conf
		fi
	else 
		if [ -f "$PERFHOME/bin.tar" ];then
			cd $PERFHOME;$TAR_CMD -xf bin.tar
			$RM_CMD -f bin.tar
		fi
		if [ -f "$PERFHOME/src.tar" ];then
			cd $PERFHOME;$TAR_CMD -xf src.tar
			$RM_CMD -f src.tar
		fi
		$CAT_CMD $PERFHOME/etc/perf-conf |$SED_CMD "s/PERFHOME=.*/PERFHOME=$PERFHOME_SED/" |$SED_CMD "s/PERFSERVER=.*/PERFSERVER=$IP_SED/" > $PERFHOME/etc/perf-conf.save
		$MV_CMD $PERFHOME/etc/perf-conf.save $PERFHOME/etc/perf-conf

		# OS Specific Settings
		if [ "$OS" = "SunOS" ]; then
			$CAT_CMD $PERFHOME/etc/perf-conf |$SED_CMD "s/PS_CMD=.*/PS_CMD=$PS_CMD_SED/" |$SED_CMD "s/VMSTAT_CMD=.*/VMSTAT_CMD=$VMSTAT_CMD_SED/" |$SED_CMD "s/SWAP_CMD=.*/SWAP_CMD=$SWAP_CMD_SED/" |$SED_CMD "s/PRTCONF_CMD=.*/PRTCONF_CMD=$PRTCONF_CMD_SED/" |$SED_CMD "s/IOSTAT_CMD=.*/IOSTAT_CMD=$IOSTAT_CMD_SED/" |$SED_CMD "s/NETSTAT_CMD=.*/NETSTAT_CMD=$NETSTAT_CMD_SED/" |$SED_CMD "s/IFCONFIG_CMD=.*/IFCONFIG_CMD=$IFCONFIG_CMD_SED/" |$SED_CMD "s/KSTAT_CMD=.*/KSTAT_CMD=$KSTAT_CMD_SED/" |$SED_CMD "s/DF_CMD=.*/DF_CMD=$DF_CMD_SED/" > $PERFHOME/etc/perf-conf.save
			$MV_CMD $PERFHOME/etc/perf-conf.save $PERFHOME/etc/perf-conf
		elif [ "$OS" = "Linux" ]; then
			$CAT_CMD $PERFHOME/etc/perf-conf |$SED_CMD "s/PS_CMD=.*/PS_CMD=$PS_CMD_SED/" |$SED_CMD "s/VMSTAT_CMD=.*/VMSTAT_CMD=$VMSTAT_CMD_SED/" |$SED_CMD "s/IOSTAT_CMD=.*/IOSTAT_CMD=$IOSTAT_CMD_SED/" |$SED_CMD "s/NETSTAT_CMD=.*/NETSTAT_CMD=$NETSTAT_CMD_SED/" |$SED_CMD "s/DF_CMD=.*/DF_CMD=$DF_CMD_SED/" > $PERFHOME/etc/perf-conf.save
			$MV_CMD $PERFHOME/etc/perf-conf.save $PERFHOME/etc/perf-conf
		fi
	fi

}

Startup () {

	# Copy init script
	if [ ! -f /etc/init.d/perf ]; then
		$CP_CMD $PERFHOME/install/perf /etc/init.d
	fi

	# Setup symbolic link to rc script
	if [ "$OS" = "SunOS" ]; then
		if [ ! -f /etc/rc2.d/S99perf ]; then
			$LN_CMD -s /etc/init.d/perf /etc/rc2.d/S99perf
			$LN_CMD -s /etc/init.d/perf /etc/rc0.d/K10perf
		fi
	elif [ "$OS" = "Linux" ]; then
		if [ ! -f /etc/rc.d/rc2.d/S99perf -o ! -f /etc/rc.d/rc0.d/K10perf ]; then
			$CHKCONFIG_CMD --add perf
		fi
	fi
}

NoStartup () {

	# Remove init script
	if [ -f /etc/init.d/perf ]; then
		$RM_CMD /etc/init.d/perf
	fi

	# Remove symbolic links
	if [ "$OS" = "SunOS" ]; then
		if [ -f /etc/rc2.d/S99perf ]; then
			$RM_CMD /etc/rc2.d/S99perf
			$RM_CMD /etc/rc0.d/K10perf
		fi
	elif [ "$OS" = "Linux" ]; then
		if [ -f /etc/rc.d/rc2.d/S99perf -o -f /etc/rc.d/rc0.d/K10perf ]; then
			$CHKCONFIG_CMD --del perf
		fi
	fi

}

ConfigureApp () {

	if [ "$SERVER" = "y" -o "$SERVER" = "Y" ]; then
		$PERFHOME/bin/tools/perfconfig -global -root
		$PERFHOME/bin/tools/perfconfig -server -root
		$PERFHOME/bin/tools/perfconfig -client -root
	else
		$PERFHOME/bin/tools/perfconfig -global -root
		$PERFHOME/bin/tools/perfconfig -client -root
	fi

}

# Install using pre-configured perf-conf file if -automated options is used
if [ "$2" = "-automated" ];then

	VerifyUser
	SetVars
	SetOwnership
	SetPermissions

	if [ "$3" = "-startup" ];then
		Startup
	else
		NoStartup
	fi

	exit
fi
	
# Determine OS
OS=`$UNAME_CMD -s`
HOSTNAME=`$UNAME_CMD -a |$AWK_CMD '{print $2}'`

# Setup echo statements
if [ "$OS" = "SunOS" ];then
	ECHO_USER="Enter PerfStat User [$USER]:\c"
	ECHO_GROUP="Enter PerfStat Group [$GROUP]:\c"
	ECHO_PERMISSIONS="Changing ownership/permissions for the $perfhome directory [Y]:\c"
	ECHO_STARTUP="Start PerfStat automatically at boot [Y]:\c"
elif [ "$OS" = "Linux" ];then
	ECHO_USER="-n Enter PerfStat User [$USER]:"
	ECHO_GROUP="-n Enter PerfStat Group [$GROUP]:"
	ECHO_PERMISSIONS="-n Changing ownership/permissions for the $perfhome directory [Y]:"
	ECHO_STARTUP=" -n Start PerfStat automatically at boot [Y]:"
fi

clear
echo "---PerfStat $VER Installation---"

# Setup PerfStat user/group
echo $ECHO_USER
read ANS

if [ "$ANS" != "" ]; then
	USER=$ANS
fi	

echo $ECHO_GROUP
read ANS

if [ "$ANS" != "" ]; then
	GROUP=$ANS
fi	

### Run SubRoutines ###
VerifyUser
SetVars
SetOwnership

# Change Permissions on PerfStat dir
ANS=""
echo $ECHO_PERMISSIONS
read ANS

if [ "$ANS" = "" ]; then
	ANS="Y"
fi

if [ "$ANS" = "y" -o "$ANS" = "Y" ]; then
	SetPermissions
else
	echo "PerfStat $VER Installation aborted!"
	exit 1
fi	

# Set Startup
echo $ECHO_STARTUP
read ANS

if [ "$ANS" = "" ]; then
	ANS="Y"
fi

if [ "$ANS" = "y" -o "$ANS" = "Y" ]; then
	Startup
	sleep 2
else
	echo ""
	echo "You have chosen not to start PerfStat at boot!"
	NoStartup
	sleep 2
fi	

### Configure App ###
ConfigureApp
