#!/usr/local/bin/perl
use warnings;
use strict;

my @a = (1..9);

for(@a){
	print("$_", "\n");
}

my @b = (1..9);
for my $i (@b){
	print("$i", "\n");
}
my $counter = 10;

while($counter > 0){
	print("$counter\n");
	$counter--;
	sleep(1);

	if($counter == 0){
		print("Happy New Year!\n");
	}
}
