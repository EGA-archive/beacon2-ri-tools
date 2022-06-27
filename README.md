# NAME

Beacon: A script to transform **genomic variant data** (VCF) and **metadata** (including phenotypic data) to queryable data (MongoDB)

# SYNOPSIS

beacon &lt;mode> \[-arguments\] \[-options\]

    Mode:
       info
          -h|help                        Brief help message
          -man                           Full documentation
          -v                             Version

        vcf 
          -i|input                       Requires a VCF.gz file
                                         (May require a parameters file)

        mongodb
                                         (May require a parameters file)

        full (vcf + mongodb)
          -i|input                       Requires a VCF.gz file
                                         (May require a parameters file)

        Options:
          -c                             Requires a configuration file
          -p                             Requires a parameters file
          -n                             Number of cpus/cores/threads
          -debug                         Print debugging (from 1 to 5, being 5 max)
          -verbose                       Verbosity on

          (For convenience, specifiers may have a leading - or --)

# DESCRIPTION

Beacon is a script to transform **genomic variant data** (VCF) and **metadata** (including phenotypic data) to queryable data (MongoDB).

This script is part of the ELIXIR-CRG Beacon v2 Reference Implementation (B2RI).  

               * Beacon v2 Reference Implementation *

                   ___________
                   |          |
             XLSX  | Metadata | (incl. Phenotypic data)
                   |__________|
                        |     
                        |
                        | Validation
                        |                          
    _________       ____v____        __________         ______
    |       |       |       |       |          |        |     | <---- Request
    |  VCF  | ----> |  BFF  | ----> | Database | <----> | API | 
    |_______|       |_ _____|       |__________|        |_____| ----> Response
                        |             MongoDB             
                        |                           
               Optional |
                        |
                  ______v_______
                  |            |
                  | BFF        |
                  | Genomic    | Visualization
                  | Variations |
                  | Browser    |
                  |____________|
    

The script transforms metadata+VCF files into Beacon Friendly Format (BFF).
The BFF is a set of 7 text files (documents/records stored as JSON arrays) that will be loaded as _collections_ in a MongoDB database. 

