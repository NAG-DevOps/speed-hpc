#include <iostream>

#include <mpi.h>

#define ROOT 0

int main(int argc, char** argv) {
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

  std::cout << "[";
  if (rank == ROOT) {
    std::cout << "ROOT:" << ROOT;
  } else {
    std::cout << "Rank:" << rank;
  }
  std::cout << "] This is rank " << rank << " running on " << processor_name << "!" << std::endl;

  if(rank == ROOT){
    // If this is the ROOT (aka rank 0) then send data.
    for(int i = 0; i < world_size; i++) {
      if (i == ROOT) continue;    

      std::cout << "[ROOT:"<< ROOT << "] sending to " << i << "..." << std::endl;
   
      MPI_Send(&i, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
    }
  } else {
    // Receive data sent from ROOT.
    int recv;
    MPI_Recv(&recv, 1, MPI_INT, ROOT, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    std::cout << "[Rank:" << rank << "] Received " << recv << " from ROOT!" << std::endl;
  }

  // MPI_Finalize must be called to clean up the runtime.
  // No other MPI calls are functional after this call.
  MPI_Finalize();
  return 0;
}
