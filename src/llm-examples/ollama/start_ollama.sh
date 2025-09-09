#!/encs/bin/tcsh

#SBATCH --job-name=ollama-server
#SBATCH --mem=50G
#SBATCH --gpus=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mail-type=ALL
#SBATCH --output=ollama-%J.out
#SBATCH --time=03:00:00 ## Adjust based on your needs

set ODIR = /speed-scratch/$USER/ollama
mkdir -p $ODIR && cd $ODIR

# Download Ollama tarball and extract it once
if ( ! -x $ODIR/bin/ollama ) then
    echo "Downloading Ollama..."
    curl -LO https://ollama.com/download/ollama-linux-amd64.tgz
    tar -xzf ollama-linux-amd64.tgz
endif

# Add ollama to your PATH and set models directory
setenv PATH $ODIR/bin:$PATH
setenv OLLAMA_MODELS $ODIR/models
mkdir -p $OLLAMA_MODELS

# Ollama by default listens on 127.0.0.1:11434, the port however can be overwritten
set PORT = `python -c 'import socket,sys; s=socket.socket(); s.bind(("",0)); print(s.getsockname()[1]); s.close()'`
setenv OLLAMA_HOST 127.0.0.1:$PORT
echo "http://localhost:$PORT" >! ${ODIR}/.ollama_host

# Print connection instructions
set NODE = `hostname -s`
set USER = `whoami`
echo ""
echo "===================================================="
echo " Ollama server will start on $NODE"
echo "===================================================="
echo "To connect from your laptop, open a new terminal and run:"

echo ""
echo " ssh -L ${PORT}:${NODE}:${PORT} ${USER}@speed.encs.concordia.ca -t ssh $NODE"
echo ""
echo "Once connected, set your environment variables:"
echo "  setenv PATH ${ODIR}/bin:$PATH"
echo "  setenv OLLAMA_HOST http://localhost:${PORT}"
echo "  setenv OLLAMA_MODELS ${ODIR}/models"
echo "===================================================="
echo ""

# Start server
srun ollama serve
