#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

open INFILE, 'input.txt';
my %count;
my $total_by_any;
my $total_by_all;
my $group_size = 0;

while (my $line = <INFILE>) {
    chomp($line);
    for my $c (split //, $line) {
        if (exists($count{$c})) {
            $count{$c} = $count{$c} + 1;
        }
        else {
            $count{$c} = 1;
        }
    }
    $group_size++;
    if ($line =~ m/^$/ || eof INFILE) {
        if ($line =~ m/^$/) {
            $group_size--;
        }
        foreach my $v (values %count) {
            $total_by_any++ if ($v > 0);
            $total_by_all++ if ($v == $group_size);
        }
        $group_size = 0;
        %count = ();
        next;
    }
}
close INFILE;

print "Part 1:  " . $total_by_any . "\n";
print "Part 2:  " . $total_by_all . "\n";