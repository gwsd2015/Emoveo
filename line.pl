$line = "This is the best sentence. Ever. Period.";
print $line;
print "\n";
$line =~ s/\S+\s*//;
print "how many chars to remove from the end?\t";
$input = <STDIN>;
chomp $input;
for($i = 0; $i < $input; $i++){
	$line =~ s/(\S)$//i;
}
$line =~ s/\s{2,}/ /g;
print $line;
