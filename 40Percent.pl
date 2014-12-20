use strict;
use warnings;
use utf8;
use Search::VectorSpace;
use PDL;
use Text::Summarize::En;
use Data::Dump qw(dump);
use Algorithm::MarkovChain;
use Path::Class;
use Lingua::EN::Fathom;
use Lingua::Stem;
use PDL;
use Plucene;
use Algorithm::NaiveBayes;

#the build currently only works in Linux, need a dict to build on Windows
#use Lingua::EN::NamedEntity;


#use Inline::C;
#use Inline::Python;
#use Inline::Java;
#use Inline::Ruby;
#use GATE::ANNIE::Simple;
 

#next step is to actually implement the PDF::API2, really useful as it can extract information from the PDF even
#if we haven't ocr'd yet. The vector space algorithm allows me to potentially place weight so giving a bit more
#weight potentially given by PDF API2 and Lingua::EN::NamedEntity / GATE::ANNIE::Simple
use PDF::API2;


#implementation of Text SenseClusters is a latent semantic analysis, but not sure how useful it will be
#most of the weight is going to be placed on Vector Space Searching algorithm, however, it might be useful
#to identify decoument connections, but that doesn't really have anything to do. Originally had a plan to use
#this for something but can't remember at the moment

use Text::SenseClusters;



#$input will be the document to be examined
#my $input = 
#open(	INPUT,	$input	) or die;


#$output will be the summarized document
#summarization will be important as a measure of reduction in the file
#summarization will be used by taking a paragraph from the original document and comparing it to
#the output documents for a comparison of size reduction
#compare will be a subroutine

#my $output = 
#open(	OUTPUT,		'>'.$output	) or die;


#$output2 will be a file I use to store my initial split
#my $output2 = 
#open(	OUTPUT2,	'>.$output2	) or die;

#$output3 is currently a word masher with the MarkovChain
#my $output3 = 
#open(	OUTPUT3,	'>'.$output3	) or die;

#$output4 will be the output of NaiveBayes
#my output4 = 
#open(	OUTPUT4,	'>'.$output4	) or die;

my @docs = get_docs;


while(	<INPUT>	){

	tr/A-Z/a-z/;
	
	tr/.,:;!&?"'(){}\-\$\+\=\{\}\@\/\*\>\<//d;
	
	s/[0-9]//g;

	my @paragraph = split(/\n/, $_);

	print OUTPUT2 "$_" for paragraph;

	foreach my $para(	@paragraph	){

	my $Parsed = $para;
	
	my $summary = $summarizerEn->getSummaryUsingSumbasic(	listOfText => [$Parsed]	);
		
	dump $summarizerEn->getSummaryUsingSumbasic(listOfText => [$Parsed]);
	
	print $summarizerEn;
	
	my $buffer = "";
		
	my $size = (length($Parsed))*0.45;
	
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
	
	print OUTPUT $buffer."\n\n";	
	
}



}


print "Enter the topic for generation: ";

my $getuserinput = <STDIN>;

chomp $getuserinput;

my @inputs = @docs; 

my $dir = dir(".");

my $f = "";

my @symbols = ();
    
