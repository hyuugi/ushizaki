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
  -h   Print usage
  -v   Verbose output"

# Debian GNU/Linux packages
HYDRUS_NETWORK_PACKAGES="ffmpeg git libsqlite3-dev python3 python3-venv"
POETRY_PACKAGES="python3 python3-venv"
HYDOWNLOADER_PACKAGES="ffmpeg git python3 python3-venv"

BASE_INSTALL_DIR="./install_directory"

HYDRUS_NETWORK_REPOSITORY="https://github.com/hydrusnetwork/hydrus.git"
HYDRUS_NETWORK_INSTALL_DIR="${BASE_INSTALL_DIR}/hydrus_network/"
HYDRUS_NETWORK_VENV="${BASE_INSTALL_DIR}/venv_hydrus_network/"

POETRY_VENV="${BASE_INSTALL_DIR}/venv_poetry/"

HYDOWNLOADER_REPOSITORY="https://gitgud.io/thatfuckingbird/hydownloader.git"
HYDOWNLOADER_INSTALL_DIR="${BASE_INSTALL_DIR}/hydownloader/"
# This is where poetry expects a local venv to be.
HYDOWNLOADER_VENV="${HYDOWNLOADER_INSTALL_DIR}/.venv"

verbosity_level=0
VERBOSE_NORMAL=0

display_usage () {
	printf '%s\n' "${USAGE}"
	exit "$1"
}

while getopts hv arg
do
	case ${arg} in
		h)  display_usage 0;;
		v)  verbosity_level=$((verbosity_level + 1));;
		*)  display_usage 1;;
	esac
done

packages_are_installed () {
	packages_missing=0

	for p in $1
	do
		if dpkg-query -W | grep -q "^${p}"
		then
			if [ "${verbosity_level}" -gt "${VERBOSE_NORMAL}" ]
			then
				printf '%s\n' "Package is installed: ${p}"
			fi
		else
			printf '%s\n' "Missing package: ${p}"
			packages_missing=$((packages_missing + 1))
		fi
	done

	if [ "${packages_missing}" -ne 0 ]
	then
		printf '%s\n' "Number of missing packages: ${packages_missing}"
		exit 1
	fi
}

setup_venv () {
	python3 -m venv "${1}"
	"${1}/bin/python" -m pip install -U pip
	"${1}/bin/python" -m pip install -U wheel setuptools
}

packages_are_installed "${HYDRUS_NETWORK_PACKAGES}"
git clone "${HYDRUS_NETWORK_REPOSITORY}" "${HYDRUS_NETWORK_INSTALL_DIR}"
setup_venv "${HYDRUS_NETWORK_VENV}"
"${HYDRUS_NETWORK_VENV}/bin/python" -m pip install -r "${HYDRUS_NETWORK_INSTALL_DIR}"/requirements.txt


packages_are_installed "${POETRY_PACKAGES}"
setup_venv "${POETRY_VENV}"
"${POETRY_VENV}/bin/python" -m pip install poetry


packages_are_installed "${HYDOWNLOADER_PACKAGES}"
git clone "${HYDOWNLOADER_REPOSITORY}" "${HYDOWNLOADER_INSTALL_DIR}"
setup_venv "${HYDOWNLOADER_VENV}"
"${POETRY_VENV}/bin/poetry" -C "${HYDOWNLOADER_INSTALL_DIR}" install

