#include <iostream>
#include <vector>

#include <mpi.h>

struct Particle {
  int id;
  char attrib;
  float x, y, z;
};

std::ostream& operator<< (std::ostream& out, const Particle& p) {
  out << p.id << ":" << p.attrib << "(" << p.x << "," << p.y << "," << p.z << ")";
  return out;
}

int main(int argc, char **argv) {
  // MPI_Init must be called before calling and MPI functions.
  MPI_Init(&argc, &argv);

  // Basic information retrieval commands
   
  // Get current processor / host name
  char processor_name[MPI_MAX_PROCESSOR_NAME];
  int namelen;
  MPI_Get_processor_name(processor_name, &namelen);

  // Get world size
  int world_size;
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);

  if(world_size < 2) {
    std::cerr << "There must be at least 2 processes" << std::endl;
    return 1;
  }

  // Get rank of the process. This is the id of the process in the MPI context.
  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  std::cout << "Hello from processor " << processor_name << " rank " << rank << std::endl;

  // Create the MPI version of `Particle`
  MPI_Datatype MPI_Particle;

  // Scoping these variables so that they are deleted from the main program
  {
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
    MPI_Type_create_struct(3, blocklengths, offsets, types, &MPI_Particle);
    MPI_Type_commit(&MPI_Particle);
  }
  

  Particle p2;
  if(rank == 0) {

    p2.id = 1;
    p2.attrib = 'a';
    p2.x = 1.0f;
    p2.y = 2.0f;
    p2.z = 3.0f;

    std::cout << "Rank " << rank << ": Broadcasting " << p2 << std::endl;
  } else {
    std::cout << "Rank " << rank << ": Waiting..." << std::endl;
  }

  // Broadcast the vector data from the rank 0 process to all other processes.
  MPI_Bcast(&p2, 1, MPI_Particle, 0, MPI_COMM_WORLD);

  if (rank != 0) {
    std::cout << "Process " << rank << " received: " << p2 << std::endl;
  }

  // Wait for all processes to display that they have received the broadcast
  MPI_Barrier(MPI_COMM_WORLD);

  std::vector<Particle> particles;
  particles.resize(2); // Set the size of the vector for all processes

  if(rank == 0) {
    particles.at(0) = {2, 'b', 4.0f, 5.0f, 6.0f};
    particles.at(1) = {3, 'c', 7.0f, 8.0f, 9.0f};

    std::cout << "Rank " << rank << ": Broadcasting..." << std::endl;
    int i = 0;
    for(auto it : particles) {
      std::cout << i << ": " << it << std::endl;
      ++i;
    }
  } else {
    std::cout << "Rank " << rank << ": Waiting..." << std::endl;
  }

  // Broadcast the vector data from the rank 0 process to all other processes.
  MPI_Bcast(particles.data(), particles.size(), MPI_Particle, 0, MPI_COMM_WORLD);

  if (rank != 0) {
    std::cout << "Rank " << rank << ": received..." << std::endl;
    int i = 0;
    for(auto it : particles) {
      std::cout << "Rank " << rank << " index: " << i << ": " << it << std::endl;
      ++i;
    }
  }

  // Wait for all processes to display that they have received the broadcast
  MPI_Barrier(MPI_COMM_WORLD);

  std::cout << "Process " << rank << " done!" << std::endl;

  MPI_Finalize();

  return 0;
}
