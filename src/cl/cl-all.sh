#!/encs/bin/tcsh

#
# Runs all benchmarks and examples for convenience
#

date
echo "Starting 3 scripts; expect 3 slurm output files and whatever else they produce."
echo "The scripts are launched synchronously but will queue asynchronously as jobs."
echo "They will execuite sequentially though because there is a single AMD GPU."
echo "They will execuite in parallel, if adapted to NVIDIA GPUs away from speed-19".
./cl-bench.sh
./cl-examples.sh
./cl-tutorials.sh
date

# EOF
