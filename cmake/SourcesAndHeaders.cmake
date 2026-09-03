# ITNOA

set(LIBRARY_SOURCES
    src/ModuleA/Component1.cpp
    src/SubTraditionalLibA/LibA.cpp
)

set(LIBRARY_MODULES
    src/ModuleA/Component1.ixx
    src/ModuleA/ModuleA.ixx
)

set(APPLICATION_SOURCES
		src/main.cpp
		${sources}
)

set(LIBRARY_HEADERS
    src/SubTraditionalLibA/LibA.h
)

set(LIBRARY_PUBLIC_HEADERS
    include/PublicLibA.h
)

set(TEST_SOURCES
  src/tmp_test.cpp
)