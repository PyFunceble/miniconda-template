#!/usr/bin/env bash
# All initial credits to @mitchellkrogza and @funilrys
# Modified by @spirillen
# License: https://www.mypdns.org/w/license/
# Issues: https://www.mypdns.org/maniphest/
# Project: https://www.mypdns.org/project/profile/5/
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
	printf "You forgot to tell me what to test...\nPlease use %s /full/path/to/file\n\n" "${0}"
	exit 1
fi

# Change the output directory to suite your needs
read -erp "Enter output directory for test results: " -i "/tmp/pyfuncebletesting/$(date +'%H%M')" outputDir

# Clean output dir if exist for a clean test environment
if [[ -d "${outputDir}" ]]
then
	rm -fr "${outputDir}"
fi

# Set your desired pyfunceble verion
read -erp "Which version of PyFunceble would you like to use?: pyfunceble or pyfunceble-dev: " -i "pyfunceble-dev" pyfunceblePackageName

# Set your test string.
# IMPORTANT: the -f argument is preset as last argument
read -erp "Enter any custom test string: " -i "--dns 127.0.0.1:5302 -m -p $(nproc --ignore=2) -h --plain -a --dots -vsc" pyfuncebleArgs

# Should we use default .pyfunceble-env file from users @HOME/.config/
while true
do
read -erp "Would you like to use your default .pyfunceble-env file? [Y/n] " -i "Yes" input

case $input in
	[yY][eE][sS]|[yY])
 _pyfenv="yes"
 break
 ;;
	[nN][oO]|[nN])
 _pyfenv=""
 break
        ;;
     *)
 echo "Invalid input..."
 ;;
 esac
done

# Get the conda CLI.
source "${condaInstallDir}/etc/profile.d/conda.sh"

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

# Export ENV variables from .pyfunceble-env
# Note: Using cat here is in violation with SC2002, but the only way I have
# been able to obtain the data from default .ENV file, with-out risking
# to reveals any sensitive data. Better suggestions are very welcome

if [ -n "$_pyfenv" ]
then
	export $(cat "${HOME}/.config/PyFunceble/.pyfunceble-env" | xargs)
fi

# Run PyFunceble
# Do not quote the following args, as it will brake PyFunceble

PyFunceble ${pyfuncebleArgs} -f "${1}"

# When finished - Deactivate the environment
conda deactivate

echo ${?}
