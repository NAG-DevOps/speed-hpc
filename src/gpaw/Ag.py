from gpaw import GPAW, PW
from ase.constraints import StrainFilter
from ase.filters import StrainFilter
from ase.io import Trajectory
from ase.optimize import BFGS
from ase.io import read

#from ase.visualize import view

conv= {'energy': 0.0005, 'density': 1.0e-5, 'eigenstates': 4.0e-08, 'bands': 'occupied'}

calc = GPAW(mode=PW(600), xc="PBE", txt="Ag.txt", kpts=(4,4,4), symmetry = 'off', convergence=conv)

print("calc d")

from ase.build import bulk

unitcell = bulk('Ag', cubic=True)
print("unitcell d")
#view(unitcell)
unitcell.get_cell()

unitcell.calc = calc
sf = StrainFilter(unitcell)
opt = BFGS(sf, logfile="Ag.log")
traj = Trajectory("Ag.traj", "w", unitcell)
print("traj d")
opt.attach(traj)
opt.run(fmax=0.025)
print("run d")

traj = read('Ag.traj', index=-1)
print(traj.get_cell())
