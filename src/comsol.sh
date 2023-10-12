#!/encs/bin/tcsh

##
## Job Scheduler options 
##

#$ -N comsole_job  # job name
#$ -cwd            # Run from directory that script is in, e.g., your speed-scratch directory
#$ -m bea          # Email notifications at job's start and end, or on abort
#$ -pe smp 8       # Request 8 slots from parellel environment 'smp'
#$ -l h_vmem=500G  # set resource value h_vmem (hard virtual memory size) to 500G
                
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
comsol batch -inputfile <path/inputfile> \
             -outputfile <path/outputfile name> \
             -batchlog <path/logfile name>
                         
echo "$0 : Done!"
date

#EOF
