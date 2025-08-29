# Ollama on HPC (Speed) Cluster

Ollama is an open-source software tool that simplifies running large language models (LLMs) directly on your local machine.

#### References:
- [Ollama](https://ollama.com)
- [Ollama GitHub](https://github.com/ollama/ollama)


## Prerequisites

Before starting, ensure you have [access](https://nag-devops.github.io/speed-hpc/#requesting-access) to the HPC (Speed) cluster.

## Instructions

This requires having 2 sessions open

### Session A - get a GPU node & start the server

* SSH to speed and start an interactive session with salloc
```shell
ssh <ENCSusername>@speed.encs.concordia.ca
salloc --mem=50G --gpus=1
```

* Create a working directory and navigate to it
```shell
mkdir /speed-scratch/$USER/ollama
cd /speed-scratch/$USER/ollama
```

* Download Ollama tarball and extract it (creates the ollama binary here)
```shell
curl -LO https://ollama.com/download/ollama-linux-amd64.tgz
tar -xzf ollama-linux-amd64.tgz
```

* Add ollama to your PATH for this session
```shell
setenv PATH /speed-scratch/$USER/ollama/bin:$PATH
```

* Set Ollama to store its model in `/speed-scratch` to aviod quota limits
```shell
setenv OLLAMA_MODELS /speed-scratch/$USER/ollama/models
mkdir -p $OLLAMA_MODELS
```

* Start ollama server
```shell
ollama serve
```

* Leave this session open

### Session B - hop to the same node & run/test
* open a new terminal window and ssh to speed then to the node you have the server running on
```shell
ssh <ENCSusername>@speed.encs.concordia.ca
ssh speed-XX
cd /speed-scratch/$USER/ollama
```

* Sanity check
```shell
setenv PATH /speed-scratch/$USER/ollama/bin:$PATH
ollama -v
```

* Pull a specific model and run it (Optional)
```shell
ollama pull llama3.1
echo "What is today" | ollama run llama3.1
```

* Create a Python environment to run the example
```shell
setenv ENV_DIR /speed-scratch/$USER/envs/python-env
mkdir -p $ENV_DIR/{tmp,pkgs,cache}

setenv TMP $ENV_DIR/tmp
setenv TMPDIR $ENV_DIR/tmp
setenv PIP_CACHE_DIR $ENV_DIR/cache

python3 -m venv $ENV_DIR
source $ENV_DIR/bin/activate.csh
pip install -U pip ollama
```

* Copy the python file and execute it
```shell
python ollama_test.py
```