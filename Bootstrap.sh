#! /usr/bin/env bash
#
# ITNOA
#
# Author: Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
#/ Usage: Bootstrap.sh [OPTIONS]... [ARGUMENTS]...
#/
#/ 
#/ OPTIONS
#/   -h, --help
#/                Print this help message
#/
#/ EXAMPLES
#/  

# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't hide errors within pipes
set -o pipefail

IFS=$'\t\n'   # Split on newlines and tabs (but not on spaces)
script_name=$(basename "${0}")
script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly script_name script_dir

function main() {
    # check_args "${@}"
    apt install --assume-yes gcc ninja-build
    prepare_cmake
    prepare_gcc
    :
}

function prepare_cmake() {
    local cmake_version=$(cmake --version | head -n 1 | cut -d ' ' -f 3)
    readonly cmake_version
    echo "CMake version is: ${cmake_version}"

    if [[ ${cmake_version} < 3.31  ]] ; then
        echo "cmake version is lower than required"
        install_cmake
    fi
}

function prepare_gcc() {
    local gcc_version=$(gcc --version | head -n 1 | cut -d ' ' -f 4)
    readonly gcc_version
    echo "GCC version is: ${gcc_version}"

    if [[ ${gcc_version} < 14.2 ]] ; then
        echo "gcc version is lower than required"
        install_gcc
    fi

}

function install_cmake() {
    # TODO: Check distro and version
    apt install --assume-yes ca-certificates gpg wget
    test -f /usr/share/doc/kitware-archive-keyring/copyright ||
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ noble main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
    apt update
    apt install --assume-yes kitware-archive-keyring
    apt install --assume-yes cmake
}

function install_gcc() {
    # TODO: Check distro and version
    apt install --assume-yes g++-14
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 100
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 100
}

function finish() {
  result=$?
  # Your cleanup code here
  exit ${result}
}

trap finish EXIT ERR

main "${@}"

