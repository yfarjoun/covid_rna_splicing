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

## all the commands below can be removed or changed to include the software/files you need but cannot install via 
## conda.

Rscript  -<<EOF 

install.packages("remotes", repos = "https://cloud.r-project.org")

remotes::install_github("rstudio/renv") 
if(! installed.packages("renv")){ quit(1) }

remotes::install_github("stan-dev/rstantools")
if(! installed.packages("rstantools")){ quit(1) }

# adds quantify PSI function
remotes::install_github("davidaknowles/leafcutter", ref = "psi_2019") 
if(! installed.packages("leafcutter")){ quit(1) }

EOF

git clone https://github.com/RajLabMSSM/leafcutter-pipeline.git

cp example.yaml leafcutter-pipeline/examples/

mkdir reference
pushd reference

curl -L https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/gencode.v38.annotation.gtf.gz --output gencode.v38.annotation.gtf.gz
tabix index gencode.v38.annotation.gtf.gz

curl -L https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/GRCh38.p13.genome.fa.gz --output GRCh38.p13.genome.fa.gz
bwa index GRCh38.p13.genome.fa.gzGRCh38.p13.genome.fa.gz

ls
popd 