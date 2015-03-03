use strict;

use warnings;

use utf8;

use Lingua::EN::Tagger;

use File::Slurp;

my $input = 'C:\Perl\STR.txt';

open (INPUT, $input) or die;

my $output = 'C:\Perl\taggedtxt.txt';

open (OUTPUT, '>'.$output) or die;

my $output2 = 'C:\Perl\NNPextract.txt';

open (OUTPUT2, '>'.$output2) or die;

my $text = read_file(	$input	);

my $parsed = new Lingua::EN::Tagger;

my $tagged_text = $parsed->add_tags(	$text	);

my %word_list = $parsed->get_words(	$text	);

my $readable_text = $parsed->get_readable(	$text	);

print OUTPUT $readable_text;

close OUTPUT;

open (OUTPUT, $output) or die;

while(<OUTPUT>){

	my @wordlist = split /\s/;
	
	while (my $word = pop @wordlist){

		if ($word =~ /\w\/NNP/ig){
			
			print OUTPUT2 $word."\n";
			
		}
	
	}

}

close INPUT;

close OUTPUT;

close OUTPUT2;

open (OUTPUT2, $output2) or die;

my $output3 = 'C:\Perl\finalentity.txt';

open (OUTPUT3, '>'.$output3) or die;

my %seen;
my @lines;

while (<OUTPUT2>) {
    my @cols = split /\s+/;
    unless ($seen{$cols[0]}++) {
        push @lines, $_;
    }
}

print OUTPUT3 @lines;

close OUTPUT2;

close OUTPUT3;

