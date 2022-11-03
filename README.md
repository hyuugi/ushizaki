# Ushizaki

Deploy and maintain the Hydrus Network and supporting programs.

## Purpose

This Ansible collection's goal is to ease the installation, configuration, updating, and management of the Hydrus Network and some of its auxiliary programs. Maintaining a Hydrus installation alone is relatively self-contained. Once complementary software is introduced, manually pulling git repositories, updating dependencies, starting daemons, and tracking configuration changes becomes haphazard. This collection aims to make this process more reliable.

## Installation

As a regular user:

``` sh
# Import the Ansible collection
ansible-galaxy collection install "git+https://github.com/hyuugi/ushizaki.git"
# Set the working directory where all the data will be downloaded
mkdir ushizaki
cd ushizaki
# Run the playbook
ansible-playbook hyuugi.ushizaki.ushizaki
```
