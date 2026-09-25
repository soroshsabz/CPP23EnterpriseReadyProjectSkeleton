# ITNOA

set(LIBRARY_SOURCES
    Source/ModuleA/Component1.cpp
    Source/SubTraditionalLibA/LibA.cpp
)

set(LIBRARY_MODULES
    Source/ModuleA/Component1.cppm
    Source/ModuleA/ModuleA.cppm
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
    Modules/PublicModuleA.cppm
)

set(TEST_SOURCES
  Tests/Component1Tests.cpp
)