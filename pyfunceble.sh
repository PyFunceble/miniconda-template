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
set -e #-x

pkgs="tree"
if ! dpkg -s $pkgs >/dev/null 2>&1; then
  sudo apt-get install $pkgs
fi

# Run this script by appending test-file to the script name in the shell prompt
# E.g. miniconda_pyfunceble.sh "/full/path/to/file"

# just a bit of fun
echo -e "\tI'm your hungry cheese missing a piece..."
echo -e "\tAre you ready to go hunting the red pills"
echo -e "\tso we can hunt down evil ghosts"
echo ""
echo -e "\tAre you ready to start?"
echo ""
echo -e "\tloading kacman..."

# Set conda install dir
condaInstallDir="${HOME}/miniconda"

if [[ -z "${1}" ]]
then
    printf "\n\tYou have been swaloowing a blue pill..."
    printf "\tThe ghosts caught you :skull:"
    printf "\tPlease show me the route to the ghosts"
    printf "\tYou want me to chew through\n\t.%s /blue/pills/is/dead/ghosts\n\n" "${0}"
    exit 1
fi

# Select Python version for test env
read -erp "Enter Python version to be used in Conda: " \
    -i "3.9.6" PV

# Change the output directory to suite your needs
read -erp "Enter output directory for test results: " \
    -i "/tmp/pyfunceble/$(date +'%H%M')" outputDir

# Clean output dir if exist for a clean test environment
if [[ -d "${outputDir}" ]]
then
    rm -fr "${outputDir}"
fi

# Set your desired pyfunceble verion
# We set pyfunceble-dev as default to avoid typos.
read -erp "Which version of PyFunceble would you like to use?: pyfunceble4: " \
    -i "pyfunceble4" PYFUNCEBLEPACKAGENAME

# Set your test string.
# IMPORTANT: the -f argument is preset as last argument

# Bug #3 test string
read -erp "Enter any custom test string: " \
    -i "--hierarchical -ex -a --dns 192.168.0.100:5302 -w 40 --database-type mariadb -dbr 0 --whois-lookup --http --netinfo-lookup" -a PYFUNCEBLEARGS

# We should change the default ENV dir to match the PyF versions conda dir
# shellcheck disable=SC2034  # Unused variables left for readability

while true
do
read -erp "Would you like to use your default pyfunceble enviroment
  ${condaInstallDir}/envs/${PYFUNCEBLEPACKAGENAME}?: [Y/n] " -i "Y" PYFUNCEBLE_ENV

case $PYFUNCEBLE_ENV in
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

# Activate your environment
# According to the https://docs.conda.io/projects/conda/en/latest/_downloads/843d9e0198f2a193a3484886fa28163c/conda-cheatsheet.pdf
# We shall replace source with conda activate vs source
conda env update -f '.environment.yaml'

conda activate "${PYFUNCEBLEPACKAGENAME}"

# Set python version to use
conda install python="${PV}"

# Make sure output dir is present
mkdir -p "${outputDir}"

# Upgrade the environment
# pip install -I -U -q pip wheel Pygments>=2.0
# pip uninstall -yq PyFunceble-dev #"${PYFUNCEBLEPACKAGENAME}"
# pip install --no-cache-dir --upgrade -q --pre pyfunceble-dev>=4.0.0b61 'alabaster<0.8,>=0.7'
# pip install --no-cache-dir --upgrade -I -q 'git+https://github.com/funilrys/PyFunceble.git@dev'
# pip install --no-cache-dir --upgrade -I -q 'git+https://mypdns.org/pyfunceble/PyFunceble.git@dev'

if [ "${PYFUNCEBLEPACKAGENAME}" == 'pyfunceble' ]
then
	pip install --no-cache-dir --upgrade -I -q 'git+https://github.com/Ultimate-Hosts-Blacklist/whitelist.git@script'
	pyfunceble --version
	uhb-whitelist --version
	#pip list
else
	pip install --no-cache-dir --upgrade -I -q 'git+https://github.com/Ultimate-Hosts-Blacklist/whitelist.git@script-dev'
	pyfunceble --version
	uhb-whitelist --version
	#pip list
fi

# print pyfunceble version
pyfunceble --version

# Tell the script to install/update the configuration file automatically.
export PYFUNCEBLE_AUTO_CONFIGURATION=yes

# Currently only availeble in the @dev edition see
# GH:funilrys/PyFunceble#94
export PYFUNCEBLE_OUTPUT_LOCATION="${outputDir}/"

# Export ENV variables from $HOME/.config/.pyfunceble-env

if [ -n "$useEnvPath" ]
then
    if [ -f "${condaInstallDir}/envs/${PYFUNCEBLEPACKAGENAME}/.pyfunceble-env" ]
    then
        rm "${condaInstallDir}/envs/${PYFUNCEBLEPACKAGENAME}/.pyfunceble-env"
    fi

    if [ ! -f "${condaInstallDir}/envs/${PYFUNCEBLEPACKAGENAME}/.pyfunceble-env" ]
    then
        cp "$HOME/.config/PyFunceble/.pyfunceble-env.4" "${condaInstallDir}/envs/${PYFUNCEBLEPACKAGENAME}/.pyfunceble-env"
    fi
    export PYFUNCEBLE_CONFIG_DIR="${condaInstallDir}/envs/${PYFUNCEBLEPACKAGENAME}/"
else
    export PYFUNCEBLE_CONFIG_DIR="${outputDir}/"
fi

# Run PyFunceble
# Switched to use array to keep quotes for SC2086
pyfunceble "${PYFUNCEBLEARGS[@]}" -f "${1}"

# Output the test variables at the end of the test, as it could have been
# Running for hours and terminal history could be to long to be visible

echo ""
echo ""
echo -e "\tThank you for feting me with all that junk food, I used to like you too..."
echo -e "\tYou tested with: " $(pyfunceble --version)
echo -e "\tYou tested this source: ${1}"
echo -e "\tWith the following variable: ${PYFUNCEBLEARGS[@]}"
echo -e "\tYou're output location is: ${outputDir}"
echo -e "\tThe following files have been generated in the outputDir\n"
echo ""
echo ""

tree --prune -f "${outputDir}"

# When finished - Deactivate the environment
conda deactivate

echo ${?}
