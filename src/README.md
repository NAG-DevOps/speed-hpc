<!-- TOC --><a name="examples"></a>
# Examples

This directory has example job scripts and some tips and tricks how to
run certcain things.

## TOC 

- [Sample Jobs](#sample-jobs)
- [Creating Environments and Compiling Code on Speed](#creating-environments-and-compiling-code-on-speed)
   * [Correct Procedure](#correct-procedure)
      + [Overview of preparing environments, compiling code and testing](#overview-of-preparing-environments-compiling-code-and-testing)
      + [Once your environment and code have been tested](#once-your-environment-and-code-have-been-tested)
      + [Do not use the submit node to create environments or compile code](#do-not-use-the-submit-node-to-create-environments-or-compile-code)
      + [`pip`](#pip)
   * [Environments](#environments)
      + [Anaconda](#anaconda)
         - [Load the Anaconda module](#load-the-anaconda-module)
         - [Initialize Shell](#initialize-shell)
         - [Create an Environment](#create-an-environment)
         - [List Environments](#list-environments)
         - [Activate an Environment](#activate-an-environment)
- Detailed Examples
   + [efficientdet](#efficientdet)
   * [Diviner Tools](#diviner-tools)
   * [OpenFoam](#openfoam-multinode)
   * [OpenISS-yolov3](#openiss-yolov3)
      + [Speed Login Configuration ](#speed-login-configuration)
      + [Speed Setup and Development Environment Preperation](#speed-setup-and-development-environment-preperation)
      + [Run Interactive Script ](#run-interactive-script)
      + [Run Non-interactive Script ](#run-non-interactive-script)
      + [Performance comparison](#performance-comparison)
   * [OpenISS-reid-tfk](#openiss-reid-tfk)
      + [Environment](#environment)
      + [Configuration and execution](#configuration-and-execution)
   * [CUDA](#cuda)
      + [Special Notes for sending CUDA jobs to the GPU Partition (`pg`)](#special-notes-for-sending-cuda-jobs-to-the-gpu-partition-pg)
      + [Jupyter notebook example: Jupyter-Pytorch-CUDA](#jupyter-example-gpu-pytorch)
   * [Python Modules](#python-modules)

<!-- TOC end -->

<!-- TOC --><a name="sample-jobs"></a>
## Sample Jobs

These are examples either trivial or some are more elaborate. Some are described in the [manual](../doc/) more in detail or vice versa. The examples were written by the Speed team as well as contributed by the users or a result of solving a problem of some kind.

- Basic examples:
  - `tcsh.sh` -- default `tcsh` job script example
  - `tmpdir.sh` -- example use of TMPDIR on a local node
  - `bash.sh` -- example use with `bash` shell as opposed to `tcsh`
  - `manual.sh` -- example job to compile our very manual here to PDF and HTML using LaTeX
  - `poppler.txt` -- Interactive job example: PDF rendering using poppler and pdf2image; instructions and code ready to paste.
- Common packages:
  - `fluent.sh` -- Fluent job
  - `comsol.sh` -- Comsol job
  - `matlab-sge.sh` -- MATLAB job
- Advanced or research examples:
  - `msfp-speed-job.sh` -- MAC Spoofer Investigation starter job script (for detailes see [here](https://dx.doi.org/10.1145/2641483.2641540) and [here](https://dx.doi.org/10.1007/978-3-319-17040-4_11))
  - `efficientdet.sh` -- `efficientdet` with Conda environment described below
  - `gurobi-with-python.sh` -- using Gurobi with Python and Python virtual environment
  - `pytorch-multicpu.txt` -- using Pytorch with Python virtual environment to run on CPUs; with instructions and code ready to paste.
  - `pytorch-multinode-multigpu.sh` -- using Pytorch with Python virtual environment to run on Multinodes and MultiGpus
  - `lambdal-singularity.sh` -- an example use of the Singularity container to run LambdaLabs software stack on the GPU node. The container was built from the docker image as a [source](https://github.com/NAG-DevOps/lambda-stack-dockerfiles).
  - `openfoam-multinode.sh` -- an example using OpenFoam, icoFoam solver to run on Multinodes-multicpus
  - `openiss-reid-speed.sh` -- OpenISS computer vision exame for re-edentification, see [more](https://github.com/NAG-DevOps/speed-hpc/tree/master/src#openiss-reid-tfk) in its section
  - `openiss-yolo-cpu.sh`, `openiss-yolo-gpu.sh`, and `openiss-yolo-interactive.sh` -- OpenISS examples with YOLO, related to `reid`, see [more](https://github.com/NAG-DevOps/speed-hpc/tree/master/src#openiss-yolov3) in the corresponding section

<!-- TOC --><a name="creating-environments-and-compiling-code-on-speed"></a>
# Creating Environments and Compiling Code on Speed

<!-- TOC --><a name="correct-procedure"></a>
## Correct Procedure

<!-- TOC --><a name="overview-of-preparing-environments-compiling-code-and-testing"></a>
### Overview of preparing environments, compiling code and testing

- Create an `salloc` session to the queue you wish to run your jobs 
(e.g., `salloc -p pg --gpus=1` for GPU jobs)
- Within the `salloc` session, create and activate an Anaconda environment in 
your `/speed-scratch/` directory using the instructions found in Section 2.11.1 of the manual: 
https://nag-devops.github.io/speed-hpc/#creating-virtual-environments
- Compile your code within the environment.
- Test your code with a limited data set.
- Once you are satisfied with your test results, exit your `salloc` session.

<!-- TOC --><a name="once-your-environment-and-code-have-been-tested"></a>
### Once your environment and code have been tested

- Create a job script. (see https://nag-devops.github.io/speed-hpc/#job-submission-basics)
- Remember to Activate your Anaconda environment in the user scripting section
- Use the `sbatch` command to submit your job script to the correct partition and account

<!-- TOC --><a name="do-not-use-the-submit-node-to-create-environments-or-compile-code"></a>
### Do not use the submit node to create environments or compile code

- `speed-submit` is a virtual machine intended to submit user jobs to 
the job scheduler. It is not intended to compile or run code. 
- **Importantly**, `speed-submit` does not have GPU drivers. This means that code compiled on `speed-submit` will not be compiled against proper GPU drivers. 
- Processes run outside of the scheduler on `speed-submit` will be killed and you will lose your work.

<!-- TOC --><a name="pip"></a>
### `pip`

By default, `pip` installs packages to a system-wide default location.

Creating environments via `pip` shound NOT be done outside of an Anaconda environment.

Why you should create an Anaconda environment and not use pip directly from the 
command line:
- Using pip directly from the command line affects the system wide environment. If all users
use pip in this way, the packages and versions installed via pip may change while your jobs run.
- Creating Anaconda environments allows you to fully control what python packages, and their versions, are within that environment.
- It is possible to create multiple conda environments for your different projects.

<!-- TOC --><a name="environments"></a>
## Environments

Virtual Environment Creation documentation. The following documentation is specific to **Speed**.

<!-- TOC --><a name="anaconda"></a>
### Anaconda

<!-- TOC --><a name="load-the-anaconda-module"></a>
#### Load the Anaconda module

To view the Anaconda modules available, run
`module avail anaconda`

Load the desired version of anaconda using the module load command.

For example:
`module load anaconda3/2023.03/default`

<!-- TOC --><a name="initialize-shell"></a>
#### Initialize Shell
To initialize your shell, run
`conda init <SHELL_NAME>`

The default shell for ENCS accounts is tcsh. Therefore, to initialize your default shell run
`conda init tcsh`

<!-- TOC --><a name="create-an-environment"></a>
#### Create an Environment
To create an anaconda environment in your speed-scratch directory, use the `--prefix` option when executing `conda create`. 

For example:
`conda create --prefix /speed-scratch/$USER/myconda`

Where `$USER` is an environment variable containing your encs_username

Without the `--prefix` option, `conda create` creates the environment in your home directory by default.

<!-- TOC --><a name="list-environments"></a>
#### List Environments
To view your conda environments, type 
`conda info --envs`

```
# conda environments:
#
base                  *  /encs/pkg/anaconda3-2023.03/root
                         /speed-scratch/<encs_username>/myconda
```                 

<!-- TOC --><a name="activate-an-environment"></a>
#### Activate an Environment
Activate the environment `/speed-scratch/<encs_username>/myconda` as follows

`conda activate /speed-scratch/$USER/myconda`

After activating your environment, add pip to your environment by using 

`conda install pip`

This will install pip and pip's dependencies, including python.

**Important Note:** pip (and pip3) are used to install modules from the python distribution while `conda install` installs modules from anaconda's repository.

<!-- TOC --><a name="no-space-left-conda"></a>
#### No Space left error when creating Conda Environment
You are using your /home directory as conda default directory, the tarballs and pkgs are using all the space

`conda clean --all --dry-run` will show you the size of tarballs, packages, caches
`conda clean -all` will wipe-out all unused packages, caches and tarballs

If the `conda clean` hasn't freed enough space, try to set change the location of Conda pkgs to another directory, e.g:
```
setenv CONDA_PKGS_DIRS /speed-scratch/$USER/tmp/pkgs
```

<!-- TOC --><a name="create-conda-env-speed"></a>
#### Example: Create Conda Environment in Speed
On speed-submit:
`salloc --mem=10Gb -n1 -pps`

On the node where the interactive session is running:

```
setenv TMPDIR /speed-scratch/$USER/tmp
setenv TMP /speed-scratch/$USER/tmp
module load anaconda3/2023.03/default
setenv CONDA_PKGS_DIRS $TMP/pkgs
conda create -p $TMP/Venv-Name python==3.11
conda activate $TMP/Venv-Name
```

<!-- TOC --><a name="efficientdet"></a>
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

<!-- TOC --><a name="diviner-tools"></a>
## Diviner Tools

[Diviner Tools](https://github.com/d-chante/diviner-tools) is a custom library for pre-processing Diviner RDR LVL1 Channel 7 data by [Chantelle Dubois](https://github.com/d-chante).

- [Speed-related scripts](https://github.com/d-chante/diviner-tools/tree/development/jobs/speed)

<!-- TOC --><a name="openfoam-multinode"></a>
## OpenFoam-multinode

This example is taken from OpenFoam tutorials section: $FOAM_TUTORIALS/incompressible/icoFoam/cavity/cavity
1. Go to your speed-scratch directory: `cd /speed-scratch/$USER`
2. open a salloc session
3. Load OpenFoam module: `module load OpenFOAM/v2306/default`
4. Copy the cavity example to your speed-scratch space: `cp -r $FOAM_TUTORIALS/incompressible/icoFoam/cavity/cavity/ .`
5. Modify cavity/system/decomposeParDict: 
   Remove coeffs section and modify the following:
         numberOfSubdomains  10;
         method  scotch;
6. Exit the salloc session, go to the cavity directory and run the script: `sbatch --mem=10Gb -pps --constraint=el9 openfoam-multinode.sh`

<!-- TOC --><a name="openiss-yolov3"></a>
## OpenISS-yolov3

This is a case study example on image classification, for more details please visit [openiss-yolov3](https://github.com/NAG-DevOps/openiss-yolov3).

<!-- TOC --><a name="speed-login-configuration"></a>
### Speed Login Configuration 
1. As an interactive option is supported that show live video, you will need to enable ssh login with -X support. Please check this [link](https://www.concordia.ca/ginacody/aits/support/faq/xserver.html) to do that.
2. If you didn't know how to login to speed and prepare the working environment please check the manual in the follwing [link](https://github.com/NAG-DevOps/speed-hpc/blob/master/doc/speed-manual.pdf) section 2.

After you logged in to speed change your working directory to `/speed-scratch/$USER` directory.
```
cd /speed-scratch/$USER/
```

<!-- TOC --><a name="speed-setup-and-development-environment-preperation"></a>
### Speed Setup and Development Environment Preperation

The pre-requisites to prepare the virtual development environment using anaconda is explained in [speed manual](https://github.com/NAG-DevOps/speed-hpc/blob/master/doc/speed-manual.pdf) section 3, please check that for more inforamtion.
1. Make sure you are in speed-scratch directory. Then Download OpenISS yolo3 project from [Github](https://github.com/NAG-DevOps/openiss-yolov3) to your speed-scratch proper diectory. 
```
cd /speed-scratch/$USER/
git clone --depth=1 https://github.com/NAG-DevOps/openiss-yolov3.git
```
2. Starting by loading anaconda module 
```
module load anaconda3/2023.03/default
```
3. Switch to the project directoy. Create anaconda virtual environment, and configure development librires. The name of the environment can by any name here as an example named YOLO. Activate the conda environment YOLOInteractive.
```
cd /speed-scratch/$USER/openiss-yolov3
conda create -p /speed-scratch/$USER/YOLO
conda activate /speed-scratch/$USER/YOLO
```
4. Install all required libraries you need and upgrade pip to install `opencv-contrib-python` library 

```
conda install python=3.5
conda install Keras=2.1.5
conda install Pillow
conda install matplotlib
conda install -c menpo opencv
pip install --upgrade pip 
pip install opencv-contrib-python
```

5. Validate conda environemnt and installed packages using following commands. Make sure the version of python and keras are same as requred.
```
conda info --env
conda list
```
if you need to delete the created virtual environment 
```
conda deactivate
conda env remove -p /speed-scratch/$USER/YOLO
```

<!-- TOC --><a name="run-interactive-script"></a>
### Run Interactive Script 

File `openiss-yolo-interactive.sh` is the speed script to run video example to run it you follow these steps:
1. Run interactive job we need to keep `ssh -X` option enabled and `Xming` server in your windows is working (MobaXterm provides an alternative; on macOS use XQuartz). 
2. The `sbatch` is not the proper command since we have to keep direct ssh connection to the computational node, so `salloc` will be used. 
3. Enter `salloc` in the `speed-submit`. The `salloc` will find an approriate computational node then it will allow you to have direct `ssh -X` login to that node. Make sure you are in the right directory and activate conda environment again.
```
salloc --x11=first -t 60 -n 16 --mem=40G -p pg
cd /speed-scratch/$USER/openiss-yolov3
conda activate /speed-scratch/$USER/YOLO
```
4. Before you run the script you need to add permission access to the project files, then start run the script `./openiss-yolo-interactive.sh`    
```
chmod u+x *.sh
./openiss-yolo-interactive.sh
```
5. A pop up window will show a classifed live video. 

Please note that since we have limited number of nodes with GPU support `salloc` the interactive sessions are time-limited to max 24h. 

<!-- TOC --><a name="run-non-interactive-script"></a>
### Run Non-interactive Script 

Before you run the script you need to add permission access to the project files using `chmod` command.   
```
chmod u+x *.sh
```
To run the script you will use `sbatch`, you can run the task on CPU or GPU compute nodes as follwoing:
1. For CPU nodes use `openiss-yolo-cpu.sh` file 
```
sbatch ./openiss-yolo-cpu.sh
```

2. For GPU nodes use `openiss-yolo-gpu.sh` file with option -p to specify a GPU partition (`pg`) for submission.
```
sbatch -p pg ./openiss-yolo-gpu.sh
```

For Tiny YOLOv3, just do in a similar way, just specify model path and anchor path with `--model model_file` and `--anchors anchor_file`.

<!-- TOC --><a name="performance-comparison"></a>
### Performance comparison

Time is in minutes, run Yolo with different hardware configurations GPU types V100 and Tesla P6. Please note that there is an issue to run Yolo project on more than one GPU in case of teasla P6. The project use  keras.utils library calling `multi_gpu_model()` function, which cause hardware faluts and force to restart the server. GPU name for V100 (gpu32), for P6 (gpu16) you can find that in scripts shell.    

|   1GPU-P6     |    1GPU-V100  |    2GPU-V100  |    32CPU       |
| --------------|-------------- |-------------- |----------------|
|    22.45      |   17.15       |   23.33       |     60.42      |
|    22.15      |   17.54       |   23.08       |     60.18      |
|    22.18      |   17.18       |   23.13       |     60.47      |


<!-- TOC --><a name="openiss-reid-tfk"></a>
## OpenISS-reid-tfk

The following steps will provide the information required to execute the *OpenISS Person Re-Identification Baseline* Project (https://github.com/NAG-DevOps/openiss-reid-tfk) on *SPEED*

<!-- TOC --><a name="environment"></a>
### Environment

The pre-requisites to prepare the environment are located in `environment.yml` (https://github.com/NAG-DevOps/openiss-reid-tfk).

Using a test dataset (Market1501) and 120 epochs as an example, we ran the script and the results were the following:

Speed 1 GPU: 5hrs 25min

Speed CPU - 32 cores: 2 days 22 hours

TEST DATASET: Market1501

---- Train images: 12936

---- Query images: 3368

---- Gallery images: 15913

<!-- TOC --><a name="configuration-and-execution"></a>
### Configuration and execution

- Log into Speed, go to your speed-scratch directory:  `cd /speed-scratch/$USER/`
- Clone the repo from https://github.com/NAG-DevOps/openiss-reid-tfk
- Download the dataset: go to `datasets/` and run `get_dataset_market1501.sh`
- In `reid.py` set the epochs (`g_epochs=120` by default)
- Download `openiss-reid-speed.sh` from this repository
- On `environment.yml` comment or uncomment tensorflow accordingly (for CPU or GPU, GPU is default)
- On `openiss-reid-speed.sh` comment or uncomment the secction accordingly (for CPU or GPU)
- Submit the job:

   On CPUs nodes: `sbatch ./openiss-reid-speed.sh`

   On GPUs nodes: `sbatch -p pg ./openiss-reid-speed.sh`

**IMPORTANT**

Modify the script `openiss-reid-speed.sh` to setup the job to be ready for CPUs or GPUs nodes; `--mem=` and `gpus=` in particular, see more information about these parameters on https://github.com/NAG-DevOps/speed-hpc/blob/master/doc/speed-manual.pdf


<!-- TOC --><a name="cuda"></a>
## CUDA

When calling CUDA within job scripts, it is important to create a link to the desired CUDA libraries and set the runtime link path to the same libraries. For example, to use the `cuda-11.5` libraries, specify the following in your `Makefile`.
```
-L/encs/pkg/cuda-11.5/root/lib64 -Wl,-rpath,/encs/pkg/cuda-11.5/root/lib64
```
In your job script, specify the version of `gcc` to use prior to calling cuda. For example: 
   `module load gcc/8.4`
or
   `module load gcc/9.3`

<!-- TOC --><a name="special-notes-for-sending-cuda-jobs-to-the-gpu-partition-pg"></a>
### Special Notes for sending CUDA jobs to the GPU Partition (`pg`)

Interactive jobs (easier to debug) should be submitted to the **GPU Queue** with `salloc` in order to compile and link CUDA code.

We have several versions of CUDA installed in:
```
/encs/pkg/cuda-11.5/root/
/encs/pkg/cuda-10.2/root/
/encs/pkg/cuda-9.2/root
```

For CUDA to compile properly for the GPU queue, edit your `Makefile` replacing `/usr/local/cuda` with one of the above.

<!-- TOC --><a name="jupyter-example-gpu-pytorch"></a>
### Jupyter notebook example: Jupyter-Pytorch-CUDA

Example prepared to run on speed, extracted from: https://developers.redhat.com/learning/learn:openshift-data-science:configure-jupyter-notebook-use-gpus-aiml-modeling/resource/resources:how-examine-gpu-resources-pytorch

From speed-submit: 
- Download `gpu-ml-model.ipynb` from this github to your `/speed-scratch/$USER space`
- `salloc --mem=10Gb --gpus=1`

From the node (interactive session):
- `module load singularity/3.10.4/default`
- `srun singularity exec -B $PWD\:/speed-pwd,/speed-scratch/$USER\:/my-speed-scratch,/nettemp --env SHELL=/bin/bash --nv /speed-scratch/nag-public/jupyter-pytorch-cuda.sif /bin/bash -c '/opt/conda/bin/jupyter notebook --no-browser --notebook-dir=/speed-pwd --ip="*" --port=8888 --allow-root'`
- Follow the steps described in: https://nag-devops.github.io/speed-hpc/#jupyter-notebooks
- When Jupyter is running on the browser, open `gpu-ml-model.ipynb` and run each cell

<!-- TOC --><a name="python-modules"></a>
## Python Modules

By default when adding a python module `/tmp` is used for the temporary repository of files downloaded. `/tmp` on speed-submit is too small for pytorch.

To add a python module:

- First create you own tmp directory in /speed-scratch
  - `mkdir /speed-scratch/$USER/tmp`
- Use the tmp direcrtory you created
  - `setenv TMPDIR /speed-scratch/$USER/tmp`
- Attempt the installation of pytorch

Where `$USER` is an environment variable containing your GCS ENCS username
