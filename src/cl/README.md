# OpenCL-like application examples

We use some of the OpenCL examples and benchmarks as an alternaive to CUDA.
Especially for AMDGPUs. This can be later extended to HIP.

Note OpenCL is deprecated and HIP can work in various environments and
in most cases interoperate or convert OpenCL and CUDA applications.
Driver and hardware-dependent.

speed-19 currently has AMD GPU. The OpenCL examples *should* also work
on NVIDIA GPUs. The 'cl' parition covers most of the GPUs including
AMDGPU and NVIDIA.

## Examples

We leverage the following repos as examples for these OpenCL jobs:

- https://github.com/NAG-DevOps/amd-gpu-benchmark
- https://github.com/NAG-DevOps/OpenCL-Tutorials
- https://github.com/NAG-DevOps/OpenCL-examples

They are forks of the original projects with our modifications to make
them compile and run on Speed.

- `cl-bench.sh` runs amd-gpu-benchmark 
