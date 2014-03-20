# PerfMon Client Daemon
package PerlSvc;

use Win32::PerfLib;
use CGI::Carp qw(carpout);
use IO::Socket qw(:DEFAULT :crlf);
use POSIX qw(uname);
use Fcntl qw(:flock);

# Get Operating System
my $os = (uname)[0];
$os =~ s/ //g;

# Slurp in path to Perfhome
$perfhome=&PATH;
$perfhome =~ s/\\bin//;
$perfOutFile="$perfhome/tmp/perf.out";

$perf="$perfhome/bin/perf.exe";

# Remove perf out file if it exists
if (-f "$perfOutFile") {
    unlink "$perfOutFile"
        or die "ERROR: Couldn't delete $perfOutFile: $!\n";
}

# Slurp in Configuration
my %conf       = ();
&GetConfiguration(\%conf);

# Set Environment Variables from %conf
foreach $key (keys %conf) {
        $ENV{$key}="$conf{$key}";
}

# Convert Intervals from minutes to seconds
$ENV{'RUN_INTERVAL'}=$ENV{'RUN_INTERVAL'} * 60;

# Log all alerts and warnings to the below logfile
my $logfile = "$perfhome/var/perfctl.log";
open(LOGFILE, ">> $logfile")
	or die "Unable to append to $logfile: $!\n";
carpout(*LOGFILE);

# Remove counter files if exist
&CounterRemove;

# Organize rates of data collection
&DataCollection;

# Organize Normal services into hash for sorting
foreach my $serviceBasic (@serviceBasicNormal) {
	$intervalBasic_h{$serviceBasic}=$ENV{'RUN_INTERVAL'};
}

# Organize unique services into hash for sorting
foreach my $serviceBasic (@serviceBasicUnique) {
	$serviceBasic =~ m/(\S+):(\d+)/;
       	$serviceBasic=$1; my $interval=$2;
       	$interval=$interval * 60;
	$intervalBasic_h{$serviceBasic}=$interval;
}

# Organize Normal extention services into hash for sorting
foreach my $serviceExt (@serviceExtNormal) {
  $serviceExt="$perfhome/ext/$serviceExt";
	$intervalExt_h{$serviceExt}=$ENV{'RUN_INTERVAL'};
}

# Organize unique extention services into hash for sorting
foreach my $serviceExt (@serviceExtUnique) {
	$serviceExt =~ m/(\S+):(\d+)/;
       	$serviceExt=$1; my $interval=$2;
        $serviceExt="$perfhome/ext/$serviceExt";
       	$interval=$interval * 60;
	$intervalExt_h{$serviceExt}=$interval;
}

# Main Body of Program
# Run metrics and sleep for X interval
sub Startup {

  # Open connection to perfmon data counters
  $perflib = new Win32::PerfLib($server);

  while (ContinueRun(10)) {
    
    my $currTime=time;

    # Determine if this is the first time through
    if (! defined $first)  {
		  $first="1";

      # Build has relating basic service to it's runtime interval
		  foreach my $serviceBasic (keys %intervalBasic_h) {

			 $newtime=$currTime + $intervalBasic_h{$serviceBasic};
			 $timeBasic_h{$serviceBasic}=$newtime;
      }

      # Build has relating extention service to it's runtime interval
		  foreach my $serviceExt (keys %intervalExt_h) {

			 $newtime=$currTime + $intervalExt_h{$serviceExt};
			 $timeExt_h{$serviceExt}=$newtime;
      }
   
    } else {
		  # Run service and reset it's time counter if it is = or < the current time
		  foreach my $serviceBasic (keys %timeBasic_h) {

        my $updateTime=();
        if ($currTime >= $timeBasic_h{$serviceBasic}) {
				  my $updateTime=$currTime + $intervalBasic_h{$serviceBasic};
				  $timeBasic_h{$serviceBasic}=$updateTime;
          &RunProgram($serviceBasic);
			   }
      }
      
      # Run extention service and reset it's time counter if it is = or < the current time
		  foreach my $serviceExt (keys %timeExt_h) {

        my $updateTime=();
        if ($currTime >= $timeExt_h{$serviceExt}) {
          $extFlag="1";
				  my $updateTime=$currTime + $intervalExt_h{$serviceExt};
				  $timeExt_h{$serviceExt}=$updateTime;
				  &RunProgram($serviceExt,$extFlag);
			   }
      }

      # Send data if it has been collected
      if (-f "$perfOutFile") {
          &SendData;
      }
    }
 }
 # Close connection to perfmon data counters
 $perflib->Close();
}

