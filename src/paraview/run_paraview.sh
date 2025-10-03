#!/encs/bin/tcsh

module load GCC/12.3.0 -s
module load OpenMPI/4.1.5 -s
module load ParaView/5.13.2 -s
module load python/3.11.6/default -s

setenv PSM3_DEVICES 'self,shm'

# Get the current node and user information
set node = `hostname -s`
set user = `whoami`

# Get an available port for Jupyter
set port = `python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()'`

# Print SSH tunneling instructions
echo "To connect to the compute node ${node} on speed.encs.concordia.ca running your Paraview server, \
use the following SSH command in a new terminal on your workstation/laptop: \
ssh -L ${port}:${node}:${port} ${user}@speed.encs.concordia.ca \
Open Paraview installed on your workstation as described in https://github.com/NAG-DevOps/speed-hpc/tree/master/src/paraview \
File - Connect - Add server and fill in the details:\
Name: HPC\
Server Type: Client/Server\
Startup Type: Manual\
Host: localhost\
Port: ${port}\
Save and connect\n\
Once finished working with Paraview, disconnect the session: File - Disconnect and close the application"

echo "Starting Paraview server. DO NOT CLOSE THIS  WINDOWS"
mpirun pvserver -p ${port}
