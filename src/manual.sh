#!/encs/bin/tcsh

##
## Job Scheduler options 
##

#$ -N speed-manual # job name
#$ -cwd            # Run from directory that script is in, e.g., your speed-scratch directory
#$ -m bea          # Email notifications at job's start and end, or on abort
#$ -pe smp 2       # Request 2 slots from parellel environment 'smp'
#$ -l h_vmem=1G    # set resource value h_vmem (hard virtual memory size) to 1G
                
##
## Job to run
##

# timestamp
echo "$0 : about to run Speed manual generation job on Speed :-)"
date

# Pull speed-hpc sources latest commit only to avoid
# downloading all the history. For fun time the longer
# running commands.
time git clone --depth 1 --branch master https://github.com/NAG-DevOps/speed-hpc.git

# We need to be in the doc directory
cd speed-hpc/doc
pwd

# Generate PDF manual
time make

# Generate the HTML manual
time make html

# Report generated files
ls -al *.pdf web/*
git status

echo "$0 : Done!"
date

# EOF
