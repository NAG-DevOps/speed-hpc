# Ollama on HPC (Speed) Cluster

Ollama is an open-source software tool that simplifies running large language models (LLMs) directly on your local machine.

#### References:
- [Ollama](https://ollama.com)
- [Ollama GitHub](https://github.com/ollama/ollama)

## Prerequisites
Before starting, ensure you have [access](https://nag-devops.github.io/speed-hpc/#requesting-access) to the HPC (Speed) cluster.

## Instructions
* Connect to Speed:
```shell
ssh <ENCSusername>@speed.encs.concordia.ca
```

* Clone Speed Github repository
```shell
    git clone --depth=1 https://github.com/NAG-DevOps/speed-hpc.git
```

* Navigate to the Ollama directory:

* Run `start_ollama.sh`
```shell
sbatch start_ollama.sh
```

* The script will:
  - Request resources and setup environment variables
  - Install Ollama tarball, extract it, and add Ollama to user's path (`setenv PATH /speed-scratch/$USER/ollama/bin:$PATH`)
  - Choose a random available port and set `OLLAMA_HOST` to it
  - Start Ollama server `ollama serve` and print ssh command to connect to the server.

**Note**: The server is set to run for 4 hours, adjust based on your needs.

* Monitor the job output:
```shell
tail -f ollama-<JOB-ID>.out
```

* In a new terminal window, use the ssh command printed earlier
```shell
ssh -L ${PORT}:${NODE}:${PORT} ${USER}@speed.encs.concordia.ca -t ssh $NODE
```

* Setup environment variables and add Ollama to your path (also printed earlier)
```shell
setenv PATH ${ODIR}/bin:$PATH
setenv OLLAMA_HOST http://localhost:${PORT}
setenv OLLAMA_MODELS ${ODIR}/models
```

* Sanity check
```shell
ollama -v
```

* Pull a model
```shell
ollama pull llama3
```

* List the models
```shell
ollama list
```

### Option 1: Run a model and start a chat
```
ollama run llama3
>>> What is 2+2?
Easy peasy!

The answer to 2+2 is... 4!
>>>
```

### Option 2: Run a python code demo
* Run `run_ollama.sh` script.

**Note**: Replace `$NODE` with the name of the node the server is running on (`$NODE` is printed in the output of `start_ollama.sh`.)
```shell
sbatch -w $NODE run_ollama.sh
```

* The script will:
  - Request resources and setup environment variables
  - Pull a model to run (in this case it's llama3)
  - Create a python environment to run `ollama_demo.py`
  - Run `ollama_demo.py` which interacts with the model 

* Check the job output:
```shell
cat ollama-<JOB-ID>.out
```

## Cleanup
To stop the Ollama server, cancel the job:
```shell
scancel <JOB-ID>
```
