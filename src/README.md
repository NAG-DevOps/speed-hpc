# Environments #
Speed: Gina Cody School HPC Facility: Virtual Environment Creation documentation

The following documentation is specific to **speed**.

## Anaconda ##

### Create an Environment ###
To create an anaconda environment in your speed-scratch directory, use the `--prefix` option when executing `conda create`. 

For example:
`conda create --prefix /speed-scratch/<encs_username>/myconda`

Without the `--prefix` option, `conda create` creates the environment in your home directory by default.

### List Environments ###
To view your conda environments, type 
`conda info --envs`

```
# conda environments:
#
base                  *  /encs/pkg/anaconda3-2019.07/root
                         /speed-scratch/<encs_username>/myconda
```                 

### Activate an Environment ###
Activate the environment `/speed-scratch/<encs_username>/myconda` as follows

`conda activate /speed-scratch/<encs_username>/myconda`

After activating your environment, add pip to your environment by using 

`conda install pip`

This will install pip and pip's dependencies, including python.

**Important Note:** pip (and pip3) are used to install modules from the python distribution while `conda install` installs modules from anaconda's repository.

## efficientdet ##

The following steps describing how to create an efficientdet environment on speed, were submitted by a member of Dr. Amer's Research Group.

* Enter your ENCS user account's speed-scratch directory `cd /speed-scratch/<encs_username>`
* load python `module load python/3.8.3`
* create virtual environment `python3 -m venv <env_name>`
* activate virtual environment `source <env_name>/bin/activate.csh`
* install DL packages for Efficientdet
```python
pip install tensorflow==2.7.0
pip install lxml>=4.6.1
pip install absl-py>=0.10.0
pip install matplotlib>=3.0.3
pip install numpy>=1.19.4
pip install Pillow>=6.0.0
pip install PyYAML>=5.1
pip install six>=1.15.0
pip install tensorflow-addons>=0.12
pip install tensorflow-hub>=0.11
pip install neural-structured-learning>=1.3.1
pip install tensorflow-model-optimization>=0.5
pip install Cython>=0.29.13
pip install git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI
```

## Openiss-reid-tfk ##

The following steps will provide the information required to execute the *OpenISS Person Re-Identification Baseline* Project (https://github.com/carlos-encs/openiss-reid-tfk) on *SPEED*
### Environment ###

The pre-requisites to prepare the environment are located in `environment.yml`. (https://github.com/carlos-encs/openiss-reid-tfk)

Using a test dataset (Market1501) and 2 epochs as an example, we ran the script and the results were the following:

Workstation: Intel(R) Core(TM) i7-10700 CPU @ 2.90GHz --- 4hrs  
Speed 1 GPU: 1hr 30min  
Speed CPU - 32 cores: 1hr 4min  

TEST DATASET: Market1501

---- Train images: 12936

---- Query images: 3368

---- Gallery images: 15913

### Prepare ###

Once logged into Speed, go to your speed-scratch directory:  `cd /speed-scratch/$USER/` and clone/download this git repository: https://github.com/carlos-encs/openiss-reid-tfk.

```
**IMPORTANT**  
Modify the script `openiss-2-speed.sh` to setup the job to be ready for CPUs or GPUs nodes; h_vmem= and gpu= CAN'T be enabled at the same time, more information about these parameters on https://github.com/NAG-DevOps/speed-hpc/blob/master/doc/speed-manual.pdf
```

### Run ###

The script `openiss-2-speed.sh` will prepare the environment and run `reid.py`

To submit the job to speed:

On CPUs nodes: `qsub ./openiss-2-speed.sh`  
On GPUs nodes: `qsub -q g.q ./openiss-2-speed.sh`

## CUDA ##

When calling CUDA within job scripts, it is important to create a link to the desired CUDA libraries and set the runtime link path to the same libraries. For example, to use the cuda-11.5 libraries, specify the following in your Makefile.
```
-L/encs/pkg/cuda-11.5/root/lib64 -Wl,-rpath,/encs/pkg/cuda-11.5/root/lib64
```
In your job script, specify the version of `gcc` to use prior to calling cuda. For example: 
   `module load gcc/8.4`
or
   `module load gcc/9.3`
 
  
### Special Notes for sending CUDA jobs to the GPU Queue(`g.q`) ###

It is not possible to create an interactive `qlogin` session to **GPU Queue** (`g.q`) nodes. As direct login to these nodes is not available, batch jobs must be submitted to the **GPU Queue** with `qsub` in order to compile and link.

We have several versions of CUDA installed in:
```
/encs/pkg/cuda-11.5/root/
/encs/pkg/cuda-10.2/root/
/encs/pkg/cuda-9.2/root
```

For CUDA to compile properly for the GPU queue, edit your Makefile replacing `/usr/local/cuda` with one of the above.
