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

Rscript  -<<EOF 
install.packages("remotes")
remotes::install_github("stan-dev/rstantools")
# adds quantify PSI function
remotes::install_github("davidaknowles/leafcutter/leafcutter", ref = "psi_2019")
EOF