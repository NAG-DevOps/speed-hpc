# BERT on HPC (Speed) Cluster

BERT is an open-source Google machine learning framework for natural language processing (NLP). This example demonstrates how to run a BERT model using PyTorch and Hugging Face Transformers on Speed.

#### References:
- [Ollama](https://huggingface.co/docs/transformers/en/model_doc/bert)

## Prerequisites
Before starting, ensure you have [access](https://nag-devops.github.io/speed-hpc/#requesting-access) to the HPC (Speed) cluster.

## Instructions
* Clone Speed Github repository
    ```shell
    git clone --depth=1 https://github.com/NAG-DevOps/speed-hpc.git
    ```

* Navigate to bert directory in `src/llm-examples/bert`

* Run `run_bert.sh`
    ```shell
    sbatch run_bert.sh
    ```

    The script will:
    - Request required resources
    - Create a Conda environment and install required packages
    - Run `bert_demo.py` which runs masked language modeling and question answering examples.

* Job output will be written to: `bert-<JOB-ID>.out`

## Cleaning Up
If needed, remove the environment:
```
rm -rf /speed-scratch/$USER/envs/bert
```