foreach $f (@inputs) {
        
	my $file = $dir->file($f);
    	
	my $linecounter = 0;
       
	my $wordcounter = 0;
        
	my $file_handle = $file->openr();
        
	while(	my $line = $file_handle->getline()	)	{
    		
		chomp ($line);
    		
		my @words = split(' ', $line);
            
		push(	@symbols,	@words);
    		
		$linecounter++;
    		
		$wordcounter += scalar(	@words	);
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

our %stop_hash;


#default standard given by http://www.perl.com/pub/2003/02/19/engine.html to try

our @stop_words = qw/i in a to the it have haven't was but is be from/;

foreach @stop_words	{	$stop_hash{$_}++};


#print the stop words w/ count of how many words

#get back to this later...

print "Your stop words are ... [#][stop word -new line-]";


#we need to map the list of content words into a vector of v map to dimension-(# of content words)
#solution for very slow loop is PDL

#my $num_words = "last count of stop word";

#default number I will use is 10;

my $num_words = 10;

my $vec = zeroes $num_words;

print $vec;


my $value = 3;

my $offset = 4;

index(	$vec,	$offset	) .= $value;

print $vec; 


#a little different than the example given on http://search.cpan.org/~mceglows/Search-VectorSpace-0.02/VectorSpace.pm


my $engine = Search::VectorSpace -> new(	docs =>	\@docs	);

$engine->build_index();

$engine->set_threshold(	0.8	);

while(	my $query = <>	){

	my %results = $engine->search(	$query	);

	foreach my $result(	sort	{	$result{$b}	<=>	$result{$a}	}	
				keys	%results	)	{

		print "Relevance: ", $results{$result}, "\n";

		print $result, "\n";

	}
	


}


#Plucene, a perl version of Lucene, a query based search engine
#haven't figured out how to build the query yet, I think I'm going to take the subroutine get_words and use that for my query

my $doc = Plucene::Document->new;
$doc->add(	Plucene::Document::Field->Text(	content => $content	)	);
$doc->add(	Plucene::Document::Field->Text(	author => "Your Name"	)	);


my $analyzer = Plucene::Analysis::SimpleAnalyzer->new();
my $writer = Plucene::Index::Writer->new(	"my_index",	$analyzer,	1	);
$writer->add_document(	$doc	);
undef $writer;

my $parser = Plucene::QueryParser->new(	{
	
	analyzer => Plucene::Analysis::SimpleAnalyzer->new(),
	
	#need to figure out a general default for all documents, will probably use a named entity comparison between all modules to figure out common themes

	default => "default query material" 		

}	);


my $searcher = Plucene::Search::IndexSearcher->new(	"my_index"	);


my $hc = Plucene::Search::HitCollector->new(	collect	=> sub	{
	my	(	$self,	$doc,	$score	)	= @_;
	push	@docs,	$searcher->doc(	$doc	);
}	);

$searcher->search_hc($query	=>	$hc);


#close INPUT;
#close OUTPUT;
#close OUTPUT2;
#close OUTPUT3;
#close OUTPUT4;


for(	my $i = 0; $i < $#docs; $i++){

	my $text_for_analysis = new Lingua::EN::Fathom;

	$text_for_analysis -> analyse_file(	$doc[$i]	);
	
	print "Preparing statistics on generated paragraphs: \n\n\n";
	
	print $text_for_analysis -> report;
}

my $text = read_file(	$doc[0]	);

my $text2 = read_file(	$doc[1]	);

print comparisontest (
	$text,
	$text2,	
);



#the reason for Plucene is that it is customizable vs Search::VectorSpace which is more automatic
#I haven't decided which one is better of the two to go towards


#example get_words, takes too long and not accurate, includes all words that are unnecessary

#original idea was to use Lingua::EN::NamedEntity
#only works in linux b/c windows version broken, the new sub get_words uses stop words to help identify key words

#subroutine is used to extract words from each text document the user specifies
#splits text on whitespace, transliterates to lowercase, and takes out - and '


=pod

sub get_words	{

	my(	$text	) = @_;

	return	map	{	lc $_ => 1	}

		map	{	/([a-z\-']+)/i	}

		split	/\s+/s,	$text; 


	}

=cut


#sub get_words use this one:


sub get_words	{


	my(	$text	) = @_;


	return	map	{	stem($_) => 1	}
		
		grep	{	!(exists $stop_hash{$_})	}
		
		map lc,


		map	{	/([a-z\-']+)/i	}

		split /\s+/s,	$text;
		
	}




# http://www.perl.com/pub/2003/02/19/engine.html subroutine to modify Lingua::Stem syntax

# wraps into sub get_words by stem($_) => 1;



sub stem	{

	my(	$word	) = @_;

	my $stemref = Lingua::Stem::stem(	$word	);

	return $stemref -> [0];


}


sub make_vector	{

	my(	$doc	) = @_;

	my %words = get_words(	$doc	);

	my $vector = zeroes $word_count;

	foreach my $w (	keys	%words	){

		my $value = $words{$w};

		my $offset = $index{$w};

		index(	$vector,	$offset	) .= $value;		

	}

	return vector;	

}



#cosine measure subroutine
#cosine measure is used to use closeness of angle of a vector to test for similarities 


# cos  = ( V1 * V2 ) / ||V1|| x ||V2||


sub cosine	{
	
	my(	$vec1,	$vec2	) = @_;

	my $n1 = norm $vec1;

	my $n2 = norm $vec2;

	my $cos = inner(	$n1,	$n2	);

	#needs this line to convert PDL back into Perl scalar or else, calculations will be off

	return $cos->sclr();
	

}

sub get_cosines	{

	my(	$query_vec	) = @_;

	my %cosines;

	while (	my	(	$id,	$vec	) = each	%document_vectors	)	{

		my $cosine = cosine(	$vec,	$query_vec	);

		next unless $cosine > $threshold;

		$cosines{$id} = $cosine;


	}

	return %cosines;



}



sub search	{

	my(	$query	) = @_;

	my $query_vec = make_vector(	$query	);

	my %results = get_cosines(	$query_vec	);

	return %results;


}




sub sentence2hash	{

	my $words	= words(lc(shift));

	my $stemmed	=   Lingua::Stem::En::stem({

		-words	=> [	grep	{	!$StopWords{$_}	} @$words	]
	
	});

	return	{	map	{$_ => 1}	grep $_, @$stemmed	};

}




sub comparisontest	{
	my	(	$h1, $h2	) = map {	sentence2hash($_) } @_;
        
	my %composite = %$h1;
        
	$composite{	$_	}++ for keys %$h2;
        
	return 100*(sum	(	values %composite	)/keys %composite)/2;
    }
