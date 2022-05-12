#!/usr/bin/env perl
# Author: mrueda
# cut -f67 ../uk1.tsv |sed '1d' | sort -u > country.lst
# https://www.ebi.ac.uk/ols/search?q=Scotland&ontology=gaz
# cut -f67 ../uk1.tsv | perl country.pl > for_excel.tsv
use strict;
use warnings;
use Data::Dumper;
use feature qw(say);

# perl print_hash.pl country.lst
my %country = (
    'Do not know'          => '',
    'Elsewhere'            => '',
    'England'              => '00002641',
    'Northern Ireland'     => '00002638',
    'Prefer not to answer' => '',
    'Republic of Ireland'  => '00004018',
    'Scotland'             => '00002639',
    'Wales'                => '00002640'
);

#print Dumper \%country;
<>;
say "geographicOrigin.id\tgeographicOrigin.label";
while (<>) {
    chomp;
    say $country{$_} ? "GAZ:$country{$_}\t$_" : "\t";
}
