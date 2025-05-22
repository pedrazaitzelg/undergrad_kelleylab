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
#SBATCH --array=[1-1]

#set working directory
cd /hb/groups/kelley_training/itzel/population_bears_proj24/SPRING_25

#set variables
LINE=$(sed -n "${SLURM_ARRAY_TASK_ID}"p /hb/groups/kelley_training/itzel/population_bears_proj24/genes_analysis/populations/locations.txt)
LOC=$(echo ${LINE} | awk ' {print $1; } ' )

LINE2=$(sed -n "${SLURM_ARRAY_TASK_ID}"p /hb/groups/kelley_training/itzel/population_bears_proj24/vcftool_out/corrected_vcf/singleton.singletons)
INDV=$(echo ${LINE} | awk ' {print $5; } ' ) #print indv name to run through


SINGLETON=/hb/groups/kelley_training/itzel/population_bears_proj24/vcftool_out/corrected_vcf/singleton.singletons

LOC_FILE=${LOC}_indiv.txt #location file with individual names


# Loop through each individual in the singleton file (skip header)
tail -n +2 "$SINGLETON" | while read -r LINE2; do
    INDV=$(echo "$LINE2" | awk '{print $5}')
    LOCATIONS=()

    while read -r LINE; do
        LOC=$(echo "$LINE" | awk '{print $1}')
        LOC_FILE="${LOC}_indiv.txt"

        if grep -qw "$INDV" "$LOC_FILE"; then
            LOCATIONS+=("$LOC")
        fi
    done < "$LOCATION_LIST"


awk -F'\t' '
    NR==FNR { loc[$1]=$2; next }
    FNR==1 { print $0 "\tLOCATION"; next }
    { print $0 "\t" (loc[$5] ? loc[$5] : "Unknown") }
' single_loc.txt singleton.singletons > output.txt

    LOC_STR=$(IFS=, ; echo "${LOCATIONS[*]}")
    echo -e "$LINE2\t$LOC_STR" >> "single_fixed"
done

