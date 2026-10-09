#include <iostream>
#include <vector>

#include <mpi.h>

struct Coord {
  float x, y, z;
};

std::ostream& operator<< (std::ostream& out, const Coord& c) {
  out << "(" << c.x << "," << c.y << "," << c.z << ")";
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

  // Create the MPI version of `coord`
  MPI_Datatype MPI_Coord;
  MPI_Type_contiguous(3, MPI_FLOAT, &MPI_Coord);
  MPI_Type_commit(&MPI_Coord);
  
  std::cout << "Hello from processor " << processor_name << " rank " << rank << std::endl;

  Coord c;
  if(rank == 0) {
    c.x = 1.0f;
    c.y = 2.0f;
    c.z = 3.0f;

    std::cout << "Rank " << rank << ": Broadcasting " << c << std::endl;
  } else {
    std::cout << "Rank " << rank << ": Waiting..." << std::endl;
  }

  // Broadcast the vector data from the rank 0 process to all other processes.
  MPI_Bcast(&c, 1, MPI_Coord, 0, MPI_COMM_WORLD);

  if (rank != 0) {
    std::cout << "Process " << rank << " received: " << c << std::endl;
  }

  // Wait for all processes to display that they have received the broadcast
  MPI_Barrier(MPI_COMM_WORLD);

  std::vector<Coord> coords;
  coords.resize(2); // Set the size of the vector for all processes

  if(rank == 0) {
    coords.at(0) = {4.0f, 5.0f, 6.0f};
    coords.at(1) = {7.0f, 8.0f, 9.0f};

    std::cout << "Rank " << rank << ": Broadcasting..." << std::endl;
    int i = 0;
    for(auto it : coords) {
      std::cout << i << ": " << it << std::endl;
      ++i;
    }
  } else {
    std::cout << "Rank " << rank << ": Waiting..." << std::endl;
  }

  // Broadcast the vector data from the rank 0 process to all other processes.
  MPI_Bcast(coords.data(), coords.size(), MPI_Coord, 0, MPI_COMM_WORLD);

  if (rank != 0) {
    std::cout << "Rank " << rank << ": received..." << std::endl;
    int i = 0;
    for(auto it : coords) {
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
