#################################################################
#purpose of the program

#ISO27k Guideline on Information Asset Valuation

#Information wherever it is handled or stored (e.g., in computers, file cabinets,
#desktops, fax machines, Xerox, printer, verbal communication etc.) needs to be
#suitably and appropriately protected from unauthorized access, modification,
#disclosure, and destruction. All information will not be accorded with the same
#importance. Consequently, classification of information into categories is necessary
#to help identify a framework for evaluating the information's relative value and the
#appropriate controls required to preserve its value to the organization.
#To achieve this purpose, upon creation of the information (whether in a computer
#system, memo in a file cabinet etc.), the creator/owner of that information
#(generally the information asset owner) is responsible for classification. Further, the
#owner of information asset is responsible to review the classification of information at
#least annually.
#The analysis is to be done by Business Process Owner i.e. process / function head.

#three major class of information
# 1. Confidential
# 2. Internal Use Only
# 3. Public

#################################################################

use strict;
use warnings;
use Lingua::EN::StopWords qw(%StopWords);
use Lingua::Stem::En;
use Data::Dump qw(dump);
use Path::Class;
use Lingua::EN::Fathom;
use utf8;
use File::Slurp qw(read_file write_file);

#use PDL;
#use LWP::Simple;
#use HTML::TreeBuilder;
#use HTML::FormatText;
use Locale::Country;
use Locale::Language;
use Lingua::Concordance;

#use Lingua::EN::Ngram;
use Encode qw(decode encode);
use Text::TermExtract;
use RTF::Writer;
use WWW::Wikipedia;
use Lingua::EN::Tagger;
use Tkx;
use List::Compare;

#take the input file from the user
#file slurp and extract the text

print
"Make sure that the pdf is saved as a txt file using the save as other function built into Adobe Reader.\n";
print "Enter txt file location:\t";
my $inputfile = <STDIN>;
chomp $inputfile;
print "Input file, $inputfile, read.\n";

#print "Enter a title for the txt file:\t";
#my $title = <STDIN>;
#chomp $title;
my $textfile = read_file($inputfile);

#print "$textfile\n\n";

#my $analysistextfile = $textfile;
my $datatomod = ($textfile);

#building some of these file to check that I properly completed steps.
#necessary to keep in order to hvae file to chain the n-gram removal tool.
my $check = "C:/Perl/".$inputfile."checkfile.txt";
open( CHK, ">", $check ) or die "Can't generate $check\n";
print "File $check generated.\n";
print CHK "$textfile";
close CHK;

my $text = new Lingua::EN::Fathom;
$text->analyse_file($inputfile);
my $accumulate = 1;
$text->analyse_block( my $text_string, $accumulate );

my $num_chars             = $text->num_chars;
my $num_words             = $text->num_words;
my $percent_complex_words = $text->percent_complex_words;
my $num_sentences         = $text->num_sentences;
my $num_text_lines        = $text->num_text_lines;
my $num_blank_lines       = $text->num_blank_lines;
my $num_paragraphs        = $text->num_paragraphs;
my $syllables_per_word    = $text->syllables_per_word;
my $words_per_sentence    = $text->words_per_sentence;

my $fog     = $text->fog;
my $flesch  = $text->flesch;
my $kincaid = $text->kincaid;

print( $text->report );
print "\n\n";
system('pause');

$datatomod = read_file($check);

$datatomod =~ s/\n+/ ~~/g;

my @datamod = split( /~~/, $datatomod );
my @datasen = split( /\./, $datatomod );

system('pause');

#print $datamod[0];

print "Preparing to perform analysis on the text...\n";

system('pause');

if ( $num_paragraphs < 50 ) {
    for ( my $data = 0 ; $data < $#datamod ; $data++ ) {
        my $datashow = "$datamod[$data]";
        my $extra    = Text::TermExtract->new();
        my $dataz    = $data + 1;
        print "\nParagraph $dataz topics: \n";
        for my $ex ( $extra->terms_extract( $datashow, { max => 5 } ) ) {
            print $ex. "\n";
        }
        print "\nParagraph topics listed. Remove paragraph?\t";
        while () {
            my $removeyesno = <STDIN>;
            chomp $removeyesno;
            if ( $removeyesno =~ /yes/ig ) {
                $datamod[$data] =
'||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||';
                print $datamod[$data] . "\n";
                last;
            }
            else {
                last;
            }
        }
    }
}
else {
    print
"File too large to do paragraph analysis.\n Give 3 topics to remove, separated by commas:\t";
    my $usertoinput = <STDIN>;
    chomp $usertoinput;
    my @usertopics = split( /,/, $usertoinput );
    for ( my $u = 0 ; $u < $#usertopics ; $u++ ) {
        my $topic_to_clear = $usertopics[$u];
        for ( my $ui = 0 ; $ui < $#datasen ; $ui++ ) {
            my $sen_to_an = $datasen[$ui];
            if ( $sen_to_an =~ /\b$topic_to_clear\b/ ) {
                $datasen[$ui] =
                  '||||||||||||||||||||||||||||||||||||||||||||||||||';
            }
        }
    }
}

my $intermediatefile = "C:/Perl/".$inputfile."intermediate.txt";
open( INT, ">>", $intermediatefile ) or die;

system('pause');
print @datamod;
system('pause');

if ( $num_paragraphs < 50 ) {
    for ( my $data2 = 0 ; $data2 < $#datamod ; $data2++ ) {
        my $datashow2 = "$datamod[$data2]";
        print INT $datashow2 . " ~~";
    }
}
else {
    for ( my $uidat = 0 ; $uidat < $#datasen ; $uidat++ ) {
        my $uidataprint = "$datasen[$uidat]";
        print INT $uidataprint . " ";
    }
}

close INT;

$datatomod = 0;

$datatomod = read_file($intermediatefile);

print "Preparing to get up to 20 keywords from the document...\n";

our @initial_keys;
our @initial_keys_to_tag;
our @keys_for_0;
our @keys_for_1;
our @keys_for_2;
our @keys_for_3;
our @keys_for_4;
our @keys_for_5;
our @keys_for_6;
our @keys_for_7;
our @keys_for_8;
our @keys_for_9;
our @keys_for_10;
our @keys_for_11;
our @keys_for_12;
our @keys_for_13;
our @keys_for_14;
our @keys_for_15;
our @keys_for_16;
our @keys_for_17;
our @keys_for_18;
our @keys_for_19;

my $ext = Text::TermExtract->new();
$ext->exclude(
    [
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
        'www'
    ]
);

for my $wordsensing ( $ext->terms_extract( $datatomod, { max => 20 } ) ) {
    print "$wordsensing\n";
    push @initial_keys,        $wordsensing;
    push @initial_keys_to_tag, $wordsensing;
}
system('pause');

for ( my $co = 0 ; $co < $#initial_keys ; $co++ ) {
    my $keyprint = $initial_keys[$co];

    #print $keyprint. "\n";
}
system('pause');

our @exclude_list;
our $exclude_list_ref = [@exclude_list];

