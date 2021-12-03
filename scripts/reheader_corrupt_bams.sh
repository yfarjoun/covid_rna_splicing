#!/bin/bash

set -xeuo pipefail

input=$1

# sed -n '1,1{s/^.*@HD/@HD/p}; 2,2{s/^/@RG\t/p}; 3,/@CO/{p}'  <(zless ${input}) > header.sam
sed -n '1,1 s/^.*@HD/@HD/p; 2,2 s/^/@RG\t/p; 3,/@CO/ p'  <(zless ${input}) > header.sam

cat << "EOF" >> header.sam
@CO	manual fixing of header using:  "sed -n '1,1 s/^.*@HD/@HD/p; 2,2 s/^/@RG\t/p; 3,/@CO/ p' "
EOF

samtools reheader header.sam $input > temp.bam

nlines=$(samtools view temp.bam | wc -l)

if [[ $nlines -eq 0 ]]; then
	echo "resulting bam file is still corrupt"
else
	echo "resulting bam file has $nlines lines"
fi
mv temp.bam $input
	