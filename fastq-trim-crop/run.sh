#!/bin/bash
#SBATCH --job-name='fastq-trim-crop'
#SBATCH --cpus-per-task=1
#SBATCH --mem=8GB
#SBATCH --output=fastq-trim-crop.stdout.log
#SBATCH --error=fastq-trim-crop.stderr.log
#SBATCH --time=96:00:00

wkdir=""
cd ${wkdir}
nextflow run main.nf \
         -profile ilifu,singularity -resume
