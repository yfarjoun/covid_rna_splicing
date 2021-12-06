#!/bin/bash 

## run post-conda steps
BASEDIR="$(dirname "$0")"

ENV="analysis"

echo BASEDIR="$BASEDIR"
echo RUNNING post-conda steps

# shellcheck source=/dev/null
set +e \
  && PS1='$$$ ' \
  && . "$(conda info --base)"/etc/profile.d/conda.sh \
  && conda activate "${ENV}"

set -xeuo pipefail

conda info 
conda list

mkdir reference
pushd reference


for file in \
	https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/gencode.v38.annotation.gtf.gz \
	https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dict \
	https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta \
	https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.alt \
	https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.amb \
	https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.ann \
	https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.bwt \
	https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.pac \
	https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.sa \
	https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.fai 
do
	curl  -L "${file}" --output "$(basename file)" 

done

ls
popd 
