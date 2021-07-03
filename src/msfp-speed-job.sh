#!/encs/bin/tcsh

# Serguei Mokhov
# UGE-based job invocation script
# mac-spoofer-flucid-processor is a Perl script -- the actual job

##
## Job scheduler options
##

# Run from the current directory where this script is
#$ -cwd

# High value of memory requeted
#$ -l h_vmem=20G
#$ -ac hv=8

# Number of cores requested (approx).
# Includes 4 Perl/Java processes per claim type
#$ -pe smp 8

# Notifications
#$ -m bea

##
## Job to run
##

# 
# The $RT variable is initialized on the command line 
# via -v to qsub, like, `qsub -v RT=123 ...'

echo "$0 : about to run mac-spoofer-flucid-processor on Speed"
mac-spoofer-flucid-processor $RT

# EOF
