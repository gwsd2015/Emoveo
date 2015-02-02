
http://www.perlmonks.org/?node_id=503154

open(FILE, "<", "/usr/share/dict/words");
my @lines = <FILE>;
my $word = $ARGV[0];

sub BinSearch
{
    my ($target, $cmp) = @_;
    my @array = @{$_[2]};

    my $posmin = 0;
    my $posmax = $#array;

    return -0.5 if &$cmp (0, \@array, $target) > 0;
    return $#array + 0.5 if &$cmp ($#array, \@array, $target) < 0;

    while (1)
    {
        my $mid = int (($posmin + $posmax) / 2);
        my $result = &$cmp ($mid, \@array, $target);


        if ($result < 0)
        {
            $posmin = $posmax, next if $mid == $posmin && $posmax != $posmin;
            if ($mid == $posmin){
                return "Not found, TODO find close match\n";
            }
            $posmin = $mid;
        }
        elsif ($result > 0)
        {
            $posmax = $posmin, next if $mid == $posmax && $posmax != $posmin;
            if ($mid == $posmax){
                return "Not found, TODO find close match\n"; 
            }
            $posmax = $mid;
        }
        else
        
        
