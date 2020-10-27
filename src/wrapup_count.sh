#!/bin/bash
OUT_DIR=$1

if [ ! -f src/count.sh ]; then
  echo must run from directory containing src/count.sh! exit
  exit 1
fi

if [ -z $OUT_DIR ]; then
  echo need OUT_DIR as arg1. exit.
  exit 1
fi
if [ ! -d $OUT_DIR ]; then
  echo OUT_OUT $OUT_DIR not found! exit.
  exit 1
fi

DIFF_DIR=${OUT_DIR}/diff
mkdir -p $DIFF_DIR
#cd $DIFF_DIR

ls ${OUT_DIR}/*/*.final.peaks > $DIFF_DIR/peaks.list
ls ${OUT_DIR}/*/*.final.bam > $DIFF_DIR/bams.list

bash src/count.sh hg38 $DIFF_DIR/peaks.list $DIFF_DIR/bams.list $DIFF_DIR/counts

echo -e "name\tcondition" > $DIFF_DIR/sample.info

COUNT_F=$DIFF_DIR//counts.counts.gz
echo $COUNT_F

zcat $COUNT_F | head -n 1 | cut -f 5- | tr '\t' '\n' | sed 's/.final$//' | awk '{print $0"\t"int((NR-1)/4);}' >> $DIFF_DIR/sample.info
