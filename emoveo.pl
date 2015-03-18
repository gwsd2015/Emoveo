#################################################################
#Newest info

#will need to collect CSV log to maintain data on redaction performed

#fix loop and refresh global var for concordance search

#removed a bunch of code. working on removing my one word analysis
#for common words and stuff to prevent redaction infringing on the
#read-ability of the text.

#implementing Text::TermExtract to do better search and allow user to
#decide the amount of keywords they want extracted from the text
#this reduces the loop necessary for the 5 keyword search.
#Text::TermExtract uses collocation for better analysis of the text.

#from http://en.wikipedia.org/wiki/Collocation
#In corpus linguistics, a collocation is a sequence of words or terms that 
#co-occur more often than would be expected by chance. In phraseology, 
#collocation is a sub-type of phraseme. An example of a phraseological collocation, 
#as propounded by Michael Halliday,[1] is the expression strong tea. 
#While the same meaning could be conveyed by the roughly equivalent 
#*powerful tea, this expression is considered incorrect by English speakers. 
#Conversely, the corresponding expression for computer, powerful computers is 
#preferred over *strong computers. Phraseological collocations should not be 
#confused with idioms, where meaning is derived, whereas collocations are mostly compositional.
#There are about six main types of collocations: adjective+noun, 
#noun+noun (such as collective nouns), verb+noun, adverb+adjective, 
#verbs+prepositional phrase (phrasal verbs), and verb+adverb.
#Collocation extraction is a task that extracts collocations 
#automatically from a corpus, using computational linguistics.

#Applying keyword search with wikipedia to build keyword trees to potentially build
#a closed space search rather than just a concordance. The concordance at this point
#in time is really just a replication of grep.

#Grammar rules to be applied are located at the bottom of the document to help fix the 
#text or pinpoint sentences affected by redaction to alert user if they desire to modify
#the sentence.
#This was taken from the Grammarian module which doesn't work for windows and instead,
#what I build will force the checks rather than have user and coder specify what to check for.
#I'm using it as an idea to create more of an alert system rather than use it for grammar check.

#Modifying the printing document to RTF format so I can use |||||||||| for my substitutions
# and bold them to reflect the lines in an actual redacted document.

#adding options to prevent brute force just cutting out as much as possible.

#################################################################
#Previous notes in chronological order

#loop keywords at least 3 times for successful and different kw search.

#Next step is to create the file split for file > 7000 words to increase the speed of reduction

#just kidding, 5 keywords isn't too reliable but works for initial pruning.
#built in a proper concordance and works for substitution of lines.

#was able to confirm that the 5 keyword is reliable. Not sure how to do search.
#Text::Context::Porter search does stem search as well but it seems that the results
#of the search are kind of meh. It doesn't produce a reliable search. 
#Attempting to solve this by stemming the keywords and then forcing them into the concordance
#for a mandated search and then prints the sentences or word + 100 chars behind and in front
#problem is, I realized that I do way too much substitution before I even run it through
#so I mandated a different variable to store the first read for better analysis.

#re-applied the WebService::Prismatic::w/e to compare with the keyword generator.
#doesn't produce better results. 

#making the keyword algorithm more reliable

#increased reliability of redaction. sometimes, names that occur the most don't
#get redacted so I need to find a way to just identify that reaccuring name
#and substitute it with the first letter or something.
#Mr. Rogers -> Mr. R

#concordance isn't looping properly, going to double check on that

#need a switch case loop to resolve this... I don't even remember how to do it...
#created concordance key word search for the program. going to test if it works.

#New reduction is able to force 3168 KB file (450k+ words) to 1536 KB (about 50% reduction)

#more of a security issue than anything, will figure some stuff out after I finalize more of the
#algorithm
#I need my sentences to achieve randomness so you can't use patterns in attempts to unredact

#fixed the ngram regex's to be more reliable in removal
#Some regex result in removal of inital vowels from words that start a sentence

#non-issue using encoding now... not sure if even necessary
#read the files as utf 8 encoding to remove the funny characters

#not sure if I should use this anymore. Causes errors in substitution from ({$a} <=> {$b}) which results in
#the last element of the array invalid. This can be inferred from "uninit value" from the cmd line.
#solution found: use \Q to remove all meta characters that force the program to quit
#use Lingua::EN::Ngram;

#These translation modules below aren't working as I intend or aren't working as I want them to.
#Translating things using babelfish seem to not be working 
#don't know if obscuring is necessary, will save for a later day to work on.
#use WWW::Babelfish;
#use WWW::Translate::Apertium;
#use Speech::Google::TTS;
#use the random secure to generate between 0..1 to random select a language to translate back and forth
#use Math::Random::Secure qw(rand);
#module below did not install properly
#update: I believe it is only installable on Linux
#use Lingua::Identify::CLD;

########################further notes below can be found in Thinking... file

#I haven't subroutined my stuff yet, trying to write everything out and figure how things
#are cutting depending on the size of the program.

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
#use Text::Summarize::En;
use Data::Dump qw(dump);
use Path::Class;
use Lingua::EN::Fathom;
use utf8;
use File::Slurp qw(read_file write_file);
use Parse::RecDescent;
use Lingua::Identify qw(langof);
#use Text::Levenshtein::XS qw(distance);
#use Text::Soundex;
#use Search::VectorSpace;
use PDL;
use Regexp::Common;
use POSIX qw(strftime);
use LWP::Simple;
use HTML::TreeBuilder;
use HTML::FormatText;
use Locale::Country;
use Locale::Language;
#hmmm not as useful as I thought...
#use Lingua::NegEx;
#use Text::Identify::BoilerPlate;
#only works on an individual word basis, not useful
#use Text::IdMor;
#use Text::Roman;
use Lingua::EN::Tagger;
#use Symbol::Name;
use String::Multibyte;
use WebService::Prismatic::InterestGraph;
#use Lingua::EN::NameParse;
#use Lingua::EN::Titlecase;
use Lingua::Norms::SUBTLEX;
#need to get this to work
#doesn't work for windows properly. ignoring and using files to build own.
#use Lingua::EN::Grammarian ':all';
use Lingua::Concordance;
#this to be phased out for Text::TermExtract
use Lingua::EN::Ngram;
use Lingua::Orthon;
use Date::Extract;
use Date::Extract::Surprise;
use Encode qw(decode encode);
#only useful for obscure but can be achieved by heavy redaction
#I still want heavy redaction to be possible but I want to work with all levels of
#redaction
#use WWW::Translate::Apertium;
#use Math::Random::Secure qw(rand);
#to be phased out for Text::TermExtract
use Lingua::EN::Keywords qw(keywords);
#to be phased out for Text::TermExtract
use Text::Context::Porter;

#take topics from website and use it to clear document
#topics of interest are common and searched for in a document
#to take them out allows us to remove prediction power in later stages
#this will be paired with the N-grams and my word frequency identifier
#to increase the chances of taking out the right words

#my $topicfile = "C:/Perl/topicsfile.txt";
#open(TOPIC, ">:utf8", $topicfile) or die "Can't generate $topicfile from HTML::TreeBuilder and HTML::FormatText\n";

#print "Checking online database...\n";
#system('pause');
#my $topicurl = get("http://interest-graph.getprismatic.com/topic/all/human");
#my $Format = HTML::FormatText->new();
#my $TreeBuilder = HTML::TreeBuilder->new();
#$TreeBuilder->parse($topicurl);
#my $topicstorage = $Format->format($TreeBuilder);
#print TOPIC $topicstorage;
#print "Data created in $topicfile. Extraction from database success.\n";
#close TOPIC;
#my $topicdata = read_file($topicfile);
#$topicdata =~ s/   Complete list of topics.//ig;
#$topicdata =~ s/   If you're looking for something specific, please use the topic search//ig;
#$topicdata =~ s/   to increase the chances you find what you're looking for.//ig;
#$topicdata =~ s/\bid\b//ig;
#$topicdata =~ s/\btopic\b//ig;
#$topicdata =~ s/[0-9]{1,6}\n//ig;
#$topicdata =~ s/(\s|\t|\n){2,}}//g;
#$topicdata =~ s/(\(|\)|\,)//g;
#$topicdata =~ s/&//g;
#my $substitutioncheck = "C:/Perl/topicsfilesub.txt";
#open(TSUB, ">:utf8", $substitutioncheck) or die "Can't create $substitutioncheck.\n";
#print TSUB $topicdata;
#close TSUB;
#print "Please check $substitutioncheck to see if topic list was created successfully.\n";
#system('pause');
#my @topicfromweblist = split(/\n/, $topicdata);
#print @topicfromweblist;
#system('pause');
#my @topicthreebelow;
#my @topicfourtofive;
#my @topicsixup;
#for(my $h = 0; $h < $#topicfromweblist; $h++){
#	my $topicer = $topicfromweblist[$h];
#	my $counter = $topicer =~ s/((^|\s)\S)/$1/g;
#	if($counter <= 3){
#		push @topicthreebelow, $topicer;
#	}
#	elsif($counter > 3 and $counter < 6){
#		push @topicfourtofive, $topicer;
#	}
#	elsif($counter >= 6){
#		push @topicsixup, $topicer;
#	}
#}

#take the input file from the user
#file slurp and extract the text

print "Make sure that the pdf is saved as a txt file using the save as other function built into Adobe Reader.\n";
print "Enter txt file location:\t";
my $inputfile = <STDIN>;
chomp $inputfile;
print "Input file, $inputfile, read.\n";
print "Enter a title for the txt file:\t";
my $title = <STDIN>;
chomp $title;
my $textfile = read_file($inputfile);
print "$textfile\n\n";
my $analysistextfile = $textfile;
my $datatomod = ($textfile);

#create regex in order to search subsections of that text
#I think I want to define subsections as /\w{1,50}\n/ or similar pattern
#in order to get that to work I might have to add the roman numerals
#and the numbered system.

#building some of these file to check that I properly completed steps.
my $check = "C:/Perl/checkfile.txt";
open(CHK, ">:utf8",$check) or die "Can't generate $check\n";
print "File $check generated.\n";
print CHK "$textfile";
close CHK;

print "Preparing to do initial analysis of the readability of the text file...\n\n\n";
my $analysisfile = "C:/Perl/analysis.txt";
open (ASYS, ">:utf8",$analysisfile) or die "Can't create file to store initial analysis.\n";

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

#this routine is used to capture words but I want to be able to capture words in large quantities such as 
#of, which, the, to be able to remove from the text when searching for named entities

my @commonwords;
my @characterizingwords;

