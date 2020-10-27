#!/bin/bash
#for f in output_bcell_lines.hg38.SE/MXP5_IK_rep2.I160op_Ad24 output_bcell_lines.hg38.SE/MXP5_IK_rep1.I80op_Ad22; do 
ODIR=output_bcell_lines.hg38.SE
for f in $ODIR/*; do
  echo $f
  mv ${f}/${f}_postfastqc $ODIR/
  mv ${f}/${f}_prefastqc $ODIR/
  mv ${f}/${f}.cutadapt.log.gz $ODIR/
  mv ${f}/${f}.1.fq.gz $ODIR/ 
  mv ${f}/${f}.raw.bam $ODIR/
  mv ${f}/${f}.srt.bam $ODIR/
  mv ${f}/${f}.srt.bam.bai $ODIR/
  mv ${f}/${f}.rmdup.bam $ODIR/
  mv ${f}/${f}.rmdup.bam.bai $ODIR/
  rm -r ${f}/*; 
  mv $ODIR/${f}* ${f}; 
done
