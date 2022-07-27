#!/encs/bin/tcsh

# Assigns a name to the job
#$ -N matlab-job-test 

# Tells the scheduler to execute the job from the current working directory
#$ -cwd

# Sends e-mail notications (begin/end/abort)
#$ -m bea

# How many GPUs (currently limit is set 2 max for Speed 5 and 17)
#$ -l gpu=2

# Loads matlab module version
module load matlab/R2022a/default

# Displays to the output file whether the module(s) is(are) loaded correctly <OPTIONAL> 
module list

# Matlab parameters - add/modify/remove them according your script

# -singleCompThread: Forces MATLAB to run single-threaded
# -nodesktop -nodisplay: Launches Matlab in the terminal
# -nojvm : Tells Matlab to run without the Java Virtual Machine to reduce overhead
# test.m : Matlab commands file

matlab -singleCompThread -nodisplay -nodesktop -nojvm < test.m
