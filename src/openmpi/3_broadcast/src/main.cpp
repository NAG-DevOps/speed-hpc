#include <algorithm>
#include <iostream>
#include <random>
#include <string>
#include <stdexcept>
#include <vector>

#include <cmath>

#include <mpi.h>

// Random number generator pointer
std::mt19937 *gen;

// Return a vector containing `n` indices out of `limit`.
std::vector<int> random_indices(int n, int limit) {
  std::vector<int> v(n, 0);
  std::vector<int> values;

  for (int i = 0; i < limit; ++i) {
    values.push_back(i);
  }

  std::shuffle(values.begin(), values.end(), *gen);

  for (int i = 0; i < n; i++)
    v[i] = values[i];

  return v;
}

// Print a vector `v` as a square to `std::cout`. `v` must be a square integer.
void display(const std::vector<int> &v) {
  int n = std::sqrt(v.size());
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      std::cout << v[i * n + j] << " ";
    }
    std::cout << std::endl;
  }
}

int main(int argc, char **argv) {

  if(argc != 2) {
    std::cerr << "You must specify a number of repetitions." << std::endl;
    return 1;
  }

  int repetitions;
  std::string arg = argv[1];
  try {
    std::size_t pos;
    repetitions = std::stoi(arg, &pos);
    if (pos < arg.size()) {
      std::cerr << "Warning: repetitions parameter has trailing characters." << std::endl;
    }
  } catch (std::invalid_argument const &ex) {
    std::cerr << "Invalid number: " << arg << std::endl;
    return 1;
  } catch (std::exception const &ex) {
    std::cerr << "Caught exception: " << ex.what() << std::endl;
    return 1;
  }

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

  std::printf("Hello from processor %s rank %d\n", processor_name, rank);

  // Random number generator initialization
  std::random_device rd;
  gen = new std::mt19937(rd());

  // Initialize empty vector of size 9
  std::vector<int> v(9, 0);

  for (int i = 0; i < repetitions; i++) {

    if (rank == 0) {
      // If rank 0 print the random vector indices and set them to 1
      std::fill(v.begin(), v.end(), 0);
      for (auto it : random_indices(3, v.size())) {
        std::cout << "index: " << it << std::endl;
        v[it] = 1;
      }
    } else {
      // Else display current vector
      std::cout << "Rank " << rank << " starting with starting with..." << std::endl;
      display(v);
      std::cout << std::endl;
    }

    // Broadcast the vector data from the rank 0 process to all other processes.
    MPI_Bcast(v.data(), v.size(), MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0) {
      std::cout << "Sent: " << std::endl;
      display(v);
      std::cout << std::endl;
    } else {
      std::cout << "Process " << rank << " received:" << std::endl;
      display(v);
      std::cout << std::endl;
    }

    // Wait for all processes to display that they have received the broadcast
    MPI_Barrier(MPI_COMM_WORLD);
  }

  std::cout << "Process " << rank << " done!" << std::endl;

  MPI_Finalize();

  delete gen;
  return 0;
}
