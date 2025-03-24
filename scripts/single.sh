#!/bin/bash

#SBATCH --partition=128x24               # Partition/queue to run on
#SBATCH --time=1-00:00:00                # Max time for job to run
#SBATCH --job-name=sing_count                # Name for job (shows when running squeue)
#SBATCH --mail-type=ALL                  # Mail events(NONE,BEGIN,END,FAIL,ALL)
#SBATCH --mail-user=igpedraz@ucsc.edu    # Where to send mail
#SBATCH --ntasks=1                       # Number of tasks to run
#SBATCH --cpus-per-task=8                # Number of CPU cores to use per task
#SBATCH --nodes=1                        # Number of nodes to use
#SBATCH --mem=10G                        # Ammount of RAM to allocate for the task
#SBATCH --output=slurm_%j.out            # Standard output and error log
#SBATCH --error=slurm_%j.err             # Standard output and error log
#SBATCH --no-requeue                     # don't requeue the job upon NODE_FAIL
#SBATCH --array=[1-659]                    # sets array - 658


echo -e "INDV\tTOTAL\tINSR\tPPARG\tACP5\tSLC2A4\tSREBF1" > total_single.txt


LINE1=$(sed -n "${SLURM_ARRAY_TASK_ID}"p ala_sing.txt)

LINE2=$(sed -n "${SLURM_ARRAY_TASK_ID}"p Alaska.singletons)


indiv=$(echo ${LINE1} | awk ' {print $1; } ' )
chrom=$(echo ${LINE2} | awk ' {print $1; } ' | uniq)
#chrom="NW_026622808.1"

for ind in ${indiv}; do
        if [ "$ind" != "INDV" ]; then
                echo 'Searching for' ${ind}
                total=$(grep -w "${ind}" Alaska.singletons | wc -l)
                echo 'Total number:' ${total}
                for chr in ${chrom}; do
                        echo 'Filtering for NW_026622808.1'
                        temp_pparg=$(awk -v chr="NW_026622808.1" '$1 == chr && $2 >= 65790000 && $2 <= 65790000' Alaska.singletons)
                        temp_insr=$(awk -v chr="NW_026622808.1" '$1 == chr && $2 >= 17765709 && $2 <= 17900000' Alaska.singletons)
                        temp_acp=$(awk -v chr="NW_026622808.1" '$1 == chr && $2 >= 20010012 && $2 <= 20015662' Alaska.singletons)
                        temp_slc2a4=$(awk -v chr="NW_026622808.1" '$1 == chr && $2 >= 10133505 && $2 <= 10141168' Alaska.singletons)
                        temp_srebf1=$(awk -v chr="NW_026622808.1" '$1 == chr && $2 >= 1162795 && $2 <= 1187854' Alaska.singletons)

                                if [ -n "$temp_insr" ]; then  # Check if temp_insr is not empty
                                        insr_cnt=$(echo "$temp_insr" | grep -w "${ind}" | wc -l)
                                else
                                        insr_cnt=0
                                fi

                                if [ -n "$temp_pparg" ]; then  # Check if temp_insr is not empty
                                        pparg_cnt=$(echo "$temp_pparg" | grep -w "${ind}" | wc -l)
                                else
                                        pparg_cnt=0
                                fi

                                if [ -n "$temp_acp" ]; then  # Check if temp_insr is not empty
                                        acp_count=$(echo "$temp_acp" | grep -w "${ind}" | wc -l)
                                else
                                        acp_count=0
                                fi

                                if [ -n "$temp_slc2a4" ]; then  # Check if temp_insr is not empty
                                        slc2a4_count=$(echo "$temp_slc2a4" | grep -w "${ind}" | wc -l)
                                else
                                        slc2a4_count=0
                                fi

                                if [ -n "$temp_srebf1" ]; then  # Check if temp_insr is not empty
                                        srebf1_count=$(echo "$temp_srebf1" | grep -w "${ind}" | wc -l)
                                else
                                        srebf1_count=0
                                fi
                                
                        echo 'Filtering for NW_026622763.1'
                        temp_pdk1=$(awk -v chr="NW_026622808.1" '$1 == chr && $2 >= 51961548 && $2 <= 51994435' Alaska.singletons)
                                
                                if [ -n "$temp_pdk1" ]; then  # Check if temp_insr is not empty
                                        pdk1_cnt=$(echo "$temp_pdk1" | grep -w "${ind}" | wc -l)
                                else
                                        pdk1_cnt=0
                                fi

                        echo 'INSR Count:' ${insr_cnt}
                        echo 'PPARG Count:' ${pparg_count}
                        echo 'ACP5 Count:' ${acp_count}
                        echo 'SLC2A4 Count:' ${slc2a4_count}
                        echo 'SREBF1 Count:' ${srebf1_count}
                        echo 'PDK1 Count:' ${pdk1_cnt}
                done
        echo -e "${ind}\t${total}\t${insr_cnt}\t${pparg_count}\t${acp_count}\t${slc2ar_count}\t${srebf1_count}" >> total_single.txt
        fi
done


count=$(echo total_single.txt | wc -l)
orig=$(echo ala_single.txt | wc -l)
if [ "$count" != "$orig"; then
  echo 'Something went wrong :('
else
  echo 'All good :)'
fi