# Determine data collection
sub DataCollection {
	foreach my $serviceBasic (@servicesBasic) {
		# Separate unique/normal intervals for basic services
		if ($serviceBasic =~ m/\S+:\d+/) {
			push(@serviceBasicUnique,$serviceBasic);
		} elsif ($serviceBasic =~ m/\S+/) {
			push(@serviceBasicNormal,$serviceBasic);
		}
	}
 
  foreach my $serviceExt (@servicesExt) {
    # Separate unique/normal intervals for extention services
    if ($serviceExt =~ m/\S+:\d+/) {
      push(@serviceExtUnique,$serviceExt);
    } elsif ($serviceExt =~ m/\S+/) {
      push(@serviceExtNormal,$serviceExt);
    }
	}
}

# Run data gathering/services programs
sub RunProgram {

	my $service=shift;
  my $extFlag=shift;

	# Run data colloection program, service, or status
	warn "DEBUG: Running $service Service\n" if ($ENV{'DEBUG'});

    # Run Service program
    if (! defined $extFlag) {
      &$service;

    } else {
      system($service);
    }
}

### Metrics Gathering Section ###

# CPU Sub
sub cpu {

  my $service="cpu";

  # Index numbers for PerfLib
  my $processor = 238;
  my $queue = 1300;
  my $sys = 6;
  my $usr = 142;
  my $priv = 144;
  my $queue_length = 1302;

  # Initialize some variables
  my $proc_ref0 = {};
  my $proc_ref1 = {};
  my $queue_ref0 = {};
  my $proc_time=();
  my $user_time=();
  my $priv_time=();
  my $load=();
  my $Numerator0=();
  my $Numerator1=();
  my $Denominator0=();
  my $Denominator1=();

  # Navigate PerfLib data structure
  $perflib->GetObjectList($processor, $proc_ref0);
  sleep 1;
  $perflib->GetObjectList($processor, $proc_ref1);
  $perflib->GetObjectList($queue, $queue_ref0);

  my $instance_ref0 = $proc_ref0->{Objects}->{$processor}->{Instances};
  my $instance_ref1 = $proc_ref1->{Objects}->{$processor}->{Instances};

  foreach $p (keys %{$instance_ref0}) {

    my $counter_ref0 = $instance_ref0->{$p}->{Counters};
    my $counter_ref1 = $instance_ref1->{$p}->{Counters};

    foreach $i (keys %{$counter_ref0}){

        # Get the total of all processors only
        if ($instance_ref0->{$p}->{Name} eq "_Total") {

            if($counter_ref0->{$i}->{CounterNameTitleIndex} == $usr) {

                my $Numerator0 = $counter_ref0->{$i}->{Counter};
                my $Denominator0 = $proc_ref0->{PerfTime100nSec};
                my $Numerator1 = $counter_ref1->{$i}->{Counter};
                my $Denominator1 = $proc_ref1->{PerfTime100nSec};
                $user_time = (($Numerator1 - $Numerator0) /
                    ($Denominator1 - $Denominator0 )) * 100;
            }

            if($counter_ref0->{$i}->{CounterNameTitleIndex} == $priv) {

                my $Numerator0 = $counter_ref0->{$i}->{Counter};
                my $Denominator0 = $proc_ref0->{PerfTime100nSec};
                my $Numerator1 = $counter_ref1->{$i}->{Counter};
                my $Denominator1 = $proc_ref1->{PerfTime100nSec};
                $priv_time = (($Numerator1 - $Numerator0) /
                    ($Denominator1 - $Denominator0 )) * 100;
            }

        }
      }
  }

  # Calculate processor Idle time
  my $idl_time=100 - ($user_time + $priv_time);
  
  # Gather Load Average
  my $instance_ref0 = $queue_ref0->{Objects}->{$queue}->{Instances};

  foreach $p (keys %{$instance_ref0}) {

      my $counter_ref0 = $instance_ref0->{$p}->{Counters};

      foreach $i (keys %{$counter_ref0}){

          # Get the total of all processors only
          if ($instance_ref0->{$p}->{Name} eq "Blocking Queue") {

              if($counter_ref0->{$i}->{CounterNameTitleIndex} == $queue_length) {
                  my $Numerator0 = $counter_ref0->{$i}->{Counter};
                  $load="$Numerator0";
              }
          }
      }
  }

  # Send Data to Perf Server
  my $perfOut="$os data $service $user_time $priv_time $idl_time $load";
  &PerfOut($perfOut);
      
}

