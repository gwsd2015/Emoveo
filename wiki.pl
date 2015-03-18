use WWW::Wikipedia;
use Text::TermExtract;
use File::Slurp;
use utf8;

$file = "C:/Perl/wikistore.txt";
open(WIKI, ">:utf8", $file) or die;

my $wiki = WWW::Wikipedia->new();
## search for 'perl' 
my $result = $wiki->search( 'Japan' );

## if the entry has some text print it out
if ( $result->text() ) { 
      print WIKI $result->text();
}

## list any related items we can look up 
#print join( "\n", $result->related() );

close WIKI;

$textfile = read_file($file);
$ext = Text::TermExtract->new();

for my $word($ext->terms_extract($textfile,{max =>20})){
	print "$word\n";
}

exit();
