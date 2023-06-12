cmake_minimum_required(VERSION 3.16)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CUDA_STANDARD 14)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)

set(CUDA_CPP cuda-cpp CACHE INTERNAL "")

if(UNIX)
    if ("${CMAKE_BUILD_TYPE}" STREQUAL "")
        set(CMAKE_BUILD_TYPE RELEASE)
    else()
        string(TOUPPER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE)
    endif()

    set(CMAKE_CUDA_COMPILER /usr/local/cuda/bin/nvcc)

    # https://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/
    set(CMAKE_CUDA_ARCHITECTURES 86) # Ampere RTX30xx 
endif()

project(
    ${CUDA_CPP}
    VERSION 0.1.0
    DESCRIPTION "simple cuda starter/playground"
    LANGUAGES CXX CUDA
)

file(GLOB_RECURSE ${CUDA_CPP_SOURCES}
    *.h
    rtc/*.h
)

find_package(CUDAToolkit REQUIRED)

add_library(${CUDA_CPP} INTERFACE ${CUDA_CPP_SOURCES})
target_link_libraries(${CUDA_CPP} INTERFACE CUDA::cudart_static CUDA::cuda_driver) 

target_include_directories(${CUDA_CPP} INTERFACE 
    ${CMAKE_CURRENT_LIST_DIR} 
    ${CMAKE_CURRENT_LIST_DIR}/rtc 
)

if(CMAKE_BUILD_TYPE STREQUAL RELEASE)
    target_compile_options(${CUDA_CPP} INTERFACE
        $<$<COMPILE_LANGUAGE:CXX>: -O3 -Wall -Wextra -Wreorder-ctor>
        $<$<COMPILE_LANGUAGE:CUDA>: --extended-lambda>
    )
elseif(CMAKE_BUILD_TYPE STREQUAL DEBUG)
    target_compile_options(${CUDA_CPP} INTERFACE
        $<$<COMPILE_LANGUAGE:CXX>: -O0 -g -Wall -Wextra -Wreorder-ctor -Wconversion>
    )
endif()
