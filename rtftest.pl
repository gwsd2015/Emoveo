use strict;

use warnings;

use RTF::Writer;

print "||||||||||||";

my $rtf = RTF::Writer->new_to_file("C:/Perl/ref.rtf");
$rtf->prolog('title' => "Testing redaction printing");
$rtf->number_pages;
$rtf->paragraph(
	\'\fs40', "\tHi this is ||||||||||||||||||||||||. We decided to go to |||||||||||||||||||||||| and complete ||||||||||||||||||||||||. For one thing, the conditions |||||||||||||||||||||||| and ||||||||||||||||||||||||. While most of the |||||||||||||||||||||||| was unimportant, we must take note to ||||||||||||||||||||||||."
);
