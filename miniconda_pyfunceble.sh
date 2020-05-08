#!/usr/bin/env bash
# All initial credits to @mitchellkrogza and @funilrys
# Modified by @spirillen
# -------------------------------
# Setup Conda Python Environments
# -------------------------------

# Run this script by appending test-file to the script name in the shell prompt
# E.g. miniconda_pyfunceble.sh "/full/path/to/file"

# Change the output directory to suite your needs
_outdir="/tmp/pyfuncebletesting"

# Set your desired pyfunceble verion
_pyfv="pyfunceble-dev"

# Set python version
_pyv="3.8.2"

# set your test string.
# IMPORTANT: the -f argument is preset as last argument
_string="-m -p $(nproc --ignore=2) -ex -h --plain --idna"

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
pip install "${_pyfv}" --upgrade

# 7. Export the Path to PyFunceble before running PyFunceble
export PYFUNCEBLE_CONFIG_DIR="${_outdir}/"

# 8. Run PyFunceble
PyFunceble ${_string} -f "${1}"

# 9. When finished - Deactivate the environment
conda deactivate pyfuncebletesting
