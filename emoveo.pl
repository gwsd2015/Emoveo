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
use Parse::RecDescent;
use Lingua::Identify qw(langof);
use PDL;
use Regexp::Common;
use POSIX qw(strftime);
use LWP::Simple;
use HTML::TreeBuilder;
use HTML::FormatText;
use Locale::Country;
use Locale::Language;
use String::Multibyte;
use Lingua::Concordance;
use Lingua::EN::Ngram;
use Lingua::Orthon;
use Date::Extract;
use Date::Extract::Surprise;
use Encode qw(decode encode);
#to be phased out for Text::TermExtract
use Lingua::EN::Keywords qw(keywords);
#to be phased out for Text::TermExtract
use Text::Context::Porter;
use Text::TermExtract;
use RTF::Writer;
use WWW::Wikipedia;
use Lingua::EN::Tagger;
use Tkx;

#take the input file from the user
#file slurp and extract the text

print "Make sure that the pdf is saved as a txt file using the save as other function built into Adobe Reader.\n";
print "Enter txt file location:\t";
my $inputfile = <STDIN>;
chomp $inputfile;
print "Input file, $inputfile, read.\n";
#print "Enter a title for the txt file:\t";
#my $title = <STDIN>;
#chomp $title;
my $textfile = read_file($inputfile);
print "$textfile\n\n";
#my $analysistextfile = $textfile;
my $datatomod = ($textfile);

#building some of these file to check that I properly completed steps.
#necessary to keep in order to hvae file to chain the n-gram removal tool.
my $check = "C:/Perl/checkfile.txt";
open(CHK, ">:utf8",$check) or die "Can't generate $check\n";
print "File $check generated.\n";
print CHK "$textfile";
close CHK;

my $text = new Lingua::EN::Fathom;
$text->analyse_file($inputfile);
my $accumulate = 1;
$text->analyse_block(my $text_string, $accumulate);

my $num_chars = $text->num_chars;
my $num_words = $text->num_words;
my $percent_complex_words = $text->percent_complex_words;
my $num_sentences = $text->num_sentences;
my $num_text_lines = $text->num_text_lines;
my $num_blank_lines = $text->num_blank_lines;
my $num_paragraphs = $text->num_paragraphs;
my $syllables_per_word = $text->syllables_per_word;
my $words_per_sentence = $text->words_per_sentence;

my $fog     = $text->fog;
my $flesch  = $text->flesch;
my $kincaid = $text->kincaid;

print($text->report);
print "\n\n";
system('pause');

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
for my $wordsensing($ext->terms_extract($datatomod,{max =>20})){
	print "$wordsensing\n";
	push @initial_keys, $wordsensing;
	push @initial_keys_to_tag, $wordsensing;
}
system('pause');

print @initial_keys;
system('pause');

print "\nPreparing to build keyword trees...\n\n";

for(my $counters = 0; $counters < $#initial_keys; $counters++){
	my $key_to_search = $initial_keys[$counters];
	my $wiki = WWW::Wikipedia->new();
	my $result = $wiki->search($key_to_search);
	my $filewiki = "C:/Perl/wikistore.txt";
	open(WIKI, ">:utf8", $filewiki) or die;
	if($result !~ /^$/){
		if ($result->text()){ 
			print WIKI $result->text();
			print $result->text();
			close WIKI;
			#my $service = read_file($filewiki);
			my $wikifile = read_file($filewiki);
			my $wikiext = Text::TermExtract->new();
			for my $keyword($wikiext->terms_extract($wikifile,{max =>20})){
				print $keyword."\n";
				if($counters == 0){
					push @keys_for_0, $keyword;
				}
				elsif($counters == 1){
					push @keys_for_1, $keyword;
				}
				elsif($counters == 2){
					push @keys_for_2, $keyword;
				}
				elsif($counters == 3){
					push @keys_for_3, $keyword;
				}
				elsif($counters == 4){
					push @keys_for_4, $keyword;
				}
				elsif($counters == 5){
					push @keys_for_5, $keyword;
				}
				elsif($counters == 6){
					push @keys_for_6, $keyword;
				}
				elsif($counters == 7){
					push @keys_for_7, $keyword;
				}
				elsif($counters == 8){
					push @keys_for_8, $keyword;
				}
				elsif($counters == 9){
					push @keys_for_9, $keyword;
				}
				elsif($counters == 10){
					push @keys_for_10, $keyword;
				}
				elsif($counters == 11){
					push @keys_for_11, $keyword;
				}
				elsif($counters == 12){
					push @keys_for_12, $keyword;
				}
				elsif($counters == 13){
					push @keys_for_13, $keyword;
				}
				elsif($counters == 14){
					push @keys_for_14, $keyword;
				}
				elsif($counters == 15){
					push @keys_for_15, $keyword;
				}
				elsif($counters == 16){
					push @keys_for_16, $keyword;
				}
				elsif($counters == 17){
					push @keys_for_17, $keyword;
				}
				elsif($counters == 18){
					push @keys_for_18, $keyword;
				}
				elsif($counters == 19){
					push @keys_for_19, $keyword;
				}
			}
		}
	}
}

