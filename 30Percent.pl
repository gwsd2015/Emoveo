use strict;
use warnings;
use utf8;
use Text::Summarize::En;
use Data::Dump qw(dump);
use Algorithm::MarkovChain;
use Path::Class;
use Lingua::EN::Fathom;

my $input = 'c:/Perl/finance.txt';
open (INPUT, $input) or die;

my $output = 'c:/Perl/paragraphsplit.txt';
open (OUTPUT, '>'.$output) or die;

my $output2 = 'c:/Perl/paragraphsummary.txt';
open (OUTPUT2, '>'.$output2) or die;

my $output3 = 'c:/Perl/markovout.txt';
open (OUTPUT3, '>'.$output3) or die;

while(<INPUT>){
	tr/A-Z/a-z/;
	tr/.,:;!&?"'(){}\-\$\+\=\{\}\@\/\*\>\<//d;
	s/[0-9]//g;
	my @paragraph = split(/\n/, $_);
	print OUTPUT "$_" for @paragraph;	
	
=pod
	foreach my $para (@paragraph){
		my $summarizerEn = Text::Summarize::En->new();
		my $Parsed = $para;
		my $summary = $summarizerEn->getSummaryUsingSumbasic(listOfText => [$Parsed]);
		dump $summarizerEn->getSummaryUsingSumbasic(listOfText => [$Parsed]);
		print $summarizerEn;
		my $buffer = "";
		my $size = (length($Parsed))*0.80;
		my @sentence_list = map { $_->[0] } @{$summary->{idScore}};
		my @sentence_content;
		foreach my $tagged_sentence ( @{$summary->{listOfStemmedTaggedSentences}} ) {
    my @t;
    foreach my $element ( @{ $tagged_sentence } ) {
        my $Parsed = @$element[1];
        #issue 2
	# remove tabs and single new lines
        $Parsed =~ s/\t/ /;
        $Parsed =~ s/\n/ /;
	#, seems to work well for non-technical texts
	$Parsed =~ s/\s{2,}/ /;
        push @t, $Parsed;
    }
	#important to note here that this method uses /r in substitution so that original text files taken in $text
	#aren't substituted, rather a copy is made then the copy is placed in the substitution.
    	push @sentence_content, (join "", map { s/ +/ /gr } @t);
}

#while loop adds sentences joined in @sentence_content from the join "", map @t to the buffer until it is below the size
#limit
while ( length($buffer) < $size ) {
    $buffer .= join "\n", $sentence_content[(shift @sentence_list)];
	

}	
	print OUTPUT2 $buffer."\n\n";	
	}
	
=cut	
	
}

print "Enter the topic for generation: ";

my $getuserinput = <STDIN>;

chomp $getuserinput;

my @inputs = qw(finance.txt forensics.txt); 
    my $dir = dir(".");
    my $f = "";
    my @symbols = ();
    foreach $f (@inputs) {
        my $file = $dir->file($f);
    	my $linecounter = 0;
        my $wordcounter = 0;
        my $file_handle = $file->openr();
        while( my $line = $file_handle->getline() ) {
    		chomp ($line);
    		my @words = split(' ', $line);
            push(@symbols, @words);
    		$linecounter++;
    		$wordcounter += scalar(@words);
        }
    	print "$linecounter lines, $wordcounter words read from $f\n";
    }   
    my $chain = Algorithm::MarkovChain::->new();
    $chain->seed(symbols => \@symbols, longest => 6);
    foreach (1 .. 20) {
        my @newness = $chain->spew(length   => 100,
                                   complete => [ $getuserinput ]);
	print @newness;
	print "\n\nWould you like to keep this? \t\t";
	my $yesno = <STDIN>;
	chomp $yesno;
	if($yesno =~ /[Yy][Ee][Ss]\n?/){
        	print OUTPUT3 join (" ", @newness), ".\n\n";
		while (<OUTPUT3>){
			s/\]/ /g;
			s/\[/ /g;
		}
	}
    }

close INPUT;
close OUTPUT;
close OUTPUT2;
close OUTPUT3;

my $text_for_analysis = new Lingua::EN::Fathom;
$text_for_analysis -> analyse_file('c:/perl/markovout.txt');
print "Preparing statistics on generated paragraphs: \n\n\n";
print $text_for_analysis -> report;