while () {
    print
"\nAre there any keywords you would like to exclude, (this can include words not listed)?\t";
    my $userexclude = <STDIN>;
    chomp $userexclude;
    if ( $userexclude =~ /yes/i ) {
        while () {
            print "\nEnter word to exclude (exit to escape):\t";
            my $wordtoex = <STDIN>;
            chomp $wordtoex;
            push @$exclude_list_ref, $wordtoex;
            if ( $wordtoex =~ /exit/i ) {
                last;
            }
        }
        my $extracting = Text::TermExtract->new();
        @initial_keys        = ();
        @initial_keys_to_tag = ();
        $extracting->exclude($exclude_list_ref);
        $extracting->exclude(
            [
                'said',          'a',
                'able',          'about',
                'above',         'abst',
                'accordance',    'according',
                'accordingly',   'across',
                'act',           'actually',
                'added',         'adj',
                'affected',      'affecting',
                'affects',       'after',
                'afterwards',    'again',
                'against',       'ah',
                'all',           'almost',
                'alone',         'along',
                'already',       'also',
                'although',      'always',
                'am',            'among',
                'amongst',       'an',
                'and',           'announce',
                'another',       'any',
                'anybody',       'anyhow',
                'anymore',       'anyone',
                'anything',      'anyway',
                'anyways',       'anywhere',
                'apparently',    'approximately',
                'are',           'aren',
                'arent',         'arise',
                'around',        'as',
                'aside',         'ask',
                'asking',        'at',
                'auth',          'available',
                'away',          'awfully',
                'b',             'back',
                'be',            'became',
                'because',       'become',
                'becomes',       'becoming',
                'been',          'before',
                'beforehand',    'begin',
                'beginning',     'beginnings',
                'begins',        'behind',
                'being',         'believe',
                'below',         'beside',
                'besides',       'between',
                'beyond',        'biol',
                'both',          'brief',
                'briefly',       'but',
                'by',            'c',
                'ca',            'came',
                'can',           'cannot',
                'ca',            'cause',
                'causes',        'certain',
                'certainly',     'co',
                'com',           'come',
                'comes',         'contain',
                'containing',    'contains',
                'could',         'could',
                'd',             'date',
                'did',           'did',
                'different',     'do',
                'does',          'does',
                'doing',         'done',
                'do',            'down',
                'downwards',     'due',
                'during',        'e',
                'each',          'ed',
                'edu',           'effect',
                'eg',            'eight',
                'eighty',        'either',
                'else',          'elsewhere',
                'end',           'ending',
                'enough',        'especially',
                'et',            'et-al',
                'etc',           'even',
                'ever',          'every',
                'everybody',     'everyone',
                'everything',    'everywhere',
                'ex',            'except',
                'f',             'far',
                'few',           'ff',
                'fifth',         'first',
                'five',          'fix',
                'followed',      'following',
                'follows',       'for',
                'former',        'formerly',
                'forth',         'found',
                'four',          'from',
                'further',       'furthermore',
                'g',             'gave',
                'get',           'gets',
                'getting',       'give',
                'given',         'gives',
                'giving',        'go',
                'goes',          'gone',
                'got',           'gotten',
                'h',             'had',
                'happens',       'hardly',
                'has',           'has',
                'have',          'have',
                'having',        'he',
                'hed',           'hence',
                'her',           'here',
                'hereafter',     'hereby',
                'herein',        'heres',
                'hereupon',      'hers',
                'herself',       'hes',
                'hi',            'hid',
                'him',           'himself',
                'his',           'hither',
                'home',          'how',
                'howbeit',       'however',
                'hundred',       'i',
                'id',            'ie',
                'if',            'i',
                'im',            'immediate',
                'immediately',   'importance',
                'important',     'in',
                'inc',           'indeed',
                'index',         'information',
                'instead',       'into',
                'invention',     'inward',
                'is',            'is',
                'it',            'itd',
                'it',            'its',
                'itself',        'i',
                'j',             'just',
                'k',             'keep',
                'keeps',         'kept',
                'kg',            'km',
                'know',          'known',
                'knows',         'l',
                'largely',       'last',
                'lately',        'later',
                'latter',        'latterly',
                'least',         'less',
                'lest',          'let',
                'lets',          'like',
                'liked',         'likely',
                'line',          'little',
                '',              'look',
                'looking',       'looks',
                'ltd',           'm',
                'made',          'mainly',
                'make',          'makes',
                'many',          'may',
                'maybe',         'me',
                'mean',          'means',
                'meantime',      'meanwhile',
                'merely',        'mg',
                'might',         'million',
                'miss',          'ml',
                'more',          'moreover',
                'most',          'mostly',
                'mr',            'mrs',
                'much',          'mug',
                'must',          'my',
                'myself',        'n',
                'na',            'name',
                'namely',        'nay',
                'nd',            'near',
                'nearly',        'necessarily',
                'necessary',     'need',
                'needs',         'neither',
                'never',         'nevertheless',
                'new',           'next',
                'nine',          'ninety',
                'no',            'nobody',
                'non',           'none',
                'nonetheless',   'noone',
                'nor',           'normally',
                'nos',           'not',
                'noted',         'nothing',
                'now',           'nowhere',
                'o',             'obtain',
                'obtained',      'obviously',
                'of',            'off',
                'often',         'oh',
                'ok',            'okay',
                'old',           'omitted',
                'on',            'once',
                'one',           'ones',
                'only',          'onto',
                'or',            'ord',
                'other',         'others',
                'otherwise',     'ought',
                'our',           'ours',
                'ourselves',     'out',
                'outside',       'over',
                'overall',       'owing',
                'own',           'p',
                'page',          'pages',
                'part',          'particular',
                'particularly',  'past',
                'per',           'perhaps',
                'placed',        'please',
                'plus',          'poorly',
                'possible',      'possibly',
                'potentially',   'pp',
                'predominantly', 'present',
                'previously',    'primarily',
                'probably',      'promptly',
                'proud',         'provides',
                'put',           'q',
                'que',           'quickly',
                'quite',         'qv',
                'r',             'ran',
                'rather',        'rd',
                're',            'readily',
                'really',        'recent',
                'recently',      'ref',
                'refs',          'regarding',
                'regardless',    'regards',
                'related',       'relatively',
                'research',      'respectively',
                'resulted',      'resulting',
                'results',       'right',
                'run',           's',
                'said',          'same',
                'saw',           'say',
                'saying',        'says',
                'sec',           'section',
                'see',           'seeing',
                'seem',          'seemed',
                'seeming',       'seems',
                'seen',          'self',
                'selves',        'sent',
                'seven',         'several',
                'shall',         'she',
                'shed',          'she',
                'shes',          'should',
                'should',        'show',
                'showed',        'shown',
                'showns',        'shows',
                'significant',   'significantly',
                'similar',       'similarly',
                'since',         'six',
                'slightly',      'so',
                'some',          'somebody',
                'somehow',       'someone',
                'somethan',      'something',
                'sometime',      'sometimes',
                'somewhat',      'somewhere',
                'soon',          'sorry',
                'specifically',  'specified',
                'specify',       'specifying',
                'still',         'stop',
                'strongly',      'sub',
                'substantially', 'successfully',
                'such',          'sufficiently',
                'suggest',       'sup',
                'sure',          'I',
                'a',             'about',
                'an',            'are',
                'as',            'at',
                'be',            'by',
                'com',           'for',
                'from',          'how',
                'in',            'is',
                'it',            'of',
                'on',            'or',
                'that',          'the',
                'this',          'to',
                'was',           'what',
                'when',          'where',
                'who',           'will',
                'with',          'the',
                'www'
            ]
        );
        for my $wordgets (
            $extracting->terms_extract( $datatomod, { max => 20 } ) )
        {
            print "$wordgets\n";
            push @initial_keys,        $wordgets;
            push @initial_keys_to_tag, $wordgets;
        }
    }
    else {
        last;
    }

}

print "\nPreparing to build keyword trees...\n\n";

