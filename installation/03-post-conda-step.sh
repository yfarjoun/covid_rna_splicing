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

set -euo pipefail

conda info 
conda list

## all the commands below can be removed or changed to include the software/files you need but cannot install via 
## conda.

git clone https://github.com/lindenb/jvarkit.git
pushd jvarkit

git reset --hard 9510914989e462163fa190cbd7b086a1d44feab9
JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8 ./gradlew msa2vcf

popd


mkdir reference
pushd reference

curl --output NC_045512.2.fasta.zip 'https://api.ncbi.nlm.nih.gov/datasets/v1/virus/taxon/2697049/genome/download?refseq_only=true&host=9606&complete_only=true&exclude_sequence=false&filename=NC_045512.2.fasta'
unzip NC_045512.2.fasta.zip
mv ncbi_dataset/data/genomic.fna NC_045512.2_covid19.fa
rm -r NC_045512.2.fasta.zip
rm -rf ncbi_dataset

bwa index NC_045512.2_covid19.fa 

popd


mkdir picard
pushd picard

curl -L --output picard.jar https://github.com/broadinstitute/picard/releases/download/2.26.5/picard.jar

popd
