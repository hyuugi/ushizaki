# Ushizaki
# Copyright (C) 2023 Hoshiguma Yuugi

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

USAGE="Usage: $(basename "$0") [OPTIONS]
Deploy the Hydrus Network and supporting programs.

Options:
  -h          Print usage
  -c SCRIPT   Execute a shell script to configure the environment"

# Software versions to install. 'git checkout' will receive this value.
HYDRUS_NETWORK_VERSION="v533"
HYDOWNLOADER_VERSION="c5551d428a04cc6a6b5c41cb2087114c5f9005f2"
HYDOWNLOADER_SYSTRAY_VERSION="f0f638c4ee0ff9597d1aa5e494c94a58d6ba5a0d"
HYDRUS_COMPANION_VERSION="7cafd0ae5fc4da62ebb7ed72e90ced03d27b0927"

# Convenience variables. Used to define subsequent variables.
BASE_INSTALL_DIR="./installations/"
BASE_DATABASE_DIR="./databases/"
BASE_SCRIPT_DIR="./"

# Hydrus Network variables.
HYDRUS_NETWORK_REPOSITORY="https://github.com/hydrusnetwork/hydrus.git"
HYDRUS_NETWORK_INSTALL_DIR="${BASE_INSTALL_DIR}/hydrus_network/"
HYDRUS_NETWORK_VENV="${BASE_INSTALL_DIR}/venv_hydrus_network/"
HYDRUS_NETWORK_DATABASE="${BASE_DATABASE_DIR}/hydrus_network_database/"

# Python poetry is installed into this venv.
POETRY_VENV="${BASE_INSTALL_DIR}/venv_poetry/"

# Hydownloader variables.
HYDOWNLOADER_REPOSITORY="https://gitgud.io/thatfuckingbird/hydownloader.git"
HYDOWNLOADER_INSTALL_DIR="${BASE_INSTALL_DIR}/hydownloader/"
# This is where poetry expects a local venv to be. Leave this variable alone.
# https://python-poetry.org/docs/configuration/#virtualenvsin-project
HYDOWNLOADER_VENV="${HYDOWNLOADER_INSTALL_DIR}/.venv/"
HYDOWNLOADER_DATABASE="${BASE_DATABASE_DIR}/hydownloader_database/"
# A list of tests can be found with "hydownloader-tools test --help"
HYDOWNLOADER_TEST_SITES="environment" # Comma-separated

# Hydownloader-systray variables.
HYDOWNLOADER_SYSTRAY_REPOSITORY="https://gitgud.io/thatfuckingbird/hydownloader-systray.git"
HYDOWNLOADER_SYSTRAY_INSTALL_DIR="${BASE_INSTALL_DIR}/hydownloader_systray"
HYDOWNLOADER_SYSTRAY_BUILD_DIR="${HYDOWNLOADER_SYSTRAY_INSTALL_DIR}/build/"

# Hydrus companion variables.
HYDRUS_COMPANION_REPOSITORY="https://gitgud.io/prkc/hydrus-companion.git"
HYDRUS_COMPANION_INSTALL_DIR="${BASE_INSTALL_DIR}/hydrus_companion/"

# Script to start these programs.
IGNITION_SCRIPT_LOCATION="${BASE_SCRIPT_DIR}/ignition.sh"
# Ignition.sh spawns new terminals.
TERMINAL_EMULATOR_COMMAND="xterm -e"

display_usage () {
	printf '%s\n' "${USAGE}"
	exit "$1"
}

while getopts hc: arg
do
	case ${arg} in
		h)  display_usage 0;;
		c)  USHIZAKI_CONFIGURATION_LOCATION="${OPTARG}";;
		*)  display_usage 1;;
	esac
done

if [ -n "${USHIZAKI_CONFIGURATION_LOCATION}" ]
then
	# shellcheck source=./example_configuration.sh
	. "${USHIZAKI_CONFIGURATION_LOCATION}"
fi

# Clone a repository if it does not exist, otherwise git fetch.
# Then checkout a pinned commit. Detached HEAD is the norm.
# $1 - Repository URL
# $2 - Local directory
# $3 - Commit to checkout
git_clone_or_fetch () {
	if [ -d "${2}/.git" ]
	then
		git -C "${2}" fetch --all
	else
		git clone "${1}" "${2}"
	fi

	git -C "${2}" checkout "${3}"
}

# Create venv and update Python utilities
# $1 - Location of the venv
setup_venv () {
	python3 -m venv "${1}"
	"${1}/bin/python" -m pip install -U pip
	"${1}/bin/python" -m pip install -U wheel setuptools
}