for ( my $counters = 0 ; $counters < $#initial_keys ; $counters++ ) {
    my $key_to_search = $initial_keys[$counters];
    my $wiki          = WWW::Wikipedia->new();
    my $result        = $wiki->search($key_to_search);
    my $filewiki      = "C:/Perl/".$inputfile."wikistore.txt";
    open( WIKI, ">", $filewiki ) or die;
    if ( $result !~ /^$/ ) {
        if ( $result->text() ) {
            print WIKI $result->text();
            print $result->text();
            close WIKI;

            #my $service = read_file($filewiki);
            my $wikifile = read_file($filewiki);
            my $wikiext  = Text::TermExtract->new();
            $wikiext->exclude(
                [
                    'refer', 'ref',     'may',        'refers',
                    'see',   'defined', 'definition', 'including'
                ]
            );
            $wikiext->exclude($exclude_list_ref);
            $wikiext->exclude(
                [
                    'said',          'a',
                    'able',          'about',
                    'above',         'abst',
                    'accordance',    'according',
                    'accordingly',   'across',
                    'act',           'actually',
                    'added',         'adj',
                    'affected',      'affecting',
                    'affects',       'after',
                    'afterwards',    'again',
                    'against',       'ah',
                    'all',           'almost',
                    'alone',         'along',
                    'already',       'also',
                    'although',      'always',
                    'am',            'among',
                    'amongst',       'an',
                    'and',           'announce',
                    'another',       'any',
                    'anybody',       'anyhow',
                    'anymore',       'anyone',
                    'anything',      'anyway',
                    'anyways',       'anywhere',
                    'apparently',    'approximately',
                    'are',           'aren',
                    'arent',         'arise',
                    'around',        'as',
                    'aside',         'ask',
                    'asking',        'at',
                    'auth',          'available',
                    'away',          'awfully',
                    'b',             'back',
                    'be',            'became',
                    'because',       'become',
                    'becomes',       'becoming',
                    'been',          'before',
                    'beforehand',    'begin',
                    'beginning',     'beginnings',
                    'begins',        'behind',
                    'being',         'believe',
                    'below',         'beside',
                    'besides',       'between',
                    'beyond',        'biol',
                    'both',          'brief',
                    'briefly',       'but',
                    'by',            'c',
                    'ca',            'came',
                    'can',           'cannot',
                    'ca',            'cause',
                    'causes',        'certain',
                    'certainly',     'co',
                    'com',           'come',
                    'comes',         'contain',
                    'containing',    'contains',
                    'could',         'could',
                    'd',             'date',
                    'did',           'did',
                    'different',     'do',
                    'does',          'does',
                    'doing',         'done',
                    'do',            'down',
                    'downwards',     'due',
                    'during',        'e',
                    'each',          'ed',
                    'edu',           'effect',
                    'eg',            'eight',
                    'eighty',        'either',
                    'else',          'elsewhere',
                    'end',           'ending',
                    'enough',        'especially',
                    'et',            'et-al',
                    'etc',           'even',
                    'ever',          'every',
                    'everybody',     'everyone',
                    'everything',    'everywhere',
                    'ex',            'except',
                    'f',             'far',
                    'few',           'ff',
                    'fifth',         'first',
                    'five',          'fix',
                    'followed',      'following',
                    'follows',       'for',
                    'former',        'formerly',
                    'forth',         'found',
                    'four',          'from',
                    'further',       'furthermore',
                    'g',             'gave',
                    'get',           'gets',
                    'getting',       'give',
                    'given',         'gives',
                    'giving',        'go',
                    'goes',          'gone',
                    'got',           'gotten',
                    'h',             'had',
                    'happens',       'hardly',
                    'has',           'has',
                    'have',          'have',
                    'having',        'he',
                    'hed',           'hence',
                    'her',           'here',
                    'hereafter',     'hereby',
                    'herein',        'heres',
                    'hereupon',      'hers',
                    'herself',       'hes',
                    'hi',            'hid',
                    'him',           'himself',
                    'his',           'hither',
                    'home',          'how',
                    'howbeit',       'however',
                    'hundred',       'i',
                    'id',            'ie',
                    'if',            'i',
                    'im',            'immediate',
                    'immediately',   'importance',
                    'important',     'in',
                    'inc',           'indeed',
                    'index',         'information',
                    'instead',       'into',
                    'invention',     'inward',
                    'is',            'is',
                    'it',            'itd',
                    'it',            'its',
                    'itself',        'i',
                    'j',             'just',
                    'k',             'keep',
                    'keeps',         'kept',
                    'kg',            'km',
                    'know',          'known',
                    'knows',         'l',
                    'largely',       'last',
                    'lately',        'later',
                    'latter',        'latterly',
                    'least',         'less',
                    'lest',          'let',
                    'lets',          'like',
                    'liked',         'likely',
                    'line',          'little',
                    '',              'look',
                    'looking',       'looks',
                    'ltd',           'm',
                    'made',          'mainly',
                    'make',          'makes',
                    'many',          'may',
                    'maybe',         'me',
                    'mean',          'means',
                    'meantime',      'meanwhile',
                    'merely',        'mg',
                    'might',         'million',
                    'miss',          'ml',
                    'more',          'moreover',
                    'most',          'mostly',
                    'mr',            'mrs',
                    'much',          'mug',
                    'must',          'my',
                    'myself',        'n',
                    'na',            'name',
                    'namely',        'nay',
                    'nd',            'near',
                    'nearly',        'necessarily',
                    'necessary',     'need',
                    'needs',         'neither',
                    'never',         'nevertheless',
                    'new',           'next',
                    'nine',          'ninety',
                    'no',            'nobody',
                    'non',           'none',
                    'nonetheless',   'noone',
                    'nor',           'normally',
                    'nos',           'not',
                    'noted',         'nothing',
                    'now',           'nowhere',
                    'o',             'obtain',
                    'obtained',      'obviously',
                    'of',            'off',
                    'often',         'oh',
                    'ok',            'okay',
                    'old',           'omitted',
                    'on',            'once',
                    'one',           'ones',
                    'only',          'onto',
                    'or',            'ord',
                    'other',         'others',
                    'otherwise',     'ought',
                    'our',           'ours',
                    'ourselves',     'out',
                    'outside',       'over',
                    'overall',       'owing',
                    'own',           'p',
                    'page',          'pages',
                    'part',          'particular',
                    'particularly',  'past',
                    'per',           'perhaps',
                    'placed',        'please',
                    'plus',          'poorly',
                    'possible',      'possibly',
                    'potentially',   'pp',
                    'predominantly', 'present',
                    'previously',    'primarily',
                    'probably',      'promptly',
                    'proud',         'provides',
                    'put',           'q',
                    'que',           'quickly',
                    'quite',         'qv',
                    'r',             'ran',
                    'rather',        'rd',
                    're',            'readily',
                    'really',        'recent',
                    'recently',      'ref',
                    'refs',          'regarding',
                    'regardless',    'regards',
                    'related',       'relatively',
                    'research',      'respectively',
                    'resulted',      'resulting',
                    'results',       'right',
                    'run',           's',
                    'said',          'same',
                    'saw',           'say',
                    'saying',        'says',
                    'sec',           'section',
                    'see',           'seeing',
                    'seem',          'seemed',
                    'seeming',       'seems',
                    'seen',          'self',
                    'selves',        'sent',
                    'seven',         'several',
                    'shall',         'she',
                    'shed',          'she',
                    'shes',          'should',
                    'should',        'show',
                    'showed',        'shown',
                    'showns',        'shows',
                    'significant',   'significantly',
                    'similar',       'similarly',
                    'since',         'six',
                    'slightly',      'so',
                    'some',          'somebody',
                    'somehow',       'someone',
                    'somethan',      'something',
                    'sometime',      'sometimes',
                    'somewhat',      'somewhere',
                    'soon',          'sorry',
                    'specifically',  'specified',
                    'specify',       'specifying',
                    'still',         'stop',
                    'strongly',      'sub',
                    'substantially', 'successfully',
                    'such',          'sufficiently',
                    'suggest',       'sup',
                    'sure',          'I',
                    'a',             'about',
                    'an',            'are',
                    'as',            'at',
                    'be',            'by',
                    'com',           'for',
                    'from',          'how',
                    'in',            'is',
                    'it',            'of',
                    'on',            'or',
                    'that',          'the',
                    'this',          'to',
                    'was',           'what',
                    'when',          'where',
                    'who',           'will',
                    'with',          'the',
                    'www'
                ]
            );
            for my $keyword (
                $wikiext->terms_extract( $wikifile, { max => 20 } ) )
            {
                print $keyword. "\n";
                if ( $counters == 0 ) {
                    push @keys_for_0, $keyword;
                }
                elsif ( $counters == 1 ) {
                    push @keys_for_1, $keyword;
                }
                elsif ( $counters == 2 ) {
                    push @keys_for_2, $keyword;
                }
                elsif ( $counters == 3 ) {
                    push @keys_for_3, $keyword;
                }
                elsif ( $counters == 4 ) {
                    push @keys_for_4, $keyword;
                }
                elsif ( $counters == 5 ) {
                    push @keys_for_5, $keyword;
                }
                elsif ( $counters == 6 ) {
                    push @keys_for_6, $keyword;
                }
                elsif ( $counters == 7 ) {
                    push @keys_for_7, $keyword;
                }
                elsif ( $counters == 8 ) {
                    push @keys_for_8, $keyword;
                }
                elsif ( $counters == 9 ) {
                    push @keys_for_9, $keyword;
                }
                elsif ( $counters == 10 ) {
                    push @keys_for_10, $keyword;
                }
                elsif ( $counters == 11 ) {
                    push @keys_for_11, $keyword;
                }
                elsif ( $counters == 12 ) {
                    push @keys_for_12, $keyword;
                }
                elsif ( $counters == 13 ) {
                    push @keys_for_13, $keyword;
                }
                elsif ( $counters == 14 ) {
                    push @keys_for_14, $keyword;
                }
                elsif ( $counters == 15 ) {
                    push @keys_for_15, $keyword;
                }
                elsif ( $counters == 16 ) {
                    push @keys_for_16, $keyword;
                }
                elsif ( $counters == 17 ) {
                    push @keys_for_17, $keyword;
                }
                elsif ( $counters == 18 ) {
                    push @keys_for_18, $keyword;
                }
                elsif ( $counters == 19 ) {
                    push @keys_for_19, $keyword;
                }
            }
        }
    }
}

