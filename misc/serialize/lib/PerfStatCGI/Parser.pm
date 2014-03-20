package PerfStatCGI::Parser;

#convert file containing perfstat markup language to executable perl file
sub html2Perl()
{
	#Accept the passed in variable fileName
	my ($this, $htmlFileName) = @_;
	if (!defined($htmlFileName)) {
		die("no file argument\n");
	}
	$htmlFileName =~ s/^[ \t]+//;
	
	#Test for .html extension
	if ($htmlFileName !~ /\.htm$|\.html$/) { 
		die("not an html file: $htmlFileName\n");
	}

	#Test if file exists
	if ( !(-e $htmlFileName))
	{
		die("file name does not exist: $htmlFileName\n");
	}


	#Derive the perlFileName from the html file name
	$perlFileName = $htmlFileName;
	$perlFileName =~ s/.htm$|.html$//;
	$perlFileName = $perlFileName  . ".pl";

	#Determine if we should parse the html file to create the perl file
	my $doParse = 0;
	if ( !(-e $perlFileName)) #if perl file doesn't exist do the parse
	{
		$doParse = 1;
	}
	else #if perl file older that html file
	{
		if (-M $perlFileName > -M $htmlFileName)
		{
			$doParse = 1;
		}
	}
	
	if ($doParse == 1)
	{
		#Open the html file for reading
		open(INPUT, "$htmlFileName") or die("Unable to open $htmlFileName: $!\n");
		#Open the perl file for writing
		open(OUTPUT, ">$perlFileName") or die("Unable to open $perlFileName: $!\n");

		#Write the strict pragma and package main statement
		print OUTPUT ("use strict;\n");
		print OUTPUT ("package main;\n");
		print OUTPUT ($line);
		#Parse line of input and write to output
		$counter = 0;
		$line = <INPUT>;
		while ($line ne "")
		 {
			$line = parseLine($line, \$counter);
			print OUTPUT ($line);
			$line = <INPUT>;
		}

		close(INPUT);
		close(OUTPUT);
	}
	return 1;
}

#utility function for pml2Perl
sub parseLine
{
	my ($line) = @_;
	
	if ($line =~ /^\n$/) 
	#if line is blank
	{
		#do nothing
	}
	elsif ($line =~ /^[\s]*%/)
	#if line starts with %, remove % and return
	{
		$line =~ s/^[\s]*%//;
	}
	else
	{
		my $startPoint = $counter;
		my $formulaNumber = $startPoint;
		
		#replace each <%...%> with a distinctive mark: <%...%>1, <%...%>2, etc
		$line =~ s/%>/"%>".$formulaNumber++/ge;
		
		#update startPoint in main
		$counter = $formulaNumber;
	
		#pull out each distinctive <%...%> for initial execute block
		$formulaNumber = $startPoint;
		$pattern = "<%(.*)%>".$formulaNumber;
		$evalBlock = "";
		while ($line =~ /$pattern/g) {
			$leftValue = "my \$formula".$formulaNumber;
			$rightValue = $1;
			$tempString = $leftValue . "=" . $rightValue . ";";
			$evalBlock .= $tempString;
			$formulaNumber++;
			$pattern = "<%(.*)%>".$formulaNumber;
		}

		#replace each distinctive <%...%>1 with value from eval block
		$formulaNumber = $startPoint;
		$pattern = "<%(.*)%>".$formulaNumber;
		while ($line =~ /$pattern/) {
			$line =~ s/$pattern/"\$formula".$formulaNumber/e;
			$formulaNumber++;
			$pattern = "<%(.*)%>".$formulaNumber;
		}

		#escape special characters
		$line =~ s/"/\\"/g;
		$line =~ s/\$/\\\$/g;

		#unescape special eval value block
		$line =~ s/\\\$formula/\$formula/g;

		#Add Perl Print statement;
		if(!eof){chop($line)};
		$line = "print(\"" . $line . "\\n\");\n";
		#Add eval block
		$line = $evalBlock . $line;
	}
	return $line;
}
1; #terminate the package