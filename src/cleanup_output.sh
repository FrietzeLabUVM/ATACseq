#!/bin/bash
#rm intermediate files
OUTDIR=$1
RUN=$2
if [ -z $OUTDIR ]; then echo must have OUTDIR as arg1. exit.; exit 1; fi
if [ ! -d $OUTDIR ]; then echo OUTDIR must be a directory. exit.; exit 1; fi
if [ -z $RUN ]; then echo supply arg2 as \"clean\" to remove files.; RUN="no"; fi


SUFF=".1.fq.gz .2.fq.gz .raw.bam .srt.bam .srt.bam.bai .rmdup.bam .rmdup.bam.bai .pseudorep1.bam .pseudorep1.bam.bai .pseudorep2.bam .pseudorep2.bam.bai .significant.peaks .lenient.rep1.peaks .lenient.rep2.peaks .bamStats.peaks.tsv.gz .merge.bam .merge.bam.bai .bamStats.peaks.tsv.gz .vcf.gz .vcf.gz.tbi .norm.vcf.gz .norm.vcf.gz.tbi"

for s in $SUFF; do 
 echo $s
 for d in $OUTDIR/*; do
  if [ ! -d $d ]; then next; fi
   bn=$(basename $d)
  for f in $OUTDIR/$bn/${bn}${s}; do
   if [ -f $f ]; then
    echo $f
    if [ $RUN == clean ]; then rm $f; fi
   fi
  done
 done
done

if [ $RUN != clean ]; then echo supply arg2 as \"clean\" to remove files.; fi 
