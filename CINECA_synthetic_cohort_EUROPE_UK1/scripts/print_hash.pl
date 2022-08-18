#!/usr/bin/env perl
# Author: mrueda
use strict;
use warnings;
use feature qw(say);
while (<>) {
    chomp;
    my @fields = split /\s+/, $_;
    $fields[-1] = '' if $fields[-1] eq 'NA';
    print "'@fields[0..$#fields-1]' => '$fields[-1]'";
    say ',' unless eof;
}
