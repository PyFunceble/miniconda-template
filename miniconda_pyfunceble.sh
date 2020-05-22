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

# Set conda install dir
condaInstallDir="${HOME}/miniconda"

if [[ -z "${1}" ]]
then
	printf "You forgot to tell me what to test...\nPlease use ${0} /full/path/to/file\n\n"
	exit 1
fi

# Change the output directory to suite your needs
read -e -p "Enter output directory for test results: " -i "/tmp/pyfuncebletesting/$(date +'%H%M')" outputDir

# Clean output dir if exist for a clean test environment
if [[ -d "${outputDir}" ]]
then
	rm -fr "${outputDir}"
fi

# Set your desired pyfunceble verion
read -e -p "Which version of PyFunceble would you like to use?: pyfunceble or pyfunceble-dev: " -i "pyfunceble-dev" pyfunceblePackageName

# set your test string.
# IMPORTANT: the -f argument is preset as last argument
read -e -p "Enter any custom test string: " -i "--dns 1.1.1.3 -m -p $(nproc --ignore=2) -h --plain -a --dots -vsc" pyfuncebleArgs

# Get the conda CLI.
source ${condaInstallDir}/etc/profile.d/conda.sh

hash conda

# First Update Conda
conda update -q conda

# Activate your environment
source activate pyfuncebletesting

# Make sure output dir is there
mkdir -p "${outputDir}"

# Upgrade your environment
pip install --upgrade pip
pip uninstall -y pyfunceble pyfunceble-dev
pip install "${pyfunceblePackageName}" --upgrade

# Tell the script to install/update the configuration file automatically.
export PYFUNCEBLE_AUTO_CONFIGURATION=yes

# Export the Path to PyFunceble before running PyFunceble
export PYFUNCEBLE_CONFIG_DIR="${outputDir}/"

# Run PyFunceble
PyFunceble ${pyfuncebleArgs} -f "${1}"

# When finished - Deactivate the environment
conda deactivate

echo ${?}
