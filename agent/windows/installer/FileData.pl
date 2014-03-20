use warnings;
use strict;
##############################################################
#
#   To copy files to the product folder you should write them into 
#   %FILES, where keys are source file path relative to source root folder 
#   and values are target file paths relative to product folder. 
#   @CreateDir - directories to create inside product folder.
##############################################################

#my $SDirActive = "1.50";

our @CreateDir = ('bin','doc','etc','var','tmp','tmp\\counters');
our %FILES = (
        
        "bin\\perfctl.exe"				=> "\\bin\\perfctl.exe",
        "bin\\perf.exe"					=> "\\bin\\perf.exe",
        "bin\\perfconfig.exe"				=> "\\bin\\perfconfig.exe",
       	"doc\\changes.txt"				=> "\\doc\\changes.txt",
	"doc\\license.rtf"				=> "\\doc\\license.rtf",
	"doc\\readme.txt"				=> "\\doc\\readme.txt",
	"doc\\readme.html"				=> "\\doc\\readme.html",
	"etc\\perf-conf"				=> "\\etc\\perf-conf",
        
        );

###########################################################################################################################
##########################################################################################################################

sub FileData{\%FILES;};
sub Directories{\@CreateDir;};

