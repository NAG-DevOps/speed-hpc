cmake_minimum_required(VERSION 3.10)

project(client_server)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_BUILD_TYPE Debug)

find_package(MPI REQUIRED
    COMPONENTS CXX
)

set(SERVER_SRC
  src/server.cpp
  src/particle.cpp
)

set(CLIENT_SRC
  src/client.cpp
  src/particle.cpp
)

add_executable(server ${SERVER_SRC})
target_include_directories(server PRIVATE include)
target_link_libraries(server
  MPI::MPI_CXX
)

add_executable(client ${CLIENT_SRC})
target_include_directories(client PRIVATE include)
target_link_libraries(client
  MPI::MPI_CXX
)
