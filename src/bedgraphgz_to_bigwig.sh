#!/bin/bash

if [ $# -ne 3 ]
then
    echo ""
    echo "Usage: $0 <hg38|g19|mm10> <bedGraph.gz> <suffix>"
    echo ""
    exit -1
fi

SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT")

# Activate environment
export PATH=${BASEDIR}/../bin/bin:${PATH}
conda deactivate
conda activate ${BASEDIR}/../bin/envs/atac2

# CMD parameters
ATYPE=${1}
BDG_GZ=${2}
SUFFIX=${3}

PREFIX=${BDG_GZ/$SUFFIX/""}

BDG=${PREFIX}.tmp.bdg
BDG_SORT=${PREFIX}.tmp.sorted.bdg
BW=${PREFIX}.bw

#remove track line
gunzip -c ${BDG_GZ} | awk 'NR>1' > $BDG

chrSizes=${BASEDIR}/../bin/envs/atac/share/igvtools-2.3.93-0/genomes/${ATYPE}.chrom.sizes
if [ ! -f $chrSizes ]; then echo $chrSizes file not found for chrSizes! stop.; exit 1; fi

sort -k1,1 -k2,2n ${BDG} > ${BDG_SORT}
bedGraphToBigWig ${BDG_SORT} ${chrSizes} ${BW}

rm $BDG $BDG_SORT

echo wrote bigWig to ${BW}
