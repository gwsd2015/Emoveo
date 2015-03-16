use Lingua::Concordance;
use File::Slurp;

$file = "C:/Perl/geneva.txt";
$data = read_file($file);
print $data;

# initialize
$concordance = Lingua::Concordance->new;
$concordance->text($data);
$querytool = "fa";
$concordance->query($querytool);

# do the work
foreach ( $concordance->lines ) { print "$_\n" };
