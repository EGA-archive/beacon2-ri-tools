#!/usr/bin/env perl
# Author: mrueda
# https://bioportal.bioontology.org/ontologies/NCIT/?p=classes&conceptid=http%3A%2F%2Fncicb.nci.nih.gov%2Fxml%2Fowl%2FEVS%2FThesaurus.owl%23C43856
# cut -f7 ../uk1.tsv | perl race.pl > for_excel.tsv
use strict;
use warnings;
use Data::Dumper;
use feature qw(say);

# perl print_hash.pl race.lst
my %race = (
    'African'                    => 'C42331',
    'Any other Asian background' => 'C67109',
    'Any other Black background' => 'C67109',
    'Any other mixed background' => 'C67109',
    'Any other white background' => 'C67109',
    'Asian or Asian British'     => 'C41260',
    'Bangladeshi'                => 'C41260',
    'Black or Black British'     => 'C16352',
    'British'                    => 'C41261',
    'Caribbean'                  => 'C77810',
    'Chinese'                    => 'C41260',
    'Do not know'                => '',
    'Indian'                     => 'C67109',
    'Irish'                      => 'C43856',
    'Mixed'                      => 'C67109',
    'Other ethnic group'         => 'C67109',
    'Pakistani'                  => 'C41260',
    'Prefer not to answer'       => '',
    'White'                      => 'C41261',
    'White and Asian'            => 'C67109',
    'White and Black African'    => 'C67109',
    'White and Black Caribbean'  => 'C67109'
);

#print Dumper \%race;
<>;
say "ethnicity.id\tethnicity.label";
while (<>) {
    chomp;
    say $race{$_} ? "NCIT:$race{$_}\t$_" : "\t";
}
