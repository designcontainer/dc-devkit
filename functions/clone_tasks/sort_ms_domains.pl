#!/usr/bin/perl -w
use strict;

my @hosts = @ARGV;

print join("\n", sort {
 	$a = lc($a);
	$b = lc($b);
 	if ($a eq $b) {
  		return 0;
 	}
	my @a = split(/\./, $a);
	my @b = split(/\./, $b);
	my $max = (scalar(@a), scalar(@b))[@a < @b];
	for (my $i=0; $i < $max; $i++) {
		if (($i < @a) && ($i < @b)) {
			if (my $c = $a[$i] cmp $b[$i]) {
				return $c;
			}
		}
		else {
			return scalar(@a) <=> scalar(@b);
		}
	}
	return 0;
} @hosts) . "\n";