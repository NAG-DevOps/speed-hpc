import time
import sys

# Open a separate log file
logfile = open('progress.log', 'a', buffering=1)  # Line buffered

for i in range(120):
    msg = f"Iteration {i}"
    logfile.write(msg + "\n")
    logfile.flush()

    time.sleep(5)

print("Done!")
logfile.write("Done!\n")
logfile.close()