# Memory Sub
sub memory {

  my $service="mem";
  
  # Index numbers for PerfLib
  my $memory = 4;
  my $swap = 700;
  my $avail_mem_index = 1382;
  my $committed_index = 26;
  my $pages_in_index = 822;
  my $pages_out_index = 48;
  my $page_faults_index = 28;
  my $swap_usage_index = 702;

  # Initialize some variables
  my $mem_ref0 = {};
  my $mem_ref1 = {};
  my $swap_ref0 = {};
  my $mem_avail_mb=();
  my $mem_comm_mb=();
  $pages_in=();
  $pages_out=();
  my $page_faults=();
  my $swap_used_pct=();
  my $Numerator0=();
  my $Denominator0=();

  # Navigate PerfLib data structure
  $perflib->GetObjectList($memory, $mem_ref0);
  $perflib->GetObjectList($memory, $mem_ref1);
  $perflib->GetObjectList($swap, $swap_ref0);

  my $instance_ref0 = $mem_ref0->{Objects}->{$memory}->{Counters};
  my $instance_ref1 = $mem_ref1->{Objects}->{$memory}->{Counters};

  # Gather memory info
  foreach $p (keys %{$instance_ref0}) {

    my $counter_ref0 = $instance_ref0->{$p};
    my $counter_ref1 = $instance_ref1->{$p};

    foreach $i (keys %{$counter_ref0}){

        if($counter_ref0->{CounterNameTitleIndex} == $avail_mem_index) {

            $mem_avail_mb=$counter_ref0->{Counter};
        }

        if($counter_ref0->{CounterNameTitleIndex} == $committed_index) {

            $mem_comm_mb=$counter_ref0->{Counter};
            $mem_comm_mb=$mem_comm_mb / 1024 /1024;

        }

        if($counter_ref0->{CounterNameTitleIndex} == $pages_in_index) {
            $pages_in = $counter_ref1->{Counter};
        }

        if($counter_ref0->{CounterNameTitleIndex} == $pages_out_index) {
            $pages_out = $counter_ref1->{Counter};
        }
    }
  }

  # Gather swap info
  my $instance_ref0 = $swap_ref0->{Objects}->{$swap}->{Instances};

  foreach $p (keys %{$instance_ref0}) {

    my $counter_ref0 = $instance_ref0->{$p}->{Counters};

    foreach $i (keys %{$counter_ref0}){

        # Get the total of all paging files
        if ($instance_ref0->{$p}->{Name} eq "_Total") {

            if($counter_ref0->{$i}->{CounterNameTitleIndex} == $swap_usage_index) {

                if ($counter_ref0->{$i}->{CounterType} == 0x20020400) {
                    $Numerator0 = $counter_ref0->{$i}->{Counter};
                }
                if ($counter_ref0->{$i}->{CounterType} == 0x40030403) {
                    $Denominator0 = $counter_ref0->{$i}->{Counter};
                }
                $swap_used_pct=($Numerator0 / $Denominator0) * 100;

            }
         }
    }
  }

  # Handle Counter Data
  $counterData="pages_in pages_out";
  &COUNTERS($service,$counterData);
  
  # Figure out memory utlization
  my $mem_total_mb=$mem_avail_mb + $mem_comm_mb;
  my $mem_used_pct=($mem_comm_mb / $mem_total_mb) * 100;

  # Send Data to Perf Server
  my $perfOut="$os data $service $mem_used_pct $swap_used_pct $pages_in $pages_out";
  &PerfOut($perfOut);
      
}

