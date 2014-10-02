use strict;
use warnings;
use Text::Summarize::En;	
use utf8;
use LWP::Simple;
use HTML::TreeBuilder;
use HTML::FormatText;

my $URL = get("http://perlmaven.com/writing-to-files-with-perl/");

my $Format = HTML::FormatText->new();

my $TreeBuilder = HTML::TreeBuilder->new();

$TreeBuilder->parse($URL);

my $Parsed = $Format->format($TreeBuilder);

print "$Parsed";

#data::dump makes arrays more readable/prettier 
use Data::Dump qw(dump);

my $summarizerEn = Text::Summarize::En->new();

my $summary = $summarizerEn->getSummaryUsingSumbasic(listOfText => [$Parsed]);

dump $summarizerEn->getSummaryUsingSumbasic(listOfText => [$Parsed]);
print $summarizerEn;
 
#method is based off of https://gist.github.com/mrallen1/3344323

#buffer needs to begin empty, so that sentences, etc. can be added
my $buffer = "";
#size is based off of the limit you want your summary to be. In my code, I'm working on % based so I'm not sure
#exactly what I want it to be yet.
#issue 1

my $size = (length($Parsed))*0.80;

#map function is basically a way of writing a hash/array function. I'm mapping my idScore based off of Sumbasic to $_
# to generate my @sentence_list array. The output of map is always an array or hash.
my @sentence_list = map { $_->[0] } @{$summary->{idScore}};
 
my @sentence_content;
#tagged sentences is based off of library's tagging protocol that affects Sumbasic's method of ranking 
foreach my $tagged_sentence ( @{$summary->{listOfStemmedTaggedSentences}} ) {
    my @t;
    foreach my $element ( @{ $tagged_sentence } ) {
        $Parsed = @$element[1];
        #issue 2
	# remove tabs and single new lines
        $Parsed =~ s/\t/ /;
        $Parsed =~ s/\n/ /;
	#, seems to work well for non-technical texts
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
 
print "$buffer\n\n";