my %words = $text->unique_words;
foreach my $word(sort keys %words){
	print ASYS ("$words{$word} :$word\n");
	if($num_words >= 500){
		if ($words{$word}/$num_words > 0.002){
			push @commonwords, $word;
		}
		elsif ($words{$word} < 7){
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

print "Preparing to get top 5 keywords from the document...\n";

my $texttext = $analysistextfile;

my @keywords = keywords($texttext);

my $keycontextfile = "C:/Perl/keywordscontext.html";
open(KEYCTXT, ">:utf8", $keycontextfile) or die; 

my $snippet = Text::Context::Porter->new($analysistextfile, @keywords);
$snippet->keywords(@keywords);
print KEYCTXT $snippet->as_html;
print $snippet->as_text;
$datatomod =~ s/$snippet->as_text//ig;
close KEYCTXT;

system('pause');

my @keywords_of_choice;
system('pause');
for(my $iijk = 0; $iijk < $#keywords; $iijk++){
	my $texter = $keywords[$iijk];
	print $texter."\n";
	while($iijk < 5){
		print "Is this a keyword you wish to use?\t";
		my $keyyesno = <STDIN>;
		chomp $keyyesno;
		if($keyyesno =~ /yes/i){
			print "Performing analysis on phrases that suggest the keyword...\n";
			push @keywords_of_choice, $texter;
			my $stemmer = Lingua::Stem::Snowball->new(lang=>'en');
			$stemmer->stem_in_place(\@keywords_of_choice);
			my $concordance = Lingua::Concordance->new;
			$concordance->text($datatomod);
			$concordance->query($texter);
			foreach($concordance->lines){
				print "$_\n";
				print "Would you like to remove this line?\t";
				my $keepline = <STDIN>;
				chomp $keepline;
				if($keepline =~ /yes/i){
					if($datatomod =~ m/$_/g){
						$datatomod =~ s/$_//ig;
					}
				}
				else{
					system('pause');
				}
			}
		}
		$keyyesno = "Yes";
		last;
	}
}
system('pause');



#My API key is not working or reading for some reason. I go onto the website
#with my API key and it seems to be able to process and generate the text for
#me just fine.
#maybe I just have to curl it
#curl -H "X-API-TOKEN: <API-TOKEN>" 'http://interest-graph.getprismatic.com/url/topic' --data 'url=http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FMachine_learning'

#WebService::Prismatic::InterestGraph has a limit to 20 calls per hour so I'm implementing my own
#version of tagging above. What I'm doing is just pulling the tags directly from their website and
#performing my own analysis of it instead of relying on them to give me the tags. Most of the time,
#my algorithms end up removing the tagged subject anyway.

#print "\n\nNow generating potential tags for the following document...\n";
if($num_chars < 5000){
	my $key = "MTQyNDQ0MjY1NzU5MA.cHJvZA.anduaW5nbGlAZ3d1LmVkdQ.Yv0MSCbxZK1l3k-6J-vlkTQsywA";
	my $ig = WebService::Prismatic::InterestGraph->new(api_token => $key);
	my @tags = $ig->tag_text($textfile, $title);
	for(my $a = 0; $a < $#tags; $a++){
		print $tags[$a]."\n";
	}
	foreach my $tag(@tags){
		print "\n", $tag->topic, "\t", $tag->score;
	}
	print "\n\n";
	system('pause');
}

#my $translatedfile = "C:/Perl/translatedfile.txt;
#open(TRANSLATE, ">:utf8", $translatedfile) or die "Can't create $translatedfile\n";
#my $float = rand();
#close TRANSLATE;

print "List of words that don't contribute to meaning: \n";
#print @commonwords;
for(my $i = 0; $i < $#commonwords; $i++){
	print $commonwords[$i]."\n";
}
system('pause');

my $wordlist = "C:/Perl/wordlist.txt";
open(WORD, ">:utf8",$wordlist) or die "Can't create file to store wordlist.\n";

print "List of words that make this document unique: \n";
#print @characterizingwords;
for(my $j = 0; $j < $#characterizingwords; $j++){
	print $characterizingwords[$j]."\n";
	print WORD $characterizingwords[$j]."\n";
}
system('pause');

print "File storing the unique words is now available at $wordlist \n";

close WORD;

#my $datatomod =~ s/(\.|\?|!)/ ./g;

my $taggedtextout = 'C:\Perl\taggedtxt.txt';
open (TAGOUT, ">:utf8",$taggedtextout) or die;
my $nnpex = 'C:\Perl\NNPextract.txt';
open (NNP, ">:utf8",$nnpex) or die;
my $propernoun = 'C:\Perl\propernoun.txt';
open (PNOUN, ">:utf8",$propernoun) or die;
my $nnpex_bigram = 'C:\Perl\NNPphraseextract.txt';
open (NNPEX, ">:utf8", $nnpex_bigram);

my $parsednnp = new Lingua::EN::Tagger;
my $tagged_text = $parsednnp->add_tags($datatomod);
my %word_list = $parsednnp->get_words($datatomod);					 
my $readable_text = $parsednnp->get_readable($datatomod);
my $proper_nouns = $parsednnp->get_proper_nouns($datatomod);
print TAGOUT $readable_text;
close TAGOUT;
print PNOUN $proper_nouns;
close PNOUN;

my @taggedwordlist2;

open(TAGOUT2, $taggedtextout) or die;
while(<TAGOUT2>){
	my @taggedwordlist = split /\s/;
	while (my $tagword = pop @taggedwordlist){
		if ($tagword =~ /\w\/((NN(P|S)?S?)|(FW)|(JJ(R|S)))/ig){
			print NNP $tagword."\n";
			$tagword =~ s/\/((NN(P|S)?S?)|(FW)|(JJ(R|S)))/ /ig;
			$datatomod =~ s/\b$tagword\b/ /ig;
		} 
	}
#	for(my $tagz = 0; $tagz < $#taggedwordlist; $tagz++){
#		my $taggertwo = $taggedwordlist[$tagz]." ".$taggedwordlist[$tagz+1];		
#		if ($taggertwo =~ /\w\/NNP\s\w\/NNP/){
#			print NNPEX $taggertwo."\n";
#			push @taggedwordlist2, $taggertwo;
#		}
#	}
}

print @taggedwordlist2;
system('pause');

#open(PNOUN2, $propernoun) or die;
#while(<PNOUN2>){
#	my @propernounlist = split /\s/;
#	while(my $pnoun = pop @propernounlist){
#		if($pnoun =~ s/\w\/
#	}
#close PNOUN;

close TAGOUT2;
close NNP;
close NNPEX;

#my $exitsign = "Time to exit!";
#print "Traverse the file for targeted removal...\n";
#print "If you ever want to stop the query after it has complete a search, type $exitsign\n";
#system('pause');
#my $concordance = Lingua::Concordance->new;
#$concordance->text($datatomod);
#my $querysearch = "0";
#my $concordanceyesno;
#while(my $querysearch != $exitsign){
#	print "Enter word or phrase to query:\t";
#	$querysearch = <STDIN>;
#	chomp $querysearch;
#	print "\n";
#	$concordance->query($querysearch);
#	foreach my $concordancedline ($concordance->lines){
#		print "$concordancedline\n";
#		print "Would you like too subsitute this line?\t";
#		$concordanceyesno = <STDIN>;
#		chomp $concordanceyesno;
#		if($concordanceyesno =~ /yes/){
#			$datatomod =~ s/$concordancedline/ /ig;
#		}
#		else{
#			system('pause');
#		}
#	}
#}

#quick and dirty method to find possible keywords, not very good


#working now
#currently not working
#my method of finding keywords;

my @search_for_sentence;
my @sentence_split_store;
my @key_sentences;
my $infocentricfile = "C:/Perl/liners.txt";
open(INFO, $infocentricfile) or die;
while(<INFO>){
	@search_for_sentence = split(/\^/, $_);
}
system('pause');
print "$_" for @search_for_sentence;
print "\n";
system('pause');
my $datatomodstore = $datatomod;
@sentence_split_store = split(/\./, $datatomodstore);
for(my $eji = 0; $eji < $#sentence_split_store; $eji++){
	my $sentence_now = $sentence_split_store[$eji];
	for(my $ejik = 0; $ejik < $#search_for_sentence; $ejik++){
		my $indicator = $search_for_sentence[$ejik];
		if($sentence_now =~ /$indicator/g){
			push @key_sentences, $sentence_now;
			$ejik = $#search_for_sentence;
		}
	}
}
close INFO;

my $keysentencefile = "C:/Perl/keysentences.txt";
open(KEYSEN, ">:utf8", $keysentencefile);
for(my $ejikl = 0; $ejikl < $#key_sentences; $ejikl++){
	my $sentence_to_print = $key_sentences[$ejikl];
	print KEYSEN $sentence_to_print."\n";
}
close KEYSEN;

#currently problem with file reading but... will figure out how to fix it

my $keyfileimport = read_file($keysentencefile);
my @keywords2 = keywords($keyfileimport);
system('pause');
for(my $is = 0; $is < $#keywords2; $is++){
	my $primer = $keywords2[$is];
	print $primer."\n";
}
system('pause');

#error resolved
#error ends program with unmatched regex

my @twoset;
my @threeset;
my @fourset;
my @fiveset;
my @sixset;
my @sevenset;

my $ngram = Lingua::EN::Ngram->new(file => $check);

my $sevengramfile = "C:/Perl/7gram.txt";
open(SEVENGRAM, ">:utf8",$sevengramfile) or die "Can't create file to store 7grams.\n";
my $sevengrams = $ngram->ngram(7);
foreach my $sevengram(sort {$$sevengrams{my $b} <=> $$sevengrams{my $a}} keys %$sevengrams){
	print SEVENGRAM $$sevengrams{$sevengram}, "\t$sevengram\n";
	if($$sevengrams{$sevengram} > 1){
		push @sevenset, $sevengram;
	}
}
print "Sevengrams created...\n";
close SEVENGRAM;
system('pause');
for( my $y = 0; $y < $#sevenset; $y++ ){
	print $sevenset[$y]."\n";
	my $seventosub = $sevenset[$y];
	$seventosub =~ s/\s\.//g;
	$seventosub =~ s/\s,/,/g;
	$seventosub =~ s/\s?\(\s?/(/g;
	$seventosub =~ s/\s?\)\s?/)/g;
	$seventosub =~ s/\s:/:/g;
	$seventosub =~ s/\s?-\s?/-/g;
	#$seventosub =~ s/\s?\\\s?/\/g;
	#$seventosub =~ s/\s?\/\s?///g;
	$seventosub =~ s/\b[a-z]\b/[thisisnothingtosubandwontmatchtoanything]/ig;
	$datatomod =~ s/\Q$seventosub/ /ig;
	
}
my $seventohold = "C:/Perl/7gramhold.txt";
open(SEVENHOLD, ">:utf8",$seventohold) or die "Can't make $seventohold\n";
print SEVENHOLD $datatomod;
close SEVENHOLD;
system('pause');

$ngram = Lingua::EN::Ngram->new(file => $seventohold);

my $sixgramfile = "C:/Perl/6gram.txt";
open(SIXGRAM, ">:utf8",$sixgramfile) or die "Can't create file to store 6grams.\n";
my $sixgrams = $ngram->ngram(6);
foreach my $sixgram(sort {$$sixgrams{my $b} <=> $$sixgrams{my $a}} keys %$sixgrams){
	print SIXGRAM $$sixgrams{$sixgram}, "\t$sixgram\n";
	if($$sixgrams{$sixgram} > 1){
		push @sixset, $sixgram;
	}
}
print "Sixgrams created...\n";
close SIXGRAM;
system('pause');
for( my $x = 0; $x < $#sixset; $x++ ){
	print $sixset[$x]."\n";
	my $sixtosub = $sixset[$x];
	$sixtosub =~ s/\s\././g;
	$sixtosub =~ s/\s,/,/g;
	$sixtosub =~ s/\s?\(\s?/(/g;
	$sixtosub =~ s/\s?\)\s?/)/g;
	$sixtosub =~ s/\s:/:/g;
	$sixtosub =~ s/\s?-\s?/-/g;
	#$sixtosub =~ s/\s?\\\s?/\/g;
	#$sixtosub =~ s/\s?\/\s?///g;
	$sixtosub =~ s/\b[a-z]\b/[thisisnothingtosubandwontmatchtoanything]/ig;
	$datatomod =~ s/\Q$sixtosub/ /ig;
	
}
my $sixtohold = "C:/Perl/6gramhold.txt";
open(SIXHOLD, ">:utf8",$sixtohold) or die "Can't make $sixtohold\n";
print SIXHOLD $datatomod;
close SIXHOLD;
system('pause');

$ngram = Lingua::EN::Ngram->new(file => $sixtohold);

my $fivegramfile = "C:/Perl/5gram.txt";
open(FIVEGRAM, ">:utf8",$fivegramfile) or die "Can't create file to store 5grams.\n";
my $fivegrams = $ngram->ngram(5);
foreach my $fivegram(sort {$$fivegrams{my $b} <=> $$fivegrams{my $a}} keys %$fivegrams){
	print FIVEGRAM $$fivegrams{$fivegram}, "\t$fivegram\n";
	if($$fivegrams{$fivegram} > 1){
		push @fiveset, $fivegram;
	}
}
print "Fivegrams created...\n";
close FIVEGRAM;
system('pause');
for( my $v = 0; $v < $#fiveset; $v++ ){
	print $fiveset[$v]."\n";
	my $fivetosub = $fiveset[$v];
	$fivetosub =~ s/\s\././g;
	$fivetosub =~ s/\s,/,/g;
	$fivetosub =~ s/\s?\(\s?/(/g;
	$fivetosub =~ s/\s?\)\s?/)/g;
	$fivetosub =~ s/\s:/:/g;
	$fivetosub =~ s/\s?-\s?/-/g;
	#$fivetosub =~ s/\s?\\\s?/\/g;
	#$fivetosub =~ s/\s?\/\s?///g;
	$fivetosub =~ s/\b[a-z]\b/[thisisnothingtosubandwontmatchtoanything]/ig;
	$datatomod =~ s/\Q$fivetosub/ /ig;
	
}
my $fivetohold = "C:/Perl/5gramhold.txt";
open(FIVEHOLD, ">:utf8",$fivetohold) or die "Can't make $fivetohold\n";
print FIVEHOLD $datatomod;
close FIVEHOLD;
system('pause');

$ngram = Lingua::EN::Ngram->new(file => $fivetohold);

my $fourgramfile = "C:/Perl/4gram.txt";
open(FOURGRAM, ">:utf8",$fourgramfile) or die "Can't create file to store 4grams.\n";
my $fourgrams = $ngram->ngram(4);
foreach my $fourgram(sort {$$fourgrams{my $b} <=> $$fourgrams{my $a}} keys %$fourgrams){
	print FOURGRAM $$fourgrams{$fourgram}, "\t$fourgram\n";
	if($$fourgrams{$fourgram} > 1){
		push @fourset, $fourgram;
	}
}
print "Fourgrams created...\n";
close FOURGRAM;
system('pause');
for( my $w = 0; $w < $#fourset; $w++ ){
	print $fourset[$w]."\n";
	my $fourtosub = $fourset[$w];
	$fourtosub =~ s/\s\././g;
	$fourtosub =~ s/\s,/,/g;
	$fourtosub =~ s/\s?\(\s?/(/g;
	$fourtosub =~ s/\s?\)\s?/)/g;
	$fourtosub =~ s/\s:/:/g;
	$fourtosub =~ s/\s?-\s?/-/g;
	#$fourtosub =~ s/\s?\\\s?/\/g;
	#$fourtosub =~ s/\s?\/\s?///g;
	$fourtosub =~ s/\b[a-z]\b/[thisisnothingtosubandwontmatchtoanything]/ig;
	$datatomod =~ s/\Q$fourtosub/ /ig;
	
}
my $fourtohold = "C:/Perl/4gramhold.txt";
open(FOURHOLD, ">:utf8",$fourtohold) or die "Can't make $fourtohold\n";
print FOURHOLD $datatomod;
close FOURHOLD;
system('pause');

$ngram = Lingua::EN::Ngram->new(file => $fourtohold);

my $threegramfile = "C:/Perl/3gram.txt";
open(THREEGRAM, ">:utf8",$threegramfile) or die "Can't create file to store 3grams.\n";
my $trigrams = $ngram->ngram(3);
foreach my $trigram(sort {$$trigrams{my $b} <=> $$trigrams{my $a}} keys %$trigrams){
	print THREEGRAM $$trigrams{$trigram}, "\t$trigram\n";
	if($$trigrams{$trigram} > 5){
		push @threeset, $trigram;
	}
}
print "Trigrams created...\n";
close THREEGRAM;
system('pause');
for( my $abcd = 0; $abcd < $#threeset; $abcd++ ){
	print $threeset[$abcd]."\n";
	my $threetosub = $threeset[$abcd];
	$threetosub =~ s/\s\././g;
	$threetosub =~ s/\s,/,/g;
	$threetosub =~ s/\s?\(\s?/(/g;
	$threetosub =~ s/\s?\)\s?/)/g;
	$threetosub =~ s/\s:/:/g;
	$threetosub =~ s/\s?-\s?/-/g;
	#$threetosub =~ s/\s?\\\s?/\/g;
	#$threetosub =~ s/\s?\/\s?///g;
	$threetosub =~ s/\b[a-z]\b/[thisisnothingtosubandwontmatchtoanything]/ig;
	$datatomod =~ s/\Q$threetosub/ /ig;
	
}
my $threetohold = "C:/Perl/3gramhold.txt";
open(THREEHOLD, ">:utf8",$threetohold) or die "Can't make $threetohold\n";
print THREEHOLD $datatomod;
close THREEHOLD;
system('pause');

$ngram = Lingua::EN::Ngram->new(file => $threetohold);

my $twogramfile = "C:/Perl/2gram.txt";
open(TWOGRAM, ">:utf8",$twogramfile) or die "Can't create file to store 2grams.\n";
#bigrams to sevengrams to sort

my $bigrams = $ngram->ngram(2);
foreach my $bigram(sort {$$bigrams{my $b} <=> $$bigrams{my $a}} keys %$bigrams){
	print TWOGRAM $$bigrams{$bigram}, "\t$bigram\n";
	if(($$bigrams{$bigram}) > 5){
		push @twoset, $bigram;
	}
}
print "Bigrams created...\n";
close TWOGRAM;
system('pause');
for( my $defg = 0; $defg < $#twoset; $defg++ ){
	print $twoset[$defg]."\n";
	my $twotosub = $twoset[$defg];
	$twotosub =~ s/\s\././g;
	$twotosub =~ s/\s,/,/g;
	$twotosub =~ s/\s?\(\s?/(/g;
	$twotosub =~ s/\s?\)\s?/)/g;
	$twotosub =~ s/\s:/:/g;
	$twotosub =~ s/\s?-\s?/-/g;
	#$twotosub =~ s/\s?\\\s?/\/g;
	#$twotosub =~ s/\s?\/\s?///g;
	$twotosub =~ s/\b[a-z]\b/[thisisnothingtosubandwontmatchtoanything]/ig;
	$datatomod =~ s/\Q$twotosub/ /ig;
	
}
my $twotohold = "C:/Perl/2gramhold.txt";
open(TWOHOLD, ">:utf8",$twotohold) or die "Can't make $twotohold\n";
print TWOHOLD $datatomod;
close TWOHOLD;
system('pause');

#no idea what I'm going to use this for yet. 
#The splitting is terrible and I still have to fix it.
my $splitstorage = "C:/Perl/splitfile.txt";
open(SSTORE, ">:utf8",$splitstorage) or die "Can't create file to store the subsections.\n";
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

my $inputfilemod = $inputfile;
my $modify = $inputfile."redacted.txt";
#my $modify = "C:/Perl/removal.txt";
print "Beginning to remove uniquely identifying material in text.\n";
print "Output will be located in $modify \n";
print "This process can take a lot of time and memory... please be patient.\n";

#for(my $bb = 0; $bb < $#twoset; $bb++){
#	my $two = $twoset[$bb];
#	if($datatomod =~ /$two/){
#	$datatomod =~ s/\b$two\b//g;
#	}
#}
#for(my $cc = 0; $cc < $#threeset; $cc++){
#	my $three = $threeset[$cc];
#	if($datatomod =~ /$three/){
#	$datatomod =~ s/\b$three\b//g;
#	}
#}
#for(my $dd = 0; $dd < $#fourset; $dd++){
#	my $four = $fourset[$dd];
#	if($datatomod =~ /$four/){
#	$datatomod =~ s/\b$four\b//g;
#	}
#}
#for(my $ee = 0; $ee < $#fiveset; $ee++){
#	my $five = $fiveset[$ee];
#	if($datatomod =~ /$five/){
#	$datatomod =~ s/\b$five\b//g;
#	}
#}
#for(my $ff = 0; $ff < $#sixset; $ff++){
#	my $six = $sixset[$ff];
#	if($datatomod =~ /$six/){
#	$datatomod =~ s/\b$six\b//g;
#	}
#}
#for(my $gg = 0; $gg < $#sevenset; $gg++){
#	my $seven = $sevenset[$gg];
#	if($datatomod =~ /$seven/){
#	$datatomod =~ s/\b$seven\b//g;
#	}
#}

#for(my $zz = 0; $zz < $#topicfromweblist; $zz++){
#	my $searchtop = $topicfromweblist[$zz];
#	$datatomod =~ s/$searchtop/ /ig;
#}

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

my @impossiblebigram = qw(bk bq bx cb cf cg cj cp cv cw cx dx fk fq fv fx fz gq gv gx hk hv hx hz iy jb jc jd jf jg jh jk jl jm jn jp jq jr js jt jv jw jx jy jz kq kv kx kz lq lx mg mj mq mx mz pq pv px qa qb qc qd qe qf qg qh qj qk ql qm qn qo qp qr qs qt qv qw qx qy qz sx sz tq tx vb vc vd vf vg vh vj vk vm vn vp vq vt vw vx vz wq wv wx wz xb xg xj xk xv xz yq yv yz zb zc zg zh zj zn zq zr zs zx);

for(my $ggh = 0; $ggh < $#impossiblebigram; $ggh++){
	my $impbigramword = $impossiblebigram[$ggh];
	$datatomod =~ s/\b([a-z]+)?$impbigramword([a-z]+)?\b//ig;
}

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
#	my $engine = WWW::Translate::Apertium->new();
#	our $translated_data = $engine->translate($datatomod);
#	our $float = rand();
#	if($float >= 0 and $float < 0.25){
#		$engine->from_into(en-es);
#		$ngram = Lingua::EN::Ngram->new($translated_data);
#		my $enginetwograms = $ngram->ngram(2);
#		foreach my $enginetwogram(sort {$$enginetwograms{my $b} <=> $$enginetwograms{my $a}} keys %$enginetwograms){
#			print $$enginetwograms{$enginetwogram}, "\t$enginetwogram\n";
#			if($$enginetwograms{$enginetwogram} > 4){
#				push @languagegramstore, $enginetwogram;
#				for(my $enes = 0; $enes < $#languagegramstore; $enes++){
#					my $enessub = $languagegramstore[$enes];
#					$translated_data =~ s/$enessub/ /ig;
#				}
#			}
#		}
#		my $engine2 = WWW::Translate::Apertium->new();
#		$engine2->from_into(es-en);
#		$datatomod = $engine2->translate($translated_data);
#		system('pause');
#	}
#	elsif($float >= 0.25 and $float < 0.5){
#		$engine->from_into(en-gl);
#		$ngram = Lingua::EN::Ngram->new($translated_data);
##		my $enginetwograms = $ngram->ngram(2);	
##		foreach my $enginetwogram(sort {$$enginetwograms{my $b} <=> $$enginetwograms{my $a}} keys %$enginetwograms){	
##			print $$enginetwograms{$enginetwogram}, "\t$enginetwogram\n";	
#			if($$enginetwograms{$enginetwogram} > 4){	
#				push @languagegramstore, $enginetwogram;	
##				for(my $engl = 0; $engl < $#languagegramstore; $engl++){	
#					my $englsub = $languagegramstore[$engl];	
#					$translated_data =~ s/$englsub/ /ig;	
#				}	
#			}	
#		}	
#		my $engine3 = WWW::Translate::Apertium->new();	
#		$engine3->from_into(gl-en);	
#		$datatomod = $engine3->translate($translated_data);	
#		system('pause');	
#		}	
#	}
#	elsif($float >= 0.5 and $float < 0.75){
#		$engine->from_into(en-eo);
#		$ngram = Lingua::EN::Ngram->new($translated_data);
#		my $enginetwograms = $ngram->ngram(2);
#		foreach my $enginetwogram(sort {$$enginetwograms{my $b} <=> $$enginetwograms{my $a}} keys %$enginetwograms){
#			print $$enginetwograms{$enginetwogram}, "\t$enginetwogram\n";
#			if($$enginetwograms{$enginetwogram} > 4){
#				push @languagegramstore, $enginetwogram;
#				for(my $eneo = 0; $eneo < $#languagegramstore; $eneo++){
#					my $eneosub = $languagegramstore[$eneo];
#					$translated_data =~ s/$eneosub/ /ig;
#				}
#			}
#		}
#		my $engine4 = WWW::Translate::Apertium->new();
#		$engine4->from_into(eo-en);
#		$datatomod = $engine4->translate($translated_data);
#		system('pause');
#		}
#	}
#	elsif($float >= 0.75 and $float <= 1){
#		$engine->from_into(en-ca);
#		$ngram = Lingua::EN::Ngram->new($translated_data);
#		my $enginetwograms = $ngram->ngram(2);
#		foreach my $enginetwogram(sort {$$enginetwograms{my $b} <=> $$enginetwograms{my $a}} keys %$enginetwograms){
#			print $$enginetwograms{$enginetwogram}, "\t$enginetwogram\n";
#			if($$enginetwograms{$enginetwogram} > 4){
#				push @languagegramstore, $enginetwogram;
#				for(my $enca = 0; $enca < $#languagegramstore; $enca++){
#					my $encasub = $languagegramstore[$enca];
#					$translated_data =~ s/$encasub/ /ig;
#				}
#			}
#		}
#		my $engine5 = WWW::Translate::Apertium->new();		
#		$engine5->from_into(ca-en);		
#		$datatomod = $engine5->translate($translated_data);		
#		system('pause');		
#	}				
#	}
}
else {
	print "\nLanguage analysis completed.\n";
	print "\nPassed second stage analysis.\n";
}

#use this instead if CLD ever installs properly
#my $cld = Lingua::Identify::CLD->new();
#my @langanalysis = $cld->identify($datatomod);
#for(my $r = 0; $r < $#langanalysis; $r++){
#	print $langanalysis[$r]."\n";
#}
#print "\nLanguage analysis completed. Please review the data before continuing.\n";
#system('pause');

#The following is obsolete given that I'm taking out WebService::Prismatic::InterestGraph
#Will implement new interation below code.



#my @tagsplitstore;
#for(my $s = 0; $s < $#tags; $s++){
#	my $tagsub = $tags[$s];
#	$tagsub =~ tr/.,:;!&?"'(){}\-\$\+\=\{\}\@\/\*\>\<//d;
#	$tagsub =~ s/\sand\s/ /ig;
#	$tagsub =~ s/\sthe\s/ /ig;
#	$tagsub =~ s/\s{2,}/ /g;
#	my @tagadd = split(/\s/, $_);
#	push @tagsplitstore, @tagadd;
#}
#push @tagsplitstore, @tags;
#for(my $t = 0; $t < $#tagsplitstore; $t++){
#	my $tagtorem = $tagsplitstore[$t];
#	$datatomod =~ s/\s$tagtorem\s/ /ig;
#}
#system('pause');

print MODIFY $datatomod."\n============================\n";

#I've been of the opinion recently that summarization is a test rather than a method to
#cut the size of the document. I realized that it's a great way to combine the entire 
#document and see if people can still derive meaning and information from the information
#redacted. I want to be able to apply the summarization meaning back to my analysis
#on the level of secrecy afforded to this document because that should help determine how 
#much should be properly removed. In essence, you can argue that this is a semantics test
#of how well I have redacted the argument.



#if($num_words > 500 and $num_words < 7000){
#	print "Preparing to summarize the document...\n";
##
#	print "Summarization in progress...\n";
##
#	my $summarizerEn = Text::Summarize::En->new();
#	my $summary = $summarizerEn->getSummaryUsingSumbasic(listOfText => [$datatomod]);
#	dump $summarizerEn->getSummaryUsingSumbasic(listOfText => [$datatomod]);
###	print $summarizerEn;
#	my $buffer = "";
#	my $size = length($textfile)*.25;
#	my @sentence_list = map {$_->[0]} @{$summary->{idScore}};
#	my @sentence_content;
#	foreach my $tagged_sentence(@{$summary->{listOfStemmedTaggedSentences}}){
#		my @t;
#		foreach my $element (@{$tagged_sentence}){
#			my $text = @$element[1];
#			# remove tabs and single new lines
#			$text =~ s/\t/ /;
#			$text =~ s/\n/ /;
#			push @t, $text;
#		}
#		push @sentence_content, (join "", map { s/ +/ /gr } @t);
#	}
#
#	while(length($buffer) < $size){
#		$buffer .= join "\n", $sentence_content[(shift @sentence_list)];
#	}
#
#	print "Preparing file for generation...\n";
#	print "$modify generated.\n";
#
#	print MODIFY $buffer;
#}
#elsif($num_words >= 7000){
#	print "File too large, needs to be broken down before analysis.\n";
#}
#else{
#	print "File too small, map reduction is unnecessary.\n";
#}



#print MODIFY $datatomod;

close MODIFY;


#my @caution_objs = extract_cautions from($modify);
#my @error_objs = extract_errors_from($modify);
#for my $problem (@cautions_or_errors){
#	my $actual_word_or_phrase = $problem->match;
#	my $start_location_in_text = $problem->from;
#	my $end_location_in_text = $problem->to;
#	my $description_of_problem = $problem->explanations;
#	my $suggested_correction = $problem->suggestions;
#}


exit;

###################################################################################

=pod
####################################################################
#                                                                  #
#     This file specifies common grammatical errors that are       #
#     almost always incorrect in any context, along with the       #
#     appropriate correction(s) for them.                          #
#                                                                  #
#     See the documentation of the Lingua::EN::Grammarian module   #
#     for details of the format of this file.                      #
#                                                                  #
#     You probably want to put this file in your home directory    #
#     (but see the module documentation for other options).        #
#                                                                  #
# ##################################################################


=====[ Misspelling of 'than' ]===================================

better (then,them)                       --> better than
closer (then,them,that)                  --> closer than
darker (then,them,that)                  --> darker than
easier (then,them,that)                  --> easier than
farther (then,them)                      --> farther than
faster (then,them,that)                  --> faster (then,them,that)
higher (then,them,that)                  --> higher than
hotter (then,them,that)                  --> hotter than
larger (then,them,that)                  --> larger than
less (then,them,that)                    --> less than
lesser (then,them,that)                  --> less than
lighter (then,them,that)                 --> lighter than
longer (then,then,that)                  --> longer than
lower (then,them)                        --> lower than
more often (then,them,that)              --> more often than
more (then,them)                         --> more than
other (then,them,that)                   --> other than
rather (then,them,that)                  --> rather than
shorter (then,them,that)                 --> shorter than
smaller (then,them,that)                 --> smaller than
smarter (then,them,that)                 --> smarter than
sooner (then,them)                       --> sooner than
stronger (then,them,that)                --> stronger than
worse (then,them,that)                   --> worse than
younger (then,them,that)                 --> younger than






=====[ Misspelled possessive adjective ]=======================================

(it's,they're) ability                 --> (its,their) ability
(it's,they're) advantage               --> (its,their) advantage
(it's,they're) aim                     --> (its,their) aim
(it's,they're) anniversary             --> (its,their) anniversary
(it's,they're) appearance              --> (its,their) appearance
(it's,they're) class                   --> (its,their) class
(it's,they're) closure                 --> (its,their) closure
(it's,they're) color                   --> (its,their) color
(it's,they're) colour                  --> (its,their) colour
(it's,they're) construction            --> (its,their) construction
(it's,they're) contents                --> (its,their) contents
(it's,they're) course                  --> (its,their) course
(it's,they're) debut                   --> (its,their) debut
(it's,they're) end                     --> (its,their) end
(it's,they're) entire                  --> (its,their) entire
(it's,they're) former                  --> (its,their) former
(it's,they're) goal                    --> (its,their) goal
(it's,they're) inception               --> (its,their) inception
(it's,they're) initial                 --> (its,their) initial
(it's,they're) junction                --> (its,their) junction
(it's,they're) lack                    --> (its,their) lack
(it's,they're) latest                  --> (its,their) latest
(it's,they're) lead                    --> (its,their) lead
(it's,they're) leader                  --> (its,their) leader
(it's,they're) length                  --> (its,their) length
(it's,they're) main                    --> (its,their) main
(it's,they're) major                   --> (its,their) major
(it's,they're) maximum                 --> (its,their) maximum
(it's,they're) minimum                 --> (its,their) minimum
(it's,they're) name                    --> (its,their) name
(it's,they're) northern                --> (its,their) northern
(it's,they're) own                     --> (its,their) own
(it's,they're) peak                    --> (its,their) peak
(it's,they're) period                  --> (its,their) period
(it's,they're) popularity              --> (its,their) popularity
(it's,they're) population              --> (its,their) population
(it's,they're) previous                --> (its,their) previous
(it's,they're) price                   --> (its,their) price
(it's,they're) primary                 --> (its,their) primary
(it's,they're) purpose                 --> (its,their) purpose
(it's,they're) release                 --> (its,their) release
(it's,they're) residents               --> (its,their) residents
(it's,they're) rival                   --> (its,their) rival
(it's,they're) sister                  --> (its,their) sister
(it's,they're) size                    --> (its,their) size
(it's,they're) source                  --> (its,their) source
(it's,they're) southern                --> (its,their) southern
(it's,they're) status                  --> (its,their) status
(it's,they're) subsidiary              --> (its,their) subsidiary
(it's,they're) successor               --> (its,their) successor
(it's,they're) tail                    --> (its,their) tail
(it's,they're) target                  --> (its,their) target
(it's,they're) team                    --> (its,their) team
(it's,they're) test                    --> (its,their) test
(it's,they're) theme                   --> (its,their) theme
(it's,they're) timeslot                --> (its,their) timeslot
(it's,they're) toll                    --> (its,their) toll
(it's,they're) total                   --> (its,their) total
(it's,they're) type                    --> (its,their) type
(it's,they're) usage                   --> (its,their) usage
(it's,they're) user                    --> (its,their) user
(it's,they're) value                   --> (its,their) value
(it's,they're) way                     --> (its,their) way
(it's,they're) website                 --> (its,their) website
(it's,they're) weight                  --> (its,their) weight
(it's,they're) western                 --> (its,their) western
(it's,they're) width                   --> (its,their) width
(it's,they're) worst                   --> (its,their) worst
(it's,they're) yearly                  --> (its,their) yearly

had (it's,they're)                     --> had (its,their)
have (it's,they're)                    --> have (its,their)
are (it's,they're)                     --> are (its,their)
around (it's,they're)                  --> around (its,their)
at (it's,they're)                      --> at (its,their)
be (it's,they're)                      --> be (its,their)
because of (it's,they're)              --> because of (its,their)
been (it's,they're)                    --> been (its,their)
behind (it's,they're)                  --> behind (its,their)
being (it's,they're)                   --> being (its,their)
beside (it's,they're)                  --> beside (its,their)
between (it's,they're)                 --> between (its,their)
beyond (it's,they're)                  --> beyond (its,their)
both (it's,they're)                    --> both (its,their)
both of (it's,they're)                 --> both of (its,their)
by (it's,they're)                      --> by (its,their)
celebrated (it's,they're)              --> celebrated (its,their)
changed (it's,they're)                 --> changed (its,their)
closed (it's,they're)                  --> closed (its,their)
despite (it's,they're)                 --> despite (its,their)
down (it's,they're)                    --> down (its,their)
due to (it's,they're)                  --> due to (its,their)
during (it's,they're)                  --> during (its,their)
in (it's,they're)                      --> in (its,their)
into (it's,they're)                    --> into (its,their)
made (it's,they're)                    --> made (its,their)
make (it's,they're)                    --> make (its,their)
through (it's,they're)                 --> through (its,their)
throughout (it's,they're)              --> throughout (its,their)
under (it's,they're)                   --> under (its,their)
underneath (it's,they're)              --> underneath (its,their)
unlike (it's,they're)                  --> unlike (its,their)
until (it's,they're)                   --> until (its,their)
up (it's,they're)                      --> up (its,their)
upon (it's,they're)                    --> upon (its,their)
via (it's,they're)                     --> via (its,their)
with (it's,they're)                    --> with (its,their)
within (it's,they're)                  --> within (its,their)
without (it's,they're)                 --> without (its,their)


====[ Misspelled possessive or demonstrative adjective ]=========================

there's (is,are,was,were)  --> theirs (is,are,was,were)  -->  there (is,are,was,were)
there's (could,should,would)  --> theirs (could,should,would)  -->  there (could,should,would)
there's (may,might,must)  --> theirs (may,might,must)  -->  there (may,might,must)


====[ Incorrect singular contraction for a plural ]=============================

there's (two,three,four,five,six,seven,eight,nine,ten)  --> there are (two,three,four,five,six,seven,eight,nine,ten)


====[ Incorrect use of possessive "their" instead of demonstrative "there" or pronoun "they" ]=======

their are                    --> there are                   -->  they are
their had                    --> there had                   -->  they had
their (may,might) be         --> there (may,might) be        --> they (may,might) be
their (would,could,should)   --> there (would,could,should)  --> they (would,could,should

their (is,was,were,has,have) --> there (is,was,were,has,have)



====[ Missing apostrophe ]=======

lions share                  --> lion's share


====[ Incorrect use of an apostrophe ]=======

he let's                     --> he lets
lot's of                     --> lots of
of it's own                  --> of its own
on it's own                  --> on its own
parent's house               --> parents' house
she let's                    --> she lets
teacher's union              --> teachers' union
they're are                  --> there are           -->  they are


=====[ Incorrect form of the verb "to be" ]====================================

            I (is,are)         -->           I (am,am)
   (<she>,it) am               -->  (<she>,it) is
   (<she>,it) are              -->  (<she>,it) is
         <we> am               -->        <we> are
         <we> is               -->        <we> are

            I been             -->           I was    -->           I have been
   (<she>,it) been             -->  (<she>,it) was    -->  (<she>,it) has been
         <we> been             -->        <we> were   -->        <we> have been

            I have (was,were)  -->           I was   -->            I have been
   (<she>,it) have was         -->  (<she>,it) was   -->   (<she>,it) has been
   (<she>,it) have were        -->  (<she>,it) was   -->   (<she>,it) has been
         <we> have was         -->        <we> were  -->         <we> have been
         <we> have were        -->        <we> were  -->         <we> have been



#_____/ Common irregular verbs \______________________________________________
#
#        Verb and          3rd singular       Simple            Past
#        present tense     present            past              participle
#        _____________     ____________       _______           __________

<verb>   arise             arises             arose             arisen
<verb>   ask               asks               asked             asked
<verb>   awake             awakes             awoke             awoken
<verb>   bear              bears              bore              borne
<verb>   beat              beats              beat              beaten
<verb>   become            becomes            became            become
<verb>   begin             begins             began             begun
<verb>   behold            beholds            beheld            beheld
<verb>   bend              bends              bent              bent
<verb>   bet               bets               bet               bet
<verb>   bid               bids               bade              bidden
<verb>   bid               bids               bid               bid
<verb>   bind              binds              bound             bound
<verb>   bite              bites              bit               bitten
<verb>   bleed             bleeds             bled              bled
<verb>   blow              blows              blew              blown
<verb>   break             breaks             broke             broken
<verb>   breed             breeds             bred              bred
<verb>   bring             brings             brought           brought
<verb>   broadcast         broadcasts         broadcast         broadcast
<verb>   build             builds             built             built
<verb>   burn              burns              burnt             burnt
<verb>   burst             bursts             burst             burst
<verb>   bust              busts              bust              bust
<verb>   buy               buys               bought            bought
<verb>   cast              casts              cast              cast
<verb>   catch             catches            caught            caught
<verb>   choose            chooses            chose             chosen
<verb>   cling             clings             clung             clung
<verb>   come              comes              came              come
<verb>   cost              costs              cost              cost
<verb>   creep             creeps             crept             crept
<verb>   cut               cuts               cut               cut
<verb>   deal              deals              dealt             dealt
<verb>   dig               digs               dug               dug
<verb>   do                does               did               done
<verb>   draw              draws              drew              drawn
<verb>   drink             drinks             drank             drunk
<verb>   drive             drives             drove             driven
<verb>   dwell             dwells             dwelt             dwelt
<verb>   eat               eats               ate               eaten
<verb>   fall              falls              fell              fallen
<verb>   feed              feeds              fed               fed
<verb>   feel              feels              felt              felt
<verb>   feel              feels              felt              felt
<verb>   fight             fights             fought            fought
<verb>   find              finds              found             found
<verb>   flee              flees              fled              fled
<verb>   fling             flings             flung             flung
<verb>   fly               flies              flew              flown
<verb>   forbid            forbids            forbade           forbidden
<verb>   forecast          forecasts          forecast          forecast
<verb>   foresee           foresees           foresaw           foreseen
<verb>   foretell          foretells          foretold          foretold
<verb>   forget            forgets            forgot            forgotten
<verb>   forgive           forgives           forgave           forgiven
<verb>   forsake           forsakes           forsook           forsaken
<verb>   freeze            freezes            froze             frozen
<verb>   get               gets               got               gotten
<verb>   give              gives              gave              given
<verb>   go                goes               went              gone
<verb>   grind             grinds             ground            ground
<verb>   grow              grows              grew              grown
<verb>   hang              hangs              hung              hung
<verb>   have              has                had               had
<verb>   hear              hears              heard             heard
<verb>   hide              hides              hid               hidden
<verb>   hit               hits               hit               hit
<verb>   hold              holds              held              held
<verb>   hurt              hurts              hurt              hurt
<verb>   inlay             inlays             inlaid            inlaid
<verb>   input             inputs             input             input
<verb>   insist            insists            insisted          insisted
<verb>   interlay          interlays          interlaid         interlaid
<verb>   keep              keeps              kept              kept
<verb>   kneel             kneels             knelt             knelt
<verb>   know              knows              knew              known
<verb>   lay               lays               laid              laid
<verb>   lead              leads              led               led
<verb>   leap              leaps              leapt             leapt
<verb>   leave             leaves             left              left
<verb>   lend              lends              lent              lent
<verb>   let               lets               let               let
<verb>   lie               lies               lay               lain
<verb>   light             lights             lit               lit
<verb>   lose              loses              lost              lost
<verb>   make              makes              made              made
<verb>   mean              means              meant             meant
<verb>   meet              meets              met               met
<verb>   mislead           misleads           misled            misled
<verb>   mistake           mistakes           mistook           mistaken
<verb>   move              moves              moved             moved
<verb>   mow               mows               mowed             mown
<verb>   overdraw          overdraws          overdrew          overdrawn
<verb>   overhear          overhears          overheard         overheard
<verb>   overtake          overtakes          overtook          overtaken
<verb>   pay               pays               paid              paid
<verb>   preset            presets            preset            preset
<verb>   put               puts               put               put
<verb>   quit              quits              quit              quit
<verb>   read              reads              read              read
<verb>   rid               rids               rid               rid
<verb>   ride              rides              rode              ridden
<verb>   ring              rings              rang              rung
<verb>   rise              rises              rose              risen
<verb>   rive              rives              rived             riven
<verb>   run               runs               ran               run
<verb>   saw               saws               sawed             sawn
<verb>   say               says               said              said
<verb>   see               sees               saw               seen
<verb>   seek              seeks              sought            sought
<verb>   sell              sells              sold              sold
<verb>   send              sends              sent              sent
<verb>   set               sets               set               set
<verb>   sew               sews               sewed             sewn
<verb>   shake             shakes             shook             shaken
<verb>   shave             shaves             shaved            shaved
<verb>   shear             shears             sheared           shorn
<verb>   shed              sheds              shed              shed
<verb>   shine             shines             shone             shone
<verb>   shoe              shoes              shod              shod
<verb>   shoot             shoots             shot              shot
<verb>   show              shows              showed            shown
<verb>   shrink            shrinks            shrank            shrunk
<verb>   shut              shuts              shut              shut
<verb>   sing              sings              sang              sung
<verb>   sink              sinks              sank              sunk
<verb>   sit               sits               sat               sat
<verb>   slay              slays              slew              slain
<verb>   sleep             sleeps             slept             slept
<verb>   slide             slides             slid              slid
<verb>   sling             slings             slung             slung
<verb>   slink             slinks             slunk             slunk
<verb>   slit              slits              slit              slit
<verb>   sow               sows               sowed             sown
<verb>   speak             speaks             spoke             spoken
<verb>   speed             speeds             sped              sped
<verb>   spend             spends             spent             spent
<verb>   spin              spins              span              spun
<verb>   spit              spits              spat              spat
<verb>   split             splits             split             split
<verb>   spoil             spoils             spoilt            spoiled
<verb>   spread            spreads            spread            spread
<verb>   spring            springs            sprang            sprung
<verb>   stand             stands             stood             stood
<verb>   steal             steals             stole             stolen
<verb>   stick             sticks             stuck             stuck
<verb>   sting             stings             stung             stung
<verb>   stink             stinks             stank             stunk
<verb>   stride            strides            strode            stridden
<verb>   strike            strikes            struck            struck
<verb>   string            strings            strung            strung
<verb>   strive            strives            strove            striven
<verb>   sublet            sublets            sublet            sublet
<verb>   swear             swears             swore             sworn
<verb>   sweat             sweats             sweat             sweated
<verb>   sweep             sweeps             swept             swept
<verb>   swell             swells             swelled           swollen
<verb>   swim              swims              swam              swum
<verb>   swing             swings             swung             swung
<verb>   take              takes              took              taken
<verb>   teach             teaches            taught            taught
<verb>   tear              tears              tore              torn
<verb>   tell              tells              told              told
<verb>   think             thinks             thought           thought
<verb>   throw             throws             threw             thrown
<verb>   thrust            thrusts            thrust            thrust
<verb>   tread             treads             trod              trodden
<verb>   try               tries              tried             tried
<verb>   undergo           undergoes          underwent         undergone
<verb>   understand        understands        understood        understood
<verb>   undertake         undertakes         undertook         undertaken
<verb>   upset             upsets             upset             upset
<verb>   wake              wakes              woke              woken
<verb>   wear              wears              wore              worn
<verb>   weave             weaves             wove              woven
<verb>   wed               weds               wed               wedded
<verb>   weep              weeps              wept              wept
<verb>   wend              wends              wended            wended
<verb>   wet               wets               wet               wetted
<verb>   win               wins               won               won
<verb>   wind              winds              wound             wound
<verb>   withdraw          withdraws          withdrew          withdrawn
<verb>   withhold          withholds          withheld          withheld
<verb>   withstand         withstands         withstood         withstood
<verb>   wring             wrings             wrung             wrung
<verb>   write             writes             wrote             written


#_____/ Other common (but regular) verbs \____________________________________
#
#        Verb and          3rd singular       Simple            Past
#        present tense     present            past              participle
#        _____________     ____________       _______           __________

<verb>   abide             abides             abided            abided
<verb>   add               adds               added             added
<verb>   alight            alights            alighted          alighted
<verb>   allow             allows             allowed           allowed
<verb>   appear            appears            appeared          appeared
<verb>   believe           believes           believed          believed
<verb>   call              calls              called            called
<verb>   change            changes            changed           changed
<verb>   clap              claps              clapped           clapped
<verb>   clothe            clothes            clothed           clothed
<verb>   consider          considers          considered        considered
<verb>   continue          continue           continued         continued
<verb>   create            creates            created           created
<verb>   dare              dares              dared             dared
<verb>   die               dies               died              died
<verb>   dive              dives              dived             dived
<verb>   dream             dreams             dreamed           dreamed
<verb>   expect            expects            expected          expected
<verb>   fit               fits               fitted            fitted
<verb>   follow            follows            followed          followed
<verb>   happen            happens            happened          happened
<verb>   help              helps              helped            helped
<verb>   include           includes           included          included
<verb>   kill              kills              killed            killed
<verb>   knit              knits              knitted           knitted
<verb>   lean              leans              leaned            leaned
<verb>   learn             learns             learned           learned
<verb>   like              likes              liked             liked
<verb>   live              lives              lived             lived
<verb>   look              looks              looked            looked
<verb>   love              loves              loved             loved
<verb>   melt              melts              melted            melted
<verb>   misunderstand     misunderstands     misunderstood     misunderstood
<verb>   need              needs              needed            needed
<verb>   offer             offers             offered           offered
<verb>   open              opens              opened            opened
<verb>   play              plays              played            played
<verb>   prove             proves             proved            proved
<verb>   provide           provides           provided          provided
<verb>   reach             reaches            reached           reached
<verb>   remain            remains            remained          remained
<verb>   remember          remembers          remembered        remembered
<verb>   seem              seems              seemed            seemed
<verb>   serve             serves             served            served
<verb>   smell             smells             smelled           smelled
<verb>   sneak             sneaks             sneaked           sneaked
<verb>   spell             spells             spelled           spelled
<verb>   spill             spills             spilled           spilled
<verb>   start             starts             started           started
<verb>   stay              stays              stayed            stayed
<verb>   stop              stops              stopped           stopped
<verb>   strip             strips             stripped          stripped
<verb>   sunburn           sunburns           sunburned         sunburned
<verb>   talk              talks              talked            talked
<verb>   thrive            thrives            thrived           thrived
<verb>   turn              turns              turned            turned
<verb>   use               uses               used              used
<verb>   vex               vexes              vexed             vexed
<verb>   wait              waits              waited            waited
<verb>   walk              walks              walked            walked
<verb>   want              wants              wanted            wanted
<verb>   watch             watches            watched           watched
<verb>   work              works              worked            worked


=====[ Incorrect participle ]=======================================

(had,has,have,having) be         -->  (had,has,have,having) been
(had,has,have,having) ben        -->  (had,has,have,having) been
(had,has,have,having) brung      -->  (had,has,have,having) brought
(had,has,have,having) comeback   -->  (had,has,have,having) come back
(had,has,have,having) cut-off    -->  (had,has,have,having) cut off
(had,has,have,having) did        -->  (had,has,have,having) done
(had,has,have,having) is         -->  (had,has,have,having) been
(had,has,have,having) know       -->  (had,has,have,having) known
(had,has,have,having) runaway    -->  (had,has,have,having) run away
(had,has,have,having) set-up     -->  (had,has,have,having) set up
(had,has,have,having) setup      -->  (had,has,have,having) set up
(had,has,have,having) shut-down  -->  (had,has,have,having) shut down
(had,has,have,having) shutdown   -->  (had,has,have,having) shut down
(had,has,have,having) shutout    -->  (had,has,have,having) shut out
(had,has,have,having) throve     -->  (had,has,have,having) thrived
(had,has,have,having) thunk      -->  (had,has,have,having) thought
(had,has,have,having) to much    -->  (had,has,have,having) too much
(had,has,have,having) to used    -->  (had,has,have,having) to use


=====[ Incorrect use of compound noun instead of compound verb ]==============

to back fire      -->  to backfire
to back-off       -->  to back off
to back-out       -->  to back out
to back-up        -->  to back up
to backoff        -->  to back off
to backout        -->  to back out
to backup         -->  to back up
to bailout        -->  to bail out
to be build       -->  to be built
to be setup       -->  to be set up
to blackout       -->  to black out
to blastoff       -->  to blast off
to blowout        -->  to blow out
to blowup         -->  to blow up
to breakdown      -->  to break down
to buildup        -->  to build up
to built          -->  to build
to buyout         -->  to buy out
to chose          -->  to choose
to comeback       -->  to come back
to crackdown      -->  to crack down
to cutback        -->  to cut back
to dropout        -->  to drop out
to forego         -->  to forego
to grown          -->  to grow
to holdout        -->  to hold out
to kickoff        -->  to kick off
to lit            -->  to light
to lockout        -->  to lock out
to lookup         -->  to look up
to markup         -->  to mark up
to pickup         -->  to pick up
to playback       -->  to play back
to rollback       -->  to roll back
to runaway        -->  to run away
to setup          -->  to set up
to shut-down      -->  to shut down
to shutdown       -->  to shut down
to spent          -->  to spend
to spin-off       -->  to spin off
to spinoff        -->  to spin off
to takeover       -->  to take over
to that affect    -->  to that effect
to together       -->  together
to touchdown      -->  to touch down
to try and        -->  to try to
to try-out        -->  to try out
to tryout         -->  to try out
to turn-off       -->  to turn off
to turnaround     -->  to turn around
to turnoff        -->  to turn off
to turnout        -->  to turn out
to turnover       -->  to turn over
to wakeup         -->  to wake up
to walkout        -->  to walk out
to wipeout        -->  to wipe out
to workaround     -->  to work around
to workout        -->  to work out



=====[ Unnecessary extra word ]===================================

actual fact                  --> fact
and plus                     --> and
became to be                 --> became        -->  came to be
because of the fact that     --> because
becoming obsolescent         --> obsolescent
during from                  --> during        -->  from
during in                    --> during        -->  in
hadn't have                  --> hadn't
hadn't of                    --> hadn't
hence why                    --> hence         -->  that's why
in close proximity to        --> close to      -->  in proximity to
in the fact that             --> in that
is has                       --> is            -->  has
is were                      --> is            -->  were
knots per hour               --> knots
maybe be                     --> may be
medieval ages                --> middle ages   --> medieval
most optimal                 --> best          -->  optimal
originally born in           --> born in
point being is               --> point being   -->  point is
rate of speed                --> rate          -->  speed
RPM's                        --> RPM
RPMs                         --> RPM
somewhat of a                --> somewhat      -->  something of a
too also                     --> too           -->  also        -->  to also
without scarcely             --> without

====[ Incorrect use of preposition "of" instead of participle "have" ]========

could of                     --> could have
might of                     --> might have
must of                      --> must have
should not of                --> should not have
should of                    --> should have
would of                     --> would have


====[ Wrong preposition ]=======================

apart for                    --> apart from


====[ Incorrect use of present tense instead of a past participle ]======

(well,originally,usually,mainly) know for --> (well,originally,usually,mainly) known for
(well,originally,usually,mainly) know as  --> (well,originally,usually,mainly) known as
(well,originally,usually,mainly) know by  --> (well,originally,usually,mainly) known by

(sometimes,often,always,formerly) know for --> (sometimes,often,always,formerly) known for
(sometimes,often,always,formerly) know as  --> (sometimes,often,always,formerly) known as
(sometimes,often,always,formerly) know by  --> (sometimes,often,always,formerly) known by

(simply,also,better,commonly,mostly) know for --> (simply,also,better,commonly,mostly) known for
(simply,also,better,commonly,mostly) know as  --> (simply,also,better,commonly,mostly) known as
(simply,also,better,commonly,mostly) know by  --> (simply,also,better,commonly,mostly) known by

(had,has,have,having) know                -->  (had,has,have,having) known
(is,are,became,being,been,was,were) know  -->  (is,are,is,are,became,being,been,was,were) known


====[ Use of "lead" ("a metal") instead of "led" ("proceeded") ]===============

(had,has,have,having) lead the -->  (had,has,have,having) led the
(had,has,have,having) lead to  -->  (had,has,have,having) led to
                      lead by  -->                        led by
  (it,this,that,what) lead to  -->    (it,this,that,what) led to
   (was,were,been) mislead     -->     (was,were,been) misled
which (,have,has,had) lead     -->  which (,have,has,had) led
  who (,have,has,had) lead     -->    who (,have,has,had) led
  that (have,has,had) lead     -->    that (have,has,had) led


====[ Past participle of "lay" is not "lain". It's "laid" ]============================

(is,are,be,been,being,was,were) lain  --> (is,are,be,been,being,was,were) laid


====[ Past tense of "lie" is not "lied". It's "lay" ]============================

lied (ahead,dormant,empty,fallow,in state)  --> lay (ahead,dormant,empty,fallow,in state)
what lied                                   --> what lay


====[ Past tense of "lie" is not "laid". It's "lay" ]============================

laid (ahead,dormant,empty,fallow,in state)  --> lay (ahead,dormant,empty,fallow,in state)
what laid                                   --> what lay


====[ Incorrect use of "lay" ("to put down") instead of "lie" ("to rest horizontally") ]=======

lay around                          --> lie around   --> lied around
laying around                       --> lying around
lay low                             --> lie low      --> lied low
laying low                          --> lying low
laying awake                        --> lying awake
lays (atop,beside,in,low,near,on)   --> lies (atop,beside,in,low,near,on)
laying (atop,beside,in,low,near,on) --> lying (atop,beside,in,low,near,on)


====[ Incorrect use of "loose" ("to set free") instead of "lose" ("to fail or misplace") ]======

loose to                           --> lose to
loosing effort                     --> losing effort
loosing record                     --> losing record
loosing season                     --> losing season
loosing streak                     --> losing streak
loosing team                       --> losing team
loosing the                        --> losing the
loosing to                         --> losing to


====[ Incorrect use of of "principle" ("rule") instead of "principal" ("most important") ]======

principle action             --> principal action
principle activity           --> principal activity
principle actor              --> principal actor
principle advantage          --> principal advantage
principle advocate           --> principal advocate
principle agent              --> principal agent
principle aim                --> principal aim
principle area               --> principal area
principle artist             --> principal artist
principle assistant          --> principal assistant
principle attraction         --> principal attraction
principle author             --> principal author
principle branch             --> principal branch
principle cast               --> principal cast
principle caste              --> principal caste
principle cause              --> principal cause
principle character          --> principal character
principle church             --> principal church
principle city               --> principal city
principle component          --> principal component
principle composer           --> principal composer
principle goal               --> principal goal
principle group              --> principal group
principle ingredient         --> principal ingredient
principle method             --> principal method
principle office             --> principal office
principle officer            --> principal officer
principle owner              --> principal owner
principle photography        --> principal photography
principle source             --> principal source
principle student            --> principal student
principle town               --> principal town


====[ Incorrect use of "principal" ("most important") instead of "principle" ("rule") ]======

(basic,core,fundamental,first) principal --> (basic,core,fundamental,first) principle
         (legal,moral,ethical) principal -->          (legal,moral,ethical) principle
                       (in,on) principal -->                        (in,on) principle


====[ "comprise" does not take a trailing preposition ]=====================

     is comprised (of,from,with,to,by,as)   -->       comprises  -->       is composed of  -->       consists of
    was comprised (of,from,with,to,by,as)   -->       comprised  -->      was composed of  -->       consisted of
   were comprised (of,from,with,to,by,as)   -->       comprised  -->     were composed of  -->       consisted of
will be comprised (of,from,with,to,by,as)   -->  will comprise   -->  will be composed of  -->  will consist of
        comprised (of,from,with,to,by,as)   -->       comprised                            -->       consisted of
  would comprise (of,from,with,to,by,as)    --> would comprise   --> would be composed of  -->  would consist of

comprise* almost entirely of  --> comprise* almost entirely  --> consist* almost entirely of
comprise* chiefly of          --> comprise* chiefly          --> consist* chiefly of
comprise* entirely of         --> comprise* entirely         --> consist* entirely of
comprise* exclusively of      --> comprise* exclusively      --> consist* exclusively of
comprise* generally of        --> comprise* generally        --> consist* generally of
comprise* largely of          --> comprise* largely          --> consist* largely of
comprise* mainly of           --> comprise* mainly           --> consist* mainly of
comprise* mostly of           --> comprise* mostly           --> consist* mostly of
comprise* only of             --> comprise* only             --> consist* only of
comprise* primarily of        --> comprise* primarily        --> consist* primarily of
comprise* principally of      --> comprise* principally      --> consist* principally of
comprise* totally of          --> comprise* totally          --> consist* totally of
comprise* wholly of           --> comprise* wholly           --> consist* wholly of


====[ "constitute" does not take a trailing preposition ]=====================

would constitute (from,with,to,by,as)    --> would constitute     -->  would consist of
constitute* almost entirely of  --> constitute* almost entirely  --> consist* almost entirely of
constitute* chiefly of          --> constitute* chiefly          --> consist* chiefly of
constitute* entirely of         --> constitute* entirely         --> consist* entirely of
constitute* exclusively of      --> constitute* exclusively      --> consist* exclusively of
constitute* generally of        --> constitute* generally        --> consist* generally of
constitute* largely of          --> constitute* largely          --> consist* largely of
constitute* mainly of           --> constitute* mainly           --> consist* mainly of
constitute* mostly of           --> constitute* mostly           --> consist* mostly of
constitute* of                  --> constitute*                  --> consist* of
constitute* only of             --> constitute* only             --> consist* only of
constitute* primarily of        --> constitute* primarily        --> consist* primarily of
constitute* principally of      --> constitute* principally      --> consist* principally of
constitute* totally of          --> constitute* totally          --> consist* totally of
constitute* wholly of           --> constitute* wholly           --> consist* wholly of


====[ "contain" does not take a trailing preposition ]=====================

would contain (from,with,to,by,as)    --> would contain
contain* almost entirely of  --> contain* almost entirely  --> consist* almost entirely of
contain* chiefly of          --> contain* chiefly          --> consist* chiefly of
contain* entirely of         --> contain* entirely         --> consist* entirely of
contain* exclusively of      --> contain* exclusively      --> consist* exclusively of
contain* generally of        --> contain* generally        --> consist* generally of
contain* largely of          --> contain* largely          --> consist* largely of
contain* mainly of           --> contain* mainly           --> consist* mainly of
contain* mostly of           --> contain* mostly           --> consist* mostly of
contain* of                  --> contain*                  --> consist* of
contain* only of             --> contain* only             --> consist* only of
contain* primarily of        --> contain* primarily        --> consist* primarily of
contain* principally of      --> contain* principally      --> consist* principally of
contain* totally of          --> contain* totally          --> consist* totally of
contain* wholly of           --> contain* wholly           --> consist* wholly of


====[ "to consist" requires a trailing preposition "of" ]=====================

consists (a,an,the)  --> consists of (a,an,the)   -->  comprises (a,an,the)


====[ The preposition "between" takes an accusative pronoun ]=====================

between (I,we,she,he,they) and      --> between (me,us,her,him,them) and
between me and (she,he,they)        --> between me and (her,him,them)
between you and (I,she,he,they)     --> between you and (me,her,him,them)
between him and (I,she,he,they)     --> between you and (me,her,him,them)
between her and (I,she,he,they)     --> between her and (me,her,him,them)
between us and (she,he,they)        --> between us and (her,him,them)
between them and (I,she,he,we,they) --> between them and (me,her,him,us,them)


====[ Incorrect use of noun "breath" instead of verb "breathe" ]===============

                          <I> breath  -->                           <I> breathe
        (to,can,can't,cannot) breath  -->         (to,can,can't,cannot) breathe
   (could,couldn't,could not) breath  -->    (could,couldn't,could not) breathe
(should,shouldn't,should not) breath  --> (should,shouldn't,should not) breathe
        (will,won't,will not) breath  -->         (will,won't,will not) breathe
   (would,wouldn't,would not) breath  -->    (would,wouldn't,would not) breathe

breath* fire --> breathe* fire


====[ The noun "criteria" is plural ]====================

criteria (is,was)                    --> criteria (are,were)   -->  criterion (is,was)
(a,one,each,either,neither) criteria --> (a,one,each,either,neither) criterion
(this,that) criteria                 --> (these,those) criteria   -->  (this,that) criterion


====[ The noun "phenomena" is plural ]====================

phenomena (is,was)                    --> phenomena (are,were)   -->  phenomenon (is,was)
(a,one,each,either,neither) phenomena --> (a,one,each,either,neither) phenomenon
(this,that) phenomena                 --> (these,those) phenomena   -->  (this,that) phenomenon


====[ The noun "parenthesis" is singular ]===================================

(in,inside,between,within) parenthesis  --> (in,inside,between,within) parentheses


====[ Incorrect use of adjective "fair" instead of verb "fare" ]==========

didn't fair                  --> didn't fare
faired as well               --> fared as well
faired badly                 --> fared badly
faired better                --> fared better
faired far                   --> fared far
faired less                  --> fared less
faired little                --> fared little
faired much                  --> fared much
faired no better             --> fared no better
faired poorly                --> fared poorly
faired quite                 --> fared quite
faired rather                --> fared rather
faired slightly              --> fared slightly
faired somewhat              --> fared somewhat
faired well                  --> fared well
faired worse                 --> fared worse


====[ Incorrect use of "reign" ("rule") instead of "rein" ("control") ]========

free reign                   --> free rein
hand the reigns              --> hand the reins
held the reigns              --> held the reins
hold the reigns              --> hold the reins
holding the reigns           --> holding the reins
holds the reigns             --> holds the reins
reign in                     --> rein in
reigned in                   --> reined in
reigns of power              --> reins of power
take over the reigns         --> take over the reins
take the reigns              --> take the reins
taken the reigns             --> taken the reins
taking the reigns            --> taking the reins
took over the reigns         --> took over the reins
took the reigns              --> took the reins


====[ Incorrect use of preposition "over" instead of prefix "over-" ]=============

over hear                    --> overhear
over heard                   --> overheard
over look                    --> overlook
over looked                  --> overlooked
over looking                 --> overlooking
over rated                   --> overrated
over seas                    --> overseas
over see                     --> oversee

====[ Incorrect use of preposition "under" instead of prefix "under-" ]=============

under go                     --> undergo
under going                  --> undergoing
under gone                   --> undergone
under rated                  --> underrated
under take                   --> undertake
under wear                   --> underwear
under way                    --> underway
under went                   --> underwent


====[ Incorrect use of "ring" ("to surround") instead of "wring" ("to squeeze by twisting") ]=======

ring <my> neck               --> wring <my> neck
rang <my> neck               --> wrung <my> neck
ring <our> necks             --> wring <our> necks
rang <our> necks             --> wrung <our> necks

through the ringer           --> through the wringer


====[ Incorrect use of "wet" ("to moisten") instead of "whet" ("to sharpen")  ]=======

wet (her,his,its,the) appetite    -->  whet (her,his,its,the) appetite
wet (my,our,your,their) appetite  -->  whet (my,our,your,their) appetite
wet (our,your,their) appetites    -->  whet (our,your,their) appetites

====[ Incorrect use of adjective "some" instead of prefix "some-" ]=============

some how    --> somehow
some one    --> someone
some what   --> somewhat
some where  --> somewhere


====[ Ambiguous and unidiomatic phrasign for a unit of area ]==================

squared (inches,feet,yards,miles)  --> square (inches,feet,yards,miles)  --> (inches,feet,yards,miles) squared
squared (milli,centi,,kilo)meters  --> square (milli,centi,,kilo)meters  --> (milli,centi,,kilo)meters squared
squared (milli,centi,,kilo)metres  --> square (milli,centi,,kilo)metres  --> (,milli,kilo)metres       squared


====[ Use of an inappropriate word (possibly a typo) ]===========================

  <I> weighted                  -->   <I> waited   -->    <I> weighed
(apart,aside,away) form         --> (apart,aside,away) from
baited breath(,e)               --> bated breath
bare in mind                    --> bear in mind
brake away                      --> break away
breathe a sign of relief        --> breathe a sigh of relief
certain extend                  --> certain extent
compromised of                  --> composed of         -->  compromised by
construction sight              --> construction site
death nail                      --> death knell
diffuse the situation           --> defuse the situation
diffuse the tension             --> defuse the tension
dire straights                  --> dire straits
direct affect                   --> direct effect
door jam                        --> door jamb
eluded to                       --> alluded to
even thought                    --> even though
even tough                      --> even though
follow suite                    --> follow suit
for all intensive purposes      --> for all intents and purposes
forth place                     --> fourth place
full compliment                 --> full complement
get pass                        --> get past
going threw                     --> going through
(got,have) another thing coming --> (got,have) another think coming
half and hour                   --> half an hour
heart-wrenching                 --> heart-rending
hone in on                      --> home in on
in edition to                   --> in addition to
in placed                       --> in place
in regards to                   --> in regard to
in vein                         --> in vain
in(,to) affect                  --> in(,to) effect
intend on                       --> intent on           -->  intend to
is compromised of               --> is composed of      -->  compromised by
is front of                     --> in front of
is renown for                   --> is renowned for
it weight(s,ed)                 --> it wait(s,ed)
its is                          --> it is
jive with                       --> jibe with
law suite                       --> law suit
lead(,ing) roll                 --> lead(,ing) role
(major,minor) roll              --> (major,minor) role
mute point                      --> moot point
new lease of life               --> new lease on life
nip** it in the butt            --> nip** it in the bud
nipped in the butt              --> nip it in the bud
oft chance                      --> off chance
one in the same                 --> one and the same
out of sink                     --> out of sync
pass the muster                 --> pass muster     -->  pass the mustard
past away                       --> passed away     -->  died
past down                       --> passed down
per say                         --> per se
preying mantis                  --> praying mantis
put fourth                      --> put forth
reap what you sew               --> reap what you sow
role call                       --> roll call
roll player                     --> role player
side affect                     --> side effect
site lines                      --> sight lines
slight of hand                  --> sleight of hand
sneak peak                      --> sneak peek
spilt (among,between,into,up)   --> split (among,between,into,up)
spinal chord                    --> spinal cord
staring role                    --> starring role
starring roll                   --> starring role
take affect                     --> take effect
that fact that                  --> the fact that
the absent of                   --> the absence of
the affect (of,on)              --> the effect (of,on)
the affects (of,on)             --> the effects (of,on)
the are                         --> that are            -->  the area       -->  there are     -->  they are
the began                       --> that began          -->  then began     -->  they began
the extend of                   --> the extent of
the had                         --> that had            -->  there had      -->  they had
the have                        --> that have           -->  there have     -->  they have
the injures                     --> the injuries
the rational behind             --> the rationale behind
the rational for                --> the rationale for
the was                         --> that was            -->  there was
the went                        --> then went           -->  they went
the were                        --> they were
they is                         --> there is            -->  they are
they past                       --> the past            -->  they passed
they way                        --> the way             -->  their way
they weight                     --> they weigh          -->  they weighed
too be                          --> to be
took affect                     --> took effect
took and interest               --> took an interest
tot he                          -->  to the
turn for the worst              --> turn for the worse
under( ,)weigh                  --> underway
veil of tears                   --> vale of tears
vise versa                      --> vice versa
vocal chords                    --> vocal cords
waived off                      --> waved off
warn (down,out)                 --> worn (down,out)
was aloud                       --> was allowed
was though that                 --> was thought that
went threw                      --> went through
were aloud                      --> were allowed
wether or not                   --> whether or not
when (off,into,on to)           --> went (off,into,on to)
within site of                  --> within sight of
working progress                --> work in progress
worst than                      --> worse than

   peak <my> interest  -->  pique <my> interest
  peaks <my> interest  -->  piques <my> interest
 peaked <my> interest  -->  piqued <my> interest
peaking <my> interest  -->  piquing <my> interest


====[ Missing auxiliary verb ]=====================================================

  <I> better   -->     <I> had better   -->     <I>'d better


====[ Incorrect use of "who" (subject) instead of "whom" (object) ]==================

depending on who   <I>    -->  depending on whom   <I>
depending upon who   <I>  -->  depending upon whom   <I>
(for,from,with) who       -->  (for,from,with) whom
(of,over) who to          -->  (of,over) whom to
who he led                -->  whom he led
who he married            -->  whom he married
who he met                -->  whom he met
who he took               -->  whom he took
who (I,you,we,they) have  -->  whom (I,you,we,they) have
who (<she>,it) has        -->  whom (<she>,it) has
who (I,you,we,they) was   -->  whom (I,you,we,they) was
who (<she>,it) were       -->  whom (<she>,it) were
who   <I> should          -->  whom   <I> should
who   <I> could           -->  whom   <I> could
who   <I> would           -->  whom   <I> would
who   <I> may             -->  whom   <I> may
who   <I> might           -->  whom   <I> might
who   <I> must            -->  whom   <I> must
who   <I> met             -->  whom   <I> met
who   <I> took            -->  whom   <I> took
who   <I> gave            -->  whom   <I> gave

who to (believe,blame,call,invite,send,ask)  --> whom to (believe,blame,call,invite,send,ask)


====[ Incorrect use of "whom" (object) instead of "who" (subject) ]==================

whom also                    --> who also
whom is                      --> who is
whom was                     --> who was


====[ Incorrect use of "who's" ("who is") instead of "whose" ("belonging to whom") ]==================

who's actual                 -->    whose actual
who's brother                -->    whose brother
who's sister                 -->    whose sister
who's father                 -->    whose father
who's mother                 -->    whose mother
who's name                   -->    whose name
who's own                    -->    whose own
who's previous               -->    whose previous

(of,by) who's                -->    (of,by) whose


====[ Incorrect use of verb "were" instead of adjective "where" ]=======

were (<she>,it) was          -->    where (<she>,it) was
were (I,you,we,they) were    -->    where (I,you,we,they) were
were   <I> should            -->    where   <I> should
were   <I> could             -->    where   <I> could
were   <I> would             -->    where   <I> would
were   <I> may               -->    where   <I> may
were   <I> might             -->    where   <I> might
were   <I> must              -->    where   <I> must
were   <I> took              -->    where   <I> took
were   <I> gave              -->    where   <I> gave
were   <I> got               -->    where   <I> got


====[ Incorrect use of adjective "where" instead of verb "were" ]=======

                      <I> where   -->                   <I> were
      (there,these,those) where   -->   (there,these,those) were
    (that,which,what,who) where   --> (that,which,what,who) were


====[ Incorrect use of adjective "loath" ("reluctant") instead of verb "loathe" ("to dislike") ]======

             to loath        -->  to loathe
(I,you,we,they) loath        -->  (I,you,we,they) loathe
            <I> would loath  -->    <I> would loathe


====[ Incorrect use of verb "loathe" ("to dislike") instead of adjective "loath" ("reluctant") ]======

loathe(,d) to                          --> loath to


====[ Incorrect use of "reek" ("to smell") instead of "wreak" ("to inflict") ]=====

reek* havoc                   --> wreak* havoc
reek* vengeance               --> wreak* vengeance

====[ Incorrect use of "wreck" ("to destroy") instead of "wreak" ("to inflict") ]=====

wreck* havoc                  --> wreak* havoc
wreck* vengeance              --> wreak* vengeance


====[ Incorrect use of "use to" ("to employ") instead of "used to" ("accustomed" or "previously") ]===============

(be,is,are,being,been,was,were) use to  --> (be,is,are,being,been,was,were) used to
                            <I> use to  -->                             <I> used to
               (that,which,who) use to  -->                (that,which,who) used to
  (get,gets,getting,got,gotten) use to  -->   (get,gets,getting,got,gotten) used to
(grow,grows,growing,grew,grown) use to  --> (grow,grows,growing,grew,grown) used to

use to (be,have,go,do,get,take)  --> used to (be,have,go,do,get,take)


====[ Incorrect use of adverb "maybe" ("perhaps") instead of verb "may be" ]====

(that,this,these,those) maybe   --> (that,this,these,those) may be
       (which,who,what) maybe   -->  (which,who,what) may be
                  there maybe   --> there may be
                    <I> maybe   -->   <I> may be


====[ Incorrect use of a single word where two are required ]==================

ahold                        --> a hold
alot                         --> a lot
there maybe                  --> there may be
in along time                --> in a long time
in anyway                    --> in any way
in awhile                    --> in a while
in quite awhile              --> in quite a while
in stead of                  --> instead of
incase of                    --> in case of
inorder to                   --> in order to
is set(-,)up                 --> is set up
it set(-,)up                 --> it set up
was set(-,)up                --> was set up
was shutdown                 --> was shut down
was shutout                  --> was shut out
was sold-out                 --> was sold out
were set(-,)up               --> were set up
were shutdown                --> were shut down
were shutout                 --> were shut out
which breakdown              --> which break down
who maybe                    --> who may be
who setup                    --> who set up
would workout                --> would work out


====[ Incorrect use of multiple words where a single word is required ]========

all be it                    --> albeit
in tact                      --> intact
it self                      --> itself
lack there of                --> lack thereof
mean while                   --> meanwhile
near by                      --> nearby
never the less               --> nevertheless
no where to                  --> nowhere to
not withstanding             --> notwithstanding
out grow                     --> outgrow
out side                     --> outside
set backs                    --> setbacks
shortly there after          --> shortly thereafter
single handily               --> single-handedly
soon there after             --> soon thereafter
them selves                  --> themselves
there after                  --> thereafter
there by                     --> thereby
there fore                   --> therefore
there of                     --> thereof
through out                  --> throughout          --> threw out
time outs                    --> timeouts
way side                     --> wayside
where abouts                 --> whereabouts
where as                     --> whereas
where by                     --> whereby
where upon                   --> whereupon
with in                      --> within
with out                     --> without
worth while                  --> worthwhile


====[ Incorrect use of an unnecessary preposition ]============================================

as best as                   --> as best
as of yet                    --> as yet
deciding on how              --> deciding how
denied of                    --> denied
despite of                   --> despite
despite of the fact          --> despite the fact
during of                    --> during     -->  during or
during to                    --> during     -->  during the
enjoy to                     --> enjoy   --> like to
equally as                   --> equally
from hence                   --> hence
from whence                  --> whence
into to                      --> into                -->  in to
numerous of                  --> numerous     -->  numbers of
up until                     --> until


====[ Incorrect preposition used ]====================================

based (around,off)           --> based on
bored of                     --> bored with     -->  bored by
borrow off                   --> borrow from
different to                 --> different from    --> different than
focus around                 --> focus on
on accident                  --> by accident
report into                  --> report on
since many years             --> for many years
since years                  --> for years


====[ Incorrect use of a double-negative construct ]============================

couldn't (hardly,scarcely)           -->  couldn't           -->  could (hardly,scarcely)
without (not,hardly,scarcely)        -->  without

(not,hardly,scarcely) never          -->  (not,hardly,scarcely) ever
(can't,won't) never                  -->  (can't,won't) ever                 --> (can,will) never
(don't,doesn't) never                -->  (don't,doesn't) ever
(couldn't,wouldn't,shouldn't) never  -->  (couldn't,wouldn't,shouldn't) ever -->  (could,would,should) never


====[ Incorrect use of an implied negative ]=================================

could care less              --> couldn't care less
could give a damn            --> couldn't give a damn


====[ Incorrect form of verb (possibly a typo) ]===============================

been show on                 --> been shown on
being show on                --> being shown on
can been                     --> can be
could been                   --> could be     -->  could have been
did gave                     --> did give
either are                   --> either is
is ran by                    --> is run by
it spend                     --> it spent
may been                     --> may be           -->  may have been
oppose to                    --> opposed to
should been                  --> should be         -->  should have been
should have went             --> should have gone
should've went               --> should have gone
suppose to                   --> supposed to
was show on                  --> was shown on
was suppose to               --> was supposed to
were meet by                 --> were met by
were meet with               --> were met with
were suppose to              --> were supposed to
would been                   --> would be     -->  would have been


====[ Inflexion of verb does not agree with subject ]==========================

both of them is              --> both of them are
(<she>,it) don't             --> (<she>,it) doesn't
these includes               --> these include       -->  this includes
they includes                --> they include
those includes               --> those include
was do to                    --> was done to     -->  was due to


====[ "to be" takes a nominative pronoun, not an accusative pronoun ]==========

it is (me,her,him,us,them)     --> it is (I,she,he,we,they)
it's (me,her,him,us,them)      --> it's (I,she,he,we,they)
that's (me,her,him,us,them)    --> that's (I,she,he,we,they)
it was (me,her,him,us,them)    --> it was (I,she,he,we,they)
that was (me,her,him,us,them)  --> that was (I,she,he,we,they)
it were (me,her,him,us,them)   --> it were (I,she,he,we,they)
that were (me,her,him,us,them) --> that were (I,she,he,we,they)


====[ "re-" already means "back" ]=============================================

reply back                   --> reply
return back                  --> return
revert back                  --> revert


====[ Incorrect use of two forms of "to be" in a single compound verb ]=========

that's (is,are,was,were)      --> that (is,are,was,were)
what's (is,are,was,were)      --> what (is,are,was,were)
 who's (is,are,was,were)      -->  who (is,are,was,were)     --> whose (is,are,was,were)

(am,is,are,was,were) also am  --> (am,is,are,was,were) also  --> (am,is,are,was,were) being
(am,is,are,was,were) also is  --> (am,is,are,was,were) also  --> (am,is,are,was,were) being
(am,is,are,was,were) also are --> (am,is,are,was,were) also  --> (am,is,are,was,were) being
(am,is,are,was,were) be       --> (am,is,are,was,were)       --> (am,is,are,was,were) being
(am,is,are,was,were) been     --> (am,is,are,was,were)       --> (am,is,are,was,were) being  --> (have,has,have,had,had) been


====[ Unidiomatic leading "the" (possibly a typo) ]============================

the all of the    --> all of the     --> to all of the
the any of the    --> any of the     --> to any of the
the both of the   --> both of the    --> to both of the
the both the      --> both the       --> to both the
the each of the   --> each of the    --> to each of the
the <I>           --> to <I>         --> that <I>    --> then <I>   --> <I>
the <my>          --> to <my>        --> that <my>   --> then <my>  --> <my>
the <me>          --> to <me>                        --> then <me>  --> <me>
the <mine>        --> <mine>
the many of the   --> many of the    --> to many of the
the most of the   --> most of the    --> to most of the
the much of the   --> much of the    --> to much of the
the one of the    --> one of the     --> to one of the
the one's         --> one's          --> to one's           -->  the ones
the only the      --> only the       --> to only the
the some of the   --> some of the    --> to some of the
the these         --> these          --> to these
the this          --> this           --> to this
the those         --> those          --> to those
the where         --> where          --> to where


====[ Incorrect use of "reticent" (i.e. "private") instead of "reluctant" (i.e. "disinclined") ]==========

reticence to                 --> reluctance to
reticent to                  --> reluctant to


=====[ Unidiomatic construct ]====================================

make pretend                 --> make believe     -->  pretend
over and out                 --> out
will likely                  --> will probably
would liked to have had      --> would have liked to have


====[ A koala is a marsupial, not a bear ]====================================

koala bear                   --> koala



====[ Prepositions must be followed by an accusative pronoun ]=====================

about <she>             --> about <her>          --> about the
above <she>             --> above <her>          --> above the
across <she>            --> across <her>         --> across the
against <she>           --> against <her>        --> against the
around <she>            --> around <her>         --> around the
at <she>                --> at <her>             --> at the
behind <she>            --> behind <her>         --> behind the
below <she>             --> below <her>          --> below the
beneath <she>           --> beneath <her>        --> beneath the
beside <she>            --> beside <her>         --> beside the
beyond <she>            --> beyond <her>         --> beyond the
by <she>                --> by <her>             --> by the
concerning <she>        --> concerning <her>     --> concerning the
considering <she>       --> considering <her>    --> considering the
despite <she>           --> despite <her>        --> despite the
excepting <she>         --> excepting <her>      --> excepting the
excluding <she>         --> excluding <her>      --> excluding the
following <she>         --> following <her>      --> following the
from <she>              --> from <her>           --> from the
in <she>                --> in <her>             --> in the
inside <she>            --> inside <her>         --> inside the
into <she>              --> into <her>           --> into the
minus <she>             --> minus <her>          --> minus the
near <she>              --> near <her>           --> near the
of <she>                --> of <her>             --> of the
off <she>               --> off <her>            --> off the
on <she>                --> on <her>             --> on the
onto <she>              --> onto <her>           --> onto the
opposite <she>          --> opposite <her>       --> opposite the
outside <she>           --> outside <her>        --> outside the
over <she>              --> over <her>           --> over the
past <she>              --> past <her>           --> past the
regarding <she>         --> regarding <her>      --> regarding the
round <she>             --> round <her>          --> round the
save <she>              --> save <her>           --> save the
through <she>           --> through <her>        --> through the
to <she>                --> to <her>             --> to the
toward <she>            --> toward <her>         --> toward the
towards <she>           --> towards <her>        --> towards the
under <she>             --> under <her>          --> under the
underneath <she>        --> underneath <she>      --> underneath the
unlike <she>            --> unlike <her>         --> unlike the
upon <she>              --> upon <her>           --> upon the
versus <she>            --> versus <her>         --> versus the
with <she>              --> with <her>           --> with the
within <she>            --> within <her>         --> within the
without <she>           --> without <her>        --> without the

about (I,we,they)       --> about (me,us,them)
above (I,we,they)       --> above (me,us,them)
across (I,we,they)      --> across (me,us,them)
against (I,we,they)     --> against (me,us,them)
around (I,we,they)      --> around (me,us,them)
at (I,we,they)          --> at (me,us,them)
behind (I,we,they)      --> behind (me,us,them)
below (I,we,they)       --> below (me,us,them)
beneath (I,we,they)     --> beneath (me,us,them)
beside (I,we,they)      --> beside (me,us,them)
beyond (I,we,they)      --> beyond (me,us,them)
by (I,we,they)          --> by (me,us,them)
concerning (I,we,they)  --> concerning (me,us,them)
despite (I,we,they)     --> despite (me,us,them)
excepting (I,we,they)   --> excepting (me,us,them)
excluding (I,we,they)   --> excluding (me,us,them)
following (I,we,they)   --> following (me,us,them)
from (I,we,they)        --> from (me,us,them)
in (I,we,they)          --> in (me,us,them)
inside (I,we,they)      --> inside (me,us,them)
into (I,we,they)        --> into (me,us,them)
minus (I,we,they)       --> minus (me,us,them)
near (I,we,they)        --> near (me,us,them)
of (I,we,they)          --> of (me,us,them)
off (I,we,they)         --> off (me,us,them)
on (I,we,they)          --> on (me,us,them)
onto (I,we,they)        --> onto (me,us,them)
opposite (I,we,they)    --> opposite (me,us,them)
outside (I,we,they)     --> outside (me,us,them)
over (I,we,they)        --> over (me,us,them)
past (I,we,they)        --> past (me,us,them)
regarding (I,we,they)   --> regarding (me,us,them)
round (I,we,they)       --> round (me,us,them)
save (I,we,they)        --> save (me,us,them)
than (I,we,they)        --> than (me,us,them)
through (I,we,they)     --> through (me,us,them)
to (I,we,they)          --> to (me,us,them)
toward (I,we,they)      --> toward (me,us,them)
towards (I,we,they)     --> towards (me,us,them)
under (I,we,they)       --> under (me,us,them)
underneath (I,we,they)  --> underneath (me,us,them)
unlike (I,we,they)      --> unlike (me,us,them)
upon (I,we,they)        --> upon (me,us,them)
versus (I,we,they)      --> versus (me,us,them)
with (I,we,they)        --> with (me,us,them)
within (I,we,they)      --> within (me,us,them)
without (I,we,they)     --> without (me,us,them)



#____/ Absolute adjectives \____________________________________________________

<absolute>  unique
<absolute>  perfect
<absolute>  complete
<absolute>  empty
<absolute>  equal
<absolute>  essential
<absolute>  dead
<absolute>  first
<absolute>  ideal
<absolute>  impossible
<absolute>  infinite
<absolute>  perfect
<absolute>  pregnant
<absolute>  universal


#____/ Absolute adjectives with idiomatic intensifiers \_______________________

<absolute: (often,likely) >  fatal
<absolute: nearly         >  full
<absolute: often          >  married
<absolute: nearly         >  minimal
<absolute: nearly         >  maximal

  more optimal   --> optimal   --> more optimized   --> better
  most optimal   --> optimal   --> most optimized   --> best
  very optimal   --> optimal   --> well optimized
highly optimal   --> optimal   --> highly optimized


#_____/ Redundant words \_______________________________________________________

in any way, shape(,) or form  --> in any way
in no way, shape(,)  or form  --> in no way     --> not


####################################################################
#                                                                  #
#     This file specifies common usages that may or may not        #
#     be actual errors in a particular context. Mostly, these      #
#     are near-synonyms, homophones, and other words that are      #
#     frequently misused or confused with each other.              #
#                                                                  #
####################################################################

  accept*              :  to agree to receive or do
  except*              :  to exclude
- expect*              :  to regard as likely

  adverse              :  hostile or difficult
  averse               :  disinclined

  affect*              :  emotion, to have an effect on
  effect*              :  a consequence, to bring about

  aisle(s)             :  a passage between rows of seats
  isle(s)              :  an island

  all together         :  all in one place, all at once
  altogether           :  completely; on the whole

  aloud                :  audibly
  allowed              :  permitted

  altar(s)             :  a sacred table in a church
  alter(s)             :  to change

  alternate*           :  every other
  alternative(s)       :  another choice

  alternately          :  cycling through two or more alternatives
  alternatively        :  as another choice

  amoral               :  not concerned with right or wrong
  immoral              :  not following accepted moral standards

  appraise*            :  to assess
  apprise*             :  to inform

  assent(s)            :  agreement, approval
  ascent(s)            :  the action of rising or climbing up

  assure*              :  to instil confidence
  ensure*              :  to verify
  insure*              :  to indemnify against loss

  aural                :  relating to the ears or hearing
  oral                 :  relating to the mouth; spoken

  awhile               :  for a short time
- a while              :  a period of time

  balmy                :  pleasantly warm
  barmy                :  foolish, crazy

  bazaar               :  a Middle Eastern market
  bizarre              :  strange

  beg** the question   :  to use a circular argument
- raise* the question  :  to call for an answer
- evade* the question  :  to avoid answering

  berth(s)             :  a bunk in a ship, train, etc.
  birth(s)             :  the emergence of a baby from the womb

  border(s)            :  a boundary
  boarder(s)           :  one who boards

  borne                :  past tense of "to bear"
- born                 :  given birth to

  bough(s)             :  a branch of a tree
  bow(s)               :  to bend the head; the front of a ship

  bought               :  past tense of "to buy"
  brought              :  past tense of "to bring"

  brake*               :  a device for stopping a vehicle; to stop a vehicle
  break*               :  to separate into pieces; a pause

  breach*              :  a gap or break
  breech*              :  the back part of a gun barrel

  broach(es)           :  to raise a subject for discussion
  brooch(es)           :  a piece of jewellery

  canon(s)             :  a general law, rule, principle, or criterion (or collection thereof)
- cannon(s)            :  a big gun

  canvas*              :  a type of strong cloth
  canvass*             :  to seek people's votes or opinions

  carat(s)             :  200 milligrams (usually of precious stones)
  karat(s)             :  1/24 pure gold
  caret(s)             :  a typographical mark
- carrot(s)            :  a root vegetable

  careen*              :  to swerve from side to side
- career*              :  to move quickly and out of control, in a specific direction

  censure*             :  to criticize strongly
  censor*              :  to ban parts of a book or film

  cereal(s)            :  grains
  serial(s)            :  happening in a series

  chord(s)             :  a group of musical notes
  cord(s)              :  a length of string

  climactic            :  related to a climax
  climatic             :  related to climate

  coarse               :  rough
  course               :  a direction; a school subject; part of a meal

  compliment*          :  to say something positive about
  complement*          :  something which completes or improves a set

  complimentary        :  saying positive things about, offered for free
  complementary        :  going well together

  complacent(ly)       :  smug and self-satisfied
  complaisant(ly)      :  willing to please

  comprise*            :  to include the following
- compose*             :  to be made up of

  conflate             :  to combine two or more words, ideas, items into one
- confuse              :  to mistale one word, idea, item for another

  continuous(ly)       :  uninterrupted(ly)
  continual(ly)        :  repeated(ly)

  council(s)           :  a group that governs, deliberates, or advises
  counsel(s)           :  an individual who advises
  consul(s)            :  an individual who represents a foreign government

  credulous            :  gullible
- credible             :  believable

  critique*            :  to provide a detailed analysis of
- criticize*           :  to find fault with

  cue*                 :  a signal for action; a wooden rod
- queue*               :  a line of people or vehicles

  currant(s)           :  a small fruit or berry
- current(s)           :  a flow (of water, air, electricity, etc.)

  defuse*              :  to make a situation less tense
  diffuse*             :  to spread over a wide area

  depreciate*          :  to reduce the value of
  deprecate*           :  to express disapproval of

  desert(s)            :  a waterless, empty area; to abandon someone
  dessert(s)           :  the sweet course of a meal

  disburse*            :  to give out or distribute (usually money)
- disperse*            :  to scatter

  discreet             :  circumspect
  discrete             :  separate

  disinterested        :  neutral, objective, unbiased, impartial
  uninterested         :  bored, indifferent to

  dissemble*           :  to be dishonest or deliberately misleading
  disassemble*         :  to take apart

  dose*                :  administered a drug or medication
  doze*                :  fell asleep

  douse*               :  to extinguish with a liquid
  dowse*               :  to search for a liquid

  draught(s)           :  a current of air
  draft(s)             :  a first version of a piece of writing

  draw(s)              :  an even score at the end of a game
  drawer(s)            :  a sliding storage compartment

  dryer(s)             :  something that dries things
  drier(s)             :  less wet

  duel(s)              :  a formal battle
  dual(s)              :  having two of something

  economic             :  pertaining to the economy
  economical           :  money-saving

  elicit               :  to extract
  illicit              :  unlawful or improper

  envelop(s)           :  (verb) to cover or surround
  envelope(s)          :  (noun) a paper container for a letter

  exorcise*            :  to drive out an evil spirit
- exercise*            :  to perform physical activity

  eulogy(s)            :  a speech praising the deceased
  elegy(s)             :  a type of poem

  immanent             :  inherent or universal
- imminent             :  likely to occur soon

  emulate*             :  to attempt to replicate or match the performance of
  imitate*             :  to copy the behaviour of

  endemic              :  characteristic of a particular region or group
  epidemic             :  widespread or rampant

  envious(ly)          :  wanting something that another person has (and you do not)
  jealous(ly)          :  wanting to retain (exclusively) something you already have

  envy                 :  desire for something that another person has (and you do not)
  jealousy             :  desire to retain (exclusively) something you already have

  exult*               :  to rejoice
  exalt*               :  to raise up

  excited              :  aroused
  exited               :  departed

  farther              :  refers to distance in space
  further              :  refers to duration in time

  fawn(s)              :  a young deer; light brown
  faun(s)              :  a mythical being, part man, part goat

  frieze(s)            :  a decoration along a wall
- freeze(s)            :  to turn to ice

  grisly               :  gruesome, revolting
  grizzly              :  a type of bear

  fearful              :  experiencing fear oneself
  fearsome             :  provoking fear in others

  feint*               :  a diversion
  faint*               :  weak

  fewer                :  a smaller number of countable items ("fewer marbles", "two fewer")
  less                 :  a smaller amount of singular or uncountable material ("less marble", "one less")

  fiancÃ©(s)            :  a man engaged to be married
  fiance(s)
  fiancÃ©e(s)           :  a woman engaged to be married
  fiancee(s)

  flaunt*              :  to show off
  flout*               :  to ignore or show contempt for

  founder*             :  to sink
  flounder*            :  to thrash around trying not to sink

  forbear(s)           :  to refrain
  forebear(s)          :  an ancestor

  forgo                :  to do without
  forego               :  to go before

  gaff(s)              :  a large hook
  gaffe(s)             :  a mistake

  gibe*                :  to tease
  jibe*                :  to agree
  jive*                :  to dance

  gild(s)              :  to cover in gold
- guild(s)             :  an association

  hanged               :  past tense of "to be hanged (by the neck)"
  hung                 :  past tense of "to hang"

  hoard(s)             :  a collection that has been hoarded
  horde(s)             :  a group or crowd or herd

  homey                :  comfortable, cozy, welcoming, unpretentious
  homely               :  unattractive in appearance

  humus                :  rotted vegetable matter covering soil
  hummus               :  a type of dip

  impassible           :  having no feeling, impassive
- impassable           :  unable to be navigated past
- impossible           :  not able to occur, exist, or happen

  imply                :  to suggest without explicitly stating
  infer                :  to reach a conclusion using logic

  indite*              :  to write down
- indict*              :  to charge with a crime

  intersession(s)      :  a period between two sessions
- intercession(s)      :  to plead on behalf of someone else

  interment(s)         :  burial
  internment(s)        :  imprisonment

  ironic(ally)         :  having an outcome incongruously different to what was expected
- coincidental(ly)     :  unrelated but happening at (about) the same time

  it's                 :  it is
  its                  :  belonging to it

  jack(s)              :  a hole into which a plug is inserted
  plug(s)              :  one or more prongs which can be inserted into a jack

  jamb(s)              :  the vertical parts of the frame of a door or window
- jam(s)               :  a conserve, a congestion, a predicament, or a music session

  lama(s)              :  a monk
  llama(s)             :  a South American mammal

  leach*               :  to dissolve and carry away
  leech*               :  a blood-sucking worm

  lessen(s)            :  to reduce
- lesson(s)            :  something to be learned

  libel                :  false statements injurious to a person's reputation
  liable               :  responsible under law

  lightening           :  making lighter
- lightning            :  an electrical discharge in the atmosphere

  likeliness(es)       :  probability
  likeness(es)         :  similarity

  literally            :  actually
- figuratively         :  not actually

  loath                :  (adj) reluctant, unwilling
  loathe               :  (verb) to hate

  lose*                :  to be deprived of, or unable to find
  loose*               :  to unfasten, or set free

  materiel             :  equipment and supplies for a organization (usually military)
- material             :  substance, fabric, components, information

  maybe                :  perhaps
- may be               :  might be

  meteor(s)            :  a chunk of extraterrestrial rock falling through the atmosphere
  meteorite(s)         :  a chunk of extraterrestrial rock that has reached the ground
- meteoroid(s)         :  a chunk of extraterrestrial rock floating in space

  methodology(s)       :  a system of methods
- method(s)            :  a way of doing something

  militate*            :  to be a powerful factor against
  mitigate*            :  to make less severe

  mucus                :  a slimy excretion
  mucous               :  pertaining to mucus
  mucoid               :  resembling mucus

  nauseous             :  (noun) something that makes you want to vomit
  nauseated            :  (adj) wanting to vomit

  notorious            :  famous in a bad way

  obsolescent          :  in the process of becoming obsolete

  ordnance             :  mounted weapons
- ordinance            :  a law or statute

  palette(s)           :  a board for mixing paints
  pallet(s)            :  a platform or bed
- palate(s)            :  the roof of the mouth

  partake(s,n)         :  to consume
  partaking
  partook
- participate*         :  to take part in

  passed               :  a form of the verb "to pass"
  past                 :  before now, across this location (never a verb)

  payed                :  let out more rope
- paid                 :  disbursed money to settle a debt

  peaked               :  to have reached a summit or limit
  piqued               :  to have aroused curiousity

  pedal*               :  to turn a crank using a floor plate
  peddle*              :  to attempt to sell

  perpetuate*          :  to cause to continue
  perpetrate*          :  to commit a crime

  perverse             :  stubborn
- perverted            :  corrupted

  podium(s)            :  a raised platform on which a speaker stands
  lectern(s)           :  a stand to hold a book or notes

  poisonous            :  something that is deadly when eaten
  venomous             :  something that actively injects poison

  pole*                :  a long stick
  poll*                :  a survey or ballot

  populous             :  having (many) people
  populace             :  people

  pore*                :  to study something closely; a tiny opening
- pour*                :  to flow or cause to flow

  practicable          :  theoretically possible to do
- practical            :  sensible and useful to do

  prey                 :  to hunt and kill for food
  pray                 :  to request supernatural assistance

  precede*             :  to go before
  proceed*             :  to go on

  premier              :  top, first, best
  premiere             :  revealed for the first time

  prescribe*           :  to recommend or mandate
  proscribe*           :  to forbid

  presently            :  soon
- currently            :  at the moment

  presumptive          :  presumed (from the current evidence or under the present circumstances)
- presumptuous         :  going beyond what is reasonable or appropriate

  principle(s)         :  a rule or precept
  principal(s)         :  most important

  prone                :  lying face down
  supine               :  lying face up

  protagonist(s)       :  the central character of a story
  proponent(s)         :  someone who advocates something

  purposely            :  not accidentally
  purposefully         :  with a definite purpose in mind

  rack*                :  to stretch (usually painfully)
  wrack*               :  to wreck or ruin

  rationale(s)          :  underlying reasons for something
  rationalization(s)   :  false logic justifying something

  reactionary          :  seeking to restore a lost past
- reactive             :  acting in response to something

  rebut**              :  to argue against a proposition
  refute*              :  to prove a proposition wrong

  reticent             :  unwilling to speak about something
- reluctant            :  unwilling to do something

  remuneration(s)      :  payment
  renumeration(s)      :  re-counting

  resister(s)          :  one who resists
  resistor(s)          :  an component of a circuit

  retch(es,ed)         :  to vomit
  wretch(es,ed)        :  someone who is wretched

  retrospective(ly)    :  looking to the past
  retroactive(ly)      :  applying to the past (typically laws)

  revolve*             :  to spin around an external axis
  rotate*              :  to spin around an internal axis

  rout(s)              :  a disorderly retreat
- route(s)             :  a path or course taken

  scotch               :  whisky
- scots                :  pertaining to Scotland or the Scottish

  shinny*              :  to climb
  shimmy*              :  to shake
  shi(mm,nn)ying

  shrunk               :  past participle of "to shrink"  ("I have shrunk the head")
  shrank               :  simple past tense of "to shrink" ("I shrank the head")

  silicone             :  a type of polymer
  silicon              :  a chemical element

  societal             :  pertaining to societies
- social               :  pertaining to a society

  sojourn*             :  to stay at a single place
- journey*             :  to move from place to place

  specie               :  money in the form of coins
- species              :  a group of organisms capable of interbreeding

  sprain*              :  a ligament injury
- strain*              :  a muscle or tendon injury

  storey(s)            :  a level of a building
  story(s)             :  a tale or account

  take* a stance       :  to assume an position (literally or figuratively)
  took a stance
  take* a stand        :  to assume a position of resistance or opposition
  took a stand

  stationary           :  standing still
  stationery           :  writing materials

  straight(en,ened)    :  in line
  strait(en,ened)      :  tight or narrow or difficult

  stripped             :  having had a layer removed
  striped              :  having stripes

  subject to           :  potentially liable for some action or law
  subjected to         :  having some action or law actually applied to you

  secede*              :  to separate from a nation or organization
- succeed*             :  to achieve a desired outcome

  summery              :  pertaining to summer
- summary              :  a precis or summation

  systemic(ally)       :  pertaining to (parts of) a system
- systematic(ally)     :  in an orderly and logical manner

  taught               :  past tense of "to teach"
  taut                 :  stretched tight
  tort                 :  a wrongdoing that injures another

  tempera(s)           :  a kind of paint
  tempura(s)           :  a kind of food

  that                 :  what follows is essential to the meaning of the sentence
  which                :  what follows merely enhances the meaning of the sentence

  their                :  belonging to them
  they're              :  they are
  there                :  at that location

  thereupon            :  immediately after that
  there upon           :  in that place and on

  though               :  despite the fact that
  thought              :  a mental notion
  through              :  moving into and then out of
  threw                :  past tense of "to throw"

  thrown               :  past participle of "to throw"
  throne               :  a seat for a monarch or other leader

  throws               :  present tense of "to throw"
  throes               :  intense pain or struggle

  tick(s)              :  an insect, a sharp sound, a check mark
  tic(s)               :  a small muscular spasm

  timber(s)            :  wood
  timbre(s)            :  the characteristic tonal quality of a voice or instrument

  titillate*           :  to stimulate or arouse
  titivate*            :  to make more attractive

  tortuous             :  confusingly twisty
  torturous            :  pertaining to torture

  troupe(s,r)          :  a group of performers
  troop(s,er)          :  a group of any other kind

  unchartered          :  not having a charter
- uncharted            :  not appearing on a chart or map

  usage(s)             :  the manner of employing, the amount used
- use(s)               :  the act of employing

  vein(s)              :  a blood vessel or mineral seam
  vane(s)              :  a blade that interacts with gases or liquids
  vain                 :  conceited, useless

  valance(s)           :  a decorative hanging for furniture
  valence(s)           :  the combining power of an element

  vapid                :  weak, flavourless, insipid
  vacuous              :  unintelligent, trivial, mindless

  vary                 :  to alter
  very                 :  in a high degree

  versus               :  against
  verses               :  line of poetry or scripture

  were                 :  past tense of "to be"
  we're                :  we are
  where                :  at what location

  wherefore            :  why

  who's                :  who is
  whose                :  belonging to whom

  whit(s)              :  a small piece
- wit(s)               :  intelligence, humour

  wont                 :  a habitual custom
- won't                :  will not

  wangle*              :  to obtain something deviously
- wrangle*             :  to argue with, to herd livestock

  wrapped              :  surrounded by
  rapt                 :  enraptured by

  wreath(s)            :  a ring-shaped arrangement of flowers etc.
  wreathe(s)           :  to surround or encircle

  your                 :  belonging to you
  you're               :  you are

  yoke*                :  part of a harness or of an item of clothing
  yolk*                :  the yellow part of an egg


# Warn about subjectives...

- I was                : [indicative]  indicates something that is actual, sure, true, real
  I were               : [subjunctive] indicates something merely possible, conjectured, hypothetical

- she was              : [indicative]  indicates something that is actual, sure, true, real
  she were             : [subjunctive] indicates something merely possible, conjectured, hypothetical

- he was               : [indicative]  indicates something that is actual, sure, true, real
  he were              : [subjunctive] indicates something merely possible, conjectured, hypothetical

- it was               : [indicative]  indicates something that is actual, sure, true, real
  it were              : [subjunctive] indicates something merely possible, conjectured, hypothetical



=cut
