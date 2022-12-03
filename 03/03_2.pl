use v5.36;

my $things = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
my $res = 0;
while (defined(my $a = <STDIN>) and defined(my $b = <STDIN>) and defined(my $c = <STDIN> )) {
	chomp($a); chomp($b); chomp ($c);
	
	my $value = 1;
	foreach my $t (split('', $things)) {
		if (index($b, $t) != -1 and index($a, $t) != -1 and index($c, $t) != -1) {
			$res += $value;
		}
		$value += 1;
	}

	
}
print "$res\n";

