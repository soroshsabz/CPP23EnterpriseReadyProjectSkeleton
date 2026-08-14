# CMakeList.txt : CMake project for CPP23EnterpriseReadyProjectSkeleton, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.31 FATAL_ERROR)

# Prevent building in the source directory
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
if (CMAKE_VERSION VERSION_GREATER_EQUAL 4.4)
	# see https://github.com/Kitware/CMake/blob/v4.4.2/Help/dev/experimental.rst to retrieve UUID value
	set (CMAKE_EXPERIMENTAL_CXX_IMPORT_STD f35a9ac6-8463-4d38-8eec-5d6008153e7d)
elseif (CMAKE_VERSION VERSION_GREATER 4.3)
	# see https://github.com/Kitware/CMake/blob/v4.3.1/Help/dev/experimental.rst to retrieve UUID value
	set (CMAKE_EXPERIMENTAL_CXX_IMPORT_STD 451f2fe2-a8a2-47c3-bc32-94786d8fc91b)
elseif (CMAKE_VERSION VERSION_GREATER 4.0)
	set (CMAKE_EXPERIMENTAL_CXX_IMPORT_STD d0edc3af-4c50-42ea-a356-e2862fe7a444)
elseif (CMAKE_VERSION VERSION_GREATER 3.31)
	# see https://github.com/Kitware/CMake/blob/v3.31.6/Help/dev/experimental.rst to retrieve UUID value
	set (CMAKE_EXPERIMENTAL_CXX_IMPORT_STD 0e5b6991-d74f-4b3d-a41c-cf096e0b2508)
endif ()

# Project details
project (CPP23EnterpriseReadyProjectSkeleton
	VERSION 0.1.0
	LANGUAGES CXX)

string(TOUPPER ${PROJECT_NAME} PROJECT_OPTION_PREFIX)

#
# Set project options
#

# MAKE_EXPORT_COMPILE_COMMANDS is a CMake variable that, when enabled, tells CMake to generate a file named compile_commands.json during the build system generation step.
# This JSON file contains the exact compiler commands used for each translation unit (.c, .cpp, etc.) in your project.
# It’s especially useful for tools like clangd, clang-tidy, cppcheck, and IDEs that need to know your exact compiler flags and include paths.
# TODO: For per-target control, CMake 4.4+ supports the EXPORT_COMPILE_COMMANDS target property:
# set_target_properties(my_target PROPERTIES EXPORT_COMPILE_COMMANDS ON)
if(NOT DEFINED CMAKE_EXPORT_COMPILE_COMMANDS)
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE BOOL
      "Generate compile_commands.json for editor and analysis tooling")
endif()

include(cmake/StandardSettings.cmake)
include(cmake/Utils.cmake)
message(STATUS "Started CMake for ${PROJECT_NAME} v${PROJECT_VERSION}...\n")

if (UNIX)
# TODO: For per-target control
#target_compile_definitions(exe
#    PRIVATE
#        # If the debug configuration pass the DEBUG define to the compiler 
#        $<$<CONFIG:Debug>:DEBUG>
#)
# FIXME: Check not work in release mode
    add_compile_options("$<$<CONFIG:DEBUG>:-D_DEBUG>")    #this will allow to use same _DEBUG macro available in both Linux as well as Windows - MSCV environment. Easy to put Debug specific code.
endif (UNIX)

# Tell CMake that we explicitly want `import std`. This will initialize the
# property on all targets declared after this to 1
# Both gcc and msvc version must be greater than 15 to support `import std`
if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 15)
	set (CMAKE_CXX_MODULE_STD ON)
endif ()

set	(CMAKE_CXX_STANDARD 23)
set	(CMAKE_CXX_STANDARD_REQUIRED YES)
set	(CMAKE_CXX_EXTENSIONS OFF)

#
# Create library, setup header and source files
#

# Find all headers and implementation files
include(cmake/SourcesAndHeaders.cmake)

message ("CMAKE_CXX_SOURCE_FILE_EXTENSIONS ${CMAKE_CXX_SOURCE_FILE_EXTENSIONS}")

