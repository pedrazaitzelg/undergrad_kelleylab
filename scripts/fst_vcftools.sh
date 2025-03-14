#!/bin/bash

#SBATCH --partition=256x44               # Partition/queue to run on
#SBATCH --time=1-00:00:00                # Max time for job to run
#SBATCH --job-name=fst_stats                # Name for job (shows when running squeue)
#SBATCH --mail-type=ALL                  # Mail events(NONE,BEGIN,END,FAIL,ALL)
#SBATCH --mail-user=igpedraz@ucsc.edu    # Where to send mail
#SBATCH --ntasks=1                       # Number of tasks to run
#SBATCH --cpus-per-task=8                # Number of CPU cores to use per task
#SBATCH --nodes=1                        # Number of nodes to use
#SBATCH --mem=10G                        # Ammount of RAM to allocate for the task
#SBATCH --output=slurm_%j.out            # Standard output and error log
#SBATCH --error=slurm_%j.err             # Standard output and error log
#SBATCH --no-requeue                     # don't requeue the job upon NODE_FAIL

## analyses by population
## generate FST stats for pairwise comparisons

## MAINLAND v KODIAK

# set working directory
cd /hb/groups/kelley_training/itzel/population_bears_proj24/population_stats/fst_out

# set variables
#snpeff vcf file
vcf_file=/hb/groups/kelley_training/itzel/population_bears_proj24/snpEff_out/new_vcf/new_all_genes_ann.vcf
#directory of individual_txt files
dir=/hb/groups/kelley_training/itzel/population_bears_proj24/population_stats/indiv_pop


#Alaska & ABC
alaska=${dir}/Alaska_indiv.txt
abc=${dir}/ABC_indiv.txt


#load module
module load vcftools

## fst
vcftools --vcf ${vcf_file} --weir-fst-pop ${alaska} --weir-fst-pop ${abc} --out alaska_abc_fst


#unload module
module unload vcftools
