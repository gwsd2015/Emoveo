#!/usr/bin/perl
#perl standard 
use strict;
use warnings;
use utf8;

#Lingua Library
use Lingua::EN::StopWords qw/%StopWords/;
use Lingua::Stem::En;
use Lingua::EN::Fathom;
use Lingua::EN::Tagger;
use Lingua::Concordance;
use Text::Summarize::En;

#administrative modules
use File::Slurp;
use Data::Dump qw/dump/;
use Encode qw/decode encode/;
use Path::Class;
use Getopt::Long;
use Tkx;
use Cwd;

#core modules used
use Text::TermExtract;
use WWW::Wikipedia;
use List::Compare;

#security modules
use Digest::SHA qw/sha256_hex/;

#quick removal hard code
use Locale::Country;
use Locale::Language;
use Lingua::EN::NamedEntity;

#modules to be considered
use LWP::Simple;
use HTML::TreeBuilder;
use HTML::FormatText;
use Lingua::EN::Ngram;
use Lingua::EN::Summarize;
use Lingua::Identify;
use WebService::Prismatic::InterestGraph;
##############################################
#requirement to use is that input needs to be an text file

#global to store file names
our @step_by_step_file_transform;

my $text = read_file(&query_for_input("Enter text to analyse (make sure you enter the /full/directory/file.txt):"));
my $hash_original = &hash_content($text);
&write_to_log($hash_original, $step_by_step_file_transform[0]);
my $standard = &fathom_text($step_by_step_file_transform[0]);
$text = &remove_new_lines($text);

#perform analysis on text
if($standard < 50){
	my @text_array = split /~~/, $text; 
	for(my $i = 0; $i <= $#text_array; $i++){
		my @paragraph_keywords = &extract_keywords($text_array[$i]);
		my $summary = &summary($text_array[$i]);
		my $query = &query_for_input("Would you like to remove this paragraph? (Enter y or n)");
		if($query =~ /y/i){
			$text_array[$i] = "||||||||||||||||||||";
		}
	}
	open(FILE, ">:utf8", $step_by_step_file_transform[0]) or die;
	print FILE $_."\n" for @text_array;
	close FILE;
}

$text = read_file($step_by_step_file_transform[0]);
my $hash_initial_analysis = &hash_content($text);
&write_to_log($hash_initial_analysis, $step_by_step_file_transform[0]." initial analysis");
$text = &remove_new_lines($text);

print $text;

exit();
##############################################
sub query_for_input(){
	my $question = shift;
	print "\n".$question."\t";
	my $input = <STDIN>;
	chomp $input;
	push @step_by_step_file_transform, $input;
	return $input;
	undef $question;
	undef $input;
}

sub hash_content(){
	my $content = shift;
	my $digest = sha256_hex($content);
	return $digest;
	undef $content;
	undef $digest;
}

sub write_to_log(){
	my $hash_digest = shift;
	my $file_state = shift;
	my $log_file = "/etc/Emoveo/log.txt";
	open(LOG, ">>", $log_file) or die;
	print LOG $hash_digest."\t".$file_state."\n";
	close LOG;
	undef $hash_digest;
	undef $file_state;
}

sub fathom_text(){
	my $text_name = shift;
	my $analyse = Lingua::EN::Fathom->new();
	$analyse->analyse_file($text_name);
	my $num_chars = $analyse->num_chars;
	my $num_words = $analyse->num_words;
	my $percent_complex_words = $analyse->percent_complex_words;
	my $num_sentences = $analyse->num_sentences;
	my $num_text_lines = $analyse->num_text_lines;
	my $num_blank_lines = $analyse->num_blank_lines;
	my $num_paragraphs = $analyse->num_paragraphs;
	my $syllables_per_word = $analyse->syllables_per_word;
	my $words_per_sentence = $analyse->words_per_sentence;
	my $fog = $analyse->fog;
	my $flesch = $analyse->flesch;
	my $kincaid = $analyse->kincaid;
	print ($analyse->report);
	print "\n\n";
	return $num_paragraphs;
	undef $text_name;
	undef $analyse;
	undef $num_chars; 
	undef $num_words ;
	undef $percent_complex_words;
	undef $num_sentences;
	undef $num_text_lines; 
	undef $num_blank_lines; 
	undef $num_paragraphs;
	undef $syllables_per_word;
	undef $words_per_sentence;
	undef $fog;
	undef $flesch; 
	undef $kincaid;
}

