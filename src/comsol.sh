#!/encs/bin/tcsh

##
## SLURM options 
##

#SBATCH --job-name=comsole_job ## Give the job a name
#SBATCH --mail-type=ALL        ## Receive all email type notifications
#SBATCH --mail-user=$USER@encs.concordia.ca
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8      ## Request 8 cpus
#SBATCH --mem=500G             ## Assign 500G memory per node 

# Note:
# By default, SLURM sets the working directory to the directory the job is executed from.
# To set a different working directory use the --chdir=<directory name> SBATCH option.

##
## Job to run
##

echo "$0 : about to run comsol job on Speed"
date               # timestamp

# load comsol module
module load comsol/5.6

# Set licence variable
setenv LMCOMSOL_LICENSE_FILE  <port@licence file location>

# Execute the comsole batch command
# Note: review comsol batch -help for options available
srun comsol batch -inputfile <path/inputfile> \
             -outputfile <path/outputfile name> \
             -batchlog <path/logfile name>
                         
wait
echo "$0 : Done!"
date
#EOF
