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


# This example configuration script can be executed with the '-c' option.
# dash ushizaki.sh -c example_configuration.sh

# The script is executed by the interpreter, meaning variables will be
# expanded and all commands will be substituted and executed. Only run
# configuration scripts after you have understood what they will do.

# Variables may be copied from ushizaki.sh and their value modified here.

# Some examples:
# Setup alternative database locations.
HYDRUS_NETWORK_DATABASE="${BASE_DATABASE_DIR}/hydrus_network_second_database/"
HYDOWNLOADER_DATABASE="${BASE_DATABASE_DIR}/hydownloader_test_database/"

# Specify which hydownloader site tests to run.
# A list of tests can be found with "hydownloader-tools test --help"
HYDOWNLOADER_TEST_SITES="environment,siteone,sitetwo" # Comma-separated

# Create a different ignition script for these configured variables.
IGNITION_SCRIPT_LOCATION="${BASE_SCRIPT_DIR}/ignition_configured.sh"
