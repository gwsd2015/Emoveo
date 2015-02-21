#I haven't subroutined my stuff yet, trying to write everything out and figure how things
#are cutting depending on the size of the program.

#purpose of the program

#ISO27k Guideline on Information Asset Valuation 

#Information wherever it is handled or stored (e.g., in computers, file cabinets,
#desktops, fax machines, Xerox, printer, verbal communication etc.) needs to be
#suitably and appropriately protected from unauthorized access, modification,
#disclosure, and destruction. All information will not be accorded with the same
#importance. Consequently, classification of information into categories is necessary
#to help identify a framework for evaluating the informationâ€™s relative value and the
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

use strict;
use warnings;
use Lingua::EN::StopWords qw(%StopWords);
use Lingua::Stem::En;
use Text::Summarize::En;
use Data::Dump qw(dump);
use Path::Class;
use Lingua::EN::Fathom;
use utf8;
use File::Slurp qw(read_file write_file);
use Parse::RecDescent;
use Lingua::Identify qw(langof);
use Text::Levenshtein::XS qw(distance);
use Text::Soundex;
use Search::VectorSpace;
use PDL;
use Regexp::Common;
use POSIX qw(strftime);
use LWP::Simple;
use HTML::TreeBuilder;
use HTML::FormatText;
use Locale::Country;
use Locale::Language;
use Lingua::NegEx;
use Text::Identify::BoilerPlate;
use Text::IdMor;
use WebService::Prismatic::InterestGraph;
use Lingua::EN::NameParse;
use Lingua::EN::Titlecase;
use Lingua::Norms::SUBTLEX;
#module below did not install properly
#update: I believe it is only installable on Linux
#use Lingua::Identify::CLD;

#take the input file from the user
#file slurp and extract the text

print "Make sure that the pdf is save as a txt file using the save as other function built into Adobe Reader.\n";
print "Enter txt file location:\t";
my $inputfile = <STDIN>;
chop $inputfile;
print "Input file, $inputfile, read.\n";
print "Enter a title for the txt file:\t";
my $title = <STDIN>;
chomp $title;
my $textfile = read_file($inputfile);
print "$textfile\n\n";

#create regex in order to search subsections of that text
#I think I want to define subsections as /\w{1,50}\n/ or similar pattern
#in order to get that to work I might have to add the roman numerals
#and the numbered system.

#building some of these file to check that I properly completed steps.
my $check = "C:/Perl/checkfile.txt";
open(CHK, '>'.$check) or die "Can't generate $check\n";
print "File $check generated.\n";
print CHK "$textfile";
close CHK;

#My API key is not working or reading for some reason. I go onto the website
#with my API key and it seems to be able to process and generate the text for
#me just fine.
#maybe I just have to curl it
#curl -H "X-API-TOKEN: <API-TOKEN>" 'http://interest-graph.getprismatic.com/url/topic' --data 'url=http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FMachine_learning'

print "\n\nNow generating potential tags for the following document...\n";
my $key = "MTQyNDQ0MjY1NzU5MA.cHJvZA.anduaW5nbGlAZ3d1LmVkdQ.Yv0MSCbxZK1l3k-6J-vlkTQsywA";
my $ig = WebService::Prismatic::InterestGraph->new(api_token => $key);
my @tags = $ig->tag_text($textfile, $title);
for(my $a = 0; $a < $#tags; $a++){
	print $tags[$a]."\n";
}
foreach my $tag(@tags){
	print "\n", $tag->topic, $tag->score;
}
print "\n\n";
system('pause');

print "Preparing to do initial analysis of the readability of the text file...\n\n\n";
my $analysisfile = "C:/Perl/analysis.txt";
open (ASYS, '>'.$analysisfile) or die "Can't create file to store initial analysis.\n";

my $text = new Lingua::EN::Fathom;
$text->analyse_file($inputfile);
my $accumulate = 1;
$text->analyse_block(my $text_string,$accumulate);

my $num_chars = $text->num_chars;
my $num_words = $text->num_words;
my $percent_complex_words = $text->percent_complex_words;
my $num_sentences = $text->num_sentences;
my $num_text_lines = $text->num_text_lines;
my $num_blank_lines = $text->num_blank_lines;
my $num_paragraphs = $text->num_paragraphs;
my $syllables_per_word = $text->syllables_per_word;
my $words_per_sentence = $text->words_per_sentence;

#this routine is used to capture words but I want to be able to capture words in large quantities such as 
#of, which, the, to be able to remove from the text when searching for named entities

#splitting the program to perform based on the amount of words in a text

my @commonwords;
my @characterizingwords;

