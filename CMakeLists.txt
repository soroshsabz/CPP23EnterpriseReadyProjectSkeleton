# CMakeList.txt : CMake project for CPP23EnterpriseReadyProjectSkeleton, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.31 FATAL_ERROR)

# Enable Hot Reload for MSVC compilers if supported.
if (POLICY CMP0141)
  cmake_policy(SET CMP0141 NEW)
  set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>")
endif()

# Set experimental flag to enable `import std` support from CMake.
# This must be enabled before C++ language support.
#
# This specific value changes as experimental support evolves. See
# `Help/dev/experimental.rst` in the CMake source corresponding to
# your CMake build for the exact value to use.
if (CMAKE_VERSION VERSION_GREATER 3.31)
	# see https://github.com/Kitware/CMake/blob/v3.31.6/Help/dev/experimental.rst to retrive UUID value
	set (CMAKE_EXPERIMENTAL_CXX_IMPORT_STD 0e5b6991-d74f-4b3d-a41c-cf096e0b2508)
elseif (CMAKE_VERSION VERSION_GREATER 4.1)
	set (CMAKE_EXPERIMENTAL_CXX_IMPORT_STD d0edc3af-4c50-42ea-a356-e2862fe7a444)
endif ()

project (CPP23EnterpriseReadyProjectSkeleton LANGUAGES CXX)

# Tell CMake that we explicitly want `import std`. This will initialize the
# property on all targets declared after this to 1
set (CMAKE_CXX_MODULE_STD 1)

# set	(CMAKE_CXX_EXTENSIONS OFF)
set	(CMAKE_CXX_STANDARD 23)
set	(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add source to this project's executable.
add_executable (CPP23EnterpriseReadyProjectSkeleton)
target_sources (CPP23EnterpriseReadyProjectSkeleton
	PRIVATE
		"src/main.cpp")

#target_compile_features (CPP23EnterpriseReadyProjectSkeleton PRIVATE cxx_std_23 INTERFACE cxx_std_23)


# TODO: Add tests and install targets if needed.
