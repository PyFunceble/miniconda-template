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

# Setup pyfunceble@ version to be used
pyfunceblePackageName="pyfunceble-dev"

# Set python version
pythonVersion="3.8.3"

# Set conda install dir
condaInstallDir="${HOME}/miniconda"


if [[ ! -d ${condaInstallDir} ]]
then
  # Download Conda
  wget -O miniconda.sh \
    'https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh'

  # Install Conda
  bash miniconda.sh -b -p "${condaInstallDir}"

  # Get the conda CLI.
  source "${condaInstallDir}/etc/profile.d/conda.sh"

  hash conda

  # Update Conda
  conda update -q conda

  # Create an Environment (EXAMPLE: creating an environment called
  # pyfuncebletesting with Python version "pythonVersion")
  conda create -q -n pyfuncebletesting python="${pythonVersion}"

  # Activate this environment you just created
  # According to the https://docs.conda.io/projects/conda/en/latest/_downloads/843d9e0198f2a193a3484886fa28163c/conda-cheatsheet.pdf
  # We shall replace source with conda activate vs source
  conda activate pyfuncebletesting

  # Query Python and Pip versions inside this environment
  python -VVV
  pip --version

  # Install PyFunceble in this environment (pyfuncebletesting)
  pip -q install --no-cache-dir -U "${pyfunceblePackageName}"
  
  # prepared for installing thru conda package
  #conda install -c pyfunceble "${pyfunceblePackageName}"

  # When finished - Deactivate the environment
  conda deactivate
else
  echo "We assume that conda is already installed."
fi

echo ${?}

# Now you should be ready to run the miniconda_pyfunceble.sh
