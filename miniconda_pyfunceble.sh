#!/usr/bin/env bash
# All initial credits to @mitchellkrogza and @funilrys
# Modified by @spirillen
# -------------------------------
# Setup Conda Python Environments
# -------------------------------

# Stop on any error
set -e

# Run this script by appending test-file to the script name in the shell prompt
# E.g. miniconda_pyfunceble.sh "/full/path/to/file"

if [ -z "${1}" ]
then
	printf "You forgot to tell me what to test...\nPlease use ${0} /full/path/to/file\n\n"
	exit 1
fi

# Change the output directory to suite your needs
read -e -p "Enter output directory for test results: " -i "/tmp/pyfuncebletesting/$(date +'%H%M')" _outdir

# Clean output dir if exist for a clean test environment
if [ -d "${_outdir}" ]
then
	rm -fr "${_outdir}"
fi

# Set your desired pyfunceble verion
read -e -p "Which version of PyFunceble would you like to use?: pyfunceble or pyfunceble-dev: " -i "pyfunceble-dev" _pyfv

# Set python version
_pyv="3.8.2"

# set your test string.
# IMPORTANT: the -f argument is preset as last argument
read -e -p "Enter any custom test string: " -i "--dns 1.1.1.3 -m -p $(nproc --ignore=2) -h --plain -a --dots -vsc" _string

# 1. Add Conda Path to .bashrc (add line below to bottom of bashrc)
export PATH="${HOME}/miniconda/bin:${PATH}"

# 2. Reload your bashrc
source "$HOME/.bashrc"

# 3. First Update Conda
conda update -q conda

# 4. Activate your environment
source activate pyfuncebletesting

# 5. Make sure output dir is there
mkdir -p "${_outdir}"

# 6. Upgrade your environment
pip install --upgrade pip
pip uninstall -y pyfunceble pyfunceble-dev
pip install "${_pyfv}" --upgrade

# Tell the script to install/update the configuration file automatically.
export PYFUNCEBLE_AUTO_CONFIGURATION=yes

# 7. Export the Path to PyFunceble before running PyFunceble
export PYFUNCEBLE_CONFIG_DIR="${_outdir}/"

# 8. Run PyFunceble
PyFunceble ${_string} -f "${1}"

# 9. When finished - Deactivate the environment
conda deactivate

echo ${?}
