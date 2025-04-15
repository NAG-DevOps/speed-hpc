<!-- TOC --><a name="README"></a>
# VS Code on Speed

a **step-by-step** guide to running VS Code directly on the Speed HPC cluster. 

<!-- TOC --><a name="Prerequisites"></a>
## Prerequisites
Before starting, ensure you have [access](https://nag-devops.github.io/speed-hpc/#requesting-access) to Speed.

2. SSH to Speed (Requires VPN if off-campus).
    -> VPN Setup: [How to connect to the Virtual Private Network](https://www.concordia.ca/it/support/connect-from-home.html)

        ssh <ENCSusername>@speed.encs.concordia.ca

    replace `<ENCSusername>` with your ENCS username
* Clone the Github repository

        git clone --depth=1 https://github.com/NAG-DevOps/speed-hpc.git

* Navigate to the vscode directory in `src`

There's two ways to run Visual Studio Code (VS Code).