sub remove_new_lines(){
	my $text = shift;
	$text =~ s/\n+/~~/g;
	my $hash = &hash_content($text);
	&write_to_log($hash, $step_by_step_file_transform[0]." new line substitution");
	return $text;
	undef $text;
	undef $hash;
}

#entire summary SR attributed to https://gist.github.com/mrallen1/4453834 for showing me how to use it
sub summary(){
	my $text = shift;
	my $summary = $summarizerEn->getSummaryUsingSumbasic(listOfText => [$text]);
	my $buffer = "";
	my $size = length(text)*0.2;
	my @sentence_list = map { $_->[0] } @{$summary->{idScore}};
	my @sentence_content;
	foreach my $tagged_sentence ( @{$summary->{listOfStemmedTaggedSentences}} ) {
		my @t;
		foreach my $element ( @{ $tagged_sentence } ) {
			my $text = @$element[1];
			# remove tabs and single new lines
			$text =~ s/\t/ /;
			$text =~ s/\n/ /;
			push @t, $text;
		}
		push @sentence_content, (join "", map { s/ +/ /gr } @t);
	}
	while ( length($buffer) < $size ) {
		$buffer .= join "\n", $sentence_content[(shift @sentence_list)];
	}
	return $buffer;
	print $buffer."\n";
	undef $text;
	undef $buffer;
	undef $size;
}

