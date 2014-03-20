# act_graphAPI.pl - Graph generating program utilizing rrdtool API

use strict;
use CGI::Carp qw(carpout);
use RRDs;
use GD::Graph::pie;
use GD::Graph::bars;
use Storable qw(lock_retrieve);

# Slurp in path to Perfhome
my $perfhome=&PATH;
$perfhome =~ s/\/cgi\/performanceMonitor\/content//;

# Log all alerts and warnings to the below logfile
my $logfile = "$perfhome/var/logs/cgi.log";
open(LOGFILE, ">> $logfile")
        or die "ERROR: Unable to append to $logfile: $!\n";
carpout(*LOGFILE);

# Parse Graph Data
my $buffer=join(" ",@ARGV);
my @data=split(",",$buffer);
my $action=$data[0];

# Find Ser File
my $serID=$data[1];
my $serFile="$perfhome/cgi/performanceMonitor/content/graphData/$serID.ser";

# Define graphHashArray
my %graphHashArray=();
my $graphHashArray=[];

# Define GD Graph values
my $mygraph=();
my $height=();
my $width=();
my $graphVerticalLabel=();
my @colors=[];
my @label=[];


&RetrieveData;

# Handle graph data for GD Graphs and RRD Graphs
if ($action =~ m/^RRD/) {

	#print "RRDs::graph( '-', @{$graphHashArray->{optionsArray}}, @{$graphHashArray->{DEF}}, @{$graphHashArray->{LINE}})\n";
	RRDs::graph( '-', @{$graphHashArray->{optionsArray}}, @{$graphHashArray->{DEF}}, @{$graphHashArray->{LINE}});
	my $err1 = RRDs::error;
	if ( $err1 ) {
		warn ("RRD ERROR: $err1");
	}
} elsif ($action =~ m/^GD/) {

	&GraphOptions($graphHashArray->{graphType});
	my $myimage = $mygraph->plot(\@{$graphHashArray->{data}}) or die $mygraph->error;
	print $myimage->png;

	#print "test: @{$graphHashArray->{data}}, @{$graphHashArray->{label}}, @{$graphHashArray->{colors}}, $graphHashArray->{height}, $graphHashArray->{width}, $graphHashArray->{graphVerticalLabel}, $graphHashArray->{graphType}\n";

} else {
        warn "ERROR: Graph Failure, data is mungled!\n";
        exit(1);
}

# Setup graph options based on type
sub GraphOptions {
        my $graphType=$graphHashArray->{graphType};

        if ($graphType =~ m/pie/) {
                $mygraph = GD::Graph::pie->new($graphHashArray->{width}, $graphHashArray->{height});
                $mygraph->set(
                        '3d'          => 1,
                        label       => "@{$graphHashArray->{label}}",
                        dclrs       => \@{$graphHashArray->{colors}},
                ) or warn $mygraph->error;

                # Set Font pie graphs
                $mygraph->set_value_font(GD::gdMediumBoldFont);
                $mygraph->set_label_font(GD::gdMediumBoldFont);

        } elsif ($graphType =~ m/bar/) {
                $mygraph = GD::Graph::bars->new($graphHashArray->{width}, $graphHashArray->{height});
                $mygraph->set(
                        x_label     => '',
                        y_label     => "$graphHashArray->{graphVerticalLabel}",
                        bar_spacing => "10",
                        cycle_clrs  => "1",
                        dclrs       => \@{$graphHashArray->{colors}},
                ) or warn $mygraph->error;

                # Set Font for bar graphs
                $mygraph->set_x_axis_font(GD::gdMediumBoldFont);
                $mygraph->set_y_axis_font(GD::gdMediumBoldFont);
                $mygraph->set_x_label_font(GD::gdMediumBoldFont);
                $mygraph->set_y_label_font(GD::gdMediumBoldFont);
        }
}

# Retrieve Graph Data from ser file
sub RetrieveData {

	# De-serialize graph data
	$graphHashArray=lock_retrieve("$serFile")
		or die "ERROR: Couldn't de-serialize /tmp/$serFile: $!\n";

	# Remove ser file once the data has been de-serialized
	unlink "$serFile"
		or die "ERROR: Couldn't remove file $serFile: $!\n";
}

# Get path to perfctl executable
sub PATH {
  my $path = PerlApp::exe();
        $path =~ s/\/\w*$//;
        return $path;
}

1;
