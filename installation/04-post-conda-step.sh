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


git clone https://github.com/RajLabMSSM/leafcutter-pipeline.git

git clone https://github.com/davidaknowles/leafcutter.git


export TAR=/bin/tar

Rscript  -<<EOF 

install.packages("renv", repos = "https://cloud.r-project.org")
if (! "renv" %in% rownames(installed.packages())){ quit(save="no",status=1) }

remotes::install_github("stan-dev/rstantools", quiet=TRUE)
if (! "rstantools" %in% rownames(installed.packages())){ quit(save="no",status=1) }

# adds quantify PSI function
remotes::install_github("davidaknowles/leafcutter/leafcutter", ref = "psi_2019", quiet=TRUE) 
if (! "leafcutter" %in% rownames(installed.packages())){ quit(1) }

EOF

