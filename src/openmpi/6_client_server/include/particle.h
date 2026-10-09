#ifndef _MPI_PARTICLE_H_
#define _MPI_PARTICLE_H_

#include <iostream>

#include <mpi.h>

struct Particle {
  int id;
  char attrib;
  float x, y, z;

  static MPI_Datatype mpi_dtype;
  static void create_mpi_particle_datatype();
};

std::ostream& operator<< (std::ostream& out, const Particle& p);

#endif // _MPI_PARTICLE_H_
