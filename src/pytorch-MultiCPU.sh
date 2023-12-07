## Adapted to SPEED from:
## https://docs.alliancecan.ca/wiki/PyTorch

# Virtual Environment creation, python script at the end of slurm script execution section

# job script: multicpu.sh

#!/encs/bin/tcsh
#SBATCH --nodes 1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=4 # change this parameter to 2,4,6,... to see the effect on performance

#SBATCH --mem=24G
#SBATCH --time=0:05:00
#SBATCH --output=%N-%j.out

source /speed-scratch/$USER/tmp/pytorchcpu/bin/activate.csh
echo "starting training..."

time python torch-multicpu.py
######## END of Job Script

### Slurm Script execution
sbatch -p ps multicpu.sh -A Your_group_id(if you have one)
### End of slurm script


#### Virtual ENV creation. One time only:
cd /speed-scratch/$USER
salloc -p ps --mem=20Gb -A Your_group_id(if you have one)
module load python/3.9.18/default
setenv TMP /speed-scratch/$USER/tmp
setenv TMPDIR /speed-scratch/$USER/tmp
python -m venv $TMPDIR/pytorchcpu
source $TMPDIR/pytorchcpu/bin/activate.csh
pip install torch torchvision
pip install urllib3==1.26.6
deactivate
### END of VEnv creation


### Python script torch-multicpu.py

import numpy as np
import time

import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
import torch.distributed as distri

import torchvision
import torchvision.transforms as transforms
from torchvision.datasets import CIFAR10
from torch.utils.data import DataLoader

import argparse
import os

parser = argparse.ArgumentParser(description='cifar10 classification models, cpu performance test')
parser.add_argument('--lr', default=0.1, help='')
parser.add_argument('--batch_size', type=int, default=512, help='')
parser.add_argument('--num_workers', type=int, default=0, help='')

def main():

    args = parser.parse_args()
    torch.set_num_threads(int(os.environ['SLURM_CPUS_PER_TASK']))
    class Net(nn.Module):

       def __init__(self):
          super(Net, self).__init__()

          self.conv1 = nn.Conv2d(3, 6, 5)
          self.pool = nn.MaxPool2d(2, 2)
          self.conv2 = nn.Conv2d(6, 16, 5)
          self.fc1 = nn.Linear(16 * 5 * 5, 120)
          self.fc2 = nn.Linear(120, 84)
          self.fc3 = nn.Linear(84, 10)

       def forward(self, x):
          x = self.pool(F.relu(self.conv1(x)))
          x = self.pool(F.relu(self.conv2(x)))
          x = x.view(-1, 16 * 5 * 5)
          x = F.relu(self.fc1(x))
          x = F.relu(self.fc2(x))
          x = self.fc3(x)
          return x

    net = Net()

    criterion = nn.CrossEntropyLoss()
    optimizer = optim.SGD(net.parameters(), lr=args.lr)

    transform_train = transforms.Compose([transforms.ToTensor(),transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))])

    ### This next line will attempt to download the CIFAR10 dataset from the internet if you don't already have it stored in ./data
    ### Run this line on a login node with "download=True" prior to submitting your job, or manually download the data from
    ### https://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz and place it under ./data

    dataset_train = CIFAR10(root='./data', train=True, download=False, transform=transform_train)

    train_loader = DataLoader(dataset_train, batch_size=args.batch_size, num_workers=args.num_workers)

    perf = []

    total_start = time.time()

    for batch_idx, (inputs, targets) in enumerate(train_loader):

       start = time.time()

       outputs = net(inputs)
       loss = criterion(outputs, targets)

       optimizer.zero_grad()
       loss.backward()
       optimizer.step()

       batch_time = time.time() - start

       images_per_sec = args.batch_size/batch_time

       perf.append(images_per_sec)

    total_time = time.time() - total_start

if __name__=='__main__':
   main()

### END of Python script   

