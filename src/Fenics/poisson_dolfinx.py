"""
Poisson Equation Example using FEniCSx (DOLFINx)
=================================================
Solves: -Δu = f  in Ω = [0,1] x [0,1]
         u  = 0  on ∂Ω (Dirichlet BC)

Based on the official FEniCS demo:
https://github.com/FEniCS/dolfinx/blob/main/python/demo/demo_poisson.py

Usage:
    Single process:   python3 poisson_dolfinx.py
    Parallel (MPI):   srun --mpi=pmix python3 poisson_dolfinx.py (adapted to Slurm sbatch jobs)
"""

from pathlib import Path
from mpi4py import MPI
import numpy as np
import ufl
from dolfinx import fem, io, mesh
from dolfinx.fem.petsc import LinearProblem
from dolfinx.cpp.mesh import create_cell_partitioner
from dolfinx.mesh import GhostMode
from dolfinx.graph import partitioner_kahip

# ── 1. Create mesh ────────────────────────────────────────────────────────────
# Rectangle [0,1]x[0,1] with 256x256 triangular cells
# Using KaHIP partitioner — ParMETIS 4.0.3 is incompatible with OpenMPI 5.0.8
msh = mesh.create_rectangle(
    comm=MPI.COMM_WORLD,
    points=((0.0, 0.0), (1.0, 1.0)),
    n=(256, 256),
    cell_type=mesh.CellType.triangle,
    partitioner=create_cell_partitioner(partitioner_kahip(), GhostMode.shared_facet)
)

# ── 2. Define function space ──────────────────────────────────────────────────
V = fem.functionspace(msh, ("Lagrange", 1))

# ── 3. Define boundary condition ──────────────────────────────────────────────
# u = 0 on entire boundary ∂Ω
tdim = msh.topology.dim
fdim = tdim - 1
boundary_facets = mesh.locate_entities_boundary(
    msh, dim=fdim,
    marker=lambda x: np.ones(x.shape[1], dtype=bool)  # all boundary facets
)
dofs = fem.locate_dofs_topological(V=V, entity_dim=fdim, entities=boundary_facets)
bc = fem.dirichletbc(value=np.float64(0), dofs=dofs, V=V)

# ── 4. Define variational problem ─────────────────────────────────────────────
# Source term: f = 2π²sin(πx)sin(πy)  (matches exact solution u = sin(πx)sin(πy))
u = ufl.TrialFunction(V)
v = ufl.TestFunction(V)
x = ufl.SpatialCoordinate(msh)
f = 2 * ufl.pi**2 * ufl.sin(ufl.pi * x[0]) * ufl.sin(ufl.pi * x[1])

a = ufl.inner(ufl.grad(u), ufl.grad(v)) * ufl.dx
L = ufl.inner(f, v) * ufl.dx

# ── 5. Solve ──────────────────────────────────────────────────────────────────
problem = LinearProblem(
    a, L, bcs=[bc],
    petsc_options_prefix="demo_poisson_",
    petsc_options={"ksp_type": "preonly", "pc_type": "lu",
                   "ksp_error_if_not_converged": True},
)
uh = problem.solve()
uh.name = "u"

# ── 6. Compute error ──────────────────────────────────────────────────────────
u_exact = fem.Function(V)
u_exact.interpolate(lambda x: np.sin(np.pi * x[0]) * np.sin(np.pi * x[1]))

error_form = fem.form(ufl.inner(uh - u_exact, uh - u_exact) * ufl.dx)
error_local = fem.assemble_scalar(error_form)
error_global = msh.comm.allreduce(error_local, op=MPI.SUM)
L2_error = np.sqrt(error_global)

if MPI.COMM_WORLD.rank == 0:
    print(f"Number of DOFs:  {V.dofmap.index_map.size_global}")
    print(f"MPI processes:   {MPI.COMM_WORLD.size}")
    print(f"L2 error:        {L2_error:.6e}")
    print(f"(Expected ~4e-4 for 256x256 mesh with P1 elements)")

# ── 7. Save results ───────────────────────────────────────────────────────────
# Set HDF5_USE_FILE_LOCKING=FALSE before running on NFS filesystems
out_folder = Path("out_poisson")
out_folder.mkdir(parents=True, exist_ok=True)
with io.XDMFFile(msh.comm, out_folder / "poisson.xdmf", "w") as file:
    file.write_mesh(msh)
    file.write_function(uh)

if MPI.COMM_WORLD.rank == 0:
    print(f"Solution saved to {out_folder}/poisson.xdmf")
