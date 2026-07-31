# C++23 Enterprise Ready Project Skeleton (Template)

ITNOA

[![C++23](https://img.shields.io/badge/C%2B%2B-23-blue.svg)](https://isocpp.org/)
[![CMake](https://img.shields.io/badge/CMake-3.25%2B-064F8C.svg?logo=cmake&logoColor=white)](https://cmake.org/)
[![vcpkg](https://img.shields.io/badge/dependencies-vcpkg-5C2D91.svg)](https://github.com/microsoft/vcpkg)
[![License: MIT](https://img.shields.io/github/license/soroshsabz/CPP23EnterpriseReadyProjectSkeleton)](https://github.com/soroshsabz/CPP23EnterpriseReadyProjectSkeleton/blob/main/LICENSE)
[![CI](https://github.com/soroshsabz/CPP23EnterpriseReadyProjectSkeleton/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/soroshsabz/CPP23EnterpriseReadyProjectSkeleton/actions/workflows/main.yml)
[![codecov](https://codecov.io/gh/soroshsabz/CPP23EnterpriseReadyProjectSkeleton/branch/main/graph/badge.svg)](https://codecov.io/gh/soroshsabz/CPP23EnterpriseReadyProjectSkeleton)

A modern **C++23** project template designed for building **clean, maintainable, and enterprise-ready** applications.

> Use this repository as a starting point for new C++23 projects with a consistent structure, modern tooling, and scalable conventions.

[!TIP]
Use this repository as a template to create a new project with the same structure and configuration.

## Features

- Modern **C++23** support
- **CMake**-based build system
- **vcpkg** dependency management
- Ready for **scalable enterprise codebases**
- Clear and extensible project structure
- Designed with **maintainability**, **portability**, and **developer productivity** in mind
- Supports future extension for:
  - unit testing
  - static analysis
  - formatting
  - CI/CD pipelines
  - modular C++ architecture

## Getting Started

### 1. Use as a GitHub template

Click the **Use this template** button to create a new repository from this project.

### 2. Install prerequisites

- Install [CMake](https://cmake.org/)
- Install [vcpkg](https://learn.microsoft.com/en-us/vcpkg/)
- Install a C++23-capable compiler
  - MSVC 2026+
  - GCC 14+
  - Clang 16+

### 3. Configure dependencies

This project uses **vcpkg** for dependency management.

Example:

```bash
Bootstrap.ps1   # Windows
# or
Bootstrap.sh    # Linux/macOS
```

### 4. Build the project

```bash
cmake -S . -B build
cmake --build build
```

## Project Structure

A typical structure for this template is:

```text
.
├── CMakeLists.txt
├── CMakePresets.json
├── README.md
├── src/
├── include/
├── tests/
├── modules/
├── docs/
└── vcpkg.json
```

### Directory overview

- src/ — implementation files
- include/ — public headers
- tests/ — unit and integration tests
- modules/ — C++20/23 module interface units
- docs/ — documentation assets
- vcpkg.json — dependency manifest
- CMakePresets.json — build and configure presets

## Powered by

### Modules

Inspired by modern C++ module adoption strategies, including Microsoft’s guidance on moving projects to named modules:

- [An article from Microsoft dev blogs about moving a project to cpp named modules](https://devblogs.microsoft.com/cppblog/moving-a-project-to-cpp-named-modules/)

### Project Structure Inspiration

This template was informed by several modern C++ template projects and conventions:

- [Pitchfork](https://github.com/vector-of-bool/pitchfork/) - Pitchfork is a set of conventions for native C and C++ projects.
- [Modern C++ Template](https://github.com/filipdutescu/modern-cpp-template) - A quick C++ template for modern CMake projects, aimed to be an easy to use starting point.
- [Cpp Project Template](https://github.com/Barthelemy/CppProjectTemplate) - This C++ project demonstrates the usage of CMake, boost's test, boost's option parsing and Doxygen.
- [cpp-project](https://github.com/bsamseth/cpp-project) - Boiler plate for C++ projects
- [Template For C++ Projects](https://github.com/franneck94/CppProjectTemplate) - This is a template for modern C++ projects.
- [ModernCppStarter](https://github.com/TheLartians/ModernCppStarter) - Setting up a new C++ project usually requires a significant amount of preparation and boilerplate code, even more so for modern C++ projects with tests, executables and continuous integration.
- [A C++ project template based on CMake and vcpkg](https://github.com/lukka/CppCMakeVcpkgTemplate) - This repository contains a C++ based project template that leverages vcpkg and CMake's CMakePresets.json to build and test C++ source code.

## Contributing

Contributions are welcome.

If you add new tools, conventions, or project structure improvements, please keep the template:

- simple
- consistent
- well-documented
- easy to extend