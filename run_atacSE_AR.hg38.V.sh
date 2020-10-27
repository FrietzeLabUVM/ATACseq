IDX=~/data/hg38/hg38canon/bowtie2_index/hg38canon
GEN=hg38
BASE=output_bcell_lines.hg38.SE
mkdir -p $BASE

if [ ! -f ${IDX}.fa ]; then echo need ${IDX}.fa, stop!; exit 1; fi
if [ ! -f ${IDX}.fa ]; then echo need ${IDX}.1.bt2, stop!; exit 1; fi
if [ ! -f ${IDX}.fa ]; then echo need ${IDX}.rev.1.bt2, stop!; exit 1; fi

RESUME=$1

for R1 in input_fastqs_SE/*.fastq.gz; do
  echo $R1
  if [ ! -f $R1 ]; then echo R1 $R1 not found! stop; exit 1; fi
  #Change NAME line per experiment - all should be unique
  #NAME=$(basename $R1 | cut -d _ -f 1-4)
  NAME=$(basename $R1 | awk -v FS="[._]" -v OFS="_" '{print $1,$2,$3,$4,$5}')
  OPUT=${BASE}/$NAME/$NAME
  mkdir -p $(dirname $OPUT)
  echo R1 is $R1
  echo NAME is $NAME
  echo OUTPUT is $OPUT
  cmd="src/atacSE.sh $GEN $R1 $IDX $OPUT $RESUME"
  sub="sbatch --chdir=$(pwd) --nodes=1 --ntasks=4 --mem=10G --time=10:00:00 --job-name=atac_${NAME} --output=${OPUT}.pipeline.out --error=${OPUT}.pipeline.error"
  echo $cmd
  $sub $cmd
  #exit 1
done
