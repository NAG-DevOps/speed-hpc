#include <iostream>

#include <mpi.h>

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

  // Get rank of the process. This is the id of the process in the MPI context.
  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  std::cout << "Hello World from " << rank << "/" << world_size << " on "
            << processor_name << "!" << std::endl;
  
  // MPI_Finalize must be called to clean up the runtime.
  // No other MPI calls are functional after this call.
  MPI_Finalize();
  return 0;
}
