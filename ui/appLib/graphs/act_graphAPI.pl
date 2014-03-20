#!/usr/bin/perl -w
# act_graphAPI.pl - Graph generating program utilizing rrdtool API

use CGI::Carp qw(carpout);
use RRDs;
use GD::Graph::pie;
use GD::Graph::bars;
use Storable qw(lock_retrieve);

# Slurp in path to Perfhome
my $perfhome="/perfstat/dev/1.52/server";
#my $perfhome=&PATH;
#$perfhome =~ s/\/cgi\/performanceMonitor\/content//;

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
my $serFile="$perfhome/cgi/appLib/graphs/graphData/$serID.ser";
#$serFile="$perfhome/cgi/appLib/graphs/graphData/$serID.ser";

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
my $total=();
my $pieNum=();

&RetrieveData;

# Handle graph data for GD Graphs and RRD Graphs
if ($action =~ m/^RRD/) {
	
	RRDs::graph( '-', @{$graphHashArray->{optionsArray}}, @{$graphHashArray->{DEF}}, @{$graphHashArray->{LINE}});
	#DEBUG: print "RRDs::graph( '-', @{$graphHashArray->{optionsArray}}, @{$graphHashArray->{DEF}}, @{$graphHashArray->{LINE}})\n";
	
	my $err1 = RRDs::error;
	if ( $err1 ) {
		warn ("RRD ERROR: $err1");
	}
} elsif ($action =~ m/^GD/) {

	# Determine if all data is 0 (Pie graphs can't be created when data is 0)
	my $graphType=$graphHashArray->{graphType};
	
	if ($graphType =~ m/pie/) {
		my @Name=();
		my @value=();
		$total="0";
		foreach my $array (@{$graphHashArray->{data}}) {
			foreach my $data (@{$array}) {
				
				warn "here\n";
				#next if ($data =~ m/^\w+/);
				warn "data: $data\n";
				$total=$data + $total;
			}
		}
		warn "Total: $total\n";
		if ($total == "0") {
			my @data=();
			@data=(['No Data'],[1]);
			&GraphOptions($graphHashArray->{graphType});
			my $myimage = $mygraph->plot(\@data) or die $mygraph->error;
			print $myimage->png;
		} else {
			&GraphOptions($graphHashArray->{graphType});
			my $myimage = $mygraph->plot(\@{$graphHashArray->{data}}) or die $mygraph->error;
			print $myimage->png;
		}
	} else {
		&GraphOptions($graphHashArray->{graphType});
		my $myimage = $mygraph->plot(\@{$graphHashArray->{data}}) or die $mygraph->error;
		print $myimage->png;
	}

	#print "test: @{$graphHashArray->{data}}, @{$graphHashArray->{label}}, @{$graphHashArray->{colors}}, $graphHashArray->{height}, $graphHashArray->{width}, $graphHashArray->{graphVerticalLabel}, $graphHashArray->{graphType}\n";

} else {
        warn "ERROR: Graph Failure, data is mungled!\n";
        exit(1);
}

# Setup graph options based on type
sub GraphOptions {
        my $graphType=$graphHashArray->{graphType};

        if ($graphType =~ m/pie/) {
		if ($total == "0") {
                	$mygraph = GD::Graph::pie->new($graphHashArray->{width}, $graphHashArray->{height});
                	$mygraph->set(
                        	'3d'		=> 1,
                        	dclrs		=> ['#EFEFEF'],
                	) or warn $mygraph->error;

                	# Set Font pie graphs
                	$mygraph->set_value_font(GD::gdMediumBoldFont);
                	$mygraph->set_label_font(GD::gdMediumBoldFont);
		} else {
                	$mygraph = GD::Graph::pie->new($graphHashArray->{width}, $graphHashArray->{height});
                	$mygraph->set(
                        	'3d'          => 1,
                        	label       => "@{$graphHashArray->{label}}",
                        	dclrs       => \@{$graphHashArray->{colors}},
                	) or warn $mygraph->error;

                	# Set Font pie graphs
                	$mygraph->set_value_font(GD::gdMediumBoldFont);
                	$mygraph->set_label_font(GD::gdMediumBoldFont);
		}
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
