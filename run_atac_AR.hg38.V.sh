IDX=~/data/hg38/hg38canon/bowtie2_index/hg38canon
GEN=hg38
BASE=output_bcell_lines.hg38.rerun
mkdir -p $BASE

if [ ! -f ${IDX}.fa ]; then echo need ${IDX}.fa, stop!; exit 1; fi
if [ ! -f ${IDX}.fa ]; then echo need ${IDX}.1.bt2, stop!; exit 1; fi
if [ ! -f ${IDX}.fa ]; then echo need ${IDX}.rev.1.bt2, stop!; exit 1; fi

for R1 in input_fastqs/*R1_001.fastq.gz; do
  echo $R1
  R2=${R1/_R1_001.fastq.gz/_R2_001.fastq.gz}
  if [ ! -f $R2 ]; then echo R2 $R2 not found! stop; exit 1; fi
  #Change NAME line per experiment - all should be unique
  NAME=$(basename $R1 | cut -d _ -f 1-4)
  OPUT=${BASE}/$NAME/$NAME
  mkdir -p $(dirname $OPUT)
  echo R1 is $R1
  echo R2 is $R2
  echo NAME is $NAME
  echo OUTPUT is $OPUT
  cmd="src/atac.sh $GEN $R1 $R2 $IDX $OPUT"
  sub="sbatch --chdir=$(pwd) --nodes=1 --ntasks=4 --mem=10G --time=10:00:00 --job-name=atac_${NAME} --output=${OPUT}.pipeline.out --error=${OPUT}.pipeline.error"
  echo $cmd
  $sub $cmd
done
