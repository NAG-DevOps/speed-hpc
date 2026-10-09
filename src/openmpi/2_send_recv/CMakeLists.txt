cmake_minimum_required(VERSION 3.10)

project(send_recv)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_BUILD_TYPE Debug)

find_package(MPI REQUIRED
    COMPONENTS CXX
)

set(SRC
  src/main.cpp
)

add_executable(${PROJECT_NAME} ${SRC})

target_link_libraries(${PROJECT_NAME}
  MPI::MPI_CXX
)