my $keywordsfile = "C:/Perl/".$inputfile."keywords.txt";
open( KEYFI, ">", $keywordsfile ) or die;

print KEYFI "$_\n" for @initial_keys;

close KEYFI;

system('pause');

my $form = Tkx::widget->new('.');
$form->g_wm_title('test object GUI');
$form->m_configure( -background => "gray" );
$form->g_wm_minsize( 600, 400 );

my $button0;

$button0 =
  $form->new_button( -text =>
"$initial_keys[0], $initial_keys[1], $initial_keys[2], $initial_keys[3], $initial_keys[4]"
  );

$button0->g_pack(
    -padx => 100,
    -pady => 20,
);

my $button1;

$button1 =
  $form->new_button( -text =>
"$initial_keys[5], $initial_keys[6], $initial_keys[7], $initial_keys[8], $initial_keys[9]"
  );

$button1->g_pack(
    -padx => 100,
    -pady => 22,
);

my $button2;

$button2 =
  $form->new_button( -text =>
"$initial_keys[10], $initial_keys[11], $initial_keys[12], $initial_keys[13], $initial_keys[14]"
  );

$button2->g_pack(
    -padx => 100,
    -pady => 24,
);

my $button3;

$button3 =
  $form->new_button( -text =>
"$initial_keys[15], $initial_keys[16], $initial_keys[17], $initial_keys[18], $initial_keys[19]"
  );

$button3->g_pack(
    -padx => 100,
    -pady => 26,
);

Tkx::MainLoop();

$datatomod = read_file($intermediatefile);

our $loopreplacefile = "C:/Perl/".$inputfile."looper.txt";
open( LOOP, ">", $loopreplacefile );
print LOOP "$datatomod";
close LOOP;

our $integer;

if ( $num_words < 5000 ) {
    my $integer2 = int( $num_words * ( 1 / 25 ) + 0.5 );
    if ( $integer2 > 60 ) {
        $integer = $integer2 * ( 1 / 3 );
    }
    $integer = $integer2;
}
elsif ( $num_words >= 5000 && $num_words < 10000 ) {
    my $integer3 = int( $num_words * ( 1 / 400 ) + 0.5 );
    if ( $integer3 > 80 ) {
        $integer = $integer3 * ( 1 / 5 );
    }
    $integer = $integer3;
}
else {
    $integer = 30;
}

