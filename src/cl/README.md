# OpenCL-like application examples

We use some of the OpenCL examples and benchmarks as an alternaive to CUDA.
Especially for AMD GPUs. This can be later extended to HIP or Vulkan jobs.

Note, OpenCL is more portable, but usually slower on NVIDIA devcices than
CUDA, and CUDA to HIP can work for AMD GPUs in various environments and
in most cases interoperate or convert OpenCL and CUDA applications.
(Driver and hardware-dependent.)

speed-19 currently has an AMD GPU. The OpenCL examples *should* also work
on NVIDIA GPUs. The `cl` parition covers most of the GPUs including
AMDGPU and NVIDIA.

PyTorch and TensorFlow also support AMD GPUs.

## Examples

We leverage the following repo forks as examples for these OpenCL jobs:

- https://github.com/NAG-DevOps/amd-gpu-benchmark
- https://github.com/NAG-DevOps/OpenCL-Tutorials
- https://github.com/NAG-DevOps/OpenCL-examples

They are modified forks of the original projects with our modifications to make
them compile and run on Speed. Some examples require graphics and interaction
and are excluded from automated batch tests.

- `cl-all.sh` launches all the below; assuming a submit node
- `cl-bench.sh` runs `amd-gpu-benchmark`
- `cl-examples.sh` runs a subset of `OpenCL-examples`
- OpenCL-examples -- examples that work and included in tests
  - `add_numbers`
  - `Hello_World`
  - `mandelbrot` -- compiles and runs, prints not output
  - `sum_array`
  - `square_array`
  - `waste` -- needs an argument
- OpenCL-examples -- need work or require X11, excluded from tests:
  - `auger` -- requires clRNG to be downloaded to compile
  - `cf4ocl` -- requires archived `cf4ocl` to be downloaded to compile
  - `RayTraced_Quaternion_Julia-Set_Example` -- requires X11 and the client OpenGL AMD GPU to match if X11-forwarding
  - `N-BodySimulation` -- currently an XCode-only project
  - `rng` -- also relies on clRNG to be downloaded to compile
- `cl-tutorials.sh` runs a subset of `OpenCL-Tutorials`, currently 1 and 3 are included in tests
  - `tutorial_1`
  - `tutorial_2` -- requires graphics to display images
  - `tutorial_3`
  - `tutorial_4` -- needs boost with compute

## References

- https://www.khronos.org/opencl/ (latest OpenCL spec release is 3.0.18 of April 2025, most devices in Speed run 2.x)
- https://en.wikipedia.org/wiki/OpenCL
