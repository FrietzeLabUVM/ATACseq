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
    echo "Usage: $0 <hg38|hg19|mm10> <read1.fq.gz> <read2.fq.gz> <genome.fa> <output prefix>"
    echo ""
    exit -1
fi

#SCRIPT=$(readlink -f "$0")
#BASEDIR=$(dirname "$SCRIPT")
BASEDIR=$(pwd)/src
if [ ! -d $BASEDIR ]; then
  echo $BASEDIR not found, run script from ATAC-Seq pipeline location
  exit 1
fi

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

echo STEP1 - align
# Align
if [ ! -f ${OUTP}.final.bam ]; then
  ${BASEDIR}/align.sh ${ATYPE} ${FQ1} ${FQ2} ${HG} ${OUTP}
else
  echo ${OUTP}.final.bam found! skipping alignment.
fi

echo STEP2 - pseudo reps
# Generate pseudo-replicates
if [ ! -f ${OUTP}.pseudorep1.bam ] || [ ! -f ${OUTP}.pseudorep2.bam ]; then
  ${BASEDIR}/pseudorep.sh ${OUTP}.final.bam ${OUTP}
else
  echo ${OUTP}.pseudorep1.bam and ${OUTP}.pseudorep2.bam found! skipping generate pseudoreps.
fi

echo STEP3 - peaks
# Call peaks and filter using IDR (replace pseudo-replicates with true biological replicates if available)
if [ ! -f ${OUTP}.peaks ]; then
  ${BASEDIR}/peaks.sh ${OUTP}.pseudorep1.bam ${OUTP}.pseudorep2.bam ${HG} ${OUTP} ${ATYPE}
else
  echo ${OUTP}.peaks found! skipping peaks/IDR.
fi

# Delete pseudo-replicates
#rm ${OUTP}.pseudorep1.bam ${OUTP}.pseudorep1.bam.bai ${OUTP}.pseudorep2.bam ${OUTP}.pseudorep2.bam.bai

# Footprints
echo STEP 4 - footprints
if [ ! -f ${OUTP}.footprints.motifs ]; then
  ${BASEDIR}/footprints.sh ${ATYPE} ${HG} ${OUTP}.final.bam ${OUTP}
else
  echo ${OUTP}.footprints.motifs found! skipping footprints.
fi

echo STEP 5 - qc metrics
# Aggregate key QC metrics
if [ ! -f ${OUTP}.key.metrics ]; then
  ${BASEDIR}/qc_globber.sh ${OUTP}
else
  echo ${OUTP}.key.metrics found! skipping qc metrics.
fi

# Variant calling
echo STEP 6 - variant calling
if [ ! -f ${OUTP}.norm.filtered.vcf.gz ]; then 
  ${BASEDIR}/variants.sh ${HG} ${OUTP} ${OUTP}.final.bam
else
  echo ${OUTP}.norm.filtered.vcf.gz found! skipping variant calling.
fi

# Annotate peaks
echo STEP 7 - annotate peaks
if [ ! -s  ${OUTP}.annotated.normalized ]; then
  ${BASEDIR}/homer.sh ${OUTP}.peaks ${OUTP}.final.bam ${HG} ${OUTP} ${ATYPE}
else
  echo ${OUTP}.annotated.normalized found! skipping homer.
fi

# Motif discovery
echo STEP 8 - motifs
if [ ! -d ${OUTP}_motifs ]; then
  ${BASEDIR}/motif.sh ${ATYPE} ${OUTP}.peaks ${OUTP}
else
  echo ${OUTP}_motifs directory found! skipping motifs.
fi

echo STEP 9 - bigwigs abd bigbeds
for f in ${OUTP}.bedGraph.gz ${OUTP}.footprint.bedGraph.gz; do
  bash ${BASEDIR}/bedgraphgz_to_bigwig.sh ${ATYPE} $f .bedGraph.gz
done

for f in ${OUTP}.peaks; do
  bash ${BASEDIR}/narrowPeak_to_bigbed.sh ${ATYPE} $f ""
done

