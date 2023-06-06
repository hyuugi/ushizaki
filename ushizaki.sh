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
  -h   Print usage"

BASE_INSTALL_DIR="./install_directory"

HYDRUS_NETWORK_REPOSITORY="https://github.com/hydrusnetwork/hydrus.git"
HYDRUS_NETWORK_INSTALL_DIR="${BASE_INSTALL_DIR}/hydrus_network/"
HYDRUS_NETWORK_VENV="${BASE_INSTALL_DIR}/venv_hydrus_network/"

POETRY_VENV="${BASE_INSTALL_DIR}/venv_poetry/"

HYDOWNLOADER_REPOSITORY="https://gitgud.io/thatfuckingbird/hydownloader.git"
HYDOWNLOADER_INSTALL_DIR="${BASE_INSTALL_DIR}/hydownloader/"
# This is where poetry expects a local venv to be.
HYDOWNLOADER_VENV="${HYDOWNLOADER_INSTALL_DIR}/.venv"

HYDOWNLOADER_SYSTRAY_REPOSITORY="https://gitgud.io/thatfuckingbird/hydownloader-systray.git"
HYDOWNLOADER_SYSTRAY_INSTALL_DIR="${BASE_INSTALL_DIR}/hydownloader_systray"
HYDOWNLOADER_SYSTRAY_BUILD_DIR="${HYDOWNLOADER_SYSTRAY_INSTALL_DIR}/build"

HYDRUS_COMPANION_REPOSITORY="https://gitgud.io/prkc/hydrus-companion.git"
HYDRUS_COMPANION_INSTALL_DIR="${BASE_INSTALL_DIR}/hydrus_companion"

display_usage () {
	printf '%s\n' "${USAGE}"
	exit "$1"
}

while getopts h arg
do
	case ${arg} in
		h)  display_usage 0;;
		*)  display_usage 1;;
	esac
done

setup_venv () {
	python3 -m venv "${1}"
	"${1}/bin/python" -m pip install -U pip
	"${1}/bin/python" -m pip install -U wheel setuptools
}

git clone "${HYDRUS_NETWORK_REPOSITORY}" "${HYDRUS_NETWORK_INSTALL_DIR}"
setup_venv "${HYDRUS_NETWORK_VENV}"
"${HYDRUS_NETWORK_VENV}/bin/python" -m pip install -r "${HYDRUS_NETWORK_INSTALL_DIR}"/requirements.txt


setup_venv "${POETRY_VENV}"
"${POETRY_VENV}/bin/python" -m pip install poetry


git clone "${HYDOWNLOADER_REPOSITORY}" "${HYDOWNLOADER_INSTALL_DIR}"
setup_venv "${HYDOWNLOADER_VENV}"
"${POETRY_VENV}/bin/poetry" -C "${HYDOWNLOADER_INSTALL_DIR}" install


git clone "${HYDOWNLOADER_SYSTRAY_REPOSITORY}" "${HYDOWNLOADER_SYSTRAY_INSTALL_DIR}"
git -C "${HYDOWNLOADER_SYSTRAY_INSTALL_DIR}" submodule update --init
mkdir "${HYDOWNLOADER_SYSTRAY_BUILD_DIR}"
cmake -S "${HYDOWNLOADER_SYSTRAY_INSTALL_DIR}" -B "${HYDOWNLOADER_SYSTRAY_BUILD_DIR}"
make -C "${HYDOWNLOADER_SYSTRAY_BUILD_DIR}"


git clone "${HYDRUS_COMPANION_REPOSITORY}" "${HYDRUS_COMPANION_INSTALL_DIR}"
