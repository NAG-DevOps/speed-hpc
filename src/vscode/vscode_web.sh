#!/encs/bin/tcsh

date
echo "======================================================================\n"
# Go to your scratch directory.
cd /speed-scratch/$USER
mkdir -p vscode/run-user
cd vscode
mkdir -p workspace

setenv XDG_RUNTIME_DIR /speed-scratch/$USER/vscode/run-user

# Get the current node and user information
set node = `hostname -s`
set user = `whoami`

echo "To connect to this node from your local machine, open a new terminal and run:"
echo ""
echo " ssh -L 8080:${node}:8080 ${user}@speed.encs.concordia.ca"
echo ""
echo "Then, open your browser and go to: http://localhost:8080"
echo ""
echo "======================================================================\n"
echo "Launching vs code-server:"

nohup /speed-scratch/nag-public/code-server-4.22.1/bin/code-server \
    --user-data-dir=${PWD}/workspace \
    --config=${PWD}/home/.config/code-server/config.yaml \
    --bind-addr="0.0.0.0:8080" ${PWD}/workspace &

    # Wait for the config file (which contains the password) to be created.
    set CONFIG_FILE = "${PWD}/home/.config/code-server/config.yaml"
    while ( ! -e $CONFIG_FILE )
        echo "Waiting for the config file to be created..."
        sleep 2
    end

    echo ""
    echo "======================================================================\n"
    cat $CONFIG_FILE
    echo ""
    echo "======================================================================\n"
    echo "IMPORTANT: Keep this session open to maintain the VS Code server running."
    echo "When you're done, type 'exit' to terminate the session."
    echo ""