# Environments 
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