system('pause');

my $form = Tkx::widget->new('.');
$form->g_wm_title('test object GUI');
$form->m_configure(-background => "red");
$form->g_wm_minsize(800, 480);

my $button0;

$button0 = $form->new_button(
	-text => $initial_keys[0]
);

$button0->g_pack(
	-padx => 0,
	-pady => 0,
);

my $button1;

$button1 = $form->new_button(
	-text => $initial_keys[1]
);

$button1->g_pack(
	-padx => 0,
	-pady => 150,
);

my $button2;

$button2 = $form->new_button(
	-text => $initial_keys[2]
);

$button2->g_pack(
	-padx => 0,
	-pady => 300,
);

my $button3;

$button3 = $form->new_button(
	-text => $initial_keys[3]
);

$button3->g_pack(
	-padx => 0,
	-pady => 450,
);

my $button4;

$button4 = $form->new_button(
	-text => $initial_keys[4]
);

$button4->g_pack(
	-padx => 0,
	-pady => 600,
);

my $button5;

$button5 = $form->new_button(
	-text => $initial_keys[5]
);

$button5->g_pack(
	-padx => 150,
	-pady => 0,
);

my $button6;

$button6 = $form->new_button(
	-text => $initial_keys[6]
);

$button6->g_pack(
	-padx => 150,
	-pady => 150,
);

my $button7;

$button7 = $form->new_button(
	-text => $initial_keys[7]
);

$button7->g_pack(
	-padx => 150,
	-pady => 300,
);

my $button8;

$button8 = $form->new_button(
	-text => $initial_keys[8]
);

$button8->g_pack(
	-padx => 150,
	-pady => 450,
);

my $button9;

$button9 = $form->new_button(
	-text => $initial_keys[9]
);

$button9->g_pack(
	-padx => 150,
	-pady => 600,
);

my $button10;

$button10 = $form->new_button(
	-text => $initial_keys[10]
);

$button10->g_pack(
	-padx => 300,
	-pady => 0,
);

my $button11;

$button11 = $form->new_button(
	-text => $initial_keys[11]
);

$button11->g_pack(
	-padx => 300,
	-pady => 150,
);

my $button12;

$button12 = $form->new_button(
	-text => $initial_keys[12]
);

$button12->g_pack(
	-padx => 300,
	-pady => 300,
);

my $button13;

$button13 = $form->new_button(
	-text => $initial_keys[13]
);

$button13->g_pack(
	-padx => 300,
	-pady => 450,
);

my $button14;

$button14 = $form->new_button(
	-text => $initial_keys[14]
);

$button14->g_pack(
	-padx => 300,
	-pady => 600,
);

my $button15;

$button15 = $form->new_button(
	-text => $initial_keys[15]
);

$button15->g_pack(
	-padx => 600,
	-pady => 0,
);

my $button16;

$button16 = $form->new_button(
	-text => $initial_keys[16]
);

$button16->g_pack(
	-padx => 600,
	-pady => 150,
);

my $button17;

$button17 = $form->new_button(
	-text => $initial_keys[17]
);

$button17->g_pack(
	-padx => 600,
	-pady => 300,
);

my $button18;

$button18 = $form->new_button(
	-text => $initial_keys[18]
);

$button18->g_pack(
	-padx => 600,
	-pady => 450,
);

my $button19;

$button19 = $form->new_button(
	-text => $initial_keys[19]
);

$button19->g_pack(
	-padx => 600,
	-pady => 600,
);

Tkx::tk___messageBox(
	-parent => $form,
	-icon => "info",
	-title => "Word List",
	-message => "This is a wordlist for your reference",
);

