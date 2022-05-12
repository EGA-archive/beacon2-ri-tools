#!/usr/bin/env perl
# Author: mrueda
# https://www.ebi.ac.uk/ols/search?q=Scotland&ontology=gaz
# perl measures.pl <(cut -f8,9,23 ../uk1.tsv) | cut -f1-4 > for_excel.tsv
use strict;
use warnings;
use Data::Dumper;
use feature qw(say);

my @measures =
  qw(measures_assayCode.id	measures_assayCode.label	measures_date	measures_measurementValue	measures_notes	measures_observationMoment.age.iso8601duration	measures_observationMoment.ageGroup.id	measures_observationMoment.ageGroup.label	measures_observationMoment.ageRange.end	measures_observationMoment.ageRange.start	measures_procedure.ageAtProcedure.age	measures_procedure.ageAtProcedure.ageGroup	measures_procedure.ageAtProcedure.ageRange	measures_procedure.bodySite.id	measures_procedure.bodySite.label	measures_procedure.dateOfProcedure	measures_procedure.procedureCode.id	measures_procedure.procedureCode.label);

# https://ncit.nci.nih.gov/ncitbrowser/pages/concept_details.jsf
my $measures = {
    'BMI'             => {LOINC => 'LOINC:35925-4', unit => {id => 'C49671', label => 'Kilogram per Square Meter'}}, 
    'Weight'          => {LOINC => 'LOINC:3141-9',  unit => {id => 'C28252', label => 'Kilogram'}},
    'Height-standing' => {LOINC => 'LOINC:8308-9',  unit => {id => 'C49668', label => 'Centimeter'}}
};

#print Dumper $measures;
<>;
say join "\t", @measures;
while (<>) {
    chomp;
    my ($val1, $val2, $val3)  = split /\t/, $_;
    $val1 = qq({"quantity": {"value": $val1, "unit": {"id": "NCIT:$measures->{BMI}{unit}{id}", "label": "$measures->{BMI}{unit}{label}"}}});
    $val2 = qq({"quantity": {"value": $val2, "unit": {"id": "NCIT:$measures->{Weight}{unit}{id}", "label": "$measures->{Weight}{unit}{label}"}}});
    $val3 = qq({"quantity": {"value": $val3, "unit": {"id": "NCIT:$measures->{'Height-standing'}{unit}{id}", "label": "$measures->{'Height-standing'}{unit}{label}"}}});
    my @id    = ();
    my @label = ();
    for my $val (qw( BMI Weight Height-standing)) {
        push @id,    "$measures->{$val}{LOINC}";
        push @label, $val;
    }
    print join ',', @id;
    print "\t";
    print join ',', @label;
    print "\t";
    print join ',', ( ("2021-09-24") x 3 );
    print "\t";
    print '[', join ',', $val1, $val2, $val3;
    say ']';
}
