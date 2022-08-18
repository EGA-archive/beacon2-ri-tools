#!/usr/bin/env perl
# Author: mrueda
# cut -f58 ../uk1.tsv | perl sex.pl > for_excel.tsv
use strict;
use warnings;
use feature qw(say);
my %sex = (
    male   => 'NCIT:C20197',
    female => 'NCIT:C16576'
);

<>;
say "sex.id\tsex.label";
while (<>) {
    chomp;
    say "$sex{$_}\t$_";
}
