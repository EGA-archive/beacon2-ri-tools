#!/usr/bin/env perl
# Author: mrueda
# OPCS4-0.0
# cut -f72 ../uk1.tsv | perl interventions.pl > for_excel.tsv
use strict;
use warnings;
use Data::Dumper;
use feature qw(say);
my @interventions =
  qw(interventionsOrProcedures_procedureCode.id	interventionsOrProcedures_procedureCode.label);
<>;
say join "\t", @interventions;
while (<>) {
    chomp;
    my ($id, @fields)  = split /\s+/, $_;
    say join "\t", "OPCS4:$id", "OPCS(v4-0.0):@fields";
}
