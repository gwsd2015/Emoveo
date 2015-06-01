use WWW::Wikipedia;
use File::Slurp;
use Text::TermExtract;
use strict;
use warnings;

my @array_init;
my @array0a;
my @array1a;
my @array2a;
my @array3a;
my @array4a;
my @array5a;
my @array6a;
my @array7a;
my @array8a;
my @array9a;
my @array10a;
my @array11a;
my @array12a;
my @array13a;
my @array14a;
my @array15a;
my @array16a;
my @array17a;
my @array18a;
my @array19a;
my @array0b;
my @array1b;
my @array2b;
my @array3b;
my @array4b;
my @array5b;
my @array6b;
my @array7b;
my @array8b;
my @array9b;
my @array10b;
my @array11b;
my @array12b;
my @array13b;
my @array14b;
my @array15b;
my @array16b;
my @array17b;
my @array18b;
my @array19b;

#query for file

print "\nEnter file to build tree:\t";

my $query = <STDIN>;
chomp $query;

my $textfile = read_file($query);
my $extract = Text::TermExtract->new();
for my $terms($extract->terms_extract($textfile,{max => 20})){
	push @array_init, $terms;
}

for(my $i = 0; $i < $#array_init+1; $i++){
	my $toquery = $array_init[$i];
	my $wiki = WWW::Wikipedia->new();
	my $result = $wiki->search($toquery);
	if($result->text()){
		my $wikitext = $result->text;
		my $extraction = Text::TermExtract->new();
		for my $wikiterms($extraction->terms_extract($wikitext,{max=>20})){
			if($i eq 0){
				push @array0a, $wikiterms;
				push @array0b, $result->related();
				for my $array0relation(@array0b){
					my $w0 = WWW::Wikipedia->new();
					my $res0 = $w0->search($array0relation);
					if($res0->text()){
						my $wikiz0 = $res0->text;
						my $extr0 = Text::TermExtract->new();
						for my $relationterms0($extr0->terms_extract($wikiz0,{max=>20})){
							push @array0a, $relationterms0;
						}
					}
				}
			}
			elsif($i eq 1){
				push @array1a, $wikiterms;
				push @array1b, $result->related();
				for my $array1relation(@array1b){
					my $w1 = WWW::Wikipedia->new();
					my $res1 = $w1->search($array1relation);
					if($res1->text()){
						my $wikiz1 = $res1->text;
						my $extr1 = Text::TermExtract->new();
						for my $relationterms1($extr1->terms_extract($wikiz1,{max=>20})){
							push @array1a, $relationterms1;
						}
					}
				}
			}
			elsif($i eq 2){
				push @array2a, $wikiterms;
				push @array2b, $result->related();
				for my $array2relation(@array2b){
					my $w2 = WWW::Wikipedia->new();
					my $res2 = $w2->search($array2relation);
					if($res2->text()){
						my $wikiz2 = $res2->text;
						my $extr2 = Text::TermExtract->new();
						for my $relationterms2($extr2->terms_extract($wikiz2,{max=>20})){
							push @array2a, $relationterms2;
						}
					}
				}
			}
			elsif($i eq 3){
				push @array3a, $wikiterms;
				push @array3b, $result->related();
				for my $array3relation(@array3b){
					my $w3 = WWW::Wikipedia->new();
					my $res3 = $w3->search($array3relation);
					if($res3->text()){
						my $wikiz3 = $res3->text;
						my $extr3 = Text::TermExtract->new();
						for my $relationterms3($extr3->terms_extract($wikiz3,{max=>20})){
							push @array3a, $relationterms3;
						}
					}
				}
			}
			elsif($i eq 4){
				push @array4a, $wikiterms;
				push @array4b, $result->related();
				for my $array4relation(@array4b){
					my $w4 = WWW::Wikipedia->new();
					my $res4 = $w4->search($array4relation);
					if($res4->text()){
						my $wikiz4 = $res4->text;
						my $extr4 = Text::TermExtract->new();
						for my $relationterms4($extr4->terms_extract($wikiz4,{max=>20})){
							push @array4a, $relationterms4;
						}
					}
				}
			}
			elsif($i eq 5){
				push @array5a, $wikiterms;
				push @array5b, $result->related();
				for my $array5relation(@array5b){
					my $w5 = WWW::Wikipedia->new();
					my $res5 = $w5->search($array5relation);
					if($res5->text()){
						my $wikiz5 = $res5->text;
						my $extr5 = Text::TermExtract->new();
						for my $relationterms5($extr5->terms_extract($wikiz5,{max=>20})){
							push @array5a, $relationterms5;
						}
					}
				}
			}
			elsif($i eq 6){
				push @array6a, $wikiterms;
				push @array6b, $result->related();
				for my $array6relation(@array6b){
					my $w6 = WWW::Wikipedia->new();
					my $res6 = $w6->search($array6relation);
					if($res6->text()){
						my $wikiz6 = $res6->text;
						my $extr6 = Text::TermExtract->new();
						for my $relationterms6($extr6->terms_extract($wikiz6,{max=>20})){
							push @array6a, $relationterms6;
						}
					}
				}
			}
			elsif($i eq 7){
				push @array7a, $wikiterms;
				push @array7b, $result->related();
				for my $array7relation(@array7b){
					my $w7 = WWW::Wikipedia->new();
					my $res7 = $w7->search($array7relation);
					if($res7->text()){
						my $wikiz7 = $res7->text;
						my $extr7 = Text::TermExtract->new();
						for my $relationterms7($extr7->terms_extract($wikiz7,{max=>20})){
							push @array7a, $relationterms7;
						}
					}
				}
			}
			elsif($i eq 8){
				push @array8a, $wikiterms;
				push @array8b, $result->related();
				for my $array8relation(@array8b){
					my $w8 = WWW::Wikipedia->new();
					my $res8 = $w8->search($array8relation);
					if($res8->text()){
						my $wikiz8 = $res8->text;
						my $extr8 = Text::TermExtract->new();
						for my $relationterms8($extr8->terms_extract($wikiz8,{max=>20})){
							push @array8a, $relationterms8;
						}
					}
				}
			}
			elsif($i eq 9){
				push @array9a, $wikiterms;
				push @array9b, $result->related();
				for my $array9relation(@array9b){
					my $w9 = WWW::Wikipedia->new();
					my $res9 = $w9->search($array9relation);
					if($res9->text()){
						my $wikiz9 = $res9->text;
						my $extr9 = Text::TermExtract->new();
						for my $relationterms9($extr9->terms_extract($wikiz9,{max=>20})){
							push @array9a, $relationterms9;
						}
					}
				}
			}
			elsif($i eq 10){
				push @array10a, $wikiterms;
				push @array10b, $result->related();
				for my $array10relation(@array10b){
					my $w10 = WWW::Wikipedia->new();
					my $res10 = $w10->search($array10relation);
					if($res10->text()){
						my $wikiz10 = $res10->text;
						my $extr10 = Text::TermExtract->new();
						for my $relationterms10($extr10->terms_extract($wikiz10,{max=>20})){
							push @array10a, $relationterms10;
						}
					}
				}
			}
			elsif($i eq 11){
				push @array11a, $wikiterms;
				push @array11b, $result->related();
				for my $array11relation(@array11b){
					my $w11 = WWW::Wikipedia->new();
					my $res11 = $w11->search($array11relation);
					if($res11->text()){
						my $wikiz11 = $res11->text;
						my $extr11 = Text::TermExtract->new();
						for my $relationterms11($extr11->terms_extract($wikiz11,{max=>20})){
							push @array11a, $relationterms11;
						}
					}
				}
			}
			elsif($i eq 12){
				push @array12a, $wikiterms;
				push @array12b, $result->related();
				for my $array12relation(@array12b){
					my $w12 = WWW::Wikipedia->new();
					my $res12 = $w12->search($array12relation);
					if($res12->text()){
						my $wikiz12 = $res12->text;
						my $extr12 = Text::TermExtract->new();
						for my $relationterms12($extr12->terms_extract($wikiz12,{max=>20})){
							push @array12a, $relationterms12;
						}
					}
				}
			}
			elsif($i eq 13){
				push @array13a, $wikiterms;
				push @array13b, $result->related();
				for my $array13relation(@array13b){
					my $w13 = WWW::Wikipedia->new();
					my $res13 = $w13->search($array13relation);
					if($res13->text()){
						my $wikiz13 = $res13->text;
						my $extr13 = Text::TermExtract->new();
						for my $relationterms13($extr13->terms_extract($wikiz13,{max=>20})){
							push @array13a, $relationterms13;
						}
					}
				}
			}
			elsif($i eq 14){
				push @array14a, $wikiterms;
				push @array14b, $result->related();
				for my $array14relation(@array14b){
					my $w14 = WWW::Wikipedia->new();
					my $res14 = $w14->search($array14relation);
					if($res14->text()){
						my $wikiz14 = $res14->text;
						my $extr14 = Text::TermExtract->new();
						for my $relationterms14($extr14->terms_extract($wikiz14,{max=>20})){
							push @array14a, $relationterms14;
						}
					}
				}
			}
			elsif($i eq 15){
				push @array15a, $wikiterms;
				push @array15b, $result->related();
				for my $array15relation(@array15b){
					my $w15 = WWW::Wikipedia->new();
					my $res15 = $w15->search($array15relation);
					if($res15->text()){
						my $wikiz15 = $res15->text;
						my $extr15 = Text::TermExtract->new();
						for my $relationterms15($extr15->terms_extract($wikiz15,{max=>20})){
							push @array15a, $relationterms15;
						}
					}
				}
			}
			elsif($i eq 16){
				push @array16a, $wikiterms;
				push @array16b, $result->related();
				for my $array16relation(@array16b){
					my $w16 = WWW::Wikipedia->new();
					my $res16 = $w16->search($array16relation);
					if($res16->text()){
						my $wikiz16 = $res16->text;
						my $extr16 = Text::TermExtract->new();
						for my $relationterms16($extr16->terms_extract($wikiz16,{max=>20})){
							push @array16a, $relationterms16;
						}
					}
				}
			}
			elsif($i eq 17){
				push @array17a, $wikiterms;
				push @array17b, $result->related();
				for my $array17relation(@array0b){
					my $w17 = WWW::Wikipedia->new();
					my $res17 = $w17->search($array17relation);
					if($res17->text()){
						my $wikiz17 = $res17->text;
						my $extr17 = Text::TermExtract->new();
						for my $relationterms17($extr17->terms_extract($wikiz17,{max=>20})){
							push @array17a, $relationterms17;
						}
					}
				}
			}
			elsif($i eq 18){
				push @array18a, $wikiterms;
				push @array18b, $result->related();
				for my $array18relation(@array18b){
					my $w18 = WWW::Wikipedia->new();
					my $res18 = $w18->search($array18relation);
					if($res18->text()){
						my $wikiz18 = $res18->text;
						my $extr18 = Text::TermExtract->new();
						for my $relationterms18($extr18->terms_extract($wikiz18,{max=>20})){
							push @array18a, $relationterms18;
						}
					}
				}
			}
			elsif($i eq 19){
				push @array19a, $wikiterms;
				push @array19b, $result->related();
				for my $array19relation(@array19b){
					my $w19 = WWW::Wikipedia->new();
					my $res19 = $w19->search($array19relation);
					if($res19->text()){
						my $wikiz19 = $res19->text;
						my $extr19 = Text::TermExtract->new();
						for my $relationterms19($extr19->terms_extract($wikiz19,{max=>20})){
							push @array19a, $relationterms19;
						}
					}
				}
			}
		}
	}
}
