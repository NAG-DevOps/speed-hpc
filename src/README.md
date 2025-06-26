<!-- TOC --><a name="examples"></a>
# Examples

This directory has example job scripts and some tips and tricks how to
run certcain things.

<!-- TOC start -->
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
      + [Prerequisites](#prerequisites-openiss-yolov3)
      + [Configuration and Execution](#configuration-and-execution-openiss-yolov3)
         - [Run Non-interactive Script](#run-non-interactive-openiss-yolov3)
         - [Run Interactive Script ](#run-interactive-openiss-yolov3)
      + [Performance Comparison](#performance-comparison-openiss-yolov3)
   * [OpenISS-reid-tfk](#openiss-reid-tfk)
      + [Prerequisities](#prerequisites-openiss-reid)
      + [Configuration and execution](#configuration-and-execution)
   * [CUDA](#cuda)
      + [Special Notes for sending CUDA jobs to the GPU Partition (`pg`)](#special-notes-for-sending-cuda-jobs-to-the-gpu-partition-pg)
      + [Jupyter notebook example: Jupyter-Pytorch-CUDA](#jupyter-example-gpu-pytorch)
   * [Python Modules](#python-modules)
<!-- TOC end -->

<!-- TOC --><a name="sample-jobs"></a>
## Sample Jobs

This directory contains a range of job script examples. Some are basic, while others showcase advanced or research-specific workflows. Many are discussed in more detail in the Speed [Manual](https://nag-devops.github.io/speed-hpc/), and others are included here to complement it. They were written by the Speed team, contributed by users, or created as solutions to specific problems.

- Basic Examples:
  - `tcsh.sh` -- Default job script using the `tcsh` shell.
  - `bash.sh` -- Equivalent job script using `bash` shell as opposed to `tcsh`.
  - `tmpdir.sh` -- Demonstrates use of `TMPDIR` on a local node.
  - `manual.sh` -- Builds the Speed manual to PDF and HTML using LaTeX.
  - `poppler/` -- Interactive job example for PDF rendering using poppler and pdf2image. Includes instructions, setup script (`poppler.sh`), python code, and example pdf.

- Common Software Packages:
  - `fluent.sh` -- Example job for ANSYS Fluent.
  - `comsol.sh` -- Job script for COMSOL Multiphysics.
  - `matlab/` -- Incluses batch job for MATLAB.

- Research & Advanced Examples:
  - `msfp-speed-job.sh` -- MAC Spoofer analysis script (see more detailes [here](https://dx.doi.org/10.1145/2641483.2641540) and [here](https://dx.doi.org/10.1007/978-3-319-17040-4_11))
  - `efficientdet.sh` -- Uses a Conda environment for EfficientDet training.
  - `gurobi-with-python.sh` -- Gurobi with Python virtual environment.
  - `pytorch-multicpu/` -- Using Pytorch with Python virtual environment to run on CPUs.
  - `pytorch-multinode-multigpu.sh` -- Using Pytorch with Python virtual environment to run on multiple GPUs and nodes.
  - `lambdal-singularity.sh` -- Uses Singularity container to run LambdaLabs software stack on GPU node. Based on this github repo [Lambda Stack Dockerfiles](https://github.com/NAG-DevOps/lambda-stack-dockerfiles).
  - `openfoam-multinode.sh` -- Runs OpenFOAM’s icoFoam solver across multiple CPU nodes.
  - `openiss-reid-speed.sh` -- OpenISS for person re-identification. See more [here](https://github.com/NAG-DevOps/speed-hpc/tree/master/src#openiss-reid-tfk).
  - `openiss-yolo-speed.sh`, and `openiss-yolo-interactive.sh` -- OpenISS + YOLO demos; more [here](https://github.com/NAG-DevOps/speed-hpc/tree/master/src#openiss-yolov3).
  - `gpaw/` -- Example job scrits for GPAW simulaptions.

  
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
You are using your `$HOME` directory as conda default directory, the tarballs and pkgs are using all the space

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
#### Conda envs without prefix
If you don't want to use the `--prefix` option everytime you create a new environment and you don't want to use the default `$HOME` directory, create a new directory and set CONDA_ENVS_PATH and CONDA_PKGS_DIRS variables to point to the new created directory, e.g:

```
setenv CONDA_ENVS_PATH /speed-scratch/$USER/condas
setenv CONDA_PKGS_DIRS /speed-scratch/$USER/condas/pkg
```

If you want to make these changes permanent, add the variables to your .tcshrc or .bashrc (depending on the default shell you are using)

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

<!-- TOC --><a id="openiss-yolov3"></a>
## OpenISS-yolov3

This is a case study example on image classification, for more details please visit [OpenISS keras-yolo3](https://github.com/NAG-DevOps/openiss-yolov3).

<!-- TOC --><a id="prerequisites-openiss-yolov3"></a>
### Prerequisites

   #### Images and Videos
   Images and videos can be from any source, but a sample video and images are provided in `video` and `image` folders in the [OpenISS-YOLOv3 Github repository](https://github.com/NAG-DevOps/openiss-yolov3).

   #### YOLOv3 Weights
   The YOLOv3 weights can be downloaded from [YOLO website](http://pjreddie.com/darknet/yolo/). However the script provided includes a command to `wget` the weights from the link above.

   #### Environment Setup
   To set up the virtual development environment, refer to section 2.11 of the Speed manual [Creating Virtual Environments](https://nag-devops.github.io/speed-hpc/#anaconda) for detailed information.

<!-- TOC --><a id="configuration-and-execution-openiss-yolov3"></a>
### Configuration and execution
- Log into SPEED and navigate to your `speed-scratch` directory:

      ssh $USER@speed.encs.concordia.ca
      cd /speed-scratch/$USER/

   **Note**: To see a live video in an interactive session, enable X11 forwarding. Linux can run X11, however, to run X server on:
	- Windows: use MobaXterm or Putty
	- MacOS: use XQuarz with its xterm

   For more information refer to [How to Launch X11 applications](https://www.concordia.ca/ginacody/aits/support/faq/xserver.html)

- Clone the [OpenISS-YOLOv3 Github repository](https://github.com/NAG-DevOps/openiss-yolov3)

      git clone --depth=1 https://github.com/NAG-DevOps/openiss-yolov3.git
      cd /speed-scratch/$USER/openiss-yolov3

<!-- TOC --><a id="run-non-interactive-openiss-yolov3"></a>
#### Run Non-interactive Script 
   - Download and run `openiss-yolo-speed.sh` script from [Speed-HPC Github repository](https://github.com/NAG-DevOps/speed-hpc/tree/master/src).

         sbatch ./openiss-yolo-speed.sh

The script performs the following:
   - Configures job resources and paths for Conda environments.
   - Creates, or activates the Conda environment, and installs required packages if necessary.
   - Downloads YOLOv3 weights.
   - Converts the Darknet YOLO model to Keras format.      
   - Runs YOLO inference on a sample video.
   - Deactivates the Conda environment and exits.

<!-- TOC --><a id="run-interactive-openiss-yolov3"></a>
#### Run Interactive Script
   *Note* To run interactive job we need to use `ssh -X`
   - Request resources with `salloc` command

         salloc --x11=first --mem=60G -n 32 --gpus=1 -p pt

   - Download and run `openiss-yolo-interactive.sh` script from [Speed-HPC Github repository](https://github.com/NAG-DevOps/speed-hpc/tree/master/src). You need to add permission access to the project files.

         chmod u+x *.sh 
         ./openiss-yolo-interactive.sh

   - A pop up window will show a classifed live video. 

The script does the following:
   - Prepare and create Conda environment based on `environment.yml`
   - Download YOLOv3 Weights
   - Convert the Darknet YOLO model into a Keras model using `convert.py`
   - Run YOLO inference on a sample video in an intaractive mode

**Note**: If you need to delete the created virtual environment

      conda deactivate
      conda env remove -p /speed-scratch/$USER/envs/yolo_env

   For Tiny YOLOv3, it can be run in the same way, but you will need to specify model path and anchor path with `--model model_file` and `--anchors anchor_file`.

<!-- TOC --><a name="performance-comparison-openiss-yolov3"></a>
### Performance comparison

Time is in minutes, run Yolo with different hardware configurations GPU types V100 and Tesla P6. Please note that there is an issue to run Yolo project on more than one GPU in case of tesla P6. The project uses keras.utils library calling `multi_gpu_model()` function, which cause hardware faluts and force to restart the server. GPU name for V100 is gpu32, and for P6 is gpu16, you can find that in scripts shell.
|   1GPU-P6     |    1GPU-V100  |    2GPU-V100  |    32CPU       |
| --------------|-------------- |-------------- |----------------|
|    22.45      |   17.15       |   23.33       |     60.42      |
|    22.15      |   17.54       |   23.08       |     60.18      |
|    22.18      |   17.18       |   23.13       |     60.47      |

<!-- TOC --><a name="openiss-reid-tfk"></a>
## OpenISS Person Re-Identification Baseline

The following are the steps required to run the *OpenISS Person Re-Identification Baseline* Project (https://github.com/NAG-DevOps/openiss-reid-tfk) on the *Speed* cluster. This implementatoin is based on tensorflow and keras

<!-- TOC --><a name="prerequisites-openiss-reid"></a>
### Prerequisites

#### Dataset
   Using the Market1501 dataset which consist of 
   - Train images: 12,936
   - Query images: 3,368
   - Gallery images: 15,913

   Running for 10 epochs as an example, the results for different Speed configurations were:
   - Using GPU: 29 minute
   - Using CPUs (32 cores): 6 hours and 49 minute

#### Environment Setup
   The environment setup instructions are located in `environment.yml` (https://github.com/NAG-DevOps/openiss-reid-tfk). Ensure all dependencies are correctly installed.

<!-- TOC --><a name="configuration-and-execution"></a>
### Configuration and execution

- Log into Speed and navigate to your speed-scratch directory:
      
      ssh $USER@speed.encs.concordia.ca
      cd /speed-scratch/$USER/

- Clone the GitHub repo from https://github.com/NAG-DevOps/openiss-reid-tfk

- Download the dataset: Navigate to the `datasets/` directory, make the script executable, and run `get_dataset_market1501.sh`:

      chmod u+x *.sh && ./get_dataset_market1501.sh

- Download `openiss-reid-speed.sh` execution script from this repository.

- In `reid.py` set the number of epochs (`g_epochs=120` by default)

- In `environment.yml` comment/uncomment the TensorFlow section depending on whether you are running on CPU or GPU. GPU is enabled by default.

- In `openiss-reid-speed.sh` comment/uncomment the resource allocation lines for either CPU or GPU, depending on the target node (GPU is default). Ensure that only one type (CPU or GPU) is requested.

- Submit the job:

   For CPU nodes: `sbatch ./openiss-reid-speed.sh`

   For GPU nodes: `sbatch -p pg ./openiss-reid-speed.sh`

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
