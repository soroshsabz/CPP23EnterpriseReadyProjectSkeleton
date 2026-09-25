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

# shellcheck disable=SC2034
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

    if update-alternatives --query gcc 2>&1; then
        update-alternatives --remove-all gcc
        update-alternatives --remove-all g++
    fi

    if update-alternatives --query gcov 2>&1; then
        update-alternatives --remove-all gcov
    fi

    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-16 100
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-16 100
    update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-16 100
}

function install_coverage_tool() {
    echo "Installing GCovr..."
    # TODO: Check distro and version
    apt install --assume-yes gcovr
}

function install_vcpkg() {
    echo "Installing VCPKG..."

    # Ensure @func fetch_and_bootstrap_vcpkg function is cleand up when outer function exits. (even on errors)
    trap 'unset -f fetch_and_bootstrap_vcpkg' RETURN

    # FIXME: this method does not work for normal users
    apt install --assume-yes git

    function fetch_and_bootstrap_vcpkg() {
        # Maybe run in subshell
        set -o pipefail

        # TODO: Check for RETURN
        log_file=$(mktemp)
        readonly log_file
        trap 'rm -f "${log_file}"' EXIT

        echo "Try to fetch or update vcpkg..."
        if [[ -d "$HOME/vcpkg" ]]; then
            echo "Vcpkg directory exist..."
            cd ~/vcpkg
            # TODO: if git pull error, this condition does not trigger
            #       maybe git fatal error in fetch code does not return error
            #       status code correctly, for better debug we need reproduce this situation
            if ! git pull --progress 2>&1 | tee "${log_file}"; then
                git_output=$(<"${log_file}")
                echo "[ERROR] Git clone failed!" >&2
                echo "Details from git:" >&2
                echo "${git_output}" >&2

                local git_http_current_version
                git_http_current_version=$(git config --global --get http.version || echo "")
                readonly git_http_current_version

                local git_http_post_buffer
                git_http_post_buffer=$(git config --global --get http.postBuffer || echo "")
                readonly git_http_post_buffer

                echo "Change some config for more reliability"
                git config --global http.version HTTP/1.1
                git config --global http.postBuffer 524288000

                echo "Retry..."
                if ! git pull --progress 2>&1 | tee "${log_file}"; then
                    git_output=$(<"${log_file}")
                    local status_code
                    status_code=$?
                    readonly status_code
                    echo "[ERROR] Git clone failed!" >&2
                    echo "Defaitls from git:" >&2
                    echo "${git_output}" >&2

                    if [[ -n "${git_http_current_version}" ]]; then
                        git config --global --unset http.version
                    else
                        git config --global http.version "${git_http_current_version}"
                    fi

                    if [[ -n "${git_http_post_buffer}" ]]; then
                        git config --global --unset http.postBuffer
                    else
                        git config --global http.postBuffer "${git_http_post_buffer}"
                    fi
                    exit $status_code
                fi
            fi
        else
            cd ~ ; git clone https://github.com/microsoft/vcpkg.git
        fi

        echo "Run bootstrap-vcpkg..."

        if [[ ! -f "$HOME/vcpkg/vcpkg" ]]; then
            ~/vcpkg/bootstrap-vcpkg.sh
        fi

        if ! grep -q -- "VCPKG_ROOT" ~/.bashrc; then
            echo 'export VCPKG_ROOT=~/vcpkg' >> ~/.bashrc
            echo "export PATH=$VCPKG_ROOT:$PATH" >> ~/.bashrc
        fi
    }

    if [[ -n "${SUDO_USER:-}" && "${USER}" == "root" ]] ; then
        echo "Original User: ${SUDO_USER}"
        sudo -u "${SUDO_USER}" bash -c "$(declare -f fetch_and_bootstrap_vcpkg); fetch_and_bootstrap_vcpkg"
        export VCPKG_ROOT
        VCPKG_ROOT=$(getent passwd "${SUDO_USER}" | cut -d: -f6)/vcpkg
        export PATH=$VCPKG_ROOT:$PATH
    else
        fetch_and_bootstrap_vcpkg
        export VCPKG_ROOT=~/vcpkg
        export PATH=$VCPKG_ROOT:$PATH
    fi

    if [[ -f "/usr/local/bin/vcpkg" ]]; then
        echo "Remove legacy vcpkg in /usr/local/bin/"
        rm -f /usr/local/bin/vcpkg
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
