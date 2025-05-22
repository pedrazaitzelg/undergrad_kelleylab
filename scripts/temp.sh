#!/bin/bash

#SBATCH --partition=128x24               # Partition/queue to run on
#SBATCH --time=1-00:00:00                # Max time for job to run
#SBATCH --job-name=allele_filter                # Name for job (shows when running squeue)
#SBATCH --mail-type=ALL                  # Mail events(NONE,BEGIN,END,FAIL,ALL)
#SBATCH --mail-user=igpedraz@ucsc.edu    # Where to send mail
#SBATCH --ntasks=1                       # Number of tasks to run
#SBATCH --cpus-per-task=8                # Number of CPU cores to use per task
#SBATCH --nodes=1                        # Number of nodes to use
#SBATCH --mem=10G                        # Ammount of RAM to allocate for the task
#SBATCH --output=slurm_%j.out            # Standard output and error log
#SBATCH --error=slurm_%j.err             # Standard output and error log
#SBATCH --no-requeue                     # don't requeue the job upon NODE_FAIL


# -F'\t' sets field separator to a tab so awk splits into fields based on tabs
# NR total record number
# FNR record number within current file
# When NR==FNR still reading first file
# This line creates an associative array loc, where: loc[$1] = $2, i.e., key is the first field, value is the second.
# 'next' skips to the next record.
# FNR==1 { print $0 "\tLOCATION"; next }    reading second file and on first line add new column name
# { print $0 "\t" (loc[$5] ? loc[$5] : "Unknown") }
# For all subsequent lines in the second file: Look up the fifth field ($5) in the loc array.
# If found, append the corresponding value from single_loc.txt. If not found, append "Unknown".

awk -F'\t' '  
    NR==FNR { loc[$1]=$2; next }
    FNR==1 { print $0 "\tLOCATION"; next }
    { print $0 "\t" (loc[$5] ? loc[$5] : "Unknown") }
' single_loc.txt singleton.singletons > output.txt



