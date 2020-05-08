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

# 1. First Update Conda
conda update -q conda

# 2. Activate your environment
source activate pyfuncebletesting

# 3. Upgrade your environment
pip install --upgrade pip
pip install "${_pyfv}" --upgrade

# 4. Export the Path to PyFunceble before running PyFunceble
export PYFUNCEBLE_CONFIG_DIR="${_outdir}/"

# 5. Run PyFunceble
PyFunceble "${_string=}" -f "${1}"

# 6. When finished - Deactivate the environment
source deactivate pyfuncebletesting
