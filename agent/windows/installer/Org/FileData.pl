use warnings;
use strict;
##############################################################
#
#   To copy files to the product folder you should write them into 
#   %FILES, where keys are source file path relative to source root folder 
#   and values are target file paths relative to product folder. 
#   @CreateDir - directories to create inside product folder.
##############################################################

my $SDirActive = "ActiveProduct\\deploy\\";

our @CreateDir = ('ActiveProduct');
our %FILES = (
        
        $SDirActive . "active.css"				=> "doc\\Active.css",
        $SDirActive . "license.rtf"				=> "doc\\license.rtf",
        $SDirActive . "manual.html"				=> "doc\\manual.html",
        $SDirActive . "readme.html"				=> "doc\\readme.html",
        
        );

###########################################################################################################################
##########################################################################################################################

sub FileData{\%FILES;};
sub Directories{\@CreateDir;};

