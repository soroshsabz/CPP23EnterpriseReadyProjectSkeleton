#! /usr/bin/env bash
#
# ITNOA
#
# Authors: Bert Van Vreckem <bert.vanvreckem@gmail.com>; Seyyed Soroosh Hosseinalipour <soorosh_abi@hotmail.com>
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
    apt install --assume-yes gcc ninja-build zip unzip build-essential pkg-config
    prepare_cmake
    prepare_gcc
    prepare_coverage_tool
    prepare_vcpkg
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

    if [[ ${gcc_version} < 16.0 ]] ; then
        echo "gcc version is lower than required"
        install_gcc
    fi

}

function prepare_coverage_tool() {
    local gcovr_version=$(gcovr --version | head -n 1 | cut -d ' ' -f 2)
    readonly gcovr_version
    echo "GCovr version is: ${gcovr_version}"

    if [[ ${gcovr_version} < 7.0 ]] ; then
        echo "gcovr version is lower than required"
        install_coverage_tool
    fi
}

function prepare_vcpkg() {
    local vcpkg_version=$(vcpkg --version | head -n 1 | cut -d ' ' -f 6)
    readonly vcpkg_version
    echo "VCPKG version is: ${vcpkg_version}"

    if [[ ${vcpkg_version} < 2026 ]] ; then
        echo "vcpkg version is lower than required"
        install_vcpkg
    fi
}

function install_cmake() {
    # TODO: Check distro and version
    apt install --assume-yes ca-certificates gpg wget
    test -f /usr/share/doc/kitware-archive-keyring/copyright ||
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ resolute main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
    apt update
    apt install --assume-yes kitware-archive-keyring
    apt install --assume-yes cmake
}

function install_gcc() {
    # TODO: Check distro and version
    apt install --assume-yes g++-16
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-16 100
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-16 100
}

function install_coverage_tool() {
    # TODO: Check distro and version
    apt install --assume-yes gcovr
}

function install_vcpkg() {
    # FIXME: this method does not work for normal users
    apt install --assume-yes git
    cd ~ && git clone https://github.com/microsoft/vcpkg.git
    ~/vcpkg/bootstrap-vcpkg.sh
    ln -s ~/vcpkg/vcpkg /usr/local/bin/vcpkg

    cd ~ && export VCPKG_ROOT=`pwd`/vcpkg
    export PATH=$VCPKG_ROOT:$PATH
}

function finish() {
  result=$?
  # Your cleanup code here
  exit ${result}
}

trap finish EXIT ERR

main "${@}"

