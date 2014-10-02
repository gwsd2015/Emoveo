use strict;
use warnings;
use Text::Summarize::En;
use Data::Dump qw(dump);
my $summarizerEn = Text::Summarize::En->new();
my $text         = 'All people are equal. All men are equal. All are equal.';
dump $summarizerEn->getSummaryUsingSumbasic(listOfText => [$text]);

print $summarizerEn;