use File::Slurp;
use Crypt::RC4;
use MIME::Base64;

my @chars = ("A".."Z", "a".."z", "0".."9", "!", "\@", "#", "\$", "\%", "\^", "\&", "\*", "\(", "\)", "-", "_", "+", "=", "\{", "\}". "\[", "\]", "\\", "\|", ":", "\;", "\'", "\"", "\,", "\.", "\<", "\>", "?", "/", "\s" );
my $key;
$key .= $chars[rand @chars] for 1..16;

print $key."\n";

system('pause');

my $input = "C:/Perl/hk.txt";

my $plaintext = read_file($input);
my $encryption = RC4($key, $plaintext);

my $encoded = encode_base64($encryption);
my $decoded = decode_base64($encoded);
print "$encoded\n";
print "$decoded\n";

system('pause');

my $decryption = RC4($key, $decoded);
print "$decryption\n";
