#!/bin/bash

if [ $# -ne 4 ]
then
    echo ""
    echo "Usage: $0 <hg38|g19|mm10> <read1.fq.gz> <genome.fa> <output prefix>"
    echo ""
    exit -1
fi

SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT")

# Activate environment
export PATH=${BASEDIR}/../bin/bin:${PATH}
conda deactivate
conda activate ${BASEDIR}/../bin/envs/atac

# Custom parameters
THREADS=4
QUAL=30      # Mapping quality threshold

# CMD parameters
ATYPE=${1}
FQ1=${2}
HG=${3}
OUTP=${4}

# Generate IDs
FQ1ID=`echo ${OUTP} | sed 's/$/.fq1/'`

# Fastqc
if [ ! -d ${OUTP}_prefastqc/ ]; then
  mkdir -p ${OUTP}_prefastqc/ && fastqc -t ${THREADS} -o ${OUTP}_prefastqc/ ${FQ1}
else
  echo ${OUTP}_prefastqc/ found, assuming pre fastqc succeeded. Delete to rerun.
fi

# Adapter trimming
if [ ! -f ${OUTP}.1.fq.gz ]; then
  cutadapt -q 10 -m 15 -e 0.10 -a CTGTCTCTTATA -o ${OUTP}.1.fq  ${FQ1} | gzip -c > ${OUTP}.cutadapt.log.gz
  gzip ${OUTP}.1.fq
else
  echo ${OUTP}.1.fq.gz found, assuming cutadapt succeeded. Delete to rerun.
fi

# Fastqc
if [ ! -d ${OUTP}_postfastqc/ ]; then
  mkdir -p ${OUTP}_postfastqc/ && fastqc -t ${THREADS} -o ${OUTP}_postfastqc/ ${OUTP}.1.fq.gz
else
  echo ${OUTP}_postfastqc/ found, assuming post fastqc succeeded. Delete to rerun.
fi

if [ ! -f ${HG}.fa ]; then
  echo expected reference for bowtie2 index to be ${HG}.fa, not found! exit.
  exit 1;
fi

# Bowtie
if [ ! -f ${OUTP}.raw.bam ]; then
  bowtie2 --threads ${THREADS} --local -x ${HG} -U ${OUTP}.1.fq.gz 2> ${OUTP}.bowtie.log | samtools view -bT ${HG}.fa - > ${OUTP}.raw.bam
else
  echo ${OUTP}.raw.bam found, assuming alignment succeeded. Delete to rerun.
fi


# Removed trimmed fastq
#rm ${OUTP}.1.fq.gz

# Sort & Index
if [ ! -f ${OUTP}.srt.bam ]; then
  samtools sort -@ ${THREADS} -o ${OUTP}.srt.bam ${OUTP}.raw.bam && samtools index -@ ${THREADS} ${OUTP}.srt.bam
else
  echo ${OUTP}.srt.bam found, assuming bam sort succeeded. Delete to rerun.
fi

# Mark duplicates
if [ ! -f ${OUTP}.rmdup.bam ]; then
  bammarkduplicates markthreads=${THREADS} tmpfile=${OUTP}_`date +'%H%M%S'` I=${OUTP}.srt.bam O=${OUTP}.rmdup.bam M=${OUTP}.rmdup.log index=1 rmdup=0
else
  echo ${OUTP}.rmdup.bam found, assuming remove duplicates succeeded. Delete to rerun.
fi
#rm ${OUTP}.srt.bam ${OUTP}.srt.bam.bai

# Run stats using unfiltered BAM
if [ ! -f ${OUTP}.idxstats ]; then samtools idxstats ${OUTP}.rmdup.bam > ${OUTP}.idxstats; fi
if [ ! -f ${OUTP}.flagstat ]; then samtools flagstat -@ ${THREADS} ${OUTP}.rmdup.bam > ${OUTP}.flagstat; fi

# Run stats on unfiltered BAM
if [ ! -f ${OUTP}.bamStats.unfiltered.tsv.gz ]; then
  alfred qc -b ${BASEDIR}/../bed/${ATYPE}.promoter.bed.gz -r ${HG}.fa -o ${OUTP}.bamStats.unfiltered.tsv.gz -j ${OUTP}.bamStats.unfiltered.json.gz ${OUTP}.rmdup.bam
else
  echo ${OUTP}.bamStats.unfiltered.tsv.gz found, assuming alfread qc unfiltered succeeded. Delete to rerun.
fi

# Filter duplicates, mapping quality > QUAL, unmapped reads, chrM and unplaced contigs
if [ ! -f ${OUTP}.final.bam ]; then
  CHRS=`zcat ${BASEDIR}/../bed/${ATYPE}.promoter.bed.gz | cut -f 1 | sort -k1,1V -k2,2n | uniq | tr '\n' ' '`
  samtools view -@ ${THREADS} -F 1804 -q ${QUAL} -b ${OUTP}.rmdup.bam ${CHRS} > ${OUTP}.final.bam
  samtools index -@ ${THREADS} ${OUTP}.final.bam
else
  echo ${OUTP}.final.bam found, assuming final bam succeeded. Delete to rerun.
fi
#rm ${OUTP}.rmdup.bam ${OUTP}.rmdup.bam.bai

# Run stats using filtered BAM using promoter regions
if [ ! -f ${OUTP}.bamStats.promoters.tsv.gz ]; then
  alfred qc -b ${BASEDIR}/../bed/${ATYPE}.promoter.bed.gz -r ${HG}.fa -o ${OUTP}.bamStats.promoters.tsv.gz -j ${OUTP}.bamStats.promoters.json.gz ${OUTP}.final.bam
else
  echo ${OUTP}.bamStats.promoters.tsv.gz found, assuming alfread qc unfiltered succeeded. Delete to rerun.
fi

# Create browser tracks (ToDo)
if [ ! -f ${OUTP}.bedGraph.gz ] || [ ! -f ${OUTP}.tdf ]; then 
  alfred tracks -o ${OUTP}.bedGraph.gz ${OUTP}.final.bam
  igvtools totdf ${OUTP}.bedGraph.gz ${OUTP}.tdf ${ATYPE}
else
  echo ${OUTP}.bedGraph.gz and ${OUTP}.tdf found, assuming igv tracks succeeded. Delete to rerun.
fi

# Deactivate environment
conda deactivate