# File System Sub
sub fs {

  my $service="fs";

  # Index numbers for PerfLib
  my $disk = 236;
  my $disk_free_mb_index = 410;
  my $disk_free_pct_index = 408;


  # Initialize some variables
  my $disk_ref0 = {};
  my $disk_ref1 = {};
  my $disk_free_mb=();
  my $disk_free_pct=();
  my $Numerator0=();

  # Navigate PerfLib data structure
  $perflib->GetObjectList($disk, $disk_ref0);

  $perflib->GetObjectList($disk, $disk_ref1);
  $perflib->Close();

  my $instance_ref0 = $disk_ref0->{Objects}->{$disk}->{Instances};
  my $instance_ref1 = $disk_ref1->{Objects}->{$disk}->{Instances};

  foreach my $p (keys %{$instance_ref0}) {

      my $counter_ref0 = $instance_ref0->{$p}->{Counters};
      my $counter_ref1 = $instance_ref1->{$p}->{Counters};

      foreach my $i (keys %{$counter_ref0}){

          my $disk_name="$instance_ref0->{$p}->{Name}";
          $disk_name =~ s/://g;

          if ($disk_name eq "_Total") {
              $disk_name =~ s/_//g;
          }

          if ($counter_ref0->{$i}->{CounterNameTitleIndex} == $disk_free_pct_index) {
              my $Countertype = $counter_ref0->{$i}->{CounterType};

              if ($Countertype eq 1073939459) {
                  $Base0 = $counter_ref0->{$i}->{Counter};
              }

              if ($Countertype eq 537003008) {
                  $Numerator0 = $counter_ref0->{$i}->{Counter};
              }

              if (defined $Base0 && $Numerator0) {
                  $disk_free_pct = ($Numerator0 / $Base0) * 100;
                  # Reset Values for next calculation
                  $Base0=();
                  $Numerator0=();
                  $disk_used_pct = 100 - $disk_free_pct;
                  push (@{$diskfs_h{$disk_name}}, $disk_used_pct);
              }
          }
      }
  }

  # Send Data to Perf Server
  foreach $key (sort keys %diskfs_h) {
    $perfOut="$os data $service $key @{$diskfs_h{$key}}";

    &PerfOut($perfOut);
  }
  undef %diskfs_h;
}

# IO Sub
sub io {
  
  my $service="io";

  # Index numbers for PerfLib
  my $disk = 236;
  my $disk_read_index = 220;
  my $disk_write_index = 222;
  my $disk_busy_index = 200;


  # Initialize some variables
  my $disk_ref0 = {};
  my $disk_ref1 = {};
  my $disk_read_kb=();
  my $disk_write_kb=();
  my $disk_busy_pct=();
  my $Numerator0=();

  # Navigate PerfLib data structure
  $perflib->GetObjectList($disk, $disk_ref0);

  $perflib->GetObjectList($disk, $disk_ref1);
  $perflib->Close();

  my $instance_ref0 = $disk_ref0->{Objects}->{$disk}->{Instances};
  my $instance_ref1 = $disk_ref1->{Objects}->{$disk}->{Instances};

  foreach my $p (keys %{$instance_ref0}) {

      my $counter_ref0 = $instance_ref0->{$p}->{Counters};
      my $counter_ref1 = $instance_ref1->{$p}->{Counters};

      foreach my $i (keys %{$counter_ref0}){

          my $disk_name="$instance_ref0->{$p}->{Name}";
          $disk_name =~ s/://g;

          if ($disk_name eq "_Total") {
              $disk_name =~ s/_//g;
          }

          if ($counter_ref0->{$i}->{CounterNameTitleIndex} == $disk_read_index) {

              $avg_disk_read_bytes = $counter_ref1->{$i}->{Counter};
              #$avg_disk_read_kb=$avg_disk_read_bytes / 1024;
              $avg_disk_read_kb=(($avg_disk_read_kb * .0001) / 1024);

              # Handle Counter Data
              $counterData="avg_disk_read_kb";
              &COUNTERS($service,$counterData,$disk_name);

              push (@{$diskio_h{$disk_name}}, $avg_disk_read_kb);

          }

          if ($counter_ref0->{$i}->{CounterNameTitleIndex} == $disk_write_index) {

              $avg_disk_write_bytes = $counter_ref1->{$i}->{Counter};
              #$avg_disk_write_kb=$avg_disk_write_bytes / 1024;
              $avg_disk_write_kb=(($avg_disk_write_kb * .0001) / 1024);

              # Handle Counter Data
              $counterData="avg_disk_write_kb";
              &COUNTERS($service,$counterData,$disk_name);
              
              push (@{$diskio_h{$disk_name}}, $avg_disk_write_kb);

          }
      }
  }

  # Send Data to Perf Server
  foreach $key (sort keys %diskio_h) {
    $perfOut="$os data $service $key @{$diskio_h{$key}}";

    &PerfOut($perfOut);
  }
  undef %diskio_h;
}

