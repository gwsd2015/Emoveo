use Text::TermExtract;
use File::Slurp;

$file = "C:/Perl/STR.txt";
$text = read_file($file);

$ext = Text::TermExtract->new();

for my $word($ext->terms_extract($text,{max =>20})){
	print "$word\n";
}

exit();
