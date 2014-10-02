use strict;
use warnings;

use LWP::Simple;
use HTML::TreeBuilder;
use HTML::FormatText;

my $URL = get("http://www.perlmonks.org/?node_id=924726/");

my $Format = HTML::FormatText->new();

my $TreeBuilder = HTML::TreeBuilder->new();

$TreeBuilder->parse($URL);

my $Parsed = $Format->format($TreeBuilder);

print "$Parsed";

exit;


