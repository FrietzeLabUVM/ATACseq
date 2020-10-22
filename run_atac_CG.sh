IDX=/slipstream/galaxy/data/hg19/hg19full/bowtie2_index/hg19full

R1=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar2_008/10Ar2_008_Ad2_8_S3_L002_R1_001.fastq.gz
R2=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar2_008/10Ar2_008_Ad2_8_S3_L002_R2_001.fastq.gz
OPUT=output_MCF10A_progression/MCF10A_rep2/MCF10A_rep2
qsub -V -pe threads 4 -cwd -o atac."$JOB_ID".out -e atac."$JOB_ID".error ~/rausch_atac_pipeline/ATACseq/src/atac.sh hg19 $R1 $R2 $IDX $OPUT

R1=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar1_001/10Ar1_001_Ad2_1_S1_L002_R1_001.fastq.gz
R2=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar1_001/10Ar1_001_Ad2_1_S1_L002_R2_001.fastq.gz
OPUT=output_MCF10A_progression/MCF10A_rep1_001/MCF10A_rep1_001
qsub -V -pe threads 4 -cwd -o atac."$JOB_ID".out -e atac."$JOB_ID".error  ~/rausch_atac_pipeline/ATACseq/src/atac.sh hg19 $R1 $R2 $IDX $OPUT

R1=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar1_007/10Ar1_007_Ad2_7_S2_L002_R1_001.fastq.gz
R2=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar1_007/10Ar1_007_Ad2_7_S2_L002_R2_001.fastq.gz
OPUT=output_MCF10A_progression/MCF10A_rep1_007/MCF10A_rep1_007
qsub -V -pe threads 4 -cwd -o atac."$JOB_ID".out -e atac."$JOB_ID".error  ~/rausch_atac_pipeline/ATACseq/src/atac.sh hg19 $R1 $R2 $IDX $OPUT

R1=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar3_009/10Ar3_009_Ad2_9_S4_L002_R1_001.fastq.gz
R2=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/10Ar3_009/10Ar3_009_Ad2_9_S4_L002_R2_001.fastq.gz
OPUT=output_MCF10A_progression/MCF10A_rep3/MCF10A_rep3
qsub -V -pe threads 4 -cwd -o atac."$JOB_ID".out -e atac."$JOB_ID".error  ~/rausch_atac_pipeline/ATACseq/src/atac.sh hg19 $R1 $R2 $IDX $OPUT

R1=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/AT1r1_010/AT1r1_010_Ad2_10_S5_L002_R1_001.fastq.gz
R2=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/AT1r1_010/AT1r1_010_Ad2_10_S5_L002_R2_001.fastq.gz
OPUT=output_MCF10A_progression/MCF10AT1_rep1/MCF10AT1_rep1
qsub -V -pe threads 4 -cwd -o atac."$JOB_ID".out -e atac."$JOB_ID".error  ~/rausch_atac_pipeline/ATACseq/src/atac.sh hg19 $R1 $R2 $IDX $OPUT

R1=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/AT1r2_011/AT1r2_011_Ad2_11_S6_L002_R1_001.fastq.gz
R2=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/AT1r2_011/AT1r2_011_Ad2_11_S6_L002_R2_001.fastq.gz
OPUT=output_MCF10A_progression/MCF10AT1_rep2/MCF10AT1_rep2
qsub -V -pe threads 4 -cwd -o atac."$JOB_ID".out -e atac."$JOB_ID".error  ~/rausch_atac_pipeline/ATACseq/src/atac.sh hg19 $R1 $R2 $IDX $OPUT

R1=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/AT1r3_012/AT1r3_012_Ad2_12_S7_L002_R1_001.fastq.gz
R2=/slipstream/home/conggao/ATAC_seq/ATAC_andy/Stein_AF_10AATAC_iLabs_15077_092030/AT1r3_012/AT1r3_012_Ad2_12_S7_L002_R2_001.fastq.gz
OPUT=output_MCF10A_progression/MCF10AT1_rep3/MCF10AT1_rep3
qsub -V -pe threads 4 -cwd -o atac."$JOB_ID".out -e atac."$JOB_ID".error  ~/rausch_atac_pipeline/ATACseq/src/atac.sh hg19 $R1 $R2 $IDX $OPUT
