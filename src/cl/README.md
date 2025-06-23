# OpenCL-like application examples

We use some of the OpenCL examples and benchmarks as an alternaive to CUDA.
Especially for AMDGPUs. This can be later extended to HIP.

Note OpenCL is deprecated and HIP can work in various environments and
in most cases interoperate or convert OpenCL and CUDA applications.
Driver and hardware-dependent.

speed-19 currently has AMD GPU. The OpenCL examples *should* also work
on NVIDIA GPUs. The `cl` parition covers most of the GPUs including
AMDGPU and NVIDIA.

## Examples

We leverage the following repos as examples for these OpenCL jobs:

- https://github.com/NAG-DevOps/amd-gpu-benchmark
- https://github.com/NAG-DevOps/OpenCL-Tutorials
- https://github.com/NAG-DevOps/OpenCL-examples

They are modified forks of the original projects with our modifications to make
them compile and run on Speed. Some examples require graphics and interaction.

- `cl-bench.sh` runs `amd-gpu-benchmark`
- `cl-examples.sh` runs a subset of `OpenCL-examples`
- OpenCL-examples -- examples that work and included in tests
  - `add_numbers`
  - `Hello_World`
  - `mandelbrot` -- compiles and runs, prints not output
  - `sum_array`
  - `square_array`
  - `waste`
- OpenCL-examples -- need work or require X11, excluded from tests:
  - `auger` -- requires clRNG to be downloaded to compile
  - `cf4ocl` -- requires archived `cf4ocl` to be downloaded to compile
  - `RayTraced_Quaternion_Julia-Set_Example` -- requires X and the client OpenGL AMD GPU match
  - `N-BodySimulation` -- currently an XCode only project
  - `rng` -- also relies on clRNG to be downloaded to compile
- `cl-tutorials.sh` runs a subset of `OpenCL-Tutorials`
  - `tutorial_1`
  - `tutorial_2` -- requires graphics to display images
  - `tutorial_3`
  - `tutorial_4`
