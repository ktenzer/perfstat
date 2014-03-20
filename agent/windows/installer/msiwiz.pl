use strict;
require "FileData.pl";
require "ScriptGenerator.pl";
use Cwd;
use File::Copy;

###################################################################################################
sub usage {
    print <<"HERE";
usage: $0 <company_name> <product_dir> <product_name> <product_version> <product_version_name> [<File_Source_Root>] [<ValidatorPath>] [<QA_Path>]

<company_name>          As it is.(My Great World Dominating Company)
<product_dir>           Path to the product.(C:\\Test\\MyProductFolder)
<product_name>          Name of the product.(MyProductName)
<product_version>       Product version.(1.0.0.1901)
<product_version_name>  Product version name.(1.0 Beta 1)
[<File_Source_Root>]    Where to get files for copying to <product_dir>(C:\\dev\\myProjects) 
[<ValidatorPath>]       Path to "msival2.exe" folder(C:\\Program Files\\MsiVal2)
[<QA_Path>]             Where to put the copy of msi database(\\\\QA\Home\MyProductQA) 
HERE

}
###################################################################################################

if($#ARGV<=4){ usage() and exit ;}
my $i = 0;
my $company_name = $ARGV[$i++];
my $product_dir = $ARGV[$i++];
my $product_name = $ARGV[$i++];
my $ProdVesion = $ARGV[$i++];
my $BetaVesion = $ARGV[$i++];
my $sourse_root_dir = "";
if($#ARGV>($i-1)){$sourse_root_dir = $ARGV[$i++];}
my $ValidatorPath = "";
if($#ARGV>($i-1)){$ValidatorPath = $ARGV[$i++];}
my $QA_Path = "";
if($#ARGV>($i-1)){$QA_Path = $ARGV[$i++];}


my $wizard_dir = $0;
if($wizard_dir =~ /(.*)[\\\/].*/){
    $wizard_dir = $1;
}else{
    $wizard_dir = cwd();
}
$wizard_dir =~ s#\\#/#g;
my $top_dir = $product_dir;
$top_dir =~ /(.*)[\\\/](.*)/;
my $image_dir = $1;
my $out_file = $wizard_dir . '\\OUTPUT\\' . $2 . '.pl';
$out_file =~ s/ /_/g;

my $self_reg_exts = 'dll|exe|ocx';
my $body_section;
my $fh;

(my $temp1 = $BetaVesion) =~ s/ //g;
(my $temp = $product_name) =~ s/ //g;
$ProdVesion =~ /(.*\..*\..*)\.(.*)/;
my $msi_db = $temp . '-' . $1 . '-' . $temp1 . '-' . $2  . ".msi";
$msi_db =~ s/ /_/g;

if(length($sourse_root_dir)>0 && Request("Do you want to refresh files? [Y]:")!=-1){
    RefreshFiles($sourse_root_dir . "\\",$product_dir . "\\",FileData(),Directories());
}
if(Request("Do you want to refresh script for DB generation? [Y]:")!=-1){
    GenerateScript($company_name,$product_dir,$product_name,$ProdVesion,$BetaVesion,$msi_db);
    print "Created file $out_file\n" if $out_file;
}
my $dbCreated = 0;
if(Request("Do you want to run script for DB generation? [Y]:")!=-1){
    $dbCreated = system("$out_file");
}

if($dbCreated == 0){
    if(length($ValidatorPath)>0 && Request("Do you want to Validate DB? [Y]:")!=-1){
        system("CALL \"$ValidatorPath\\msival2.exe\" \"$wizard_dir\\OUTPUT\\$msi_db\" \"$ValidatorPath\\darice.cub\" -f");
    }
    if(length($QA_Path)>0 && Request("Do you want to copy to QA? [Y]:")!=-1){
        system("copy \"$wizard_dir\\OUTPUT\\$msi_db\" \"$QA_Path\"");
    }
}



###################################################################################################
sub Request {
    print shift;
    chomp(my $input = <STDIN>);
    if(!$input){
        return 0;
    }elsif($input=~/^y$/i || $input=~/^yes$/i){
        return 1;
    }

    return -1;
}

###################################################################################################
sub RefreshFiles{
    my $SourceRoot = shift;
    my $TargetRoot = shift;
    my $file_data = shift;
    my $directories = shift;


    my $count = 0;
    my $FCopied = 0;
    system("DEL /F /S /Q \"$TargetRoot\\*.*\"");
    
    foreach my $dir (@$directories){
        system("IF NOT EXIST \"$TargetRoot$dir\" MKDIR \"$TargetRoot$dir\"");
    }
    
    foreach my $f (keys %{$file_data}){
        $count++;
        if(system("copy \"$SourceRoot$f\" \"$TargetRoot$file_data->{$f}\"")==0){
            $FCopied++;
        }else{
            print "$SourceRoot$f\n";
        }
    }
    
    print "Total $FCopied files copied, expected $count files.\n"    ; 


} 

###################################################################################################
	
__DATA__

=head1 NAME

_msiwiz.pl

=head1 DESCRIPTION

This script will generate a template script which in turn will generate an MSI
installation database. The resulting script can then be customized mainly using
the interfaces defined by MSI::Installer and also by the interfaces defined by
the other MSI::* modules. This script can be run in batch mode or
interactively. In batch, configuration options are specified on the command
line while interactive mode will prompt the user for each configuration option.
By default the resulting script is written to STDOUT. If the `-o' option is 
specified the resulting script will be written to the file specified by that 
option.
	 
=head1 SEE ALSO

L<MSI::Installer>, L<MSI::Image>, L<MSI::DB>, L<Win32::Cabinet>, L<perl>

=head1 COPYRIGHT

Copyright (c) 2000, ActiveState Tool Corp. All rights reserved.

=cut

__END__