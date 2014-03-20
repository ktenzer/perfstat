# PerfStat profile
# Set ENV variables needed for PerfStat operation

# Set Path
PATH="/bin:/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/ucb"

# Set Language
LANG="en_US"

# OS Specific Commands
CAT_CMD=/bin/cat
AWK_CMD=/bin/awk
GREP_CMD=/bin/grep
SED_CMD=/bin/sed
KILL_CMD=/bin/kill
RM_CMD=/bin/rm
MV_CMD=/bin/mv
ID_CMD=/usr/bin/id
PS_CMD=/bin/ps
SU_CMD=/bin/su
CHKCONFIG_CMD=/sbin/chkconfig
LN_CMD=/bin/ln
SETPGRP_CMD=/usr/bin/setpgrp
CP_CMD=/bin/cp
UNAME_CMD=/bin/uname
DATE_CMD=/bin/date
TAIL_CMD=/usr/bin/tail
CHMOD_CMD=/bin/chmod
CHOWN_CMD=/bin/chown
USERMOD_CMD=/usr/sbin/usermod
TAR_CMD=/bin/tar

# Metrics Commands
VMSTAT_CMD=/usr/bin/vmstat
IOSTAT_CMD=/usr/bin/iostat
NETSTAT_CMD=/bin/netstat
DF_CMD=/bin/df
SWAP_CMD=/usr/sbin/swap
PRTCONF_CMD=/usr/sbin/prtconf
IFCONFIG_CMD=/usr/sbin/ifconfig
KSTAT_CMD=/usr/bin/kstat
RPM_CMD=/bin/rpm

# Export Values so they are available to other programs
export PATH LANG CAT_CMD AWK_CMD GREP_CMD SED_CMD KILL_CMD RM_CMD ID_CMD PS_CMD SU_CMD CHKCONFIG_CMD SETPGRP_CMD LN_CMD CP_CMD UNAME_CMD DATE_CMD TAIL_CMD CHMOD_CMD CHOWN_CMD USERMOD_CMD VMSTAT_CMD IOSTAT_CMD NETSTAT_CMD DF_CMD SWAP_CMD PRTCONF_CMD IFCONFIG_CMD KSTAT_CMD