# TCP Sub
sub tcp {

  my $service="tcp";
  
  # Index numbers for PerfLib
  my $tcp = 510;
  my $bytes_in_index = 264;
  my $bytes_out_index = 506;

  # Initialize some variables
  my $tcp_ref0 = {};
  my $tcp_ref1 = {};
  $bytes_in=();
  $bytes_out=();
  my $int_count=1;

  # Navigate PerfLib data structure
  $perflib->GetObjectList($tcp, $tcp_ref0);
  $perflib->GetObjectList($tcp, $tcp_ref1);

  my $instance_ref0 = $tcp_ref0->{Objects}->{$tcp}->{Instances};
  my $instance_ref1 = $tcp_ref1->{Objects}->{$tcp}->{Instances};

  foreach $p (keys %{$instance_ref0}) {

    my $counter_ref0 = $instance_ref0->{$p}->{Counters};
    my $counter_ref1 = $instance_ref1->{$p}->{Counters};

    foreach $i (keys %{$counter_ref0}){

        next if ($instance_ref0->{$p}->{Name} =~ m/MS TCP Loopback interface/);
          my $int_name = $instance_ref0->{$p}->{Name};
          $int_name =~ m/(\S*)\s*(\S*)\s*(\S*)/;
          $int_name = "$1 $2 $3";
          $int_name =~ s/ //g;

          if($counter_ref0->{$i}->{CounterNameTitleIndex} == $bytes_in_index) {

            $bytes_in = $counter_ref1->{$i}->{Counter};
            $bytest_in = $bytes_in * .0001;

            # Handle adapters with the same name
            if (defined @{$traffic_h{$int_name}}[1]) {
                $int_name="$int_name#$int_count";
                $int_count++;
            }

            # Handle Counter Data
            $counterData="bytes_in";
            &COUNTERS($service,$counterData,$int_name);

            push (@{$traffic_h{$int_name}}, $bytes_in);

          }

          if($counter_ref0->{$i}->{CounterNameTitleIndex} == $bytes_out_index) {

            $bytes_out = $counter_ref1->{$i}->{Counter};
            $bytest_out = $bytes_out * .0001;

            # Handle adapters with the same name
            if (defined @{$traffic_h{$int_name}}[0]) {
                $int_name="$int_name#$int_count";
            }

            # Handle Counter Data
            $counterData="bytes_out";
            &COUNTERS($service,$counterData,$int_name);
            
            push (@{$traffic_h{$int_name}}, $bytes_out);

          }
      }
  }

  # Send Data to Perf Server
  foreach $key (sort keys %traffic_h) {
    $perfOut="$os data $service $key @{$traffic_h{$key}}";
    &PerfOut($perfOut);
      
  }
  undef %traffic_h;
}

