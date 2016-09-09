#!/bin/sh
#$ -l mem=4G
#$ -l rmem=4G
#$ -l h_rt=1:00:00
#$ -m ae
#$ -M seb.james@sheffield.ac.uk

if [ -z "$1" ]; then
	echo "one arg please"
	exit -1
fi

OUTPLACE="$1"

pushd /home/pc1ssj/SpineML_2_BRAHMS
./convert_script_s2b -e3 -m /home/pc1ssj/izhibg/GPR_Izhikevich/bg2 -o ${OUTPLACE}
