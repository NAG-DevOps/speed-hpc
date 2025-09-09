# Ollama on HPC (Speed) Cluster

Ollama is an open-source software tool that simplifies running large language models (LLMs) directly on your local machine.

#### References:
- [Ollama](https://ollama.com)
- [Ollama GitHub](https://github.com/ollama/ollama)

## Prerequisites
Before starting, ensure you have [access](https://nag-devops.github.io/speed-hpc/#requesting-access) to the HPC (Speed) cluster.

## Instructions
* Clone Speed Github repository
    ```shell
    git clone --depth=1 https://github.com/NAG-DevOps/speed-hpc.git
    ```

* Navigate to ollama directory in `src/llm-examples`

* Run `start_ollama.sh`
    ```shell
    sbatch start_ollama.sh
    ```

    The script will:
    - Request required resources
    - Download Ollama tarball and extract it
    - Add Ollama to user's path and setup environment variables

    ```shell
    setenv PATH /speed-scratch/$USER/ollama/bin:$PATH
    ```

    - Start Ollama server with `ollama serve`
    - Print the ssh command to connect to the server.

    Note: The server is set to run for 3 hours (adjust if needed)

* Open a new terminal window and paste the ssh command to connect to the speed node the server is running on. The command will look like:
    ```shell
    ssh -L XXXXX:speed-XX:XXXXX <ENCSusername>@speed.encs.concordia.ca -t ssh speed-XX
    ```

* Navigate to ollama directory and do a sanity check
    ```shell
    setenv PATH /speed-scratch/$USER/ollama/bin:$PATH
    ollama -v
    ```

* Run the `run_ollama.sh` script, replace speed-XX with the name of the node the server is running on 
    ```shell
    sbatch -w speed-XX run_ollama.sh
    ```

    The script will:
    - Request required resources
    - Set environment variables
    - Pull a model to run (in this case it's llama3.2)
    - Create a python environment to run `ollama_demo.py`
    - Run `ollama_demo.py` which interact with the model 

Optional:
1. Check if the server is running, replace XXXXX with the port number
```shell
curl http://localhost:XXXXX/api/tags
```

2. Run a model with a prompt
```shell
curl -sS http://localhost:56781/api/generate -H "Content-Type: application/json" -d '{"model": "llama3.2","prompt": "why is the sky blue?","stream": false}' | jq -r '.response'
```
