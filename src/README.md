
This directory has example job scripts and some tips and tricks on how to
run certcain things.

<!-- TOC start -->
**Table of Contents**
- [Sample Jobs](#sample-jobs)
- [Creating Virtual Environments](#creating-virtual-environments)
  - [Procedure](#procedure)
  - [Environments](#environments)
    - [Anaconda](#anaconda)
    - [Python](#python)
  - [Environment Variables](#environment-variables)
  - [CUDA](#cuda)
- [Detailed Examples](#detailed-examples)
  - [efficientdet](#efficientdet)
  - [Diviner Tools](#diviner-tools)
  - [OpenFOAM - Multinode](#openfoam---multinode)
<!-- TOC end -->

<!-- TOC --><a id="sample-jobs"></a>
# Sample Jobs

This directory contains a range of job script examples. Some are basic, while others showcase advanced or research-specific workflows. Many are discussed in more detail in the [Speed Manual](https://nag-devops.github.io/speed-hpc/), and others are included here to complement it. They were created by the Speed team, contributed by users, or developed as solutions to specific problems.
 
- Basic Examples:
  - `bash.sh` -- Batch job script using the `bash` shell.
  - `tcsh.sh` -- Batch job script using the default `tcsh` shell.
  - `tmpdir.sh` -- Demonstrates use of `TMPDIR` on a local node.
  - `manual.sh` -- Builds the Speed manual (PDF and HTML) using LaTeX.
  - `env.sh` -- Prints job environment variables for debugging.
  - [`poppler/`](poppler/) -- Interactive job example for PDF rendering using poppler and pdf2image. Includes instructions, setup script `poppler.sh`, python code, and example pdf.

- Common Software Packages:
  - `comsol.sh` -- Job script for COMSOL Multiphysics.
  - `fluent.sh` -- Example job for ANSYS Fluent.
  - [`matlab/`](matlab/) -- Incluses batch job for MATLAB.
  - [`vscode/`](vscode/) -- Incluses instructions on how to run VS Code both locally and as a web-based version.

- Research & Advanced Examples:
  - `efficientdet.sh` -- Runs EfficientDet model using a Conda environment.
  - `gurobi-with-python.sh` -- Uses Gurobi with a Python virtual environment.
  - `lambdal-singularity.sh` -- Uses Singularity container to run LambdaLabs software stack on GPU node. Based on this github repo [Lambda Stack Dockerfiles](https://github.com/NAG-DevOps/lambda-stack-dockerfiles).
  - `msfp-speed-job.sh` -- MAC Spoofer analysis script (see more detailes [here](https://dx.doi.org/10.1145/2641483.2641540) and [here](https://dx.doi.org/10.1007/978-3-319-17040-4_11))
  - `openfoam-multinode.sh` -- Runs OpenFOAM’s icoFoam solver across multiple CPU nodes.
  - `openiss-reid-speed.sh` -- OpenISS for person re-identification. See more [here](https://github.com/NAG-DevOps/speed-hpc/tree/master/src#openiss-reid-tfk).
  - `openiss-yolo-speed.sh`, and `openiss-yolo-interactive.sh` -- OpenISS + YOLO demos; more [here](https://github.com/NAG-DevOps/speed-hpc/tree/master/src#openiss-yolov3).
  - `pytorch-multinode-multigpu.sh` -- Using Pytorch with Python virtual environment to run on multiple GPUs and nodes.

  - [`gpaw/`](gpaw/) -- Example job scrits for GPAW simulaptions.
  - [`jupyter/`](jupyter/) -- Hands-on examples for launching JupyterLab using Conda.
  - [`llm-examples/`](llm-examples/) -- Examples for running Large Language Models (LLMs) such as LLaMA or BERT.
  - [`pytorch-multicpu/`](pytorch-multicpu/) -- Using Pytorch with Python virtual environment to run on CPUs.
  - [`single-job-multi-mig/`](single-job-multi-mig/) -- Demonstrates how to run a single job using multiple MIGs (Multi-Instance GPU).
  
<!-- TOC --><a id="creating-environments"></a>
# Creating Virtual Environments

<!-- TOC --><a id="procedure"></a>
## Procedure
- Do not compile or create environments on `speed-submit{1|2}`

   These are tiny virtual machines intended for job submission only and lack GPU drivers. All work/processes running outside the scheduler will be terminated.

- Start an Interactive session with `salloc` (e.g., `salloc -p pg --gpus=1`)
- Create and activate your environment

   Use `/speed-scratch/$USER` for all environments.

- Compile and test your code within the environment. Once done, exit your `salloc` session.

- Prepare a job script (refer [Job Submission Basics](https://nag-devops.github.io/speed-hpc/#job-submission-basics))

   Use [Job Script Generator](nag-devops.github.io/speed-hpc/generator.html), and make sure you activate your environment and specify the correct resources.

- Submit your job with `sbatch`

<!-- TOC --><a id="environments"></a>
## Environments
The following documentation is specific to **Speed**.

<!-- TOC --><a id="anaconda"></a>
### Anaconda
- **List available modules for Anaconda and load the required version**.
   ```bash
   module avail anaconda
   module load anaconda3/2023.03/default
   ```

- **Initialize Conda for your shell** (only done once) **and source it** (or log out and log back in)
   ```bash
   conda init tcsh
   source ~/.tcshrc
   ```
   The default shell for ENCS accounts is tcsh.

- **Start an interactive session**
   ```bash
   # For CPU-based environments
   salloc --mem=20G

   # For GPU-based environments
   salloc --mem=20G --gpus=1
   ```

- **Create anaconda environment** (Once per project)

   It is recommended to install the environment in the `/speed-scratch/$USER` directory to avoid quota issues (default conda creates the environment in your home directory), thus we use the `-p` or `--prefix`.
   ```bash
   conda create -p /speed-scratch/$USER/<env_name> -y
   ```
   `$USER` is a parameter, either replace it by your ENCS username or the system will automatically do the work.

   **NOTE** If you don't want to use the `--prefix` option everytime you create a new environment and you don't want to use the default `$HOME` directory, create a new directory and set CONDA_ENVS_PATH and CONDA_PKGS_DIRS variables to point to the new created directory, e.g:
   ```bash
   setenv CONDA_ENVS_PATH /speed-scratch/$USER/condas
   setenv CONDA_PKGS_DIRS /speed-scratch/$USER/condas/pkg
   ```
   If you want to make these changes permanent, add the variables to your .tcshrc or .bashrc (depending on the default shell you are using).

- **Activate the environment**
   ```bash
   conda activate /speed-scratch/$USER/<env_name>
   ```
   After activating the environment, install the required packages for your environment with `conda install` or `pip install`.

- Verify and list your conda environments
   ```bash
   conda info --envs
   # conda environments:
   #
   base                 *  /encs/pkg/anaconda3-2023.03/root
                           /speed-scratch/$USER/<env_name>
   ```

- **Deactivate the environment**
   ```bash
   conda deactivate
   ```

- To delete/remove the environment (if no longer needed)
   ```bash
   conda env remove -p /speed-scratch/$USER/<env_name>
   conda clean --all --yes
   ```

   To resolve "Disk Quota Error", check https://nag-devops.github.io/speed-hpc/#how-to-resolve-disk-quota-exceeded-errors

<!-- TOC --><a id="python"></a>
### Python
- **List available modules for Anaconda and load the required version**.
   ```bash
   module avail python
   module load python/3.11.0/default
   ```
- **Create Python environment and activate it**
  
  It is recommended to install the environment in the `/speed-scratch/$USER` directory to avoid quota issues
  ```bash
  python -m venv /speed-scratch/$USER/<env_name>
  source /speed-scratch/$USER/<env_name>/bin/activate.csh
  ```
- **Install required packages**
  ```bash
  pip install
  ```
- **Deactivate the environment**
  ```bash
  deactivate
  ```

<!-- TOC --><a id="environment-variables"></a>
## Environment Variables
These variables control where temporary files are stored. This helps prevent exceeding disk quotas in your home directory.

Set these variables in your shell before installing packages or running jobs, especially if using Conda or Python virtual environments.

- **For general temporary storage**
  ```bash
  setenv TMP /speed-scratch/$USER/tmp
  setenv TMPDIR /speed-scratch/$USER/tmp
  ```
- **For Python pip cache**
  ```bash
  setenv PIP_CACHE_DIR /speed-scratch/$USER/tmp/cache
  ```
- **For Conda packages**
  ```bash
  setenv CONDA_PKGS_DIRS /speed-scratch/$USER/pkgs
  ```
- **For Hugging Face** (if using Transformers or Datasets)
  ```bash
  setenv HF_HOME /speed-scratch/$USER/huggingface
  setenv HF_HUB_CACHE /speed-scratch/$USER/huggingface/cache
  ```
- **For Singularity containers**
  ```bash
  setenv SINGULARITY_TMPDIR /speed-scratch/$USER/tmp
  setenv SINGULARITY_CACHEDIR /speed-scratch/$USER/tmp/cache
  ```

<!-- TOC --><a id="cuda"></a>
## CUDA

To compile and run CUDA programs on Speed, ensure that the correct CUDA libraries and compatible compiler version are used.

**IMPORTANT** Interactive jobs should be submitted to the **GPU Queue** (`pg`) with `salloc` in order to compile and link CUDA code.

- **Specify CUDA library paths in your Makefile**
   
   Replace `/usr/local/cuda` with the appropriate version. For example, to use CUDA 11.5:
   ```bash
   -L/encs/pkg/cuda-11.5/root/lib64 -Wl,-rpath,/encs/pkg/cuda-11.5/root/lib64
   ```

- **Load the appropriate GCC version in your job script before compiling with CUDA**
   
   For example: 
   ```bash
   module load gcc/8.4 
   # or
   module load gcc/9.3
   ```

<!-- TOC --><a id="sample-jobs"></a>
# Detailed Examples

<!-- TOC --><a id="efficientdet"></a>
## efficientdet

The following steps describing how to create an efficientdet environment on speed, were submitted by a member of Dr. Amer's Research Group.

* Enter your ENCS user account's speed-scratch directory `cd /speed-scratch/$USER`
* load python `module load python/3.8.3`
* create virtual environment `python3 -m venv my_env_name`
* activate virtual environment `source my_env_name/bin/activate.csh`
* install DL packages for Efficientdet
```bash
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

<!-- TOC --><a id="diviner-tools"></a>
## Diviner Tools

[Diviner Tools](https://github.com/d-chante/diviner-tools) is a custom library for pre-processing Diviner RDR LVL1 Channel 7 data by [Chantelle Dubois](https://github.com/d-chante).

- [Speed-related scripts](https://github.com/d-chante/diviner-tools/tree/development/jobs/speed)

<!-- TOC --><a id="openfoam-multinode"></a>
## OpenFOAM - Multinode

This example is taken from OpenFOAM tutorials section: `$FOAM_TUTORIALS/incompressible/icoFoam/cavity/cavity`
1. Go to your speed-scratch directory: `cd /speed-scratch/$USER`
2. open a salloc session
3. Load OpenFoam module: `module load OpenFOAM/v2306/default`
4. Copy the cavity example to your speed-scratch space: `cp -r $FOAM_TUTORIALS/incompressible/icoFoam/cavity/cavity/ .`
5. Modify cavity/system/decomposeParDict: 
   Remove coeffs section and modify the following:
         numberOfSubdomains  10;
         method  scotch;
6. Exit the salloc session, go to the cavity directory and run the script: `sbatch --mem=10Gb -pps --constraint=el9 openfoam-multinode.sh`