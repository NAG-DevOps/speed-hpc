#!/encs/bin/tcsh

#SBATCH -J arrayexample
#SBATCH -c 1
#SBATCH -N 1
#SBATCH -t 0-2:00
#SBATCH --mem=4Gb
#SBATCH --array=1-30
#SBATCH --mem=1G
#SBATCH -o myprogram%A_%a.out
# %A" is replaced by the job ID and "%a" with the array index
#SBATCH -e myprogram%A_%a.err

echo "Would be input shard: input$SLURM_ARRAY_TASK_ID.dat"
#./myprogram input$SLURM_ARRAY_TASK_ID.dat

sleep 10

# EOF
