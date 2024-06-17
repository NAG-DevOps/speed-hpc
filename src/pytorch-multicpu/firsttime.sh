#### Virtual ENV creation. One time only:
#!/encs/bin/tcsh
cd /speed-scratch/$USER
salloc -p ps --mem=20Gb -A Your_group_id(if you have one)
module load python/3.9.18/default
setenv TMP /speed-scratch/$USER/tmp
setenv TMPDIR /speed-scratch/$USER/tmp
python -m venv $TMPDIR/pytorchcpu
source $TMPDIR/pytorchcpu/bin/activate.csh
pip install torch torchvision
pip install urllib3==1.26.6
deactivate
### END of VEnv creation