# CMakeList.txt : CMake project for CPP23EnterpriseReadyProjectSkeleton, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.31 FATAL_ERROR)

if (CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
	message(FATAL_ERROR "Do not build in-source. Please remove CMakeCache.txt and the CMakeFiles/ directory. Then build out-of-source.")
endif()

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
if (CMAKE_VERSION VERSION_GREATER 4.0)
	set (CMAKE_EXPERIMENTAL_CXX_IMPORT_STD d0edc3af-4c50-42ea-a356-e2862fe7a444)
elseif (CMAKE_VERSION VERSION_GREATER 3.31)
	# see https://github.com/Kitware/CMake/blob/v3.31.6/Help/dev/experimental.rst to retrive UUID value
	set (CMAKE_EXPERIMENTAL_CXX_IMPORT_STD 0e5b6991-d74f-4b3d-a41c-cf096e0b2508)
endif ()

project (CPP23EnterpriseReadyProjectSkeleton
	VERSION 0.1.0
	LANGUAGES CXX)

# Tell CMake that we explicitly want `import std`. This will initialize the
# property on all targets declared after this to 1
# Both gcc and msvc version must be greater than 15 to support `import std`
if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 15)
	set (CMAKE_CXX_MODULE_STD 1)
endif ()

# set	(CMAKE_CXX_EXTENSIONS OFF)
set	(CMAKE_CXX_STANDARD 23)
set	(CMAKE_CXX_STANDARD_REQUIRED YES)

message ("CMAKE_CXX_SOURCE_FILE_EXTENSIONS ${CMAKE_CXX_SOURCE_FILE_EXTENSIONS}")

# All sources in src except main.cpp as a one library
add_library (CPP23EnterpriseReadyProjectSkeletonLib)
target_sources (CPP23EnterpriseReadyProjectSkeletonLib
	PRIVATE
		src/ModuleA/Component1.cpp
	PUBLIC FILE_SET CXX_MODULES
	FILES
	"src/ModuleA/Component1.ixx"
	"src/ModuleA/ModuleA.ixx")


# Add source to this project's executable.
add_executable (CPP23EnterpriseReadyProjectSkeleton)
target_sources (CPP23EnterpriseReadyProjectSkeleton
	PRIVATE
		"src/main.cpp")
target_link_libraries (CPP23EnterpriseReadyProjectSkeleton CPP23EnterpriseReadyProjectSkeletonLib)

#target_compile_features (CPP23EnterpriseReadyProjectSkeleton PRIVATE cxx_std_23 INTERFACE cxx_std_23)


# TODO: Add tests and install targets if needed.
