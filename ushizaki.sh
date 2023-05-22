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

