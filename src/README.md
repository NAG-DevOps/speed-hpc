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
`conda create --prefix /speed-scratch/<encs_username>/myconda`

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

`conda activate /speed-scratch/<encs_username>/myconda`

After activating your environment, add pip to your environment by using 

`conda install pip`

This will install pip and pip's dependencies, including python.

**Important Note:** pip (and pip3) are used to install modules from the python distribution while `conda install` installs modules from anaconda's repository.

### efficientdet

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

## CUDA

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