Tkx::MainLoop();

my $par = new Lingua::EN::Tagger;
my $tagged_text = $par->add_tags($datatomod);
my %nounphrase = $par->get_noun_phrases($tagged_text);
print %nounphrase;
my @nountable;
foreach my $nounkeys(keys %nounphrase){
	if($nounkeys !~ /(\(|\)|\{|\}|\[|\]|\^|\$|\.|\||\*|\+|\?|\\)/){
		push @nountable, $nounkeys;
	}
}
system('pause');
print @nountable;
system('pause');

#the removal would just be removal of text between selected subsection
#and next subsection

#feature to add a 0.20 summary of the subsection before removal would
#be important

#nextly, in order to remove sensitive material, I think that it would make
#more sense to reduce the overall space I have to search so 
#Text::Summarize::En would work best in this part

my $inputfilemod = $inputfile;
my $modify = $inputfile."redacted.txt";
#my $modify = "C:/Perl/removal.txt";
print "Beginning to remove uniquely identifying material in text.\n";
print "Output will be located in $modify \n";
print "This process can take a lot of time and memory... please be patient.\n";

$datatomod =~ s/restricted/ /ig;
$datatomod =~ s/confidential/ /ig;
$datatomod =~ s/top secret/ /ig;
$datatomod =~ s/secret/ /ig;
$datatomod =~ s/unclassified/ /ig;

#for(my $k = 0; $k < $#characterizingwords; $k++){
#	my $wordtomod = $characterizingwords[$k];
#	$datatomod =~ s/\s$wordtomod\s/ /ig;
#}

print "Removal completed...\n";
print "Printing to $modify...\n";
open(MODIFY, ">:utf8",$modify) or die "Can't open $modify.\n";

print "Searching document for generic time indicators.\n";
my @months = qw/january february march april may june july august september october november december/;
my @week = qw/monday tuesday wednesday thursday friday saturday sunday/;
for(my $l = 0; $l < $#months; $l++){
	my $monthtime = $months[$l];
	$datatomod =~ s/[0-9]{1,2}(\s)?$monthtime/ /ig;
	$datatomod =~ s/$monthtime(\s)?[0-9]{1,2}(\s|\,)?/ /ig;
	if($monthtime =~ /may/){
		$datatomod =~ s/\b$monthtime\b/ /ig;
	}
	else{
		$datatomod =~ s/$monthtime/ /ig;
	}
	$datatomod =~ s/[0-9]{2}\// /g;
}
for(my $m = 0; $m < $#week; $m++){
	my $weektime = $week[$m];
	$datatomod =~ s/$weektime\s/ /ig;
}
print "Task completed.\n";
system('pause');

print "\nMonth, days, and weekdays are removed. Would you like the year to be removed?\t";
my $timeyearyesno = <STDIN>;
chomp $timeyearyesno;
if($timeyearyesno =~ /[Yy][Ee][Ss]/){
	$datatomod =~ s/[0-9]{4}/ /g;
	print "Task completed.\n";
}
else{
	system('pause');
}

my @suffixhourcounter = qw/first second third fourth fifth sixth seventh eigth ninth tenth eleventh twelfth/;
print "\nWould you like to remove specific times such as 24:00?\t";
my $timeclockyesno = <STDIN>;
chomp $timeclockyesno;
if($timeclockyesno =~ /[Yy][Ee][Ss]/){
	$datatomod =~ s/\s[0-9]{1,2}:[0-9]{2}\s/ /g;
	$datatomod =~ s/\s[0-9]{1,2}\so\'clock/ /ig;
	for(my $n = 0; $n < $#suffixhourcounter; $n++){
		my $timehour = $suffixhourcounter[$n];
		$datatomod =~ s/$timehour\shour/ /ig;
	}
	print "Task completed.\n";
}
else{
	system('pause');
}

