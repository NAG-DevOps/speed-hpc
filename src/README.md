# Examples

This directory has example job scripts and some tips and tricks how to
run certcain things.

## Sample Jobs

These are examples either trivial or some are more elaborate. Some are described in the [manual](../doc/) more in detail or vice versa. The examples were written by the Speed team as well as contributed by the users or a result of solving a problem of some kind.

- Basic examples:
  - `tcsh.sh` -- default `tcsh` job script example
  - `tmpdir.sh` -- example use of TMPDIR on a local node
  - `bash.sh` -- example use with `bash` shell as opposed to `tcsh`
  - `manual.sh` -- example job to compile our very manual here to PDF and HTML using LaTeX
- Common packages:
  - `fluent.sh` -- Fluent job
  - `comsol.sh` -- Comsol job
  - `matlab-sge.sh` -- MATLAB job
- Advanced or research examples:
  - `msfp-speed-job.sh` -- MAC Spoofer Investigation starter job script (for detailes see [here](https://dx.doi.org/10.1145/2641483.2641540) and [here](https://dx.doi.org/10.1007/978-3-319-17040-4_11))
  - `efficientdet.sh` -- `efficientdet` with Conda environment described below
  - `gurobi-with-python.sh` -- using Gurobi with Python and Python virtual environment
  - `lambdal-singularity.sh` -- an example use of the Singularity container to run LambdaLabs software stack on the GPU node. The container was built from the docker image as a [source](https://github.com/NAG-DevOps/lambda-stack-dockerfiles).
# Creating Environments and Compiling Code on Speed

## Correct Procedure
### Overview of preparing environments, compiling code and testing:
- Create a qlogin session to the queue you wish to run your jobs 
(e.g. qlogin -q g.q -l gpu=1 for GPU jobs )  
- Within the qlogin session, create and activate an Anaconda environment in 
your /speed-scratch/ directory using the instructions found in Section 2.11.1 of the manual: 
https://nag-devops.github.io/speed-hpc/#creating-virtual-environments
- Compile your code within the environment.
- Test your code with a limited data set.
- Once you are satisfied with your test results, exit your qlogin session.

### Once your environment and code have been tested
- Create a job script. (see https://nag-devops.github.io/speed-hpc/#job-submission-basics)
- Remember to Activate your Anaconda environment in the user scripting section
- Use the qsub command to submit your job script to the correct queue
## Do not use the submit node to create environments or compile code
- Speed-submit is a virtual machine intended to submit user jobs to 
the grid engine's scheduler. It is not intended to compile or run code. 
- Importantly, speed-submit does not have GPU drivers. This means that code compiled on speed-submit will not be compiled against GPU drivers. 
- Processes run outside of the scheduler on speed-submit will be killed and you will lose your work.

## PIP
By default, pip installs packages to a system-wide default location.

Creating environments via pip shound NOT be done outside of an Anaconda environment.

Why you should create an Anaconda environment and not use pip directly from the 
command line:
- Using pip directly from the command line affects the system wide environment. If all users
use pip in this way, the packages and versions installed via pip may change while your jobs run.
- Creating Anaconda environments allows you to fully control what python packages, and their versions, are within that environment.
- It is possible to create multiple conda environments for your different projects.
## Environments

Virtual Environment Creation documentation. The following documentation is specific to **Speed**.

### Anaconda

#### Load the Anaconda module
To view the Anaconda modules available, run
`module avail anaconda`

Load the desired version of anaconda using the module load command.

For example:
`module load anaconda3`

#### Initialize Shell
To initialize your shell, run
`conda init <SHELL_NAME>`

The default shell for ENCS accounts is tcsh. Therefore, to initialize your default shell run
`conda init tcsh`

#### Create an Environment
To create an anaconda environment in your speed-scratch directory, use the `--prefix` option when executing `conda create`. 

For example:
`conda create --prefix /speed-scratch/$USER/myconda`

Where `$USER` is an environment variable containing your encs_username

Without the `--prefix` option, `conda create` creates the environment in your home directory by default.

#### List Environments
To view your conda environments, type 
`conda info --envs`

```
# conda environments:
#
base                  *  /encs/pkg/anaconda3-2019.07/root
                         /speed-scratch/<encs_username>/myconda
```                 

#### Activate an Environment
Activate the environment `/speed-scratch/<encs_username>/myconda` as follows

`conda activate /speed-scratch/$USER/myconda`

After activating your environment, add pip to your environment by using 

`conda install pip`

This will install pip and pip's dependencies, including python.

**Important Note:** pip (and pip3) are used to install modules from the python distribution while `conda install` installs modules from anaconda's repository.

### efficientdet

The following steps describing how to create an efficientdet environment on speed, were submitted by a member of Dr. Amer's Research Group.

* Enter your ENCS user account's speed-scratch directory `cd /speed-scratch/$USER`
* load python `module load python/3.8.3`
* create virtual environment `python3 -m venv my_env_name`
* activate virtual environment `source my_env_name/bin/activate.csh`
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

The following steps will provide the information required to execute the *OpenISS Person Re-Identification Baseline* Project (https://github.com/NAG-DevOps/openiss-reid-tfk) on *SPEED*
### Environment ###

The pre-requisites to prepare the environment are located in `environment.yml`. (https://github.com/NAG-DevOps/openiss-reid-tfk)

Using a test dataset (Market1501) and 120 epochs as an example, we ran the script and the results were the following:

Speed 1 GPU: 5hrs 25min

Speed CPU - 32 cores: 2 days 22 hours

TEST DATASET: Market1501

---- Train images: 12936

---- Query images: 3368

---- Gallery images: 15913

### Configuration and execution ###

- Log into Speed, go to your speed-scratch directory:  `cd /speed-scratch/$USER/`
- Clone the repo from https://github.com/NAG-DevOps/openiss-reid-tfk
- Download the dataset:  go to datasets/ and run get_dataset_market1501.sh
- In reid.py set the epochs (g_epochs=120 by default)
- Download openiss-2-speed.sh from this repository
- On environment.yml comment or uncomment tensorflow accordingly (for CPU or GPU, GPU is default)
- On openiss-2-speed.sh comment or uncomment the secction accordingly (for CPU or GPU)
- Submit the job:

   On CPUs nodes: `qsub ./openiss-2-speed.sh`

   On GPUs nodes: `qsub -q g.q ./openiss-2-speed.sh`

**IMPORTANT**  
Modify the script `openiss-2-speed.sh` to setup the job to be ready for CPUs or GPUs nodes; h_vmem= and gpu= CAN'T be enabled at the same time, more information about these parameters on https://github.com/NAG-DevOps/speed-hpc/blob/master/doc/speed-manual.pdf

## CUDA ##

When calling CUDA within job scripts, it is important to create a link to the desired CUDA libraries and set the runtime link path to the same libraries. For example, to use the cuda-11.5 libraries, specify the following in your Makefile.
```
-L/encs/pkg/cuda-11.5/root/lib64 -Wl,-rpath,/encs/pkg/cuda-11.5/root/lib64
```
In your job script, specify the version of `gcc` to use prior to calling cuda. For example: 
   `module load gcc/8.4`
or
   `module load gcc/9.3`

### Special Notes for sending CUDA jobs to the GPU Queue (`g.q`)

It is not possible to create an interactive `qlogin` session to **GPU Queue** (`g.q`) nodes. As direct login to these nodes is not available, batch jobs must be submitted to the **GPU Queue** with `qsub` in order to compile and link.

We have several versions of CUDA installed in:
```
/encs/pkg/cuda-11.5/root/
/encs/pkg/cuda-10.2/root/
/encs/pkg/cuda-9.2/root
```

For CUDA to compile properly for the GPU queue, edit your `Makefile` replacing `/usr/local/cuda` with one of the above.


## Python Modules

By default when adding a python module /tmp is used for the temporary repository of files downloaded. /tmp on speed_submit is too small for pytorch.

To add a python module:

- First create you own tmp directory in /speed-scratch
  - `mkdir /speed-scratch/$USER/tmp`
- Use the tmp direcrtory you created
  - `setenv TMPDIR /speed-scratch/$USER/tmp`
- Attempt the installation of pytorch

Where `$USER` is an environment variable containing your encs_username

