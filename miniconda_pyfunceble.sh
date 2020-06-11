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
#set -e

# Run this script by appending test-file to the script name in the shell prompt
# E.g. miniconda_pyfunceble.sh "/full/path/to/file"

# Set conda install dir
condaInstallDir="${HOME}/miniconda"

if [[ -z "${1}" ]]
then
	printf "\n\tYou forgot to feed me...\n\tTherefor I died like your hamster :skull:\n\tPlease show me the route to the bad domain\n\tYou want me to chew through\n\t.%s /roast/beef/is/good/food\n\n" "${0}"
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
#read -erp "Enter any custom test string: " -i "--dns 95.216.209.53:53 116.203.32.67:53 -m -p $(nproc --ignore=2) -h --http --plain --dots -vsc --hierarchical -db --database-type mariadb" -a pyfuncebleArgs
#read -erp "Enter any custom test string: " -i "--dns 127.0.0.1 -m -p $(nproc --ignore=2) -h --http --plain --dots -vsc --hierarchical -dbr 0 -ex -db --database-type mariadb" -a pyfuncebleArgs
#read -erp "Enter any custom test string: " -i "--dns 192.168.1.105 -m -p $(nproc --ignore=2) -h --http --plain --dots -vsc --hierarchical -dbr 0 -ex " -a pyfuncebleArgs
read -erp "Enter any custom test string: " -i "--dns 192.168.1.105:5306 -m -p 6 -h --http --plain -vsc --hierarchical -db --database-type mariadb" -a pyfuncebleArgs

# Should we use the default .pyfunceble-env file from users @HOME/.config/
# shellcheck disable=SC2034  # Unused variables left for readability

while true
do
read -erp "Would you like to use your default pyfunceble enviroment
  ${HOME}/.config/PyFunceble/?: [Y/n] " -i "Y" pyfuncebleENV

case $pyfuncebleENV in
	[yY][eE][sS]|[yY])
 useEnvPath="yes"
 break
 ;;
	[nN][oO]|[nN])
 useEnvPath=""
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
conda update -q "${pyfunceblePackageName}"

# Activate your environment
# According to the https://docs.conda.io/projects/conda/en/latest/_downloads/843d9e0198f2a193a3484886fa28163c/conda-cheatsheet.pdf
# We shall replace source with conda activate vs source
conda activate pyfuncebletesting

# Make sure output dir is there
mkdir -p "${outputDir}"

# Upgrade your environment
pip install --upgrade pip -q
pip uninstall -yq pyfunceble
pip uninstall -yq pyfunceble-dev
pip install --no-cache-dir --upgrade -q "${pyfunceblePackageName}"

# Tell the script to install/update the configuration file automatically.
export PYFUNCEBLE_AUTO_CONFIGURATION=yes

# Currently only availeble in the @dev edition see
# GH:funilrys/PyFunceble#94
export PYFUNCEBLE_OUTPUT_LOCATION="${outputDir}/"

# Export ENV variables from $HOME/.config/.pyfunceble-env
# Note: Using cat here is in violation with SC2002, but the only way I have
# been able to obtain the data from default .ENV file, with-out risking
# to reveals any sensitive data. Better suggestions are very welcome

if [ -n "$useEnvPath" ]
then
	export PYFUNCEBLE_CONFIG_DIR="${HOME}/.config/PyFunceble/"
else
	export PYFUNCEBLE_CONFIG_DIR="${outputDir}/"
fi

# Run PyFunceble
# Switched to use array to keep quotes for SC2086
pyfunceble "${pyfuncebleArgs[@]}" -f "${1}"

# When finished - Deactivate the environment
conda deactivate

# Enhangement suggestions!!
# Output the test variables at the end of the test, as it could have been
# Running for hours and terminal history could be to long to be visible

echo ""
echo ""
echo -e "\tThank you for feting me with the following junk food, and I'm now 'full'"
echo -e "\tYou tested this file: ${1}"
echo -e "\tWith the following variable: ${pyfuncebleArgs[@]}"
echo -e "\tYou're output location is: ${outputDir}"
echo -e "\tThe following files have been generated in the outputDir\n"
echo ""
echo ""

tree --prune -f "${outputDir}"

echo ${?}
