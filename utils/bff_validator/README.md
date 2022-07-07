# NAME

bff-validator: A script that validates metadata (XLSX|JSON) against Beacon v2 Models and serializes them to BFF (JSON)

# SYNOPSIS

bff-validator -i &lt;file.xlsx|\*json> \[-options\]

     Arguments:                       
       -i|input                       Metadata xlsx file or *.json files

     Options:
       -s|schema-dir                  Directory with JSON schemas (must have JSON pointers de-referenced)
       -o|out-dir                     Output (existing) directory for the BFF files (only to be used if input => XLSX)
       -gv                            Set this option if you want to process <genomicVariations> entity
       -ignore-validation             Writes JSON collection regardless of results from validation against JSON schemas (AYOR!)
       -h|help                        Brief help message
       -man                           Full documentation
       -debug                         Print debugging (from 1 to 5, being 5 max)
       -verbose                       Verbosity on
       -nc|-no-color                  Don't print colors to STDOUT
     
     Experimental:
       -gv-vcf                        Set this option to read <genomicVariations.json> from <beacon vcf> (with one document x line)

# CITATION

The author requests that any published work which utilizes Beacon includes a cite to the the following reference:

Rueda, M, Ariosa R. "Beacon v2 Reference Implementation: a toolkit to enable federated discovery of genomic and phenotypic data". _Submitted_.

# SUMMARY

bff-validator: A script that validates metadata (XLSX|JSON) against Beacon v2 Models and serializes it to BFF (JSON)

# HOW TO RUN BFF-VALIDATOR

The script runs on command-line Linux (tested on Debian-based distribution). Perl 5 is installed by default on Linux, 
but we will need to install a few CPAN modules.

First we install cpanminus (with sudo privileges):

    $ sudo apt-get install cpanminus

Second we use cpanm to install the CPAN modules:

    $ cpanm --sudo --installdeps .

If you prefer to have the dependencies in a "virtual environment" (i.e., install the CPAN modules in the directory of the application) we recommend using the module Carton.

    $ cpanm --sudo Carton

Then, we can install our dependencies:

    $ carton install

Also, we're using _xlsx2csv_, which is a python script. 

    $ sudo pip install xlsx2csv

For executing `bff-validator` you will need:

- Input file:

    You have two options:

    **A)** A XLSX file consisting of multiple sheets. A template version of this file is provided with this installation.

    Currently, the file consists of 7 sheets that match the Beacon v2 Models.

    Please use the flag `--gv` should you want to validate the data in the sheet &lt;genomicVariations>.

    _NB:_ If you have multiple CSV files instead of a XLSX file you can use the included utility [csv2xlsx](https://github.com/EGA-archive/beacon2-ri-tools/blob/main/utils/models2xlsx/csv2xlsx) that will join all CSVs into 1 XLSX.

        $ ./csv2xlsx *csv -o out.xlsx

    **B)** A set of JSON files that follow the Beacon Friendly Format. The files MUST be uncompressed and named &lt;analyses.json>, &lt;biosamples.json>, etc.

- Beacon v2 Models (with JSON pointers dereferenced)

    You should have them at `deref_schemas` directory.

**Examples:**

     $ ./bff-validator -i file.xlsx

     $ $path/bff-validator -i file.xlsx -o my_bff_outdir

     $ $path/bff-validator -i my_bff_indir/*json -s deref_schemas -o my_bff_outdir 

     $ $path/bff-validator -i file.xlsx --gv --schema-dir deref_schemas --out-dir my_bff_outdir
    
     $ carton exec -- ./bff-validator -i file.xlsx # If using Carton

## TIPS ON FILLING OUT THE EXCEL TEMPLATE

    * Please, before filling in any field, check out the provided template for ../../CINECA_synthetic_cohort_EUROPE_UK1/*xlsx
    * You can use Unicode, however, the script will 'unidecode' arrays/objects (e.g., quotes from spanish keyboard) 
    * Header fields: 
       - Dots ('.') represent objects: 
           Examples (values):
             1 - foo
             2 - NCIT:C20197
             3 - true # booleans
             4 - ["foo","bar","baz"] # arrays are also allowed
       - Underscores ('_') represent arrays: 
           * Up to 1D (e.g., individuals->measures_assyCode.id) the values are comma separated
              Examples (values):
               1 - measures_assayCode.id
                   LOINC:35925-4,LOINC:3141-9,LOINC:8308-9
                  measures_assayCode.label
                   BMI,Weight,Height-standing
                   
           * Others - Values for array fields start with '[' and end with ']'
              Examples (values): 
               1 - ["foo":{"bar": "baz"}}]
               2 - ["foo","bar","baz"]

## COMMON ERRORS AND SOLUTIONS

    * Error message: Wide character at foo.bar
      Solution: You have Unicode (non-ASCII) characters (likely double quotes) in a place where they should not be.

    * Error message: , or } expected while parsing object/hash, at character offset 574 (before "]")
      Solution: Make sure you have the right amount of opening or closing keys/brackets.

_NB:_ You can use the flag `--ignore-validation` and check the temporary files at `-o` directory.

# AUTHOR 

Written by Manuel Rueda, PhD. Info about CRG can be found at [https://www.crg.eu](https://www.crg.eu).

# REPORTING BUGS

Report bugs or comments to <manuel.rueda@crg.eu>.

# COPYRIGHT

This PERL file is copyrighted. See the LICENSE file included in this distribution.
