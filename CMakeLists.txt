cmake_minimum_required(VERSION 3.16)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CUDA_STANDARD 11)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)

set(CUDA_PLAYGROUND cuda-playground CACHE INTERNAL "project name")

if(UNIX)
    if ("${CMAKE_BUILD_TYPE}" STREQUAL "")
        set(CMAKE_BUILD_TYPE RELEASE)
    else()
        string(TOUPPER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE)
    endif()
endif()


project(
    ${CUDA_PLAYGROUND}
    VERSION 0.1.0
    DESCRIPTION "simple cuda starter/playground"
    LANGUAGES CXX CUDA
)

add_subdirectory(cuda_cpp)
add_subdirectory(examples)