my %words = $text->unique_words;
foreach my $word(sort keys %words){
	print ASYS ("$words{$word} :$word\n");
	if($num_words >= 500){
		if ($words{$word}/$num_words > 0.002){
			push @commonwords, $word;
		}
		elsif ($words{$word} < 11){
			push @characterizingwords, $word;
		}
	}
	else{
		if ($words{$word}/$num_words > 0.06){
			push @commonwords, $word;
		}
		elsif ($words{$word} < 4){
			push @characterizingwords, $word;
		}
	}
}

my $fog     = $text->fog;
my $flesch  = $text->flesch;
my $kincaid = $text->kincaid;

print($text->report);
print "\n\n";
system('pause');

close ASYS;

print "List of words that don't contribute to meaning: \n";
#print @commonwords;
for(my $i = 0; $i < $#commonwords; $i++){
	print $commonwords[$i]."\n";
}
system('pause');

my $wordlist = "C:/Perl/wordlist.txt";
open(WORD, '>'.$wordlist) or die "Can't create file to store wordlist.\n";

print "List of words that make this document unique: \n";
#print @characterizingwords;
for(my $j = 0; $j < $#characterizingwords; $j++){
	print $characterizingwords[$j]."\n";
	print WORD $characterizingwords[$j]."\n";
}
system('pause');

print "File storing the unique words is now available at $wordlist \n";

close WORD;

my $splitstorage = "C:/Perl/splitfile.txt";
open(SSTORE, '>'.$splitstorage) or die "Can't create file to store the subsections.\n";
print "File $splitstorage created to prepare for spliting the file's subsections.\n";

print "Beginning to split file's subsections.\n";
open(SPLIT, $check) or die "Unable to split the file's subsections.\n";
while(<SPLIT>){
	tr/A-Z/a-z/;
	tr/.,:;!&?"'(){}\-\$\+\=\{\}\@\/\*\>\<//d;
	my @subsections = split(/^(\d|\w){1,10}\n/, $_);
	print SSTORE "$_\n" for @subsections;
}

close SSTORE;

#the removal would just be removal of text between selected subsection
#and next subsection

#feature to add a 0.20 summary of the subsection before removal would
#be important

#nextly, in order to remove sensitive material, I think that it would make
#more sense to reduce the overall space I have to search so 
#Text::Summarize::En would work best in this part

my $modify = "C:/Perl/removal.txt";
print "Beginning to remove uniquely identifying material in text.\n";
print "Output will be located in $modify \n";
print "This process can take a lot of time and memory... please be patient.\n";

my $datatomod = $textfile;
$datatomod =~ s/restricted/ /ig;
$datatomod =~ s/confidential/ /ig;
$datatomod =~ s/top secret/ /ig;
$datatomod =~ s/secret/ /ig;
$datatomod =~ s/unclassified/ /ig;
for(my $k = 0; $k < $#characterizingwords; $k++){
	my $wordtomod = $characterizingwords[$k];
	$datatomod =~ s/\s$wordtomod\s/ /ig;
}

print "Removal completed...\n";
print "Printing to $modify...\n";
open(MODIFY, '>'.$modify) or die "Can't open $modify.\n";

