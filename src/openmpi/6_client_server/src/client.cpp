#include <iostream>
#include <string>
#include <vector>

#include <mpi.h>

#include "particle.h"

const std::string SERVICE_NAME = "MPI_CLIENT_SERVER";

int main(int argc, char** argv) {
  int provided;
  // Request multi-threading runtime permissions from MPI
  // becasue this program uses MPI from multiple threads
  MPI_Init_thread(&argc, &argv, MPI_THREAD_MULTIPLE, &provided);

  if (provided < MPI_THREAD_MULTIPLE) {
    std::cerr << "[Client] Error: MPI setup does not support concurrent "
                 "multi-threading." << std::endl;

    MPI_Finalize();
    return 1;
  }

  // Get current processor / host name
  char processor_name[MPI_MAX_PROCESSOR_NAME];
  int namelen;
  MPI_Get_processor_name(processor_name, &namelen);

  std::cout << "[Client] Hello from processor: " << processor_name << std::endl;

  std::cout << "[Client] building Particle datatype" << std::endl;
  Particle::create_mpi_particle_datatype();

  char port_name[MPI_MAX_PORT_NAME];
  std::cout << "[Client] Looking up service '" << SERVICE_NAME << "'..." << std::endl;
  MPI_Lookup_name(SERVICE_NAME.c_str(), MPI_INFO_NULL, port_name);
  std::cout << "[Client] connected on port: " << port_name << std::endl;

  MPI_Comm server_comm;
  MPI_Comm_connect(port_name, MPI_INFO_NULL, 0, MPI_COMM_SELF, &server_comm);
  std::cout << "[Client] Successfully connected to Particle Server!" << std::endl;

  MPI_Send(processor_name, MPI_MAX_PROCESSOR_NAME, MPI_CHAR, 0, 0, server_comm);

  bool running = true;
  char choice;
  while (running) {
    std::cout << "\nChoose protocol transmission:\n"
      << "[P] Send Single Particle\n"
      << "[V] Send Vector of Particles\n"
      << "[D] Disconnect from the server and exit\n\n"
      << "Selection: " << std::flush;

    std::cin >> choice;
    choice = toupper(choice);

    // Send the single-byte protocol token first
    MPI_Send(&choice, 1, MPI_CHAR, 0, 1, server_comm);

    switch(choice) {
      case 'P':
        {
          Particle p{1, 'a', 1.0f, 2.0f, 3.0f}; 
          MPI_Send(&p, 1, Particle::mpi_dtype, 0, 2, server_comm);
        }
        break;

      case 'V':
        {
          std::vector<Particle> vp;
          vp.push_back({2, 'b', 4.0f, 5.0f, 6.0f});
          vp.push_back({3, 'c', 7.0f, 8.0f, 9.0f});

          int size = vp.size();
          MPI_Send(&size, 1, MPI_INT, 0, 2, server_comm);
          MPI_Send(vp.data(), vp.size(), Particle::mpi_dtype, 0, 2, server_comm);
        }
        break;

      case 'D':
        std::cout << "\n[Client] Sent disconnect." << std::endl;
        running = false;
        break;
        
      default:
        std::cout << "\n[Client] unkown command: " << choice << std::endl;
        break;
    }
  }

  // Disconnect from the server
  MPI_Comm_disconnect(&server_comm);
  MPI_Finalize();

  return 0;
}
