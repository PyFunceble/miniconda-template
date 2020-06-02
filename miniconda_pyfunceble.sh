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

# Workaround for Bug #3
pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd $(dirname "$SCRIPT_PATH"); SCRIPT_PATH=$(readlink "${SCRIPT_PATH}"); done
fi
cd $(dirname "${SCRIPT_PATH}".) > /dev/null
SCRIPT_PATH=$(pwd);
popd  > /dev/null

ROOT_DIR="$(dirname "$SCRIPT_PATH")"

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
#read -erp "Enter any custom test string: " -i "--dns 127.0.0.1:5302 -m -p $(nproc --ignore=2) -h --plain -a --dots -vsc" pyfuncebleArgs

# Bug #3 test string
read -erp "Enter any custom test string: " -i "--dns 127.0.0.1:5302 -m -p 2 -h --http --plain --dots -vsc --hierarchical" -a pyfuncebleArgs

# Should we use the default .pyfunceble-env file from users @HOME/.config/
# shellcheck disable=SC2034  # Unused variables left for readability

while true
do
read -erp "Would you like to use your default .pyfunceble-env file? [y/N] " -i "No" input

case $input in
	[yY][eE][sS]|[yY])
 useEnvFile="yes"
 break
 ;;
	[nN][oO]|[nN])
 useEnvFile=""
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
pip install --upgrade pip -q
pip uninstall -y pyfunceble pyfunceble-dev -q
pip install "${pyfunceblePackageName}" --upgrade -q

# Tell the script to install/update the configuration file automatically.
export PYFUNCEBLE_AUTO_CONFIGURATION=yes

# Export the Path to PyFunceble before running PyFunceble
export PYFUNCEBLE_CONFIG_DIR="${outputDir}/"

# Workaround for bug #3

cd "${outputDir}"

# Export ENV variables from $HOME/.config/.pyfunceble-env
# Note: Using cat here is in violation with SC2002, but the only way I have
# been able to obtain the data from default .ENV file, with-out risking
# to reveals any sensitive data. Better suggestions are very welcome

if [ -n "$useEnvFile" ]
then
	export $(cat "${HOME}/.config/PyFunceble/.pyfunceble-env" | xargs)
fi

# Run PyFunceble
# Switched to use array to keep quotes for SC2086
pyfunceble "${pyfuncebleArgs[@]}" -f "${1}"

# When finished - Deactivate the environment
conda deactivate

# Enhangement suggestions!!
# Output the test variables at the end of the test, as it could have been
# Running for hours and terminal history could be to long to become stored

echo -e "\tThank you for feting me with the following test food, and I'm now full"
echo -e "\tYou tested this file: ${1}"
echo -e "\tWith the following variable: ${pyfuncebleArgs}"
echo -e "\tYou're output location is: ${outputDir}"
echo -e "\tThe following files have been generated in the outputDir\n"

tree --prune -f "${outputDir}"

# Workaround for bug #3
cd "${ROOT_DIR}"

echo ${?}
