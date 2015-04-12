use Text::TermExtract;
use Lingua::EN::Tagger;

$text = "Tamil /'tæm?l/ (?????, tami?, [t??m??] ?) also spelt Tamizh is a Dravidian language spoken predominantly by Tamil people of Tamil Nadu and Sri Lanka. It has official status in the Indian states of Tamil Nadu, Puducherry and Andaman and Nicobar Islands. Tamil is also an official and national language of Sri Lanka[10] and one of the official languages of Singapore.[11] It is legalised as one of the languages of medium of education in Malaysia along with English, Malay and Mandarin.[12][13] It is also chiefly spoken in the states of Kerala, Puducherry and Andaman and Nicobar Islands as a secondary language and by minorities in Karnataka and Andhra Pradesh. It is one of the 22 scheduled languages of India and was the first Indian language to be declared a classical language by the Government of India in 2004. Tamil is also spoken by significant minorities in Malaysia, England, Mauritius, Canada,[14] South Africa,[15] Fiji,[16] Germany,[17] Philippines, United States, Netherlands, Indonesia,[18] Réunion and France as well as emigrant communities around the world.";

$p = new Lingua::EN::Tagger;

$tagged = $p->add_tags($text);

%wordlist = $p->get_words($text);

foreach $z(keys %wordlist) {
	print $z."\n";
	push @originallist, $z;
	if ($z =~ /(\w+\s\w+)/){
		$z =~ s/\s/_/;
		if($z =~ /'/){
			$z =~ s/'/__/;
		}
		push @sublist, $z;
	}
}

for($i = 0; $i < $#originallist; $i++){
	$testing = $originallist[$i];
	$substition = $sublist[$i];
	if ($test =~ /$testing/){
		$test =~ s/$testing/$substitution/eeig;
	}
}

print "============================\n";

$ext = Text::TermExtract->new();

for $word($ext->terms_extract($text, {max => 3})){
	for($j = 0; $j < $#sublist; $j++){
		$subtest = $sublist[$j];
		$originalrevert = $originallist[$j];
		if($word =~ /$subtest/){
			$word =~ s/$subtest/$originalrevert/eeig;
		}
	}
	print $word."\n";
}
