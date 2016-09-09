#!/bin/sh
#$ -l mem=1G
#$ -l rmem=1G
#$ -l h_rt=1:00:00
#$ -m ae
#$ -M seb.james@sheffield.ac.uk

NUMSIMS=100

for i in `seq 1 ${NUMSIMS}`; do
    mkdir -p /fastdata/pc1ssj/SpikeGPR/run${i}
    qsub -P insigneo-notremor -N SpikeGPR${i} \
         -o /fastdata/pc1ssj/SpikeGPR/run${i}.out -j y \
         ./run_one.sh /fastdata/pc1ssj/SpikeGPR/run${i}
done
