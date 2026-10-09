#include "particle.h"

#include <iostream>

#include <mpi.h>

MPI_Datatype Particle::mpi_dtype;

void Particle::create_mpi_particle_datatype() {
  int blocklengths[3] = {1, 1, 3}; // Set the span of each variable type
  MPI_Datatype types[3] = {MPI_INT, MPI_CHAR, MPI_FLOAT}; // Declare which MPI Datatypes are necessary 

  Particle p; // Declare a particle struct to obtain offsets from
  MPI_Aint offsets[3]; // Have an array of offsets matching the blocklengths

  // Get the variables offsets based on the struct
  MPI_Get_address(&p.id, &offsets[0]);
  MPI_Get_address(&p.attrib, &offsets[1]);
  MPI_Get_address(&p.x, &offsets[2]);

  // Get the base address
  MPI_Aint base;
  MPI_Get_address(&p, &base);

  // Remove the base address so that the offsets start from 0
  for (int i = 0; i < 3; i++) {
    offsets[i] -= base;
  }

  // Create and commit the datatype for use with MPI
  MPI_Type_create_struct(3, blocklengths, offsets, types, &Particle::mpi_dtype);
  MPI_Type_commit(&Particle::mpi_dtype);
}

std::ostream& operator<< (std::ostream& out, const Particle& p) {
  out << p.id << ":" << p.attrib << "(" << p.x << "," << p.y << "," << p.z << ")";
  return out;
}
