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

LOC_FILE=${LOC}_indiv.txt #location file with individual names



# Loop through each line (individual) in singleton file
while read -r LINE2; do
    INDV=$(echo $LINE2 | awk '{print $5}')  # Adjust column index as needed
    LOCATIONS=()

    # Loop through all location files listed in the location list
    while read -r LINE; do
        LOC=$(echo $LINE | awk '{print $1}')
        LOC_FILE="${LOC}_indiv.txt"

        if grep -qw "$INDV" "$LOC_FILE"; then
            LOCATIONS+=("$LOC")
        fi
    done < "$LOCATION_LIST"

    # Join all found locations by comma
    LOC_STR=$(IFS=, ; echo "${LOCATIONS[*]}")

    # Output original singleton line + location(s)
    echo -e "$line\t$LOC_STR" >> "single_fixed"

done < "$LINE2"



