#!/bin/bash

#SBATCH --partition=256x44               # Partition/queue to run on
#SBATCH --time=2-00:00:00                # Max time for job to run
#SBATCH --job-name=filtere_gene           # Name for job (shows when running squeue)
#SBATCH --mail-type=ALL                  # Mail events(NONE,BEGIN,END,FAIL,ALL)
#SBATCH --mail-user=igpedraz@ucsc.edu    # Where to send mail
#SBATCH --ntasks=1                       # Number of tasks to run
#SBATCH --cpus-per-task=8                # Number of CPU cores to use per task
#SBATCH --nodes=1                        # Number of nodes to use
#SBATCH --mem=15G                        # Ammount of RAM to allocate for the task
#SBATCH --output=slurm_%j.out            # Standard output and error log
#SBATCH --error=slurm_%j.err             # Standard output and error log
#SBATCH --no-requeue                     # don't requeue the job upon NODE_FAIL

#grep 'ANN=' finds lines with annotation info.

#cut -f8 extracts the INFO column (assuming standard VCF format).

#tr ';' '\n' splits INFO fields by ; to isolate ANN=.

#cut -d= -f2- gets the annotation values after ANN=.

#tr ',' '\n' splits multiple annotations.

#awk -F'|' ... filters based on effect, impact, and gene, and prints the desired fields.

#set variables
LINE=$(sed -n "${SLURM_ARRAY_TASK_ID}"p /hb/groups/kelley_training/itzel/population_bears_proj24/genes_analysis/populations/locations.txt)
LOC=$(echo ${LINE} | awk ' {print $1; } ' )


grep 'ANN=' ${LOC}_filtered.vcf.recode.vcf | \
cut -f8 | \
tr ';' '\n' | \
grep '^ANN=' | \
cut -d= -f2- | \
tr ',' '\n' | \
awk -F'|' '$4 == "PPARG" { print $2, $3, $4, $7 }' \
> pparg_yaak_variants.txt

