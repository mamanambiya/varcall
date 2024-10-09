#!/bin/bash
#SBATCH --job-name='fastq-trim-crop'
#SBATCH --cpus-per-task=1
#SBATCH --mem=8GB
#SBATCH --output=/scratch3/users/mamana/varcall/fastq-trim-crop.stdout.log
#SBATCH --error=fastq-trim-crop.stderr.log
#SBATCH --time=96:00:00

wkdir="/scratch3/users/mamana/varcall"
cd ${wkdir}
nextflow -c /users/mamana/varcall/fastq-trim-crop/test.config run /users/mamana/varcall/fastq-trim-crop/main.nf \
         -profile ilifu,singularity -resume
