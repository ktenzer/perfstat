use Tk;
use Win32::Service;
use Win32;

# Slurp in path to Perfhome
$perfhome=&PATH;
$perfhome =~ s/\\bin//;

# Slurp in Configuration
%conf       = ();
&GetConfiguration(\%conf);

@servicesBasic=split(' ', $conf{'BASIC_SERVICES'});
@servicesExt=split(' ', $conf{'EXT_SERVICES'});

$mw = MainWindow->new;
$mw->title("PerfMon Client Configuration");
$mw->geometry('300x300');
$mw->maxsize(350, 400);
$frame1 = $mw->Frame()->pack (side => 'top');
$frame2 = $mw->Frame()->pack (side => 'bottom');
$frame3 = $mw->Frame()->pack (side => 'right');
$frame4 = $mw->Frame()->pack (side => 'right');
$frame5 = $mw->Frame()->pack (side => 'left');

# Create label array
@label_col = (
        $frame1->Label ( -text => "PERFSERVER:", -width => 20 , -relief => 'groove' ),
        $frame1->Label ( -text => "Server Port:", -width => 20 , -relief => 'groove' ),
        $frame1->Label ( -text => "Run Interval:", -width => 20 , -relief => 'groove' ),
        $frame1->Label ( -text => "DEBUG:", -width => 20 , -relief => 'groove' ),
        $frame1->Label ( -text => "EXT Services:", -width => 20 , -relief => 'groove' ),
        $frame4->Button(-text => "Add", -width => 5, justify => 'center',
            -command => sub { &WinAddBasicSvc # Add metric to Listbox
                  })->pack(-anchor => 'center'),
        $frame4->Button(-text => "Del", -width => 5, justify => 'center',
            -command => sub { &WinDelBasicSvc # Del metric from Listbox
                })->pack(-anchor => 'center'),
);

# Create entry array populated by conf file
@data_col = (
        $frame1->Entry ( -width => 25 , -justify => 'left', -textvariable => \$conf{'PERFSERVER'}),
        $frame1->Entry ( -width => 25 , -justify => 'left', -textvariable => \$conf{'CLIENTPORT'}),
        $frame1->Entry ( -width => 25 , -justify => 'left', -textvariable => \$conf{'RUN_INTERVAL'}),
        $frame1->Entry ( -width => 25 , -justify => 'left', -textvariable => \$conf{'DEBUG'}),
        $frame1->Entry ( -width => 25 , -justify => 'left', -textvariable => \$conf{'EXT_SERVICES'}),
        $frame3->Button(-text => "Start Service", -width => 10, justify => 'right',
            -command => sub { &StartService # Start Perfmon Service
                  })->pack(-side => 'right'),
        $frame3->Button(-text => "Stop Service", -width => 10, justify => 'right',
            -command => sub { &StopService # Stop Perfmon Service
                  })->pack(-side => 'right'),
);

# Create columns array
@columns = (
        \@label_col,
        \@data_col,
);

# Build Columns and Rows
my $col = 0;
foreach my $column (@columns)
{
        my $row = 0;

        foreach my $entry (@$column)
        {
                $entry->grid(-column => $col, -row => $row, -padx => 4);
                $row++;
        }
        $col++;
}

&ListBasicServices;

$frame2->Button(-text => "Exit",
    -command => sub { exit;})->pack(-side => 'left');
$frame2->Button(-text => "Save",
    -command => sub { &SaveConfiguration; &WinSave #Save configuration to file
        })->pack(-side => 'bottom');

# Create Basic Services List Box
sub ListBasicServices {

  $frame5->Label ( -text => "Basic Services:", -width => 20 , -relief => 'groove' )
        ->pack(-side => 'top', -anchor => 'w', -padx => 4, -pady => '4');

  $xscroll = $frame5->Scrollbar(-orient => 'horizontal');
  $yscroll = $frame5->Scrollbar();

  $met_list=$frame5->Listbox(
        -width => 7,
        -height => 5,
        -selectmode => 'single',
        -exportselection => 0,
        -xscrollcommand => ['set', $xscroll],
        -yscrollcommand => ['set', $yscroll]);

  # Insert Metrics into listbox
  foreach $met (@servicesBasic) {
      $met_list->insert('end',$met);
  }

  # Create x and y scrollbars
  $xscroll->configure(-command => ['xview', $met_list]);
  $yscroll->configure(-command => ['yview', $met_list]);

  $xscroll->pack(-side => 'bottom', -fill => 'x');
  $yscroll->pack(-side => 'right', -fill => 'y');
  $met_list->pack(-side => 'left', -fill => 'both', -expand => 'yes');
}

