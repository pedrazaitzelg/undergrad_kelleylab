#!/bin/bash

#SBATCH --partition=128x24               # Partition/queue to run on
#SBATCH --time=1-00:00:00                # Max time for job to run
#SBATCH --job-name=vcftools_allele                # Name for job (shows when running squeue)
#SBATCH --mail-type=ALL                  # Mail events(NONE,BEGIN,END,FAIL,ALL)
#SBATCH --mail-user=igpedraz@ucsc.edu    # Where to send mail
#SBATCH --ntasks=1                       # Number of tasks to run
#SBATCH --cpus-per-task=8                # Number of CPU cores to use per task
#SBATCH --nodes=1                        # Number of nodes to use
#SBATCH --mem=10G                        # Ammount of RAM to allocate for the task
#SBATCH --output=slurm_%j.out            # Standard output and error log
#SBATCH --error=slurm_%j.err             # Standard output and error log
#SBATCH --no-requeue                     # don't requeue the job upon NODE_FAIL

#set working directory
cd /hb/groups/kelley_training/itzel/population_bears_proj24/genes_analysis

#set variables
ANNOT_VCF=/hb/groups/kelley_training/itzel/population_bears_proj24/genes_analysis/NW_026622808.1/NW_026622808.1_subset.vcf 
OUT=/hb/groups/kelley_training/itzel/population_bears_proj24/genes_analysis/NW_026622808.1/INSR.vcf
POP=/hb/groups/kelley_training/itzel/population_bears_proj24/genes_analysis/indiv_pop/ABC_indiv.txt 
#load vcftools
module load vcftools


## Filter ##
vcftools --vcf $ANNOT_VCF --keep $POP --recode-INFO-all ABC_



## Allele FREQ
#vcftools --vcf $ANNOT_VCF --freq2 --out allele_freq

#Mean Depth
#vcftools --vcf $ANNOT_VCF --site-mean-depth --out mean_depth

## SITE QUALITY
#vcftools --vcf $ANNOT_VCF --site-quality --out site_qual

## PROPORTION OF MISSING sites per INDIV
#vcftools --vcf $ANNOT_VCF --missing-indv --out miss_per_indiv

## PROPORTION OF MISSING DATA PER SITE
#vcftools --vcf $ANNOT_VCF --missing-site --out miss_data_per_site

## HETEROZYGOSITY AND INBREEDING COEFFICIENT PER INDIV
#vcftools --vcf $ANNOT_VCF --het --out het