# Socket Sub
sub socket {

  my $service="socket";
  
  # Index numbers for PerfLib
  my $socket = 638;
  my $sock_est_index = 642;
  my $sock_active_index = 644;
  my $sock_passive_index = 646;

  # Initialize some variables
  my $socket_ref0 = {};
  my $socket_ref1 = {};
  my $sock_est=();
  $sock_active=();
  $sock_passive=();
  my $Numerator0=();

  # Navigate PerfLib data structure
  $perflib->GetObjectList($socket, $socket_ref0);
  $perflib->GetObjectList($socket, $socket_ref1);

  my $instance_ref0 = $socket_ref0->{Objects}->{$socket}->{Counters};
  my $instance_ref1 = $socket_ref1->{Objects}->{$processor}->{Counters};

  foreach $p (keys %{$instance_ref0}) {

    my $counter_ref0 = $instance_ref0->{$p};
    my $counter_ref1 = $instance_ref1->{$p};

    foreach $i (keys %{$counter_ref0}){

        if($counter_ref0->{CounterNameTitleIndex} == $sock_est_index) {
          my $Numerator0 = $counter_ref0->{Counter};
          $sock_est = $Numerator0;
        }

        if($counter_ref0->{CounterNameTitleIndex} == $sock_active_index) {
          my $Numerator0 = $counter_ref0->{Counter};
          $sock_active = $Numerator0;
        }

        if($counter_ref0->{CounterNameTitleIndex} == $sock_passive_index) {
          my $Numerator0 = $counter_ref0->{Counter};
          $sock_passive = $Numerator0;
        }
    }
  }

  # Handle Counter Data
  $counterData="sock_active sock_passive";
  &COUNTERS($service,$counterData);

  # Send Data to Perf Server
  $perfOut="$os data $service $sock_active $sock_passive $sock_est";
  &PerfOut($perfOut);
      
}

# Process Sub
sub procs {

  my $service="procs";
  # Index numbers for PerfLib
  my $system = 2;
  my $proc_index = 248;

  # Initialize some variables
  my $proc_ref0 = {};
  my $procs=();

  # Navigate PerfLib data structure
  $perflib->GetObjectList($system, $proc_ref0);

  my $instance_ref0 = $proc_ref0->{Objects}->{$system}->{Counters};

  foreach $p (keys %{$instance_ref0}) {

    my $counter_ref0 = $instance_ref0->{$p};

    foreach $i (keys %{$counter_ref0}){

        # Get the system uptime

        if($counter_ref0->{CounterNameTitleIndex} == $proc_index) {

          $procs = $counter_ref0->{Counter};
        }
     }
  }

  # Send Data to Perf Server
  my $perfOut="$os data $service $procs";
  &PerfOut($perfOut);
      
}

# Uptime Sub
sub uptime {

  my $service="uptime";
  
  # Index numbers for PerfLib
  my $system = 2;
  my $uptime_index = 674;

  # Initialize some variables
  my $sys_ref0 = {};
  my $uptime=();
  my $Denominator0=();
  my $Timebase=();

  # Navigate PerfLib data structure
  $perflib->GetObjectList($system, $sys_ref0);

  my $instance_ref0 = $sys_ref0->{Objects}->{$system}->{Counters};

  foreach $p (keys %{$instance_ref0}) {

    my $counter_ref0 = $instance_ref0->{$p};

    foreach $i (keys %{$counter_ref0}){

        # Get the system uptime

        if($counter_ref0->{CounterNameTitleIndex} == $uptime_index) {

          my $Denominator0 = $sys_ref0->{PerfTime};
          my $Timebase = $sys_ref0->{PerfFreq};
          #print "Den: $Denominator0 Num: $Numerator0 Time: $Timebase\n";
          $uptimeSec = int($Denominator0 / $Timebase);
        }
     }
  }

  # Calculate uptime data
  $uptimeMin=$uptimeSec / 60;
  $uptimeHour=$uptimeMin / 60;
  $uptimeHour=sprintf("%.2f",$uptimeHour);

  # Write data to perf outfile
  my $perfOut="$os data $service $uptimeHour";
  &PerfOut($perfOut);

}

# Get actual value from counter
sub COUNTERS {

  # Get counters and split into array
  my $service=shift;
  my $counters=shift;
  my $device=shift;
  
  my @counters=split " ",$counters;

  foreach my $counter (@counters) {
      if (defined $device) {
          $counterName="$device.$counter";
      } else {
          $counterName="$counter";
      }
      
      if (! -f "$perfhome/tmp/counters/$service.$counterName") {
          open(COUNTER, ">$perfhome/tmp/counters/$service.$counterName")
              or die "WARNING: Couldn't open counter for $service.$counterName: $!\n";
          print COUNTER "${$counter}";

          close (COUNTER);

          # Set to 0 since we don't know the last value
          ${$counter}="0";
      } else {

          # Open for read
          open(COUNTER, "< $perfhome/tmp/counters/$service.$counterName")
              or die "WARNING: Couldn't open counter for $service.$counterName: $!\n";

          $data=<COUNTER>;
          close (COUNTER);

          # Open for write
          open(COUNTER, "> $perfhome/tmp/counters/$service.$counterName")
              or die "WARNING: Couldn't open counter for $service.$counterName: $!\n";

          print COUNTER "${$counter}";

          close (COUNTER);

          ${$counter}=${$counter} - $data;
      }
  }
}

