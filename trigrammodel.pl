use utf8;

my $input = 'c:/Perl64/data.txt';
open (INPUT, $input) or die "Input file not found.\n";
my $output = 'c:/Perl64/englishtrigram.txt';
open (OUTPUT, '>' .$output) or die "Can't create $output.\n";

while(<INPUT>){
	tr/A-Z/a-z/;
	tr/.,:;!&?"'(){}\-\ˆ\$\_\+\=\[\]\@\/\*\>\<//d;
	s/[0-9]//g;
	s/ \^ //g;
	s/\s+/ /g;
	s/\t+//g;
	s/\n+//g; 		
	@threegrams = split (/\s/, $_);
	%frequency;
	for($i = 0; $i < $#threegrams; $i++){
		$trigram = $threegrams[$i].$threegrams[$i+1].$threegrams[$i+2];
		$frequency{$trigram}++;
	}
	

}



foreach $trigram ( sort keys %frequency) {
	$probability = $frequency{$trigram}/($i+1);
	print OUTPUT "EN\t$frequency{$trigram}\t$trigram\t$probability\n";
}

close INPUT;
close OUTPUT;
