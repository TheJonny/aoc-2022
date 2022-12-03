use v5.36;

my $things = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
my $res = 0;
foreach my $line ( <STDIN> ) {
	chomp($line);
	my $n = length($line);
	my $a = substr($line, 0, $n/2);
	my $b = substr($line, $n/2);
	
	my $value = 1;
	foreach my $t (split('', $things)) {
		if (index($b, $t) != -1 and index($a, $t) != -1) {
			$res += $value;
		}
		$value += 1;
	}

	
}
print "$res\n";
