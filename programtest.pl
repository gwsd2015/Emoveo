use strict;
use warnings;
use Text::Summarize::En;	
use utf8;
use LWP::Simple;
use HTML::TreeBuilder;
use HTML::FormatText;
use Data::Dump qw(dump);

my $URL = get("http://edition.cnn.com/2014/10/02/health/ebola-us/index.html");

my $Format = HTML::FormatText->new();

my $TreeBuilder = HTML::TreeBuilder->new();

$TreeBuilder->parse($URL);

my $Parsed = $Format->format($TreeBuilder);

print "$Parsed";

my $summarizerEn = Text::Summarize::En->new();

dump my $summary = $summarizerEn->getSummaryUsingSumbasic(listOfText => [$Parsed]);

$summarizerEn ->getSummaryUsingSumbasic(listOfText => [$Parsed]);
print $summarizerEn;
 
#method is based off of https://gist.github.com/mrallen1/3344323

my $buffer = "";

my $size = (length($Parsed))*0.45;

my @sentence_list = map { $_->[0] } @{$summary->{idScore}};
 
my @sentence_content;
foreach my $tagged_sentence ( @{$summary->{listOfStemmedTaggedSentences}} ) {
    my @t;
    foreach my $element ( @{ $tagged_sentence } ) {
        my $Parsed = @$element[1];
        $Parsed =~ s/\t/ /;
        $Parsed =~ s/\n/ /;
	$Parsed =~ s/\s{2,}/ /;
        push @t, $Parsed;
    }
	push @sentence_content, (join "", map { s/ +/ /gr } @t);
}

while ( length($buffer) < $size ) {
    $buffer .= join "\n", $sentence_content[(shift @sentence_list)];
}

###end of method ###

print $buffer;

my $file = 'c:/perl64/summarized.txt';
open FILE, ">$file";
print FILE $buffer;
close FILE;