while (1) {
    print
"Enter the keyword that you would like to search for (enter 0 to escape): ";
    my $finder = <STDIN>;
    chomp $finder;
    if ( $finder =~ /$initial_keys[0]/ ) {
        my $concordance0 = Lingua::Concordance->new;
        $concordance0->radius($integer);
        my $reader0 = read_file($loopreplacefile);
        $concordance0->text($reader0);
        $concordance0->query(
            $initial_keys[0], $keys_for_0[0],  $keys_for_0[1],
            $keys_for_0[2],   $keys_for_0[3],  $keys_for_0[4],
            $keys_for_0[5],   $keys_for_0[6],  $keys_for_0[7],
            $keys_for_0[8],   $keys_for_0[9],  $keys_for_0[10],
            $keys_for_0[11],  $keys_for_0[12], $keys_for_0[13],
            $keys_for_0[14],  $keys_for_0[15], $keys_for_0[16],
            $keys_for_0[17],  $keys_for_0[18], $keys_for_0[19]
        );
        foreach ( $concordance0->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[1]/ ) {
        my $concordance1 = Lingua::Concordance->new;
        $concordance1->radius($integer);
        my $reader1 = read_file($loopreplacefile);
        $concordance1->text($reader1);
        $concordance1->query(
            $initial_keys[1], $keys_for_1[0],  $keys_for_1[1],
            $keys_for_1[2],   $keys_for_1[3],  $keys_for_1[4],
            $keys_for_1[5],   $keys_for_1[6],  $keys_for_1[7],
            $keys_for_1[8],   $keys_for_1[9],  $keys_for_1[10],
            $keys_for_1[11],  $keys_for_1[12], $keys_for_1[13],
            $keys_for_1[14],  $keys_for_1[15], $keys_for_1[16],
            $keys_for_1[17],  $keys_for_1[18], $keys_for_1[19]
        );
        foreach ( $concordance1->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[2]/ ) {
        my $concordance2 = Lingua::Concordance->new;
        $concordance2->radius($integer);
        my $reader2 = read_file($loopreplacefile);
        $concordance2->text($reader2);
        $concordance2->query(
            $initial_keys[2], $keys_for_2[0],  $keys_for_2[1],
            $keys_for_2[2],   $keys_for_2[3],  $keys_for_2[4],
            $keys_for_2[5],   $keys_for_2[6],  $keys_for_2[7],
            $keys_for_2[8],   $keys_for_2[9],  $keys_for_2[10],
            $keys_for_2[11],  $keys_for_2[12], $keys_for_2[13],
            $keys_for_2[14],  $keys_for_2[15], $keys_for_2[16],
            $keys_for_2[17],  $keys_for_2[18], $keys_for_2[19]
        );
        foreach ( $concordance2->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[3]/ ) {
        my $concordance3 = Lingua::Concordance->new;
        $concordance3->radius($integer);
        my $reader3 = read_file($loopreplacefile);
        $concordance3->text($reader3);
        $concordance3->query(
            $initial_keys[3], $keys_for_3[0],  $keys_for_3[1],
            $keys_for_3[2],   $keys_for_3[3],  $keys_for_3[4],
            $keys_for_3[5],   $keys_for_3[6],  $keys_for_3[7],
            $keys_for_3[8],   $keys_for_3[9],  $keys_for_3[10],
            $keys_for_3[11],  $keys_for_3[12], $keys_for_3[13],
            $keys_for_3[14],  $keys_for_3[15], $keys_for_3[16],
            $keys_for_3[17],  $keys_for_3[18], $keys_for_3[19]
        );
        foreach ( $concordance3->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[4]/ ) {
        my $concordance4 = Lingua::Concordance->new;
        $concordance4->radius($integer);
        my $reader4 = read_file($loopreplacefile);
        $concordance4->text($reader4);
        $concordance4->query(
            $initial_keys[4], $keys_for_4[0],  $keys_for_4[1],
            $keys_for_4[2],   $keys_for_4[3],  $keys_for_4[4],
            $keys_for_4[5],   $keys_for_4[6],  $keys_for_4[7],
            $keys_for_4[8],   $keys_for_4[9],  $keys_for_4[10],
            $keys_for_4[11],  $keys_for_4[12], $keys_for_4[13],
            $keys_for_4[14],  $keys_for_4[15], $keys_for_4[16],
            $keys_for_4[17],  $keys_for_4[18], $keys_for_4[19]
        );
        foreach ( $concordance4->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[5]/ ) {
        my $concordance5 = Lingua::Concordance->new;
        $concordance5->radius($integer);
        my $reader5 = read_file($loopreplacefile);
        $concordance5->text($reader5);
        $concordance5->query(
            $initial_keys[5], $keys_for_5[0],  $keys_for_5[1],
            $keys_for_5[2],   $keys_for_5[3],  $keys_for_5[4],
            $keys_for_5[5],   $keys_for_5[6],  $keys_for_5[7],
            $keys_for_5[8],   $keys_for_5[9],  $keys_for_5[10],
            $keys_for_5[11],  $keys_for_5[12], $keys_for_5[13],
            $keys_for_5[14],  $keys_for_5[15], $keys_for_5[16],
            $keys_for_5[17],  $keys_for_5[18], $keys_for_5[19]
        );
        foreach ( $concordance5->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }

                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[6]/ ) {
        my $concordance6 = Lingua::Concordance->new;
        $concordance6->radius($integer);
        my $reader6 = read_file($loopreplacefile);
        $concordance6->text($reader6);
        $concordance6->query(
            $initial_keys[6], $keys_for_6[0],  $keys_for_6[1],
            $keys_for_6[2],   $keys_for_6[3],  $keys_for_6[4],
            $keys_for_6[5],   $keys_for_6[6],  $keys_for_6[7],
            $keys_for_6[8],   $keys_for_6[9],  $keys_for_6[10],
            $keys_for_6[11],  $keys_for_6[12], $keys_for_6[13],
            $keys_for_6[14],  $keys_for_6[15], $keys_for_6[16],
            $keys_for_6[17],  $keys_for_6[18], $keys_for_6[19]
        );
        foreach ( $concordance6->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[7]/ ) {
        my $concordance7 = Lingua::Concordance->new;
        $concordance7->radius($integer);
        my $reader7 = read_file($loopreplacefile);
        $concordance7->text($reader7);
        $concordance7->query(
            $initial_keys[0], $keys_for_7[0],  $keys_for_7[1],
            $keys_for_7[2],   $keys_for_7[3],  $keys_for_7[4],
            $keys_for_7[5],   $keys_for_7[6],  $keys_for_7[7],
            $keys_for_7[8],   $keys_for_7[9],  $keys_for_7[10],
            $keys_for_7[11],  $keys_for_7[12], $keys_for_7[13],
            $keys_for_7[14],  $keys_for_7[15], $keys_for_7[16],
            $keys_for_7[17],  $keys_for_7[18], $keys_for_7[19]
        );
        foreach ( $concordance7->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[8]/ ) {
        my $concordance8 = Lingua::Concordance->new;
        $concordance8->radius($integer);
        my $reader8 = read_file($loopreplacefile);
        $concordance8->text($reader8);
        $concordance8->query(
            $initial_keys[8], $keys_for_8[0],  $keys_for_8[1],
            $keys_for_8[2],   $keys_for_8[3],  $keys_for_8[4],
            $keys_for_8[5],   $keys_for_8[6],  $keys_for_8[7],
            $keys_for_8[8],   $keys_for_8[9],  $keys_for_8[10],
            $keys_for_8[11],  $keys_for_8[12], $keys_for_8[13],
            $keys_for_8[14],  $keys_for_8[15], $keys_for_8[16],
            $keys_for_8[17],  $keys_for_8[18], $keys_for_8[19]
        );
        foreach ( $concordance8->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";

                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[9]/ ) {
        my $concordance9 = Lingua::Concordance->new;
        $concordance9->radius($integer);
        my $reader9 = read_file($loopreplacefile);
        $concordance9->text($reader9);
        $concordance9->query(
            $initial_keys[9], $keys_for_9[0],  $keys_for_9[1],
            $keys_for_9[2],   $keys_for_9[3],  $keys_for_9[4],
            $keys_for_9[5],   $keys_for_9[6],  $keys_for_9[7],
            $keys_for_9[8],   $keys_for_9[9],  $keys_for_9[10],
            $keys_for_9[11],  $keys_for_9[12], $keys_for_9[13],
            $keys_for_9[14],  $keys_for_9[15], $keys_for_9[16],
            $keys_for_9[17],  $keys_for_9[18], $keys_for_9[19]
        );
        foreach ( $concordance9->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";

                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[10]/ ) {
        my $concordance10 = Lingua::Concordance->new;
        $concordance10->radius($integer);
        my $reader10 = read_file($loopreplacefile);
        $concordance10->text($reader10);
        $concordance10->query(
            $initial_keys[10], $keys_for_10[0],  $keys_for_10[1],
            $keys_for_10[2],   $keys_for_10[3],  $keys_for_10[4],
            $keys_for_10[5],   $keys_for_10[6],  $keys_for_10[7],
            $keys_for_10[8],   $keys_for_10[9],  $keys_for_10[10],
            $keys_for_10[11],  $keys_for_10[12], $keys_for_10[13],
            $keys_for_10[14],  $keys_for_10[15], $keys_for_10[16],
            $keys_for_10[17],  $keys_for_10[18], $keys_for_10[19]
        );
        foreach ( $concordance10->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";

                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[11]/ ) {
        my $concordance11 = Lingua::Concordance->new;
        $concordance11->radius($integer);
        my $reader11 = read_file($loopreplacefile);
        $concordance11->text($reader11);
        $concordance11->query(
            $initial_keys[11], $keys_for_11[0],  $keys_for_11[1],
            $keys_for_11[2],   $keys_for_11[3],  $keys_for_11[4],
            $keys_for_11[5],   $keys_for_11[6],  $keys_for_11[7],
            $keys_for_11[8],   $keys_for_11[9],  $keys_for_11[10],
            $keys_for_11[11],  $keys_for_11[12], $keys_for_11[13],
            $keys_for_11[14],  $keys_for_11[15], $keys_for_11[16],
            $keys_for_11[17],  $keys_for_11[18], $keys_for_11[19]
        );
        foreach ( $concordance11->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";

                    my $looper = read_file($loopreplacefile);

                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[12]/ ) {
        my $concordance12 = Lingua::Concordance->new;
        $concordance12->radius($integer);
        my $reader12 = read_file($loopreplacefile);
        $concordance12->text($reader12);
        $concordance12->query(
            $initial_keys[12], $keys_for_12[0],  $keys_for_12[1],
            $keys_for_12[2],   $keys_for_12[3],  $keys_for_12[4],
            $keys_for_12[5],   $keys_for_12[6],  $keys_for_12[7],
            $keys_for_12[8],   $keys_for_12[9],  $keys_for_12[10],
            $keys_for_12[11],  $keys_for_12[12], $keys_for_12[13],
            $keys_for_12[14],  $keys_for_12[15], $keys_for_12[16],
            $keys_for_12[17],  $keys_for_12[18], $keys_for_12[19]
        );
        foreach ( $concordance12->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";

                    my $looper = read_file($loopreplacefile);

                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[13]/ ) {
        my $concordance13 = Lingua::Concordance->new;
        $concordance13->radius($integer);
        my $reader13 = read_file($loopreplacefile);
        $concordance13->text($reader13);
        $concordance13->query(
            $initial_keys[13], $keys_for_13[0],  $keys_for_13[1],
            $keys_for_13[2],   $keys_for_13[3],  $keys_for_13[4],
            $keys_for_13[5],   $keys_for_13[6],  $keys_for_13[7],
            $keys_for_13[8],   $keys_for_13[9],  $keys_for_13[10],
            $keys_for_13[11],  $keys_for_13[12], $keys_for_13[13],
            $keys_for_13[14],  $keys_for_13[15], $keys_for_13[16],
            $keys_for_13[17],  $keys_for_13[18], $keys_for_13[19]
        );
        foreach ( $concordance13->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";

                    my $looper = read_file($loopreplacefile);

                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[14]/ ) {
        my $concordance14 = Lingua::Concordance->new;
        $concordance14->radius($integer);
        my $reader14 = read_file($loopreplacefile);
        $concordance14->text($reader14);
        $concordance14->query(
            $initial_keys[14], $keys_for_14[0],  $keys_for_14[1],
            $keys_for_14[2],   $keys_for_14[3],  $keys_for_14[4],
            $keys_for_14[5],   $keys_for_14[6],  $keys_for_14[7],
            $keys_for_14[8],   $keys_for_14[9],  $keys_for_14[10],
            $keys_for_14[11],  $keys_for_14[12], $keys_for_14[13],
            $keys_for_14[14],  $keys_for_14[15], $keys_for_14[16],
            $keys_for_14[17],  $keys_for_14[18], $keys_for_14[19]
        );
        foreach ( $concordance14->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";

                    my $looper = read_file($loopreplacefile);

                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[15]/ ) {
        my $concordance15 = Lingua::Concordance->new;
        $concordance15->radius($integer);
        my $reader15 = read_file($loopreplacefile);
        $concordance15->text($reader15);
        $concordance15->query(
            $initial_keys[15], $keys_for_15[0],  $keys_for_15[1],
            $keys_for_15[2],   $keys_for_15[3],  $keys_for_15[4],
            $keys_for_15[5],   $keys_for_15[6],  $keys_for_15[7],
            $keys_for_15[8],   $keys_for_15[9],  $keys_for_15[10],
            $keys_for_15[11],  $keys_for_15[12], $keys_for_15[13],
            $keys_for_15[14],  $keys_for_15[15], $keys_for_15[16],
            $keys_for_15[17],  $keys_for_15[18], $keys_for_15[19]
        );
        foreach ( $concordance15->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";

                    my $looper = read_file($loopreplacefile);

                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[16]/ ) {
        my $concordance16 = Lingua::Concordance->new;
        $concordance16->radius($integer);
        my $reader16 = read_file($loopreplacefile);
        $concordance16->text($reader16);
        $concordance16->query(
            $initial_keys[16], $keys_for_16[0],  $keys_for_16[1],
            $keys_for_16[2],   $keys_for_16[3],  $keys_for_16[4],
            $keys_for_16[5],   $keys_for_16[6],  $keys_for_16[7],
            $keys_for_16[8],   $keys_for_16[9],  $keys_for_16[10],
            $keys_for_16[11],  $keys_for_16[12], $keys_for_16[13],
            $keys_for_16[14],  $keys_for_16[15], $keys_for_16[16],
            $keys_for_16[17],  $keys_for_16[18], $keys_for_16[19]
        );
        foreach ( $concordance16->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";

                    my $looper = read_file($loopreplacefile);

                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[17]/ ) {
        my $concordance17 = Lingua::Concordance->new;
        $concordance17->radius($integer);
        my $reader17 = read_file($loopreplacefile);
        $concordance17->text($reader17);
        $concordance17->query(
            $initial_keys[17], $keys_for_17[0],  $keys_for_17[1],
            $keys_for_17[2],   $keys_for_17[3],  $keys_for_17[4],
            $keys_for_17[5],   $keys_for_17[6],  $keys_for_17[7],
            $keys_for_17[8],   $keys_for_17[9],  $keys_for_17[10],
            $keys_for_17[11],  $keys_for_17[12], $keys_for_17[13],
            $keys_for_17[14],  $keys_for_17[15], $keys_for_17[16],
            $keys_for_17[17],  $keys_for_17[18], $keys_for_17[19]
        );
        foreach ( $concordance17->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";

                    my $looper = read_file($loopreplacefile);

                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[18]/ ) {
        my $concordance18 = Lingua::Concordance->new;
        $concordance18->radius($integer);
        my $reader18 = read_file($loopreplacefile);
        $concordance18->text($reader18);
        $concordance18->query(
            $initial_keys[18], $keys_for_18[0],  $keys_for_18[1],
            $keys_for_18[2],   $keys_for_18[3],  $keys_for_18[4],
            $keys_for_18[5],   $keys_for_18[6],  $keys_for_18[7],
            $keys_for_18[8],   $keys_for_18[9],  $keys_for_18[10],
            $keys_for_18[11],  $keys_for_18[12], $keys_for_18[13],
            $keys_for_18[14],  $keys_for_18[15], $keys_for_18[16],
            $keys_for_18[17],  $keys_for_18[18], $keys_for_18[19]
        );
        foreach ( $concordance18->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";

                    my $looper = read_file($loopreplacefile);

                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /$initial_keys[19]/ ) {
        my $concordance19 = Lingua::Concordance->new;
        $concordance19->radius($integer);
        my $reader19 = read_file($loopreplacefile);
        $concordance19->text($reader19);
        $concordance19->query(
            $initial_keys[19], $keys_for_19[0],  $keys_for_19[1],
            $keys_for_19[2],   $keys_for_19[3],  $keys_for_19[4],
            $keys_for_19[5],   $keys_for_19[6],  $keys_for_19[7],
            $keys_for_19[8],   $keys_for_19[9],  $keys_for_19[10],
            $keys_for_19[11],  $keys_for_19[12], $keys_for_19[13],
            $keys_for_19[14],  $keys_for_19[15], $keys_for_19[16],
            $keys_for_19[17],  $keys_for_19[18], $keys_for_19[19]
        );
        foreach ( $concordance19->lines ) {
            print "$_\n";
            if ( $_ =~ /~~/ ) {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";
                    my $looper = read_file($loopreplacefile);
                    $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
            else {
                print "Would you like to keep this line?\t";
                my $userinput = <STDIN>;
                chomp $userinput;
                if ( $userinput =~ /no/i ) {
                    $_ =~ s/\S+\s*//;
                    print "\nHow many chars to remove from the end?\t";
                    my $endremove = <STDIN>;
                    chomp $endremove;
                    for ( my $chomper = 0 ; $chomper < $endremove ; $chomper++ )
                    {
                        $_ =~ s/(\S)$//i;
                    }
                    $_ =~ s/\s{2,}/ /g;
                    print "\n" . $_ . "\n";

                    my $looper = read_file($loopreplacefile);

                    $looper =~ s/\Q$_/||||||||||/i;
                    open( LOOPER, ">", $loopreplacefile );
                    print LOOPER "$looper";
                    close LOOPER;
                }
                elsif ( $userinput =~ /exit/i ) {
                    last;
                }
                else {
                    system('pause');
                }
            }
        }
    }
    elsif ( $finder =~ /clear all proper/i ) {
        my $properfile = "C:/Perl/".$inputfile."proper.txt";
        open( PROP, ">", $properfile );
        my $parserforproper = new Lingua::EN::Tagger;
        my $parserfile      = read_file($loopreplacefile);
        my $tagged_text     = $parserforproper->add_tags($parserfile);

        #print $tagged_text;
        my %wordlist = $parserforproper->get_words($parserfile);
        my @wordlistq;
        foreach my $parsedkey ( keys %wordlist ) {

            #print $parsedkey;
            $parsedkey =~ s/\\\w+//;
            push @wordlistq, $parsedkey;
        }
        print PROP "$_\n" for @wordlistq;
        close PROP;
        for ( my $isl = 0 ; $isl < $#wordlistq ; $isl++ ) {
            my $querty        = $wordlistq[$isl];
            my $concordance20 = Lingua::Concordance->new;
            $concordance20->radius($integer);
            my $reader20 = read_file($loopreplacefile);
            $concordance20->text($reader20);
            $concordance20->query($querty);
            foreach ( $concordance20->lines ) {
                print "$_\n";
                if ( $_ =~ /~~/ ) {
                    print "Would you like to keep this line?\t";
                    my $userinput = <STDIN>;
                    chomp $userinput;
                    if ( $userinput =~ /no/i ) {
                        $_ =~ s/\S+\s*//;
                        print "\nHow many chars to remove from the end?\t";
                        my $endremove = <STDIN>;
                        chomp $endremove;
                        for (
                            my $chomper = 0 ;
                            $chomper < $endremove ;
                            $chomper++
                          )
                        {
                            $_ =~ s/(\S)$//i;
                        }
                        $_ =~ s/\s{2,}/ /g;
                        print "\n" . $_ . "\n";
                        my $looper = read_file($loopreplacefile);
                        $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                        open( LOOPER, ">", $loopreplacefile );
                        print LOOPER "$looper";
                        close LOOPER;
                    }
                    elsif ( $userinput =~ /exit/i ) {
                        last;
                    }
                    else {
                        system('pause');
                    }
                }
                else {
                    print "Would you like to keep this line?\t";
                    my $userinput = <STDIN>;
                    chomp $userinput;
                    if ( $userinput =~ /no/i ) {
                        $_ =~ s/\S+\s*//;
                        print "\nHow many chars to remove from the end?\t";
                        my $endremove = <STDIN>;
                        chomp $endremove;
                        for (
                            my $chomper = 0 ;
                            $chomper < $endremove ;
                            $chomper++
                          )
                        {
                            $_ =~ s/(\S)$//i;
                        }
                        $_ =~ s/\s{2,}/ /g;
                        print "\n" . $_ . "\n";
                        my $looper = read_file($loopreplacefile);
                        $looper =~ s/\Q$_/||||||||||/i;
                        open( LOOPER, ">", $loopreplacefile );
                        print LOOPER "$looper";
                        close LOOPER;
                    }
                    elsif ( $userinput =~ /exit/i ) {
                        $isl = $#wordlistq;
                    }
                    else {
                        system('pause');
                    }
                }
            }
        }
    }
    elsif ( $finder =~ /i can do this myself/i ) {
        while (1) {
            print "\nWhat to search for (you can type 0 to exit):\t";
            my $givemeasearch = <STDIN>;
            chomp $givemeasearch;
            if ( $givemeasearch !~ /\b0\b/ ) {
                my $concordance21 = Lingua::Concordance->new;
                $concordance21->radius($integer);
                my $reader21 = read_file($loopreplacefile);
                $concordance21->text($reader21);
                $concordance21->query($givemeasearch);
                foreach ( $concordance21->lines ) {
                    print "$_\n";
                    if ( $_ =~ /~~/ ) {
                        print "Would you like to keep this line?\t";
                        my $userinput = <STDIN>;
                        chomp $userinput;
                        if ( $userinput =~ /no/i ) {
                            $_ =~ s/\S+\s*//;
                            print "\nHow many chars to remove from the end?\t";
                            my $endremove = <STDIN>;
                            chomp $endremove;
                            for (
                                my $chomper = 0 ;
                                $chomper < $endremove ;
                                $chomper++
                              )
                            {
                                $_ =~ s/(\S)$//i;
                            }
                            $_ =~ s/\s{2,}/ /g;
                            print "\n" . $_ . "\n";
                            my $looper = read_file($loopreplacefile);
                            $looper =~ s/\Q$_/||||||||||~~||||||||||/i;
                            open( LOOPER, ">", $loopreplacefile );
                            print LOOPER "$looper";
                            close LOOPER;
                        }
                        elsif ( $userinput =~ /exit/i ) {
                            last;
                        }
                        else {
                            system('pause');
                        }
                    }
                    else {
                        print "Would you like to keep this line?\t";
                        my $userinput = <STDIN>;
                        chomp $userinput;
                        if ( $userinput =~ /no/i ) {
                            $_ =~ s/\S+\s*//;
                            print "\nHow many chars to remove from the end?\t";
                            my $endremove = <STDIN>;
                            chomp $endremove;
                            for (
                                my $chomper = 0 ;
                                $chomper < $endremove ;
                                $chomper++
                              )
                            {
                                $_ =~ s/(\S)$//i;
                            }
                            $_ =~ s/\s{2,}/ /g;
                            print "\n" . $_ . "\n";

                            my $looper = read_file($loopreplacefile);

                            $looper =~ s/\Q$_/||||||||||/i;
                            open( LOOPER, ">", $loopreplacefile );
                            print LOOPER "$looper";
                            close LOOPER;
                        }
                        elsif ( $userinput =~ /exit/i ) {
                            last;
                        }
                        else {
                            system('pause');
                        }
                    }
                }
            }
            elsif ( $givemeasearch =~ /\b0\b/ ) {
                last;
            }
        }
    }
    elsif ( $finder =~ /\b0\b/ ) {
        last;
    }
}

$datatomod = 0;

$datatomod = read_file($loopreplacefile);

#the removal would just be removal of text between selected subsection
#and next subsection

#feature to add a 0.20 summary of the subsection before removal would
#be important

#nextly, in order to remove sensitive material, I think that it would make
#more sense to reduce the overall space I have to search so
#Text::Summarize::En would work best in this part

my $inputfilemod = $inputfile;
my $modify       = $inputfile . "redacted.txt";

#my $modify = "C:/Perl/removal.txt";
#print "Beginning to remove uniquely identifying material in text.\n";
#print "Output will be located in $modify \n";
#print "This process can take a lot of time and memory... please be patient.\n";

$datatomod =~ s/restricted/||||||||||/ig;
$datatomod =~ s/confidential/||||||||||/ig;
$datatomod =~ s/top secret/||||||||||/ig;
$datatomod =~ s/secret/||||||||||/ig;
$datatomod =~ s/unclassified/||||||||||/ig;

#for(my $k = 0; $k < $#characterizingwords; $k++){
#	my $wordtomod = $characterizingwords[$k];
#	$datatomod =~ s/\s$wordtomod\s/||||||||||/ig;
#}

#print "Removal completed...\n";
#print "Printing to $modify...\n";
open( MODIFY, ">", $modify ) or die "Can't open $modify.\n";

print "\nWould you like Month, days, and weekdays to be removed?\t";
my $monthdayweekyesno = <STDIN>;
chomp $monthdayweekyesno;
if ( $monthdayweekyesno =~ /yes/i ) {
    my @months =
      qw/january february march april may june july august september october november december/;
    my @week = qw/monday tuesday wednesday thursday friday saturday sunday/;
    for ( my $l = 0 ; $l < $#months ; $l++ ) {
        my $monthtime = "$months[$l]";
        $datatomod =~ s/[0-9]{1,2}(\s)?$monthtime/||||||||||/ig;
        $datatomod =~ s/$monthtime(\s)?[0-9]{1,2}(\s|\,)?/||||||||||/ig;
        if ( $monthtime =~ /may/ ) {
            $datatomod =~ s/\b$monthtime\b/||||||||||/ig;
        }
        else {
            $datatomod =~ s/$monthtime/||||||||||/ig;
        }
        $datatomod =~ s/[0-9]{2}\//||||||||||/g;
    }
    for ( my $m = 0 ; $m < $#week ; $m++ ) {
        my $weektime = "$week[$m]";
        $datatomod =~ s/$weektime/||||||||||/ig;
    }
    print "Task completed.\n";
    system('pause');
}

print "\nWould you like the year to be removed?\t";
my $timeyearyesno = <STDIN>;
chomp $timeyearyesno;
if ( $timeyearyesno =~ /[Yy][Ee][Ss]/ ) {
    $datatomod =~ s/[0-9]{4}/||||||||||/g;
    print "Task completed.\n";
}
else {
    system('pause');
}

my @suffixhourcounter =
  qw/first second third fourth fifth sixth seventh eigth ninth tenth eleventh twelfth/;
print "\nWould you like to remove specific times such as 24:00?\t";
my $timeclockyesno = <STDIN>;
chomp $timeclockyesno;
if ( $timeclockyesno =~ /[Yy][Ee][Ss]/ ) {
    $datatomod =~ s/\s[0-9]{1,2}:[0-9]{2}\s/||||||||||/g;
    $datatomod =~ s/\s[0-9]{1,2}\so\'clock/||||||||||/ig;
    for ( my $n = 0 ; $n < $#suffixhourcounter ; $n++ ) {
        my $timehour = "$suffixhourcounter[$n]";
        $datatomod =~ s/$timehour\shour/||||||||||/ig;
    }
    print "Task completed.\n";
}
else {
    system('pause');
}

my @timeindicators = (
    "Abruptly",             "After",
    "After a few days",     "After a long time",
    "After a short time",   "After a while",
    "After that",           "Afterward",
    "All at once",          "All of the time",
    "All the while",        "Always",
    "As long as",           "As soon as",
    "At first",             "At last",
    "At length",            "At present",
    "At that time",         "At the beginning",
    "At the end",           "At that onset",
    "At the same time",     "At this moment",
    "At times",             "Before",
    "Begin",                "By now",
    "Commence",             "Commencing",
    "Concurrently",         "Consequently",
    "Continually",          "Currently",
    "Cyclically",           "Directly",
    "During",               "Earlier",
    "Embark",               "Eventually",
    "Every time",           "Final",
    "Finally",              "First",
    "Following",            "Following that",
    "Former",               "Formerly",
    "Frequently",           "From this point",
    "Generally",            "Gradual",
    "Henceforth",           "Hereafter",
    "Heretofore",           "Immediately",
    "In an instant",        "In awhile",
    "In conclusion",        "In the end",
    "In the first place",   "In the future",
    "In the last place",    "In the meantime",
    "In the past",          "In the second place",
    "In turn",              "In frequently",
    "Initial",              "Instantly",
    "Instantaneously",      "Intermittent",
    "Just then",            "Last",
    "Last of all",          "Lastly",
    "Later",                "Later on",
    "Later that day",       "Little by little",
    "Meanwhile",            "Momentarily",
    "Never",                "Next",
    "Not at all",           "Not long after",
    "Not long ago",         "Now",
    "Occasionally",         "Of late",
    "Often",                "Often time",
    "On the next occasion", "Once",
    "Once upon a time",     "Past",
    "Periodically",         "Preceding",
    "Present",              "Presently",
    "Previously",           "Prior to",
    "Promptly",             "Quick",
    "Rarely",               "Recently",
    "Repeatedly",           "Right after",
    "Right away",           "Second",
    "Seldom",               "Sequentially",
    "Shorty",               "Simultaneously",
    "Slow",                 "So far",
    "Some of the time",     "Some time",
    "Soon",                 "Soon after",
    "Soon afterward",       "Sporadically",
    "Starting with",        "Subsequently",
    "Suddenly",             "Temporary",
    "The latter",           "The next",
    "The final",            "Then",
    "Thereafter",           "This instant",
    "Third",                "To begin with",
    "To conclude",          "To finish",
    "Today",                "Tomorrow",
    "Twice",                "Uncommon",
    "Ultimately",           "Until",
    "Until now",            "Usually",
    "When",                 "While",
    "Yesterday",            "Yet"
);
print
"\nWould you like to be more thorough and remove more specific time indicatiors?\t";
my $timeindiyesno = <STDIN>;
chomp $timeindiyesno;
if ( $timeindiyesno =~ /[Yy][Ee][Ss]/ ) {
    for ( my $o = 0 ; $o < $#timeindicators ; $o++ ) {
        my $indicator = "$timeindicators[$o]";
        $datatomod =~ s/$indicator\s/||||||||||/ig;
    }
    print "Task completed.\n";
}
else {
    system('pause');
}

print "\nWould you like to remove country names?\t";
my $countryyesno = <STDIN>;
chomp $countryyesno;
if ( $countryyesno =~ /yes/i ) {
    my @countrynames = all_country_names();
    my @morecountries =
      qw/America Europ Africa Asia North South Bolivia Bonaire Saba Antigua Barbuda Bosnia Herzegovina Carribean Indian Atlantic Pacific Brunei Keeling Cocos Falkland Malvinas Faroe Iran Korea Macedonia Micronesia Moldova Palestine Russia Kitts Nevis Miquelon Taiwan Tanzania Turks Caicos Venezuela/;
    push @countrynames, @morecountries;
    for ( my $p = 0 ; $p < $#countrynames ; $p++ ) {
        my $countryparse = "$countrynames[$p]";
        $datatomod =~ s/$countryparse([A-Z]+)?/||||||||||/ig;
    }
    my @countrylanguage = all_language_names();
    for ( my $q = 0 ; $q < $#countrylanguage ; $q++ ) {
        my $countrylang = "$countrylanguage[$q]";
        $datatomod =~ s/$countrylang/||||||||||/ig;
    }
    print "Task completed.\n";
    system('pause');
}

print "\nWould you like to do organizational redaction?\t";
my $orgyesno = <STDIN>;
chomp $orgyesno;
if ( $orgyesno =~ /yes/i ) {
    $datatomod =~ s/([A-Z](\.)?){2,}/||||||||||/g;
    $datatomod =~ s/\((\s)?([A-Z](\.)?){2,}(\s)?\)/||||||||||/ig;
    $datatomod =~ s/[0-9]+(\.)?([0-9]+)?%/||||||||||/g;
    $datatomod =~ s/\-[0-9]+//g;
    $datatomod =~ s/(([A-Z])([a-z]+)\s?){2,5}/||||||||||/g;
    print "Task completed.\n";
    system('pause');
}

#need to use a transliterated list or Regexp::Common to identify quotes and parenthesis

#$Authorship = $x*$organization + $y*$classification + $z*$topic + error;

#my @listcontainingorgname;
#my $organizationabbv =~ /[A-Z]{2,5}/;
#my $orgpattern =~ /(\w{1,}\s){2,5}$organizationabbv/ig;

$datatomod =~ tr{~}{\n};
$datatomod =~ s/\|\|\|\|\|\|\|\|\|\|(\w+)\s/|||||||||| /ig;
$datatomod =~ s/(\w+)\|\|\|\|\|\|\|\|\|\|/|||||||||| /ig;
$datatomod =~ s/_/ /g;

#$datatomod =~ s/\|\|\|\|\|/\x{25AE}\x{25AE}\x{25AE}\x{25AE}\x{25AE}/g;

#$datatomod !~ s/[^[:ascii:]]|'|"|“|”|’|!|\?//g;

print MODIFY $datatomod;

close MODIFY;

$datatomod = 0;
$datatomod = read_file($modify);

my $rtf = RTF::Writer->new_to_file("C:/Perl/redacted.rtf");
$rtf->prolog( 'title' => "Insert Title" );
$rtf->number_pages;
$rtf->print(
    \'\fs40\b\i',    # 20pt, bold, italic
    $datatomod
);
$rtf->close;

print
"\n\nAre you finished with your redaction? If not, you can save a text file to continue redaction later.\t";

my $areyoudoneyet = <STDIN>;
chomp $areyoudoneyet;

if ( $areyoudoneyet =~ /no/i ) {
    print "\nEnter the name of the file: ";
    my $filename = <STDIN>;
    chomp $filename;
    my $tryagainfile = $filename . ".txt";
    open( TRY, ">", $tryagainfile ) or die;
    print TRY $datatomod;
    close TRY;
}

open( INT2, ">", $intermediatefile ) or die;
print INT2 "";
close INT2;

my $keywordsfile2 = "C:/Perl/".$inputfile."keywords2.txt";
open( KEYFI2, ">", $keywordsfile2 ) or die;

my $datatomod2 = read_file($modify);

my @final_keys;
my $lastextract = Text::TermExtract->new();
$lastextract->exclude($exclude_list_ref);
$lastextract->exclude(
    [
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
        'www'
    ]
);

for my $words ( $lastextract->terms_extract( $datatomod2, { max => 20 } ) ) {
    push @final_keys, $words;
}

print KEYFI2 "$_\n" for @final_keys;

close KEYFI2;

my $lc = List::Compare->new( \@initial_keys, \@final_keys );

my @intersection = $lc->get_intersection;

print "Keywords that intersect (are in initial keys and final keys)\n";
print "$_\n" for @intersection;

my @union = $lc->get_union;

print "Keywords that are union (are in initial keys or final keys)\n";
print "$_\n" for @union;

print "\n\n";

my $endtext = new Lingua::EN::Fathom;
$endtext->analyse_file($modify);
my $endaccumulate = 1;
$endtext->analyse_block( my $endtext_string, $endaccumulate );

my $num_chars2             = $endtext->num_chars;
my $num_words2             = $endtext->num_words;
my $percent_complex_words2 = $endtext->percent_complex_words;
my $num_sentences2         = $endtext->num_sentences;
my $num_text_lines2        = $endtext->num_text_lines;
my $num_blank_lines2       = $endtext->num_blank_lines;
my $num_paragraphs2        = $endtext->num_paragraphs;
my $syllables_per_word2    = $endtext->syllables_per_word;
my $words_per_sentence2    = $endtext->words_per_sentence;

my $fog2     = $endtext->fog;
my $flesch2  = $endtext->flesch;
my $kincaid2 = $endtext->kincaid;

print( $endtext->report );
print "\n\n";
system('pause');

exit;
