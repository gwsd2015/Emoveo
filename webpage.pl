use LWP::Simple;
use HTML::TreeBuilder;
use HTML::FormatText;

$URL = get("http://www.perlmonks.org/?node_id=924726/");

$Format = HTML::FormatText->new();

$TreeBuilder = HTML::TreeBuilder->new();

$TreeBuilder->parse($URL);

$Parsed = $Format->format($TreeBuilder);

print "$Parsed";

exit;