print "Searching document for generic time indicators.\n";
my @months = qw/january february march april may june july august september october november december/;
my @week = qw/monday tuesday wednesday thursday friday saturday sunday/;
for(my $l = 0; $l < $#months; $l++){
	my $monthtime = $months[$l];
	$datatomod =~ s/[0-9]{1,2}(\s)?$monthtime/ /ig;
	$datatomod =~ s/$monthtime(\s)?[0-9]{1,2}(\s|\,)?/ /ig;
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
	$datatomod =~ s/$countryparse/ /ig;
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
print "Task completed.\n";
system('pause');

#need to use a transliterated list or Regexp::Common to identify quotes and parenthesis

#$Authorship = $x*$organization + $y*$classification + $z*$topic + error;

#my @listcontainingorgname;
#my $organizationabbv =~ /[A-Z]{2,5}/;
#my $orgpattern =~ /(\w{1,}\s){2,5}$organizationabbv/ig;

print "\nPreparing for second stage analysis\n";

my %languages = langof($datatomod);
dump %languages = langof($datatomod);
#print %languages;
print "\nThe probability of this text being English is:\t$languages{'en'}\n\n...\n";
if($languages{'en'} > 0.357){
	print "\nPassed second stage analysis.\n";
	print "\nLanguage analysis completed.\n";
	system('pause');
} else {
	print "\nSecond stage test have determined redaction is incomplete.\n";
}

#use this instead if CLD ever installs properly
#my $cld = Lingua::Identify::CLD->new();
#my @langanalysis = $cld->identify($datatomod);
#for(my $r = 0; $r < $#langanalysis; $r++){
#	print $langanalysis[$r]."\n";
#}
#print "\nLanguage analysis completed. Please review the data before continuing.\n";
#system('pause');

my @tagsplitstore;
for(my $s = 0; $s < $#tags; $s++){
	my $tagsub = $tags[$s];
	$tagsub =~ tr/.,:;!&?"'(){}\-\$\+\=\{\}\@\/\*\>\<//d;
	$tagsub =~ s/\sand\s/ /ig;
	$tagsub =~ s/\sthe\s/ /ig;
	$tagsub =~ s/\s{2,}/ /g;
	my @tagadd = split(/\s/, $_);
	push @tagsplitstore, @tagadd;
}
push @tagsplitstore, @tags;
for(my $t = 0; $t < $#tagsplitstore; $t++){
	my $tagtorem = $tagsplitstore[$t];
	$datatomod =~ s/\s$tagtorem\s/ /ig;
}
system('pause');

print MODIFY $datatomod."\n============================\n";

#I've been of the opinion recently that summarization is a test rather than a method to
#cut the size of the document. I realized that it's a great way to combine the entire 
#document and see if people can still derive meaning and information from the information
#redacted. I want to be able to apply the summarization meaning back to my analysis
#on the level of secrecy afforded to this document because that should help determine how 
#much should be properly removed. In essence, you can argue that this is a semantics test
#of how well I have redacted the argument.

if($num_words > 500){
	print "Preparing to summarize the document...\n";

	print "Summarization in progress...\n";

	my $summarizerEn = Text::Summarize::En->new();
	my $summary = $summarizerEn->getSummaryUsingSumbasic(listOfText => [$datatomod]);
	dump $summarizerEn->getSummaryUsingSumbasic(listOfText => [$datatomod]);
	print $summarizerEn;
	my $buffer = "";
	my $size = length($textfile)*.45;
	my @sentence_list = map {$_->[0]} @{$summary->{idScore}};
	my @sentence_content;
	foreach my $tagged_sentence(@{$summary->{listOfStemmedTaggedSentences}}){
		my @t;
		foreach my $element (@{$tagged_sentence}){
			my $text = @$element[1];
			# remove tabs and single new lines
			$text =~ s/\t/ /;
			$text =~ s/\n/ /;
			push @t, $text;
		}
		push @sentence_content, (join "", map { s/ +/ /gr } @t);
	}

	while(length($buffer) < $size){
		$buffer .= join "\n", $sentence_content[(shift @sentence_list)];
	}

	print "Preparing file for generation...\n";
	print "$modify generated.\n";

	print MODIFY $buffer;
}
else{
	print "File too small, map reduction is unnecessary.\n";
}

#print MODIFY $datatomod;



close MODIFY;



#in order to make sure that reduction works without removing the
#subsections, I'll just split and summarize the text according to the
#subsections and have it as a finite loop

#the reduction size should probably be 0.45 - 0.75
#this could be a feature available to the user
#simple method of adding <STDIN> and taking the user's input for a valid
#value.

#instead of the wordnet or query, I think I have found a more efficient 
#method. firstly, would be to give the user a document search as a feature
#then generate the amount of related words found. how to find related words
#is to first use the soundex algorithm and then use the levishtein 
#algorithm. this should generate enough positives and false positives.

#then, the user should be able to go through each of the words and the
#20 words before and after it should appear as a string to the user.
#the user would then be able to choose to alter the string 20-word-20
#or block a portion of that word. to chose to block the portion, I think
#would require the subroutine to only grep and read the string set in 
#question. 

#this would repeat until the user is done going through the entire document

#since we are going for a way to make sure that the user has modified the
#document successfully, the application of a tagger is necessary as well
#to find the named entities in the document

#I have been unable to get the Stanford NER to work with Perl and the
#perl once to work on windows so I'm going to use Lingua::EN::Tagger
#and use regex of tags in order to aim for named entities

#I have put this to the test but it seems difficult to remove the tags
#afterwards and get the text back to what it was. but this should be 
#useful to find time and noun patterns. this should allow me to detect
#certain words that even NER can't identify that might be a part of 
#the document to remove so having that is good. 

#I think the time patterns can be manually written as regex

#Regarding named entities, the person is going to have to change the 
#sting set involving the named entities so that meaning can be preserved.

#Grammar rules I think can be defined through Parse::RecDescent so that
#might help in the automatic detection. combine this with the tagger and
#we might have a strong system.

#overall, I want this to be more of a automatic process than user 
#influenced so I will automate any process that I can.

#Lingua::EN::Fathom can be used to identify the readability of the work
#generated by the automatic declassification

#I can also use Lingua::Identify to search for "non-English" words which
#might hint at important information to remove before declassification 

exit;


