#!/bin/bash

if [ $# -ne 1 ]
then
    echo ""
    echo "Usage: $0 <output prefix>"
    echo ""
    exit -1
fi

SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT")

# Parameters
OUTP=${1}

# Activate environment
export PATH=${BASEDIR}/../bin/bin:${PATH}
conda deactivate
conda activate ${BASEDIR}/../bin/envs/atac

# Collect QC information
${BASEDIR}/qc_globber.py -p ${OUTP} > ${OUTP}.key.metrics

# Deactivate environment
conda deactivate