# Create second Window
sub WinSave {
  $top1=$mw->Toplevel;
  $top1->title("Save Configuration");
  $top1->geometry('225x75');
  $top1->maxsize(225, 75);
  $top1->Label ( -text => "PerfMon configuration Saved.
      Do you want to quit?\n")->pack;
  $frame3 = $top1->Frame()->pack ( -side => 'bottom' ) ;
  $frame3->Button(-text => "No",
      -command => sub { $top1->withdraw;})->pack ( -side => 'left' );
  $frame3->Button(-text => "Yes",
      -command => sub { exit;})->pack(-side => 'right');
}

# Create third Window for service buttons
sub WinSvc {

  my @text=@_;
  
  $top1=$mw->Toplevel;
  $top1->title("Service Status");
  $top1->geometry('225x75');
  $top1->maxsize(225, 75);
  $top1->Label ( -text => "@text\n")->pack;
  $frame3 = $top1->Frame()->pack ( -side => 'bottom' ) ;
  $frame3->Button(-text => "OK",
      -command => sub { $top1->withdraw;})->pack ( -side => 'left' );
}

# Add metric to listbox
sub WinAddBasicSvc {

  $top1=$mw->Toplevel;
  $top1->title("Add Basic Service");
  $top1->geometry('225x75');
  $top1->maxsize(225, 75);
  $top1->Label ( -text => "Enter the Basic Service you would like to add below\n")->pack;
  $frame3 = $top1->Frame()->pack ( -side => 'bottom' ) ;
  $frame3->Entry ( -width => 20 , -justify => 'center', -textvariable => \$met_add)->pack();
  $frame3->Button(-text => "Exit",
      -command => sub { $top1->withdraw;})->pack ( -side => 'left' );
  $frame3->Button(-text => "OK",
      -command => sub { &CheckServices;  # Check Services and if correct add else display error
          })->pack(-side => 'bottom');
}

# Ensure correct services
sub CheckServices {

  if ($met_add =~ m/cpu|memory|fs|io|tcp|socket|procs|uptime/) {
        foreach $service (@servicesBasic) {

            if ($service =~ m/$met_add/) {
                $found="1";
            }
        }
        if (! defined $found) {
            push (@servicesBasic, $met_add);
            $met_list->insert('end', "$met_add");
            $top1->withdraw;
        } else {
            $top2=$mw->Toplevel;
            $top2->title("ERROR");
            $top2->geometry('275x75');
            $top2->maxsize(275, 75);
            $top2->Label ( -text => "Error: $met_add already Exists!")->pack;
            $frame7 = $top2->Frame()->pack ( -side => 'bottom' ) ;
            $frame7->Button(-text => "Exit",
                -command => sub { $top2->withdraw;})->pack ( -side => 'left' );
            $top1->withdraw;
        }
  } else {
      $top3=$mw->Toplevel;
      $top3->title("ERROR");
      $top3->geometry('275x75');
      $top3->maxsize(275, 75);
      $top3->Label ( -text => "Error: you must enter one of the following Basic Services:\ncpu, memory, fs, io, tcp, socket, procs, or uptime\n")->pack;
      $frame8 = $top3->Frame()->pack ( -side => 'bottom' ) ;
      $frame8->Button(-text => "Exit",
         -command => sub { $top3->withdraw;})->pack ( -side => 'left' );
      $top1->withdraw;
  }
}
# Delete metric from listbox
sub WinDelBasicSvc {

  $i="0";
  
  my $met_select_index=$met_list->curselection();

  $met_list->delete($met_select_index);
  
    foreach my $service (@servicesBasic) {
      if ($i =~ m/$met_select_index/) {
          $array_index="$i";
      }
      $i++;
  }
  splice(@servicesBasic,$array_index,$array_index);
}

# Save configuration to File
sub SaveConfiguration {

  # Get Selected services
  @met_save=$met_list->get(0, 'end');

  $file="$perfhome/etc/perf-conf";

  open(CONF, ">$file")
      or die "Couldn't open config file perf-conf: $!\n";

  print CONF "BASIC_SERVICES=@met_save\n";
  
  foreach $key (keys %conf) {
      next if ($key =~ m/BASIC_SERVICES/);
      print CONF "$key=$conf{$key}\n";
  }
  close (CONF);
}

# Start Perfmon Service
sub StartService {

  my $state=&CheckService;
  my $start_quit=();

  if ($state eq 1) {
      Win32::Service::StartService('', 'perfctl')
          or die "Can't start perfctl service! Not stopped\n";

      # Verify if service started
      while ($start_quit ne 1) {
          my $state=&CheckService;

          if ($state eq 4) {
            my $msg="The PerfMon Service Started!";
            &WinSvc($msg);
            $start_quit=1;
          }
          sleep 2;
      }
          
  } else {
      my $msg="The Perfmon service is not stopped!\nCannot start service";
      &WinSVC($msg);
  }

}

# Stop Perfmon Service
sub StopService {

  my $state=&CheckService;
  my $stop_quit=();

  if ($state eq 4) {
      Win32::Service::StopService('', 'perfctl')
          or die "Can't stop perfctl service! Not started\n";

      # Verify if service stopped
      while ($stop_quit ne 1) {
          my $state=&CheckService;

          if ($state eq 1) {
            my $msg="The PerfMon Service Stopped!";
            &WinSvc($msg);
            $stop_quit=1;
          }
          sleep 2;
      }

  } else {
      my $msg="The Perfmon service is not started!\nCannot stop service";
      &WinSvc($msg);
  }
}

# Check State of Perfmon Service
sub CheckService {

  Win32::Service::GetStatus( '','perfctl', \%status);
  
  return $status{CurrentState};
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
    $hashref->{$key}=$value;
  }
  close(FILE);
}

# Get path to perfctl executable
sub PATH {
  my $path = PerlApp::exe();
 	$path =~ s/[\w\d]+\.exe//;
 	return $path;
}

MainLoop;