# Delete metrics counters
sub CounterRemove {

  my $counterDir="$perfhome/tmp/counters";

  opendir(COUNTERDIR, $counterDir)
      or die "Couldn't open $counterDir directory: $!\n";

  while (defined ($file = readdir(COUNTERDIR))) {
      # Skip "." and ".."
      next if $file =~ m/^\.\.?$/;

      # Remove counter file
      if (-f "$counterDir/$file") {
          unlink "$counterDir/$file"
              or die "ERROR: Couldn't delete $counterDir/$file: $!\n";
      }
  }
}

# Write data to perf output file
sub PerfOut {

  my $perfOut=shift;
  
  open(PERFOUT, ">> $perfOutFile")
      or die "WARNING: Couldn't open file handle for $perfOutFile: $!\n";

  flock(PERFOUT, LOCK_EX)
      or die "WARNING: Couldn't obtain exclusive lock on $perfOutFile: $!\n";

  print PERFOUT "$perfOut\n";

  flock(PERFOUT, LOCK_UN)
      or die "WARNING: Couldn't release lock on $perfOutFile: $!\n";
      
}

# Send data to PerfStat server
sub SendData {

  my @data=();
  
  # Open perf out file and obtain lock
  open(PERFOUT, "< $perfOutFile")
      or die "ERROR: Couldn't open file handle to $perfOutFile: $!\n";

  flock(PERFOUT, LOCK_EX)
      or die "ERROR: Couldn't obtain shared lock for $perfOutFile: $!\n";

  # Slurp in contents of perf out
  while (<PERFOUT>) {
      push(@data, $_);
  }

  close (PERFOUT);
  
  # Remove perf out file
  unlink "$perfOutFile"
      or die "ERROR: Couldn't delete $perfOutFile: $!\n";

  # Prepare and send data to PerfStat server
  my $perfOut=join(":", @data);
  $perfOut =~ s/\n//g;

  my $socket = IO::Socket::INET->new( Proto    => "tcp",
                                      PeerAddr => "$ENV{'PERFSERVER'}",
				                              PeerPort => $ENV{'CLIENTPORT'},
		                                  Timeout  => 5)
          or undef $socket;

  # Send data to server or send alert
  if (defined $socket) {

      warn "DEBUG: Sending \"$perfOut\" to $server $ENV{'CLIENTPORT'}\n" if $ENV{'DEBUG'};

      print $socket "$perfOut";
      
      close $socket;
  } else {
      warn "Error: Couldn't Connect to $ENV{'PERFSERVER'}\n";
  }
}

# Get configuration dynamically from perf-conf
sub GetConfiguration {

  my $configfile="$perfhome/etc/perf-conf";
  my $hashref = shift;

  open(FILE, $configfile)
      or die "Couldn't open FileHandle for $configfile: $!\n";

  my @data=<FILE>;
  foreach $line (@data) {

    # Skip line if commented out
    next if ($line =~ m/^#/);
    $line =~ m/(\w+)=(.+)/;

    my $key=$1;
    my $value=$2;

		if ($key =~ m/^BASIC_SERVICES/) {
			@servicesBasic=split(/\s+/, $value);
    } elsif ($key =~ m/^EXT_SERVICES/) {
      @servicesExt=split(/\s+/, $value);
		} else {
 	    $hashref->{$key}=$value;
		}
  }
  close(FILE);
}

# Get path to perfctl executable
sub PATH {
  my $path = PerlSvc::exe();
 	$path =~ s/[\w\d]+\.exe//;
 	return $path;
}

# Install PerfMon as Service
sub Install {

    $Config{ServiceName} = 'Perfctl';
    $Config{DisplayName} = 'PerfStat Client';
    $Config{Description} = 'Sends performance data to PerfStat Server.';

    print "\nPerfmon Client Service Installed\n";
}

# Remove PerfMon as Service
sub Remove {

    $Config{ServiceName} = 'Perfctl';

    print "\nPerfmon Client Removed\n";
}


package main;
