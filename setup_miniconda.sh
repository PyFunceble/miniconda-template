#!/usr/bin/env bash

# All initial credits to:
# - https://github.com/mitchellkrogza
# - https://github.com/funilrys
#
# Modified by https://www.mypdns.org/p/Spirillen/
# License: https://www.mypdns.org/w/license/
# Issues: https://www.mypdns.org/maniphest/
# Project: https://www.mypdns.org/project/profile/5/
# -------------------------------
# Setup Conda Python Environments
# -------------------------------

# Stop on any error
set -e

# Set python version
# to find the latest version
# `conda search --full-name python`
pythonVersion="3.9.1"

# Set conda install dir
condaInstallDir="${HOME}/miniconda"

if [[ ! -d ${condaInstallDir} ]]
then
  if [ $(uname -m) == 'x86_64' ]
  then
  # Download Conda
  wget -O miniconda.sh \
    'https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh'
  
  elif [ $(uname -m) == 'armv7l' ]
    then
    exec ./setup-arm7l.sh && exit 0

  elif [ $(uname -m) == 'x86' ]
    then
    wget -O miniconda.sh \
    'https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86.sh'

  elif [ $(uname -m) == 'ppc64le' ]
    then
    wget -O miniconda.sh \
    'https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-ppc64le.sh'
  fi

  # Install Conda
  bash miniconda.sh -b -p "${condaInstallDir}"

  # inspired by https://gitlab.com/my-privacy-dns/test-suites-and-drafts/OpenWPM/-/blob/master/scripts/install-miniconda.sh#L14-18
  source "$HOME/miniconda/etc/profile.d/conda.sh"
  hash -r
  conda config --set always_yes yes --set changeps1 no
  conda update -q conda
  conda info -a
else
  echo "We assume that conda is already installed."
  echo "We are updating the environment"
  source "$HOME/miniconda/etc/profile.d/conda.sh"
  hash -r
  conda config --set always_yes yes --set changeps1 no
  conda update -q conda
  conda info -a

  echo ${?}

  echo "Updated cpmpleted"
fi

if [[ ! -d ${condaInstallDir}/envs/pyfunceble ]]
then
  # Setup pyfunceble@ version to be used
  pyfunceblePackageName="pyfunceble"

  # Get the conda CLI.
  source "${condaInstallDir}/etc/profile.d/conda.sh"

  hash conda

  # Update Conda
  conda update -q conda

  # Create an Environment (EXAMPLE: creating an environment called
  # pyfuncebletesting with Python version "pythonVersion")
  conda create -y -q -n "${pyfunceblePackageName}" python="${pythonVersion}"

  # Activate this environment you just created
  # According to the https://docs.conda.io/projects/conda/en/latest/_downloads/843d9e0198f2a193a3484886fa28163c/conda-cheatsheet.pdf
  # We shall replace source with conda activate vs source
  conda activate "${pyfunceblePackageName}"

  # Query Python and Pip versions inside this environment
  python -VVV
  pip --version

  # Install PyFunceble in this environment (pyfuncebletesting)
  pip -q install --no-cache-dir -U "${pyfunceblePackageName}"
  pip install --no-cache-dir --upgrade -q git+https://github.com/Ultimate-Hosts-Blacklist/whitelist.git@script

  # Test Pyfunceble version installed
  pyfunceble --version
  uhb-whitelist --version

  # prepared for installing thru conda package
  #conda install -c pyfunceble "${pyfunceblePackageName}"

  # Copy default .pyfunceble-env to new enviroment
  cp "$HOME/.config/PyFunceble/.pyfunceble-env" \
    "${condaInstallDir}/envs/${pyfunceblePackageName}"

  # When finished - Deactivate the environment
  conda deactivate

else
  echo "We assume that Pyfunceble envs is already installed."
fi

if [[ ! -d ${condaInstallDir}/envs/pyfunceble-dev ]]
then
  # Setup pyfunceble@ version to be used
  pyfunceblePackageName="pyfunceble-dev"

  # Get the conda CLI.
  source "${condaInstallDir}/etc/profile.d/conda.sh"

  hash conda

  # Update Conda
  conda update -q conda

  # Create an Environment (EXAMPLE: creating an environment called
  conda create -y -q -n "${pyfunceblePackageName}" python="${pythonVersion}"

  # Activate this environment you just created
  # According to the https://docs.conda.io/projects/conda/en/latest/_downloads/843d9e0198f2a193a3484886fa28163c/conda-cheatsheet.pdf
  # We shall replace source with conda activate vs source
  conda activate "${pyfunceblePackageName}"

  # Query Python and Pip versions inside this environment
  python -VVV
  pip --version

  # Install PyFunceble in this environment (pyfuncebletesting)
  pip -q install --no-cache-dir -U "${pyfunceblePackageName}"
  pip -q install --no-cache-dir git+https://github.com/Ultimate-Hosts-Blacklist/whitelist.git@script-dev

  # prepared for installing thru conda package
  #conda install -c pyfunceble "${pyfunceblePackageName}"

  # Test Pyfunceble version installed
  pyfunceble --version
  uhb-whitelist --version

  # Copy default .pyfunceble-env to new enviroment
  cp "$HOME/.config/PyFunceble/.pyfunceble-env" \
    "${condaInstallDir}/envs/${pyfunceblePackageName}"

  # When finished - Deactivate the environment
  conda deactivate

else
  echo "We assume that Pyfunceble-dev envs is already installed."
fi

# Temponary for pyfunceble 4 development
if [[ ! -d ${condaInstallDir}/envs/pyfunceble4 ]]
then
  # Setup pyfunceble@ version to be used
  pyfunceblePackageName="pyfunceble4"

  # Get the conda CLI.
  source "${condaInstallDir}/etc/profile.d/conda.sh"

  hash conda

  # Update Conda
  conda update -q conda

  # Create an Environment (EXAMPLE: creating an environment called
  conda create -y -q -n "${pyfunceblePackageName}" python="${pythonVersion}"

  # Activate this environment you just created
  # According to the https://docs.conda.io/projects/conda/en/latest/_downloads/843d9e0198f2a193a3484886fa28163c/conda-cheatsheet.pdf
  # We shall replace source with conda activate vs source
  conda activate "${pyfunceblePackageName}"

  # Query Python and Pip versions inside this environment
  python -VVV
  pip --version

  # Install PyFunceble in this environment (pyfuncebletesting)
  pip -q install --no-cache-dir -U 'git+https://github.com/funilrys/PyFunceble@4.0.0-dev#egg=PyFunceble-dev'
  pip -q install --no-cache-dir git+https://github.com/Ultimate-Hosts-Blacklist/whitelist.git@script-dev

  # prepared for installing thru conda package
  #conda install -c pyfunceble "${pyfunceblePackageName}"

  # Test Pyfunceble version installed
  pyfunceble --version
  uhb-whitelist --version

  # Copy default .pyfunceble-env to new enviroment
  cp "$HOME/.config/PyFunceble/.pyfunceble-env" \
    "${condaInstallDir}/envs/${pyfunceblePackageName}"

  # When finished - Deactivate the environment
  conda deactivate

else
  echo "We assume that pyfunceble4 envs is already installed."
fi

echo "Script exited with code: ${?}"

# Now you should be ready to run the miniconda_pyfunceble.sh