# All sources in src except main.cpp as a one library
add_library (${PROJECT_NAME}_INTERNAL_LIB)
target_sources (${PROJECT_NAME}_INTERNAL_LIB
	PRIVATE
		${LIBRARY_SOURCES}

		FILE_SET private_headers
		TYPE HEADERS
		BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/src
		FILES
			${LIBRARY_HEADERS}

		FILE_SET private_cxx_modules
		TYPE CXX_MODULES
		BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/src
		FILES
			${LIBRARY_MODULES}
	PUBLIC
		FILE_SET public_headers
		TYPE HEADERS
		BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/include
		FILES
			${LIBRARY_PUBLIC_HEADERS}
		
		FILE_SET public_cxx_modules
		TYPE CXX_MODULES
		BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/modules
		FILES
			${LIBRARY_PUBLIC_MODULES}
	)

target_compile_features (${PROJECT_NAME}_INTERNAL_LIB
	PRIVATE
		cxx_std_23
	PUBLIC
		cxx_std_23)

if (${PROJECT_OPTION_PREFIX}_VERBOSE_OUTPUT)
  verbose_message("Found the following sources:")
  foreach(source IN LISTS LIBRARY_SOURCES)
    verbose_message("* ${source}")
  endforeach()
  verbose_message("Found the following headers:")
  foreach(header IN LISTS LIBRARY_HEADERS LIBRARY_PUBLIC_HEADERS)
    verbose_message("* ${header}")
  endforeach()
  verbose_message("Found the following modules:")
  foreach(module IN LISTS LIBRARY_MODULES LIBRARY_PUBLIC_MODULES)
	verbose_message("* ${module}")	
  endforeach(module)
endif()

if (${PROJECT_OPTION_PREFIX}_BUILD_EXECUTABLE)
	# Add source to this project's executable.
	add_executable (${PROJECT_NAME})
	target_sources (${PROJECT_NAME}
		PRIVATE
			${APPLICATION_SOURCES})
	target_link_libraries (${PROJECT_NAME} ${PROJECT_NAME}_INTERNAL_LIB)

	if (${PROJECT_OPTION_PREFIX}_VERBOSE_OUTPUT)
	    verbose_message("Found the following sources:")
	    foreach(source IN LISTS APPLICATION_SOURCES)
	      verbose_message("* ${source}")
	    endforeach()
	endif ()
elseif (${PROJECT_OPTION_PREFIX}_BUILD_HEADERS_ONLY)
	add_library(${PROJECT_NAME} INTERFACE)
	target_sources(${PROJECT_NAME}
		INTERFACE
			FILE_SET HEADERS
			TYPE HEADERS
			FILES
				${LIBRARY_PUBLIC_HEADERS}
			FILE_SET CXX_MODULES
			TYPE CXX_MODULES
			FILES
				${LIBRARY_PUBLIC_MODULES}
	)
else ()
	add_library(${PROJECT_NAME})
	target_link_libraries(${PROJECT_NAME} ${PROJECT_NAME}_INTERNAL_LIB)
endif ()

message (STATUS "Added all header / module and implementation files. \n")

if (${PROJECT_OBTION_PREFIX}_BUILD_HEADERS_ONLY)
	target_compile_features(${PROJECT_NAME} INTERFACE cxx_std_23)
else ()
	target_compile_features (${PROJECT_NAME} PRIVATE cxx_std_23 PUBLIC cxx_std_23)
endif ()

include(CTest)

if(BUILD_TESTING)
    find_package(GTest CONFIG REQUIRED)

    add_executable(CPP23EnterpriseReadyProjectSkeletonTests
        tests/Component1Tests.cpp
    )

    target_link_libraries(CPP23EnterpriseReadyProjectSkeletonTests
        PRIVATE
            CPP23EnterpriseReadyProjectSkeletonLib
            GTest::gtest_main
    )

    include(GoogleTest)

    gtest_discover_tests(CPP23EnterpriseReadyProjectSkeletonTests)
endif()
