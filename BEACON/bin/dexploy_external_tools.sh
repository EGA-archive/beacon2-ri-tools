#!/usr/bin/env bash

################
## Pull external annotation DB 
################

cd /tmp

aria2c -x 1 -s 1 ftp://xfer13.crg.eu:221/beacon2_data.md5 
for i in {1..5}
do
 aria2c -x 16 -s 16 ftp://xfer13.crg.eu:221/beacon2_data.part$i 
done

##########################
## Verifies correct download of external annotation DB
##########################

md5sum beacon2_data.part? > my_beacon2_data.md5 
DIFF_MD5=$(cmp -s my_beacon2_data.md5 beacon2_data.md5)
if [ "$DIFF_MD5" != "" ] 
then
    echo "MD5 sum issue"
fi

cat beacon2_data.part? > beacon2_data.tar.gz 
rm beacon2_data.part? 
tar -xvf beacon2_data.tar.gz --directory /usr/share/beacon-ri/

#########################
## Soft link  GRCh38 hg38
#########################

cd /usr/share/beacon-ri/databases/snpeff/v5.0 && ln -s GRCh38.99 hg38 

#########################
## Remove auxiliar files
#########################

rm /tmp/beacon2_data.tar.gz 
rm /tmp/beacon2_data.md5

#########################
## Set config file 
#########################

cd /usr/share/beacon-ri/pro/snpEff

sed -i "s|data.dir = ./data/|data.dir = /usr/share/beacon-ri/databases/snpeff/v5.0|g" snpEff.config

cd /usr/share/beacon-ri/beacon2-ri-tools

old_dir=/media/mrueda/8TB/Databases
new_dir=/usr/share/beacon-ri/databases
for name in genomes snpeff 
do
 sed -i "s|$old_dir/$name|$new_dir/$name|g" config.yaml
done

sed -i "s|/pro/NGSutils/snpEff|/usr/share/beacon-ri/pro/snpEff|g" config.yaml 
sed -i "s|/pro/NGSutils/bcftools-1.15.1/bcftools|/usr/share/beacon-ri/pro/NGSutils/bcftools-1.15.1/bcftools|g" config.yaml  
sed -i "s|/media/mrueda/8TB/tmp|/tmp|g" config.yaml 
sed -i "s|/home/mrueda/Soft/mongodb-database-tools-ubuntu2004-x86_64-100.5.1/bin|/usr/share/beacon-ri/pro/mongodb-database-tools-ubuntu2004-x86_64-100.5.1/bin|g" config.yaml 
sed -i "s|/usr/bin/mongosh|/usr/share/beacon-ri/pro/mongosh|g" config.yaml 

#######################
## Test deployment 
########################

./beacon vcf -i test/test_1000G.vcf.gz -p test/param.in 

test_result=$( ls -t . | head -1) 

DIFF_DEPLOYMENT=$(diff <(zgrep -v beacon "$test_result"/vcf/genomicVariationsVcf.json.gz | jq -S .) <(zgrep -v beacon test/beacon_164977232803910/vcf/genomicVariationsVcf.json.gz | jq -S .) )

if [ "$DIFF_DEPLOYMENT" != "" ] 
then
    echo "The beacon is deployed"
fi
