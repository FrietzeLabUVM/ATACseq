#!/bin/bash

if [ $# -ne 3 ]
then
    echo ""
    echo "Usage: $0 <hg38|g19|mm10> <.narrowPeak> <suffix>"
    echo ""
    exit -1
fi

SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT")

CONDA_BASE=$(conda info --base)
echo $CONDA_BASE
source $CONDA_BASE/etc/profile.d/conda.sh
export -f conda
export -f __conda_activate
export -f __conda_reactivate
export -f __conda_hashr
export -f __add_sys_prefix_to_path

# Activate environment
export PATH=${BASEDIR}/../bin/bin:${PATH}
conda deactivate
conda activate ${BASEDIR}/../bin/envs/atac2

# CMD parameters
ATYPE=${1}
PEAKS=${2}
SUFFIX=${3}

PREFIX=${PEAKS/$SUFFIX/""}

BDG=${PREFIX}.tmp.narrowPeak
BDG_SORT=${PREFIX}.tmp.sorted.narrowPeak
BW=${PREFIX}.bb


#pipe into some old code
#convert narrowPeak files to bigbed
f=${PEAKS}
f_bed=${BDG_SORT}
f_bigbed=${BW}

chrSizes=${BASEDIR}/../bin/envs/atac/share/igvtools-2.3.93-0/genomes/${ATYPE}.chrom.sizes
if [ ! -f $chrSizes ]; then echo $chrSizes file not found for chrSizes! stop.; exit 1; fi


#if [ -f $f_bed ]; then echo bed file $f_bed exists, delete before running.; exit 1; fi
#if [ -f $f_bigbed ]; then echo bigbed file $f_bigbed exists, delete before running; exit 1; fi
#echo NARROWPEAK is $f
#echo BED is $f_bed
#echo BIGBED is $f_bigbed
sort -k1,1 -k2,2n $f | awk 'BEGIN {FS="\t"; OFS="\t"} {if ($5 > 1000) $5 = 1000; print $1,$2,$3,$4,$5}' > $f_bed
bedToBigBed $f_bed $chrSizes $f_bigbed
rm $f_bed

echo wrote bigbed to $f_bigbed
