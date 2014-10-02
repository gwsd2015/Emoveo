use strict;

use warnings;

use Google::Search;


my $search = Google::Search->Web(query => "windows errors");

while (my $result = $search -> next ) {
	print $result->rank, " ", $result->uri, "\n";
}
