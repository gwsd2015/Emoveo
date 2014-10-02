use strict;
use warnings;
use LWP::Simple;

my $URL = get("http://edition.cnn.com/2014/09/30/world/asia/china-hong-kong-protests/index.html?hpt=ias_c1/");

open(FILE, ">c:/perl64/file.txt");
print FILE $URL;
close(FILE);