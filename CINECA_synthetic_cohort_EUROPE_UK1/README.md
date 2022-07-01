# CINECA_synthetic_cohort_EUROPE_UK README

We have included the [CINECA_synthetic_cohort_EUROPE_UK1](https://www.cineca-project.eu/cineca-synthetic-datasets) dataset to test B2RI functionalities.

The dataset is part of a [study](https://ega-archive.org/studies/EGAS00001002472) consisting of two datasets.

## Dataset description (EGAD00001006673):
The dataset consists of 2504 samples which have genetic data (low coverage WGS) based on [1000 Genomes](https://www.nature.com/articles/nature15393) data (phase3 and Geuvadis), and 76 synthetic subject attributes and phenotypic data derived from UKBiobank. The purpose of this dataset is to aid development of technical implementations for cohort data discovery, harmonization, access, and federated analysis. In support of FAIRness in data sharing, this dataset is made freely available under the Creative Commons Licence (CC-BY). Please ensure this preamble is included with this dataset and that the CINECA project (funding: EC H2020 grant 825775) is acknowledged.

The dataset `EGAD00001006673` was downloaded from the EGA, please see the full description [here](https://ega-archive.org/datasets/EGAD00001006673). Please contact `helpdesk@ega-archive.org` should you want get access to the whole dataset.

A [raw file](./uk1.tsv) with phenoclinic data was gently donated to us from our CINECA-EU partners. 

 
### Notes about column mapping
* `individualId` was taken from the column "Subject Id" (e.g., HG00096) in the [raw data](./uk1.tsv), which in this particular dataset also matches the `biosampleId` in the `VCF`. An alternative way of labelling `individualId` would be by using the column "eid" (e.g., fake1) (not used).

* Note that some terms/variables related to `analyses` and `runs` were not present, nor they could be easily extracted (and matched to samples) from [10000 Genomes phase 3 release](https://www.internationalgenome.org/data-portal/data-collection/phase-3). Thus, some ids (e.g., `runId`, `analysisId`) were created _ad hoc_ for demonstration purposes. 

### Files included:

* `uk1.tsv` - Raw file with the metadata/phenoclinic data for 2504 fake individuals.
* `Beacon-v2-Models_CINECA_UK1.xlsx` - Excel file with the metadata/phenoclinic data (INPUT).
* `bff/*json` - Collections (JSON arrays) created from the Excel file (OUTPUT).
* `scripts/` - Directory with miscellanea (ad hoc) scripts used by the author to transform `uk1.tsv` to multiple `csv` (used to fill out `Beacon-v2-Models_CINECA_UK1.xlsx`) .

### External files (CRG public ftp site):

* `chr22.Test.1000G.phase3.joint.vcf.gz` - VCF file consisting of WGS for chr22 (INPUT).

      $ wget ftp://xfer13.crg.eu:221/external_files/CINECA_synthetic_cohort_EUROPE_UK1/vcf/chr22.Test.1000G.phase3.joint.vcf.gz

* `genomicVariationsVcf.json.gz` - Collection for genomic variations (OUTPUT).

      $ wget ftp://xfer13.crg.eu:221/external_files/CINECA_synthetic_cohort_EUROPE_UK1/bff/genomicVariationsVcf.json.gz
