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
    echo "Preparing CMake..."
    local cmake_version
    cmake_version=$(cmake --version 2>/dev/null | head -n 1 | cut -d ' ' -f 3 || echo "0")
    readonly cmake_version
    echo "CMake version is: ${cmake_version}"

    if dpkg --compare-versions "${cmake_version}" "lt" "3.31"; then
        echo "cmake version is lower than required"
        install_cmake
    fi
}

function prepare_gcc() {
    echo "Preparing GCC..."
    local gcc_version
    gcc_version=$(gcc --version 2>/dev/null | head -n 1 | cut -d ' ' -f 4 || echo "0")
    readonly gcc_version
    echo "GCC version is: ${gcc_version}"

    if dpkg --compare-versions "${gcc_version}" "lt" "16.0"; then
        echo "gcc version is lower than required"
        install_gcc
    fi

}

function prepare_coverage_tool() {
    echo "Preparing GCovr..."
    local gcovr_version
    gcovr_version=$(gcovr --version 2>/dev/null | head -n 1 | cut -d ' ' -f 2 || echo "0")
    readonly gcovr_version
    echo "GCovr version is: ${gcovr_version}"

    if dpkg --compare-versions "${gcovr_version}" "lt" "7.0"; then
        echo "gcovr version is lower than required"
        install_coverage_tool
    fi
}

function prepare_vcpkg() {
    echo "Preparing VCPKG..."
    local vcpkg_version
    vcpkg_version=$(vcpkg --version 2>/dev/null | head -n 1 | cut -d ' ' -f 6 || echo "0")
    echo $?
    readonly vcpkg_version
    echo "VCPKG version is: ${vcpkg_version}"

    if dpkg --compare-versions "${vcpkg_version}" "lt" "2026"; then
        echo "vcpkg version is lower than required"
        install_vcpkg
    fi
}

function install_cmake() {
    echo "Installing CMake..."
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
    echo "Installing GCC..."
    # TODO: Check distro and version
    apt install --assume-yes g++-16
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-16 100
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-16 100
}

function install_coverage_tool() {
    echo "Installing GCovr..."
    # TODO: Check distro and version
    apt install --assume-yes gcovr
}

function install_vcpkg() {
    echo "Installing VCPKG..."
    # FIXME: this method does not work for normal users
    apt install --assume-yes git
    local original_user
    original_user=$(journalctl _COMM=sudo | grep -i 'Bootstrap.sh' | head -n 1 | cut -d ' ' -f 6 || echo "")
    readonly original_user
    if [[ -n "${original_user}" && "${USER}" == "root" ]] ; then
        echo "Original User: ${original_user}"
        sudo -u "${original_user}" bash <<'EOF'
            cd ~ && git clone https://github.com/microsoft/vcpkg.git
            ~/vcpkg/bootstrap-vcpkg.sh

            cd ~
            if ! grep -q -- "VCPKG_ROOT" ~/.bashrc; then
                echo 'export VCPKG_ROOT=`pwd`/vcpkg' >> ~/.bashrc
                echo "export PATH=$VCPKG_ROOT:$PATH" >> ~/.bashrc
            fi
EOF
        export VCPKG_ROOT
        VCPKG_ROOT=$(getent passwd "${original_user}" | cut -d: -f6)/vcpkg
        export PATH=$VCPKG_ROOT:$PATH
    else
        cd ~ && git clone https://github.com/microsoft/vcpkg.git
        ~/vcpkg/bootstrap-vcpkg.sh

        cd ~
        if ! grep -q -- "VCPKG_ROOT" ~/.bashrc; then
            echo 'export VCPKG_ROOT=~/vcpkg' >> ~/.bashrc
            echo "export PATH=$VCPKG_ROOT:$PATH" >> ~/.bashrc
        fi

        export VCPKG_ROOT=~/vcpkg
        export PATH=$VCPKG_ROOT:$PATH
    fi
    ln -s "${VCPKG_ROOT}"/vcpkg /usr/local/bin/vcpkg
}

function finish() {
  result=$?
  # Your cleanup code here
  exit ${result}
}

trap finish EXIT ERR

main "${@}"

