#!/bin/bash

if [ $# -ne 5 ]
then
    echo "**********************************************************************"
    echo "ATAC-Seq analysis pipeline."
    echo "This program comes with ABSOLUTELY NO WARRANTY."
    echo ""
    echo "Version: 0.1.5"
    echo "Contact: Tobias Rausch (rausch@embl.de)"
    echo "Please cite: https://doi.org/10.1093/bioinformatics/bty1007"
    echo "**********************************************************************"
    echo ""
    echo "Usage: $0 <hg19|mm10> <read1.fq.gz> <read2.fq.gz> <genome.fa> <output prefix>"
    echo ""
    exit -1
fi

SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT")

# CMD parameters
ATYPE=${1}
FQ1=${2}
FQ2=${3}
HG=${4}
OUTP=${5}

CONDA_BASE=$(conda info --base)
echo $CONDA_BASE
source $CONDA_BASE/etc/profile.d/conda.sh
export -f conda
export -f __conda_activate
export -f __conda_reactivate
export -f __conda_hashr
export -f __add_sys_prefix_to_path

# Align
#${BASEDIR}/align.sh ${ATYPE} ${FQ1} ${FQ2} ${HG} ${OUTP}
if [ ! -f ${OUTP}.final.bam ]; then
  ${BASEDIR}/align.sh ${ATYPE} ${FQ1} ${FQ2} ${HG} ${OUTP}
  #echo ${OUTP}.final.bam not found from alignment step! exit
  #exit 1
else
  echo ${OUTP}.final.bam found! skipping alignment.
fi
#exit 0
# Generate pseudo-replicates
if [ ! -f ${OUTP}.pseudorep1.bam ] || [ ! -f ${OUTP}.pseudorep2.bam ]; then
  ${BASEDIR}/pseudorep.sh ${OUTP}.final.bam ${OUTP}
else
  echo ${OUTP}.pseudorep1.bam and ${OUTP}.pseudorep2.bam found! skipping generate pseudoreps.
fi

# Call peaks and filter using IDR (replace pseudo-replicates with true biological replicates if available)
if [ ! -f ${OUTP}.peaks ]; then
  ${BASEDIR}/peaks.sh ${OUTP}.pseudorep1.bam ${OUTP}.pseudorep2.bam ${HG} ${OUTP}
else
  echo ${OUTP}.peaks found! skipping peaks/IDR.
fi

# Delete pseudo-replicates
#rm ${OUTP}.pseudorep1.bam ${OUTP}.pseudorep1.bam.bai ${OUTP}.pseudorep2.bam ${OUTP}.pseudorep2.bam.bai

# Footprints
${BASEDIR}/footprints.sh ${ATYPE} ${HG} ${OUTP}.final.bam ${OUTP}

# Aggregate key QC metrics
${BASEDIR}/qc_globber.sh ${OUTP}

# Variant calling
${BASEDIR}/variants.sh ${HG} ${OUTP} ${OUTP}.final.bam

# Annotate peaks
${BASEDIR}/homer.sh ${OUTP}.peaks ${OUTP}.final.bam ${HG} ${OUTP}

# Motif discovery
${BASEDIR}/motif.sh ${ATYPE} ${OUTP}.peaks ${OUTP}