**Optional:** The user has the option of turning on the **BFF Genomic Variatons Browser**. With this option enabled, an HTML file will be created to be used with a web browser.
The purpose of such HTML file is to provide a preliminary exploration of the genomic variations data. See the full documentation [here](https://b2ri-documentation.readthedocs.io/en/latest/bff_gv_browser/).

# INSTALLATION

We provide two installation options, one [containerized](https://hub.docker.com/r/mmoldes/beacon_reference_implementation) and the one you're about to see (non-containerized).

Download the latest version from [Github](https://github.com/mrueda/beacon2-tools):

    $ tar -xvf beacon_2.0.0.tar.gz    # Note that naming may be different

Alternatively, you can use git clone to get the latest (stable) version

    $ git clone https://github.com/mrueda/beacon2-tools.git

Beacon is a Perl script (no compilation needed) that runs on Linux command-line. Internally, it submits multiple pipelines via customizable Bash scripts (see example [here](https://github.com/mrueda/beacon2-tools/blob/main/BEACON/bin/run_vcf2bff.sh)). Note that Perl and Bash are installed by default in Linux.

Perl 5 is installed by default on Linux, but we will need to install a few CPAN modules.

_NB_: Yet stable, the software will be considered **unreleased** until the accompanying paper is **ACCEPTED**.

For simplicity, we're going to install the modules (they're harmless) with sudo privileges.

(For Debian and its derivatives, Ubuntu, Mint, etc.)

First we install `cpmanminus` utility:

    $ sudo apt-get install cpanminus

Second we use `cpanm` to install the CPAN modules:

    $ cpanm --sudo --installdeps .

Also, to read the documentation you'll need `perldoc` that may or may not be installed in your Linux distribution:

    $ sudo apt-get install perl-doc

If you prefer to have the dependencies in a "virtual environment" (i.e., install the CPAN modules in the directory of the application) we recommend using the module `Carton`.

    $ cpanm --sudo Carton

Then, we can install our dependencies:

    $ carton install

Beacon also needs that **bcftools**, **SnpEff** and **MongoDB** are installed. See [external software](https://b2ri-documentation.readthedocs.io/en/latest/d-and-i/#method-1-non-containerized-version/) for more info.

## SYSTEM REQUIREMENTS

    * Ideally a Debian-based distribution (Ubuntu or Mint), but any other (e.g., CentOs, OpenSuse) should do as well (untested).
    * Perl 5 (>= 5.10 core; installed by default in most Linux distributions). Check the version with "perl -v"
    * 4GB of RAM (ideally 16GB).
    * >= 1 cores (ideally i7 or Xeon).
    * At least 200GB HDD.
    * bcftools, SnpEff and MongoDB

The Perl itself does not need a lot of RAM (max load will reach 400MB) but external tools do (e.g., process `mongod` \[MongoDB's daemon\]).

## SETTING UP BEACON

Before running anything you need to set-up the **configuration file**:

The configuration file is a [YAML](https://es.wikipedia.org/wiki/YAML) text file with locations for executables and files needed for the job (e.g., SnpEff jar files, dbSNSFP database).

You have two options here:

    * RECOMMENDED: You set the config file ONCE. This file will serve for all your jobs.
      To set it up go to the installation directory and modify the file 'config.yaml' with your paths.

    * You provide the config file with the argument -c when you run a
      job. This is useful if you want to override the "main" file (see above).

Below are parameters that can be modified by the user along with their default values.
Please remember to leave a blank space between the parameter and the value.

**Configuration file** (YAML)

    ---
    # Reference assemblies (genomes)
    hs37fasta: /path
    hg19fasta: /path
    hg38fasta: /path

    # ClinVar
    hg19clinvar: /path
    hg38clinvar: /path

    # Cosmic 
    hg19cosmic: /path
    hg38cosmic: /path

    # dbSNSFP Academic
    hg19dbnsfp: /path
    hg38dbnsfp: /path

    # Miscellanea software
    snpeff: /path
    snpsift: /path
    bcftools: /path

    # Max RAM memory for snpeff (optional)
    mem: 8G

    # MongoDB 
    mongoimport: /path
    mongostat: /path
    mongosh: /path
    mongodburi: string

    # Temporary directory (optional)
    tmpdir: /path

Please find below a detailed description of all parameters (alphabetical order):

- **bcftools**

    Location of the bcftools exe (e.g., /home/foo/bcftools\_1.11/bcftools).

- **dbnsfpset**

    The set of fields to be taken from dbNSFP database.

    Values: &lt;all> or &lt;ega>

- **genome**

    Your reference genome.

    Accepted values: hg19, hg38 and hs37.

    If you used GATKs GRCh37/b37 set it to hg19.

    Not supported  : NCBI36/hg18, NCBI35/hg17, NCBI34/hg16, hg15 and older.

- **hg19{clinvar,cosmic,dbnsfp,fasta}**

    Path for each of these files. COSMIC annotations are added but not used (v2.0.0).

- **hg38{clinvar,cosmic,dbnsfp,fasta}**

    Path for each of these files. COSMIC annotations are added but not used (v2.0.0).

- **hs37**

    Path for ithe reference genome hs37.

- **mem**

    RAM memory for the Java processes (e.g., 8G).

- **mongoXYZ**

    Parameters needed for MongoDB.

- **paneldir**

    A directory where you can store text files (consisting of a column with a lists of genes) to be displayed by the BFF Genomic Variations Browser.

- **snpeff**

    Location of the java archive  dir (e.g., /home/foo/snpEff/snpEff.jar).

- **snpsift**

    Location of the java archive  dir (e.g., /home/foo/snpEff/snpSift.jar).

- **tmpdir**

    Use if you a have a preferred tmpdir.

# HOW TO RUN BEACON

We recommend following this [tutorial](https://b2ri-documentation.readthedocs.io/en/latest/tutorial-basic/).

This script has four **modes**: `info, vcf, mongodb` and `full`

**\* Mode `info`**

It displays information about the script.

**\* Mode `vcf`**

Converting a VCF file into a BFF file for genomic variations.

**\* Mode `mongodb`**

Loading BFF data into MongoDB.

**\* Mode `full`**

Ingesting VCF and loading metadata and genomic variants (all in one step) into MongoDB.

To perform all these taks you'll need: 

- A gzipped VCF 

    Note that it does not need to be bgzipped.

- (Optional) A parameters file

    A parameters text file that will contain specific values needed for the job.

- BFF files (only for modes: mongodb and full)

    (see explanation of BFF format [here](#what-is-the-beacon-friendly-format-bff))

- (Optional) Specify the number of cores (only for VCF processing!)

    The number of threads/cores you want to use for the job. In this regard (since SnpEff does not deal well with parallelization) we recommend using `-n 1` and running multiple simultaneous jobs with GNU `parallel` or the included [queue system](https://github.com/mrueda/beacon2-tools/tree/main/utils/bff_queue)). The software scales linearly {O}(n) with the number of variants present in the input file. The easiest way is to run one job per chromosome, but if you are in a hurry and have many cores you can split each chromosome into smaller vcfs.

Beacon will create an independent project directory `projectdir` and store all needed information needed there. Thus, many concurrent calculations are supported.
Note that `beacon` will treat your data as _read-only_ (i.e., will not modify your original files).

**Annex: Parameters file**  (YAML)

    --
    bff:
      metadatadir: .
      analyses: analyses.json
      biosamples: biosamples.json
      cohorts: cohorts.json
      datasets: datasets.json
      genomicVariations: genomicVariations.json
      genomicVariationsVcf: genomicVariationsVcf.json.gz
      individuals: individuals.json
      runs: runs.json
    datasetid: crg_beacon_test
    genome: hs37
    bff2html: true
    projectdir: my_project

Please find below a detailed description of all parameters (alphabetical order):

- **bff**

    Location for the 6 metadata JSON files.

- **center**

    Experimental feature. Not used for now.

- **datasetid**

    An unique identifier for the dataset present in the input VCF. Default value is 'id\_1'

- **ega**

    (For EGA internal use only)

    egac: EGA DAC Accession ID.

    egad: EGA Dataset Accession ID.

    egas: EGA Study Accession ID.

- **genome**

    Your reference genome.

    Accepted values: hg19, hg38 and hs37.

    If you used GATKs GRCh37/b37 set it to hg19.

    Not supported  : NCBI36/hg18, NCBI35/hg17, NCBI34/hg16, hg15 and older.

- **organism**

    Experimental feature. Not used for now.

- **bff2html**

    Set bff2html to 'true' to activate BFF Genomic Variations Browser.

- **projectdir**

    The prefix for dir name.

- **technology**

    Experimental feature. Not used for now.

**Examples:**

    $ ./beacon vcf -i input.vcf.gz 

    $ ./beacon mongodb -p param_file  # MongoDB load only

    $ ./beacon full -n 1 --i input.vcf.gz -p param_file  > log 2>&1

    $ ./beacon full -n 1 --i input.vcf.gz -p param_file -c config_file > log 2>&1

    $ nohup $path_to_beacon/beacon full -i input.vcf.gz -verbose

    $ parallel "./beacon vcf -n 1 -i chr{}.vcf.gz  > chr{}.log 2>&1" ::: {1..22} X Y

    $ carton exec -- ./beacon vcf -i input.vcf.gz # If using Carton 

_NB_: Use this command to parse ANSI colors from the log file.

    $ perl -pe 's/\x1b\[[0-9;]*[mG]//g'

## WHAT IS THE BEACON FRIENDLY FORMAT (BFF)

Beacon Friendly Format is a set of 7 JSON files (JSON arrays consisting of multiple documents) that match the 7 schemas from [Beacon v2 Models](https://github.com/ga4gh-beacon/beacon-v2-Models).

Six files correspond to Metadata (`analyses.json,biosamples.json,cohorts.json,datasets.json,individuals.json,runs.json`) and one corresponds to variants (`genomicVariations.json`).

Normally, `beacon` script is used to create `genomicVariations` JSON file. The other 6 files are created with [this utility](https://github.com/mrueda/beacon2-tools/tree/main/utils/bff_validator) (part of the distribution). See intructions [here](https://github.com/mrueda/beacon2-tools/tree/main/utils/bff_validator/README.md).

Once we have all seven files, then we can proceed to load the data into MongoDB.

# TESTING THE CODE

I am not using any CPAN's module to perform unit tests. When I modify the code my "integration tests" are done by comparing to reference files. You can validate the installation using the files included in the [test](https://github.com/mrueda/beacon2-tools/tree/main/test) directory.

# COMMON ERRORS: SYMPTOMS AND TREATMENT

    * Perl: * Compilation errors:
              - Error: Unknown PerlIO layer "gzip" at (eval 10) line XXX
                Solution: cpanm --sudo PerlIO::gzip
                             ... or ...
                      sudo apt-get install libperlio-gzip-perl
            * Execution errors:
              - Error with YAML::XS
                Solution: Make sure the YAML (config.yaml or parameters file) is well formatted (e.g., space after param:' ').

    * Bash: Possible errors that can happen when the bash scripts are executed within Beacon:
            * bcftools errors: bcftools is nit-picky about VCF fields and nomneclature of contigs/chromosomes in reference genome
                   => Failed to execute: beacon_161855926405757/run_vcf2bff.sh
                      Please check this file beacon_161855926405757/run_vcf2bff.log
              - Error: 
                     # Running bcftools
                     [E::faidx_adjust_position] The sequence "22" was not found
                Solution: Make sure you have set the correct genome (e.g., hg19, hg38 or hs37) in parameters_file.
                          In this case bcftools was expecting to find 22 in the <*.fa.gz> file from reference genome, but found 'chr22' instead.
                    Tips:
                         - hg{19,38} use 'chr' in chromosome naming (e.g., chr1)
                         - hs37 does not use 'chr' in chromosome naming (e.g., 1)
          
               - Error
                    # Running bcftools
                    INFO field IDREP only contains 1 field, expecting 2
                 Solution: Please Fix VCF info field manually (or get rid of problematic fields with bcftools)
                           e.g., bcftools annotate -x INFO/IDREP input.vcf.gz | gzip > output.vcf.gz
                                 bcftools annotate -x INFO/MLEAC,INFO/MLEAF,FMT/AD,FMT/PL input.vcf.gz  | gzip > output.vcf.gz
               
                     
      NB: The bash scripts can be executed "manually" in the beacon_XXX dir. You must provide the 
          input vcf as an argument. This is a good option for debugging. 

## KNOWN ISSUES

    * Some Linux distributions do not include perldoc and thus Perl's library Pod::Usage will complain.
      Please, install it (sudo apt-get install perl-doc) if needed.

# CITATION

The author requests that any published work which utilizes Beacon includes a cite to the the following reference:

Rueda, M, Ariosa R. "Beacon v2 Reference Implementation: a toolkit to enable federated sharing of genomic and phenotypic data". _Submitted_. 

# AUTHOR

Written by Manuel Rueda, PhD. Info about CRG can be found at [https://www.crg.eu](https://www.crg.eu)

Credits: 

    * Sabela De La Torre (SDLT) created a Bash script for Beacon v1 to parse vcf files L<https://github.com/ga4gh-beacon/beacon-elixir>.
    * Toshiaki Katayamai re-implemented the Beacon v1 script in Ruby.
    * Later Dietmar Fernandez-Orth (DFO) modified the Ruby for Beacon v2 L<https://github.com/ktym/vcftobeacon and added post-processing with R, from which I borrowed ideas to implement vcf2bff.pl.
    * DFO for usability suggestions and for creating bcftools/snpEff commands.
    * Roberto Ariosa for help with MongoDB implementation.
    * Mauricio Moldes helped with the containerization.

# REPORTING BUGS

For Beacon problems, questions, or suggestions, send an e-mail to manuel.rueda@crg.eu.

# COPYRIGHT and LICENSE

This PERL file is copyrighted, (C) 2021-2022 Manuel Rueda. See the LICENSE file included in this distribution.