my @timeindicators = ("Abruptly", "After", "After a few days", "After a long time", "After a short time", "After a while", "After that", "Afterward", "All at once", "All of the time", "All the while", "Always", "As long as", "As soon as", "At first", "At last", "At length", "At present", "At that time", "At the beginning", "At the end", "At that onset", "At the same time", "At this moment", "At times", "Before", "Begin", "By now", "Commence", "Commencing", "Concurrently", "Consequently", "Continually", "Currently", "Cyclically", "Directly", "During", "Earlier", "Embark", "Eventually", "Every time", "Final", "Finally", "First", "Following", "Following that", "Former", "Formerly", "Frequently", "From this point", "Generally", "Gradual", "Henceforth", "Hereafter", "Heretofore", "Immediately", "In an instant", "In awhile", "In conclusion", "In the end", "In the first place", "In the future", "In the last place", "In the meantime", "In the past", "In the second place", "In turn", "In frequently", "Initial", "Instantly", "Instantaneously", "Intermittent", "Just then", "Last", "Last of all", "Lastly", "Later", "Later on", "Later that day", "Little by little", "Meanwhile", "Momentarily", "Never", "Next", "Not at all", "Not long after", "Not long ago", "Now", "Occasionally", "Of late", "Often", "Often time", "On the next occasion", "Once", "Once upon a time", "Past", "Periodically", "Preceding", "Present", "Presently", "Previously", "Prior to", "Promptly", "Quick", "Rarely", "Recently", "Repeatedly", "Right after", "Right away", "Second", "Seldom", "Sequentially", "Shorty", "Simultaneously", "Slow", "So far", "Some of the time", "Some time", "Soon", "Soon after", "Soon afterward", "Sporadically", "Starting with", "Subsequently", "Suddenly", "Temporary", "The latter", "The next", "The final", "Then", "Thereafter", "This instant", "Third", "To begin with", "To conclude", "To finish", "Today", "Tomorrow", "Twice", "Uncommon", "Ultimately", "Until", "Until now", "Usually", "When", "While", "Yesterday", "Yet");
print "\nWould you like to be more thorough and remove more specific time indicatiors?\t";
my $timeindiyesno = <STDIN>;
chomp $timeindiyesno;
if($timeindiyesno =~ /[Yy][Ee][Ss]/){
	for(my $o = 0; $o < $#timeindicators; $o++){
		my $indicator = $timeindicators[$o];
		$datatomod =~ s/$indicator\s/ /ig;
	}
	print "Task completed.\n";
}
else{
	system('pause');
}

print "\nNow searching for country names...\n";
my @countrynames = all_country_names();
my @morecountries = qw/Bolivia Bonaire Saba Antigua Barbuda Bosnia Herzegovina Carribean Indian Atlantic Pacific Brunei Keeling Cocos Falkland Malvinas Faroe Iran Korea Macedonia Micronesia Moldova Palestine Russia Kitts Nevis Miquelon Taiwan Tanzania Turks Caicos Venezuela/;
push @countrynames, @morecountries;
for(my $p = 0; $p < $#countrynames; $p++){
	my $countryparse = $countrynames[$p];
	$datatomod =~ s/$countryparse([A-Z]+)?/ /ig;
}
my @countrylanguage = all_language_names();
for(my $q = 0; $q < $#countrylanguage; $q++){
	my $countrylang = $countrylanguage[$q];
	$datatomod =~ s/$countrylang/ /ig;
}
print "Task completed.\n";
system('pause');

print "\nPreparing organizational redaction...\n";
$datatomod =~ s/([A-Z](\.)?){2,}/ /g;
$datatomod =~ s/\((\s)?([A-Z](\.)?){2,}(\s)?\)/ /ig;
$datatomod =~ s/[0-9]+(\.)?([0-9]+)?%/ /g;
print "Task completed.\n";
system('pause');

#need to use a transliterated list or Regexp::Common to identify quotes and parenthesis

#$Authorship = $x*$organization + $y*$classification + $z*$topic + error;

#my @listcontainingorgname;
#my $organizationabbv =~ /[A-Z]{2,5}/;
#my $orgpattern =~ /(\w{1,}\s){2,5}$organizationabbv/ig;


print "\nPreparing for second stage analysis\n";

my @languagegramstore;

my %languages = langof($datatomod);
dump %languages = langof($datatomod);
#print %languages;
print "\nThe probability of this text being English is:\t$languages{'en'}\n\n...\n";

if($languages{'en'} > 0.357){
	print "\nLanguage analysis completed.\n";	
	print "\nSecond stage test have determined redaction is incomplete.\n";
	system('pause');
}
else {
	print "\nLanguage analysis completed.\n";
	print "\nPassed second stage analysis.\n";
}

print MODIFY $datatomod."\n============================\n";

close MODIFY;

exit;

