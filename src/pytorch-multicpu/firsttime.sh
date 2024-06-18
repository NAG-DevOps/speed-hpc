#!/encs/bin/tcsh

#### Virtual ENV creation. One time only.
#### Run after salloc to a compute node!

cd /speed-scratch/$USER
module load python/3.9.18/default
setenv TMP /speed-scratch/$USER/tmp
setenv TMPDIR /speed-scratch/$USER/tmp
python -m venv $TMPDIR/pytorchcpu
source $TMPDIR/pytorchcpu/bin/activate.csh
pip install torch torchvision
pip install urllib3==1.26.6
deactivate

#### END of VEnv creation
