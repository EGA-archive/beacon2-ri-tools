#!/usr/bin/env perl
# Author: mrueda
# cut -f74- ../uk1.tsv |sed 1d |tr '\t' '\n' | grep [a-z] |sort -u > diseases.lst
# perl diseases.pl <(cut -f74- ../uk1.tsv) > for_excel.tsv
use strict;
use warnings;
use Data::Dumper;
use feature qw(say);

# We downloaded the file icd_codes.csv from
# wget https://raw.githubusercontent.com/k4m1113/ICD-10-CSV/master/codes.csv
# But at the end we went to this url:
# https://icd.who.int/browse10/2019/en#/I42
# and searched manually the ids :-(
# perl print_hash.pl diseases.lst
my %disease = (
    bronchitis           => 'J40',
    agranulocytosis      => 'D70',
    Alzheimer            => 'G309',
    asthma               => 'J45',
    bipolar              => 'F3181',
    cardiomyopathy       => 'I42',
    caries               => 'K02',
    eating               => 'F50',
    cirrhosis            => 'K74',
    'gastro-oesophageal' => 'K21',
    haemorrhoids         => 'K64',
    'Huntington'         => 'G10',
    influenza            => 'J11',
    'insulin-dependent'  => 'E10',
    anaemia              => 'D50',
    'multiple sclerosis' => 'G35',
    obesity              => 'E66',
    sarcoidosis          => 'D86',
    schizophrenia        => 'F20',
    thyroiditis          => 'E06',
    varicose             => 'I83'
);

<>;
say "diseases_diseaseCode.id\tdiseases_diseaseCode.label";
while (<>) {
    chomp;
    my @in_cols  = split "\t", $_;
    #my @out_cols = ();
    #my @json = ();
    my @id = ();
    my @label = ();
    for my $col (@in_cols) {
        my @match = grep { $col =~ m/$_/ } keys %disease if $col;;
        #push @out_cols, (@match ? qq({diseaseCode": {"label": "$col", "id": "ICD10:$disease{ $match[0] }}}) : '');
        next unless @match;
        #push @json, (@match ? qq({diseaseCode": {"label": "$col", "id": "ICD10:$disease{ $match[0] }}}) : '');
        push @id, (@match ? "ICD10:$disease{ $match[0] }" : '');
        push @label, (@match ? $col : '');
    }
    #say join "\t", @out_cols;
    #say (@json ? ('[', (join ',', @json), ']') : '');
    print (@id ?  (join ",", @id) : '');
    print "\t";
    say (@label ?  (join ",", @label) : '');
}
