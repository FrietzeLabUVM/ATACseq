#!/bin/bash

if [ $# -ne 4 ]
then
    echo ""
    echo "Usage: $0 <peaks.tsv> <align.bam> <genome.fa> <output prefix>"
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
PEAKS=${1}
ALIGN=${2}
HG=${3}
OUTP=${4}
ATYPE=${5}

# create tag directory (should we use normGC? only unique, keepOne?)
makeTagDirectory ${OUTP}/tagdir -genome ${HG}.fa -checkGC ${ALIGN} 2> ${OUTP}.homer.log

# Annotated and normalized peaks
annotatePeaks.pl ${PEAKS} ${ATYPE} -size given -annStats ${OUTP}.homer.annStats -d ${OUTP}/tagdir > ${OUTP}.annotated.normalized 2>> ${OUTP}.homer.log

# Deactivate environment
conda deactivate