sub extract_keywords(){
	my $text = shift;
	my @extract_array;
	my $extract = Text::TermExtract->new();
	$extract->exclude([
        'said',          'a',            'able',          'about',
        'above',         'abst',         'accordance',    'according',
        'accordingly',   'across',       'act',           'actually',
        'added',         'adj',          'affected',      'affecting',
        'affects',       'after',        'afterwards',    'again',
        'against',       'ah',           'all',           'almost',
        'alone',         'along',        'already',       'also',
        'although',      'always',       'am',            'among',
        'amongst',       'an',           'and',           'announce',
        'another',       'any',          'anybody',       'anyhow',
        'anymore',       'anyone',       'anything',      'anyway',
        'anyways',       'anywhere',     'apparently',    'approximately',
        'are',           'aren',         'arent',         'arise',
        'around',        'as',           'aside',         'ask',
        'asking',        'at',           'auth',          'available',
        'away',          'awfully',      'b',             'back',
        'be',            'became',       'because',       'become',
        'becomes',       'becoming',     'been',          'before',
        'beforehand',    'begin',        'beginning',     'beginnings',
        'begins',        'behind',       'being',         'believe',
        'below',         'beside',       'besides',       'between',
        'beyond',        'biol',         'both',          'brief',
        'briefly',       'but',          'by',            'c',
        'ca',            'came',         'can',           'cannot',
        'ca',            'cause',        'causes',        'certain',
        'certainly',     'co',           'com',           'come',
        'comes',         'contain',      'containing',    'contains',
        'could',         'could',        'd',             'date',
        'did',           'did',          'different',     'do',
        'does',          'does',         'doing',         'done',
        'do',            'down',         'downwards',     'due',
        'during',        'e',            'each',          'ed',
        'edu',           'effect',       'eg',            'eight',
        'eighty',        'either',       'else',          'elsewhere',
        'end',           'ending',       'enough',        'especially',
        'et',            'et-al',        'etc',           'even',
        'ever',          'every',        'everybody',     'everyone',
        'everything',    'everywhere',   'ex',            'except',
        'f',             'far',          'few',           'ff',
        'fifth',         'first',        'five',          'fix',
        'followed',      'following',    'follows',       'for',
        'former',        'formerly',     'forth',         'found',
        'four',          'from',         'further',       'furthermore',
        'g',             'gave',         'get',           'gets',
        'getting',       'give',         'given',         'gives',
        'giving',        'go',           'goes',          'gone',
        'got',           'gotten',       'h',             'had',
        'happens',       'hardly',       'has',           'has',
        'have',          'have',         'having',        'he',
        'hed',           'hence',        'her',           'here',
        'hereafter',     'hereby',       'herein',        'heres',
        'hereupon',      'hers',         'herself',       'hes',
        'hi',            'hid',          'him',           'himself',
        'his',           'hither',       'home',          'how',
        'howbeit',       'however',      'hundred',       'i',
        'id',            'ie',           'if',            'i',
        'im',            'immediate',    'immediately',   'importance',
        'important',     'in',           'inc',           'indeed',
        'index',         'information',  'instead',       'into',
        'invention',     'inward',       'is',            'is',
        'it',            'itd',          'it',            'its',
        'itself',        'i',            'j',             'just',
        'k',             'keep',         'keeps',         'kept',
        'kg',            'km',           'know',          'known',
        'knows',         'l',            'largely',       'last',
        'lately',        'later',        'latter',        'latterly',
        'least',         'less',         'lest',          'let',
        'lets',          'like',         'liked',         'likely',
        'line',          'little',       '',              'look',
        'looking',       'looks',        'ltd',           'm',
        'made',          'mainly',       'make',          'makes',
        'many',          'may',          'maybe',         'me',
        'mean',          'means',        'meantime',      'meanwhile',
        'merely',        'mg',           'might',         'million',
        'miss',          'ml',           'more',          'moreover',
        'most',          'mostly',       'mr',            'mrs',
        'much',          'mug',          'must',          'my',
        'myself',        'n',            'na',            'name',
        'namely',        'nay',          'nd',            'near',
        'nearly',        'necessarily',  'necessary',     'need',
        'needs',         'neither',      'never',         'nevertheless',
        'new',           'next',         'nine',          'ninety',
        'no',            'nobody',       'non',           'none',
        'nonetheless',   'noone',        'nor',           'normally',
        'nos',           'not',          'noted',         'nothing',
        'now',           'nowhere',      'o',             'obtain',
        'obtained',      'obviously',    'of',            'off',
        'often',         'oh',           'ok',            'okay',
        'old',           'omitted',      'on',            'once',
        'one',           'ones',         'only',          'onto',
        'or',            'ord',          'other',         'others',
        'otherwise',     'ought',        'our',           'ours',
        'ourselves',     'out',          'outside',       'over',
        'overall',       'owing',        'own',           'p',
        'page',          'pages',        'part',          'particular',
        'particularly',  'past',         'per',           'perhaps',
        'placed',        'please',       'plus',          'poorly',
        'possible',      'possibly',     'potentially',   'pp',
        'predominantly', 'present',      'previously',    'primarily',
        'probably',      'promptly',     'proud',         'provides',
        'put',           'q',            'que',           'quickly',
        'quite',         'qv',           'r',             'ran',
        'rather',        'rd',           're',            'readily',
        'really',        'recent',       'recently',      'ref',
        'refs',          'regarding',    'regardless',    'regards',
        'related',       'relatively',   'research',      'respectively',
        'resulted',      'resulting',    'results',       'right',
        'run',           's',            'said',          'same',
        'saw',           'say',          'saying',        'says',
        'sec',           'section',      'see',           'seeing',
        'seem',          'seemed',       'seeming',       'seems',
        'seen',          'self',         'selves',        'sent',
        'seven',         'several',      'shall',         'she',
        'shed',          'she',          'shes',          'should',
        'should',        'show',         'showed',        'shown',
        'showns',        'shows',        'significant',   'significantly',
        'similar',       'similarly',    'since',         'six',
        'slightly',      'so',           'some',          'somebody',
        'somehow',       'someone',      'somethan',      'something',
        'sometime',      'sometimes',    'somewhat',      'somewhere',
        'soon',          'sorry',        'specifically',  'specified',
        'specify',       'specifying',   'still',         'stop',
        'strongly',      'sub',          'substantially', 'successfully',
        'such',          'sufficiently', 'suggest',       'sup',
        'sure',          'I',            'a',             'about',
        'an',            'are',          'as',            'at',
        'be',            'by',           'com',           'for',
        'from',          'how',          'in',            'is',
        'it',            'of',           'on',            'or',
        'that',          'the',          'this',          'to',
        'was',           'what',         'when',          'where',
        'who',           'will',         'with',          'the',
        'www',		 'including',    'includes',	  'classified',
	'reports',	 'officials',	 'official',	  'government'
    	]
	);
	for my $textract ($extract->terms_extract($text, {max => 5})){
		push @extract_array, $textract;
	}
	print $_."\n" for @extract_array;
	return @extract_array;
}
