IDX=/slipstream/galaxy/data/hg38/hg38full/bowtie2_index/hg38full
GEN=hg38
BASE=output_MCF10A_progression.hg38
mkdir -p $BASE
#/slipstream/galaxy/data/hg38/hg38full/bowtie2_index/hg38full.1.bt2  /slipstream/galaxy/data/hg38/hg38full/bowtie2_index/hg38full.4.bt2      /slipstream/galaxy/data/hg38/hg38full/bowtie2_index/hg38full.rev.2.bt2
#/slipstream/galaxy/data/hg38/hg38full/bowtie2_index/hg38full.2.bt2  /slipstream/galaxy/data/hg38/hg38full/bowtie2_index/hg38full.fa
#/slipstream/galaxy/data/hg38/hg38full/bowtie2_index/hg38full.3.bt2  /slipstream/galaxy/data/hg38/hg38full/bowtie2_index/hg38full.rev.1.bt2

if [ ! -f ${IDX}.fa ]; then echo need ${IDX}.fa, stop!; exit 1; fi
if [ ! -f ${IDX}.fa ]; then echo need ${IDX}.1.bt2, stop!; exit 1; fi
if [ ! -f ${IDX}.fa ]; then echo need ${IDX}.rev.1.bt2, stop!; exit 1; fi

R1=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar2_008/10Ar2_008_Ad2_8_S3_L002_R1_001.fastq.gz
R2=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar2_008/10Ar2_008_Ad2_8_S3_L002_R2_001.fastq.gz
OPUT=${BASE}/MCF10A_rep2/MCF10A_rep2
mkdir -p $(dirname $OPUT)
qsub -V -pe threads 4 -cwd -o ${OPUT}.pipeline.out -e ${OPUT}.pipeline.error ~/rausch_atac_pipeline/ATACseq/src/atac.sh $GEN $R1 $R2 $IDX $OPUT
#bash ~/rausch_atac_pipeline/ATACseq/src/atac.sh $GEN $R1 $R2 $IDX $OPUT
#exit 0
R1=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar1_001/10Ar1_001_Ad2_1_S1_L002_R1_001.fastq.gz
R2=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar1_001/10Ar1_001_Ad2_1_S1_L002_R2_001.fastq.gz
OPUT=${BASE}/MCF10A_rep1_001/MCF10A_rep1_001
mkdir -p $(dirname $OPUT)
qsub -V -pe threads 4 -cwd -o ${OPUT}.pipeline.out -e ${OPUT}.pipeline.error  ~/rausch_atac_pipeline/ATACseq/src/atac.sh $GEN $R1 $R2 $IDX $OPUT

R1=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar1_007/10Ar1_007_Ad2_7_S2_L002_R1_001.fastq.gz
R2=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar1_007/10Ar1_007_Ad2_7_S2_L002_R2_001.fastq.gz
OPUT=${BASE}/MCF10A_rep1_007/MCF10A_rep1_007
mkdir -p $(dirname $OPUT)
qsub -V -pe threads 4 -cwd -o ${OPUT}.pipeline.out -e ${OPUT}.pipeline.error  ~/rausch_atac_pipeline/ATACseq/src/atac.sh $GEN $R1 $R2 $IDX $OPUT

R1=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar3_009/10Ar3_009_Ad2_9_S4_L002_R1_001.fastq.gz
R2=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar3_009/10Ar3_009_Ad2_9_S4_L002_R2_001.fastq.gz
OPUT=${BASE}/MCF10A_rep3/MCF10A_rep3
mkdir -p $(dirname $OPUT)
qsub -V -pe threads 4 -cwd -o ${OPUT}.pipeline.out -e ${OPUT}.pipeline.error  ~/rausch_atac_pipeline/ATACseq/src/atac.sh $GEN $R1 $R2 $IDX $OPUT

R1=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/AT1r1_010/AT1r1_010_Ad2_10_S5_L002_R1_001.fastq.gz
R2=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/AT1r1_010/AT1r1_010_Ad2_10_S5_L002_R2_001.fastq.gz
OPUT=${BASE}/MCF10AT1_rep1/MCF10AT1_rep1
mkdir -p $(dirname $OPUT)
qsub -V -pe threads 4 -cwd -o ${OPUT}.pipeline.out -e ${OPUT}.pipeline.error  ~/rausch_atac_pipeline/ATACseq/src/atac.sh $GEN $R1 $R2 $IDX $OPUT

R1=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/AT1r2_011/AT1r2_011_Ad2_11_S6_L002_R1_001.fastq.gz
R2=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/AT1r2_011/AT1r2_011_Ad2_11_S6_L002_R2_001.fastq.gz
OPUT=${BASE}/MCF10AT1_rep2/MCF10AT1_rep2
mkdir -p $(dirname $OPUT)
qsub -V -pe threads 4 -cwd -o ${OPUT}.pipeline.out -e ${OPUT}.pipeline.error  ~/rausch_atac_pipeline/ATACseq/src/atac.sh $GEN $R1 $R2 $IDX $OPUT

R1=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/AT1r3_012/AT1r3_012_Ad2_12_S7_L002_R1_001.fastq.gz
R2=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/AT1r3_012/AT1r3_012_Ad2_12_S7_L002_R2_001.fastq.gz
OPUT=${BASE}/MCF10AT1_rep3/MCF10AT1_rep3
mkdir -p $(dirname $OPUT)
qsub -V -pe threads 4 -cwd -o ${OPUT}.pipeline.out -e ${OPUT}.pipeline.error  ~/rausch_atac_pipeline/ATACseq/src/atac.sh $GEN $R1 $R2 $IDX $OPUT
