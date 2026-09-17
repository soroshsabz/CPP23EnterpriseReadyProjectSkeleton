# ITNOA

set(LIBRARY_SOURCES
    Source/ModuleA/Component1.cpp
    Source/SubTraditionalLibA/LibA.cpp
)

set(LIBRARY_MODULES
    Source/ModuleA/Component1.ixx
    Source/ModuleA/ModuleA.ixx
)

set(APPLICATION_SOURCES
	Source/main.cpp
)

set(LIBRARY_HEADERS
    Source/SubTraditionalLibA/LibA.h
)

set(LIBRARY_PUBLIC_HEADERS
    Include/PublicLibA.h
)

set(LIBRARY_PUBLIC_MODULES
    Modules/PublicModuleA.ixx
)

set(TEST_SOURCES
  Tests/Component1Tests.cpp
)