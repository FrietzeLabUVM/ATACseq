#!/bin/bash
OUT_DIR=$1
if [ -z $OUT_DIR ]; then
  echo need OUT_DIR as arg1. exit.
  exit 1
fi
if [ ! -d $OUT_DIR ]; then
  echo OUT_OUT $OUT_DIR not found! exit.
  exit 1
fi

QC_DIR=${OUT_DIR}/qc
mkdir -p $QC_DIR
cd $QC_DIR

head -n 1 ../*/*.key.metrics | grep "TssEnrichment" | uniq > summary.tsv
cat ../*/*.key.metrics | grep -v "TssEnrichment" >> summary.tsv
Rscript ../../R/metrics.R summary.tsv