# Given two paths, get a path that is relative between them
# $1 - The first path
# $2 - The second path
get_relative_path () {
	realpath -m -s --relative-to "${1}" "${2}"
}

# Create a script to run the programs
create_ignition_script () {
	local IGNITION_SCRIPT_PATH
	IGNITION_SCRIPT_PATH="$(dirname "${IGNITION_SCRIPT_LOCATION}")"
	mkdir -p "${IGNITION_SCRIPT_PATH}"
	# shellcheck disable=SC2312
	cat > "${IGNITION_SCRIPT_LOCATION}" << EOF
${TERMINAL_EMULATOR_COMMAND} "$(get_relative_path "${IGNITION_SCRIPT_PATH}" "${HYDRUS_NETWORK_VENV}/bin/python")" "$(get_relative_path "${IGNITION_SCRIPT_PATH}" "${HYDRUS_NETWORK_INSTALL_DIR}/hydrus_client.py")" -d "$(get_relative_path "${HYDRUS_NETWORK_INSTALL_DIR}" "${HYDRUS_NETWORK_DATABASE}")" &
"$(get_relative_path "${IGNITION_SCRIPT_PATH}" "${POETRY_VENV}/bin/poetry")" -C "$(get_relative_path "${IGNITION_SCRIPT_PATH}" "${HYDOWNLOADER_INSTALL_DIR}")" run hydownloader-tools test --path "$(get_relative_path "${IGNITION_SCRIPT_PATH}" "${HYDOWNLOADER_DATABASE}")" --sites "${HYDOWNLOADER_TEST_SITES}"
${TERMINAL_EMULATOR_COMMAND} "$(get_relative_path "${IGNITION_SCRIPT_PATH}" "${POETRY_VENV}/bin/poetry")" -C "$(get_relative_path "${IGNITION_SCRIPT_PATH}" "${HYDOWNLOADER_INSTALL_DIR}")" run hydownloader-daemon start --path "$(get_relative_path "${IGNITION_SCRIPT_PATH}" "${HYDOWNLOADER_DATABASE}")" &
${TERMINAL_EMULATOR_COMMAND} "$(get_relative_path "${IGNITION_SCRIPT_PATH}" "${HYDOWNLOADER_SYSTRAY_BUILD_DIR}/hydownloader-systray")" &
EOF
}

git_clone_or_fetch "${HYDRUS_NETWORK_REPOSITORY}" "${HYDRUS_NETWORK_INSTALL_DIR}" "${HYDRUS_NETWORK_VERSION}"
setup_venv "${HYDRUS_NETWORK_VENV}"
"${HYDRUS_NETWORK_VENV}/bin/python" -m pip install -r "${HYDRUS_NETWORK_INSTALL_DIR}"/requirements.txt


setup_venv "${POETRY_VENV}"
"${POETRY_VENV}/bin/python" -m pip install -U poetry


git_clone_or_fetch "${HYDOWNLOADER_REPOSITORY}" "${HYDOWNLOADER_INSTALL_DIR}" "${HYDOWNLOADER_VERSION}"
setup_venv "${HYDOWNLOADER_VENV}"
"${POETRY_VENV}/bin/poetry" -C "${HYDOWNLOADER_INSTALL_DIR}" install
"${POETRY_VENV}/bin/poetry" -C "${HYDOWNLOADER_INSTALL_DIR}" run hydownloader-tools init-db --path "${HYDOWNLOADER_DATABASE}"


git_clone_or_fetch "${HYDOWNLOADER_SYSTRAY_REPOSITORY}" "${HYDOWNLOADER_SYSTRAY_INSTALL_DIR}" "${HYDOWNLOADER_SYSTRAY_VERSION}"
git -C "${HYDOWNLOADER_SYSTRAY_INSTALL_DIR}" submodule update --init
mkdir "${HYDOWNLOADER_SYSTRAY_BUILD_DIR}"
cmake -S "${HYDOWNLOADER_SYSTRAY_INSTALL_DIR}" -B "${HYDOWNLOADER_SYSTRAY_BUILD_DIR}"
make -C "${HYDOWNLOADER_SYSTRAY_BUILD_DIR}"


git_clone_or_fetch "${HYDRUS_COMPANION_REPOSITORY}" "${HYDRUS_COMPANION_INSTALL_DIR}" "${HYDRUS_COMPANION_VERSION}"


create_ignition_script
