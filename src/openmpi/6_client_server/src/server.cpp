#include <algorithm>
#include <iostream>
#include <string>
#include <sstream>
#include <thread>
#include <vector>

#include <mpi.h>

#include "particle.h"

const std::string SERVICE_NAME = "MPI_CLIENT_SERVER";
bool server_running;

std::vector<std::thread> workers; // worker threads to handle client calls
std::vector<MPI_Comm*> client_comms; // communicator handles

void handle_client(MPI_Comm* client_comm) {
  bool connected = true;
  std::string name;
  name.resize(MPI_MAX_PROCESSOR_NAME);

  MPI_Recv(name.data(), name.size(), MPI_CHAR, 0, 0, *client_comm, MPI_STATUS_IGNORE);

  std::ostringstream oss;
  oss << "[Server:thread:" << name.c_str() << "]";
  std::string thread_log = oss.str();

  std::cout << thread_log << " started client thread..." << std::endl;

  while (connected) {
    char c;
    MPI_Recv(&c, 1, MPI_CHAR, 0, 1, *client_comm, MPI_STATUS_IGNORE);

    switch (c) {
      case 'P':
        {
          Particle p;

          MPI_Recv(&p, 1, Particle::mpi_dtype, 0, 2, *client_comm, MPI_STATUS_IGNORE);
          std::cout << thread_log << " received particle: " << p << std::endl;
        }
        break;

      case 'V':
        {
          int size;
          std::vector<Particle> vp;

          MPI_Recv(&size, 1, MPI_INT, 0, 2, *client_comm, MPI_STATUS_IGNORE);
          std::cout << thread_log << " received particle vector size: " << size << std::endl;
          vp.resize(size);

          MPI_Recv(vp.data(), vp.size(), Particle::mpi_dtype, 0, 2, *client_comm, MPI_STATUS_IGNORE);
          std::cout << thread_log << " received particle vector:" << std::endl;
          int i = 0;
          for (auto it : vp) {
            std::cout << thread_log << "idx: " << i << ": " << it << std::endl;
            ++i;
          }
        }
        break;

      case 'D':
        std::cout << thread_log << " received disconnect request" << std::endl;
        connected = false;
        break;

      default:
        std::cout << thread_log << " received unknown command: " << c << std::endl;
        break;
    }
  }
  std::cout << thread_log << " disconnecting..." << std::endl;
  MPI_Comm_disconnect(client_comm);
  client_comms.erase(std::find(client_comms.begin(), client_comms.end(), client_comm));
  delete client_comm;
}

int main(int argc, char** argv) {
  int num_clients = 1; // Number of clients to attach
 
  // Request multi-threading runtime permissions from MPI
  // becasue this program uses MPI from multiple threads
  int provided;
  MPI_Init_thread(&argc, &argv, MPI_THREAD_MULTIPLE, &provided);

  if (provided < MPI_THREAD_MULTIPLE) {
    std::cerr << "[Server:main] Error: OpenMPI setup does not support concurrent "
                 "multi-threading." << std::endl;

    MPI_Finalize();
    return 1;
  }

  // Get current processor / host name
  char processor_name[MPI_MAX_PROCESSOR_NAME];
  int namelen;
  MPI_Get_processor_name(processor_name, &namelen);

  std::cout << "[Server:main] Hello from processor: " << processor_name << std::endl;

  std::cout << "[Server:main] building Particle datatype" << std::endl;
  Particle::create_mpi_particle_datatype();

  // Open a port and publish a service name so that clients can call MPI_Lookup
  char port_name[MPI_MAX_PORT_NAME];
  MPI_Open_port(MPI_INFO_NULL, port_name);
  MPI_Publish_name(SERVICE_NAME.c_str(), MPI_INFO_NULL, port_name);

  std::cout << "[Server:main] " << SERVICE_NAME << " opened on port: " << port_name << std::endl;

  server_running = true; // Set up your exit triggers for global shutdown if needed
  
  int i = 0;
  while (server_running) {

    if(i < num_clients) {
      MPI_Comm* client_comm = new MPI_Comm;
      std::cout << "[Server:main] Waiting for incoming client handshakes..." << std::endl;

      if (MPI_Comm_accept(port_name, MPI_INFO_NULL, 0, MPI_COMM_SELF,
                          client_comm) == MPI_SUCCESS) {
        std::cout << "[Server:main] Client accepted! Offloading to new worker thread." << std::endl;

        client_comms.push_back(client_comm);
        workers.push_back(std::thread(handle_client, client_comm));
        ++i;
      }
    } else {
      if(client_comms.empty()) {
        std::cout << "[Server:main] no more clients. Closing..." << std::endl;
        server_running = false;
      }
    }
  }

  for (auto &t : workers) {
    if (t.joinable())
      t.join();
  }
 
  // Unpublish service name and close port.
  MPI_Unpublish_name(SERVICE_NAME.c_str(), MPI_INFO_NULL, port_name);
  MPI_Close_port(port_name);
  MPI_Finalize();

  return 0;
}
