cmake_minimum_required(VERSION 3.16)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)

set(CUDA_EXAMPLE cuda-example CACHE INTERNAL "project name")

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
    ${CUDA_EXAMPLE}
    VERSION 0.1.0
    DESCRIPTION "simple cuda starter/playground"
    LANGUAGES CXX CUDA
)

file(GLOB_RECURSE CUDA_EXAMPLE_SRC
    *.cpp
    *.cu
    *.h
)

add_executable(${CUDA_EXAMPLE} ${CUDA_EXAMPLE_SRC})
target_link_libraries(${CUDA_EXAMPLE} PRIVATE ${CUDA_CPP})

# if(CMAKE_BUILD_TYPE STREQUAL RELEASE)
#     target_compile_options(${CUDA_EXAMPLE}
#         $<$<COMPILE_LANGUAGE:CXX>: -O3 -Wall -Wextra -Wreorder-ctor>
#     )
# elseif(CMAKE_BUILD_TYPE STREQUAL DEBUG)
#     target_compile_options(${CUDA_EXAMPLE}
#         $<$<COMPILE_LANGUAGE:CXX>: -O0 -g -Wall -Wextra -Wreorder-ctor -Wconversion>
#     )
# endif()

install(
    TARGETS ${CUDA_EXAMPLE}
    DESTINATION ${CMAKE_INSTALL_PREFIX}
)
