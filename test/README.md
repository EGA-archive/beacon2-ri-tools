# Test README

This directory contains data to test that the transformation of `VCF` to `BFF` works as it should.

The test file included (`test_1000G.vcf.gz`) comes from the 1000 Genomes Project. It was obtained using the following command:
(no need to download again unless you want to try with a different region)

    $ #tabix -h ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20130502/ALL.chr1.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz 1:10000-200000 | bgzip > test_1000G.vcf.gz

To test your installation please execute the command below:
(It will take < 1 min to finish) 

    $ $path_to_beacon/beacon vcf -i test_1000G.vcf.gz -p param.in  # Note that here we used hs37 as a reference genome

Once done, check that your file `genomicVariationsVcf.json.gz` and the provided one match:

(where XXXX is the id of your job)

    $ diff <(zgrep -v beacon beacon_XXXX/vcf/genomicVariationsVcf.json.gz | jq -S .) <(zgrep -v beacon beacon_164977232803910/vcf/genomicVariationsVcf.json.gz | jq -S .) 

In Ubuntu, you can install the tool `jq` wil the command below:

    $ sudo apt-get install jq

Cheers!

Manu
