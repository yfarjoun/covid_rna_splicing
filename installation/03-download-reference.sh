#!/bin/bash 

set -euo pipefail

mkdir reference
pushd reference

curl -L https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/gencode.v38.annotation.gtf.gz --output gencode.v38.annotation.gtf.gz

curl -L https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/GRCh38.p13.genome.fa.gz --output GRCh38.p13.genome.fa.gz
bwa index GRCh38.p13.genome.fa.gz

ls
popd 
