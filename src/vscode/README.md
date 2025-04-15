<!-- TOC --><a name="README"></a>
# VS Code on Speed

a **step-by-step** guide to running VS Code directly on the Speed HPC cluster. 

<!-- TOC --><a name="Prerequisites"></a>
## Prerequisites

1. **Access to Speed**
   Before starting, ensure you have [access to Speed](https://nag-devops.github.io/speed-hpc/#requesting-access).

2. **SSH to Speed (Requires VPN if off-campus)**
   - VPN Setup: [How to connect to the Virtual Private Network](https://www.concordia.ca/it/support/connect-from-home.html)
     ```bash
     ssh <ENCSusername>@speed.encs.concordia.ca
     ```
    Replace `<ENCSusername>` with your ENCS username.

3. **Clone the GitHub Repository**
     ```bash
     git clone --depth=1 https://github.com/NAG-DevOps/speed-hpc.git
     ```

4. Navigate to the vscode directory in `src`

<!-- TOC --><a name="Instructions"></a>
## Instructions
There are two ways to run Visual Studio Code (VS Code) on Speed.

### Web-based Version
1. Start an interactive session
     ```bash
     salloc --job-name=vs-code --mem=10G
     ```

2. Run the script `vscode_web.sh`
     ```bash
     ./vscode_web.sh
     ```
     The script will:
   - Create a \'vscode\' directory (with subdirectories \'run-user\' and \'workspace\')
   - set the environment variable `XDG_RUNTIME_DIR` appropriately.
   - Print the SSH tunnel command required to forward port 8080 from the compute node to your local machine.
   - Launch code-server in the background, which generates a configuration file (including the VS Code password).

3. Connect from your local machine:
   - Open your web browser and navigate to http://localhost:8080.
   - If prompted for a password, use the password printed by the script.

> ❗ **IMPORTANT**: Keep this session open to maintain the VS Code server running. When you're done, type 'exit' to terminate the session.

### Running VS Code Locally
If you prefer running VS Code without needing a separate browser-based code-server.

1. Install "Remote - SSH" extension:
   - In VS Code, open the **Extensions** icon (left sidebar).
   - Search **Remote - SSH** (by Microsoft).
   - Click Install.

2. Start an interactive session:
     ```bash
     salloc --job-name=vs-code --mem=10G
     ```
    Note the compute node name (for example, speed-40.encs.concordia.ca). Keep the session open.

3. Edit your local SSH config file:
    - **On Windows**: Typically located at `C:\Users\<YourName>\.ssh\config`
    - **On macOS/Linux**: Located at `~/.ssh/config`
   
    You will need to define two “hosts” in your local SSH config:
    - **speed** (the login/submit node, `speed.encs.concordia.ca`)
    - **speed-compute** (the compute node you got, e.g., `speed-40.encs.concordia.ca`), which uses `ProxyJump speed` that tells SSH to hop from your
          local machine → the login node → the compute node.
   
     ```text
      # Speed-submit (login) node
      Host speed
      HostName speed.encs.concordia.ca
      User <ENCSusername>

      # Speed compute node
      Host speed-compute
      HostName <compute-node>.encs.concordia.ca
      User <ENCSusername>
      ProxyJump speed
      ForwardAgent yes
     ```
     
    Replace `<ENCSusername>` with your ENCS username and `<compute-node>` with the actual compute node name (e.g., speed-40).
        - `ProxyJump speed` 

4. Connect via VS Code Remote - SSH:
    - In VS Code, open the Command Palette `Ctrl+Shift+P` (or `Cmd+Shift+P` on macOS)
    - Select **Remote-SSH: Connect to Host...** and choose `speed-compute`
    - Follow the prompts to connect (you may be asked for your SSH password or a confirmation).
    - Once connected, a new VS Code window will open. Verify the status bar shows “SSH: speed-compute”.

5. Open and edit files on Speed:
    - In the new VS Code window, go to File → Open Folder… and navigate to a directory such as `/speed-scratch/<ENCSusername>/my_project`
    - Open a remote terminal via Terminal → New Terminal. This terminal will run on the compute node.
    - Edit files as needed. All changes occur on the HPC node.

> NOTE:\
> When your interactive job ends, your compute node is freed, and your VS Code session drops.\
> Each time you get a new compute node, update the `HostName` in your SSH config.
 
## References
- Speed manual:
    - Speed Manual PDF: https://github.com/NAG-DevOps/speed-hpc/blob/master/doc/speed-manual.pdf
    - Speed Manual HTML: https://nag-devops.github.io/speed-hpc/ 
- GitHub Repository (PRs are welcome): https://github.com/NAG-DevOps/speed-hpc
