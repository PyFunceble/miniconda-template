#!/usr/bin/env bash

# All initial credits to:
# - https://github.com/mitchellkrogza
# - https://mypdns.org/funilrys
#
# Modified by https://mypdns.org/spirillen
# License: https://mypdns.org/mypdns/support/-/wikis/License
# Issues: https://mypdns.org/pyfunceble/pyfunceble-templates/pyfunceble-miniconda/-/issues
# Project: https://mypdns.org/pyfunceble/pyfunceble-templates/pyfunceble-miniconda
# -------------------------------
# Setup Conda Python Environments
# -------------------------------

# Stop on any error
set -e

# Set python version
# to find the latest version
# `conda search --full-name python`
pythonVersion="3.10"

# Set conda install dir
condaInstallDir="${HOME}/miniconda"

function version () {
  echo ""
  echo "Python version"
  python -VVV
  
  echo ""
  echo "pip version"
  pip --version

  echo ""
  echo "PyFunceble version"
  pyfunceble --version

  # echo ""
  # echo "uhb-whitelist version"
  # uhb-whitelist --version
}

function copy_config () {
  # Copy default .pyfunceble-env and .PyFunceble.overwrite.yaml to new
  # environment
  cp "$HOME/.config/PyFunceble/.pyfunceble-env" \
    "${condaInstallDir}/envs/${PYFUNCEBLEPACKAGENAME}"

  cp "$HOME/.config/PyFunceble/.PyFunceble.overwrite.yaml" \
    "${condaInstallDir}/envs/${PYFUNCEBLEPACKAGENAME}"
  
  echo ""
  echo "List copied files"
  ls -lha "${condaInstallDir}/envs/${PYFUNCEBLEPACKAGENAME}"
}

if [[ ! -d ${condaInstallDir} ]]
then
  if [ $(uname -m) == 'x86_64' ]
  then
  # Download Conda
  wget -O miniconda.sh \
    'https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh'
  
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
  bash miniconda.sh -b -f -p "${condaInstallDir}"

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

  echo "Updated completed"
fi

if [[ ! -d ${condaInstallDir}/envs/pyfunceble ]]
then
  # Setup pyfunceble@ version to be used
  export PYFUNCEBLEPACKAGENAME="pyfunceble"

  # Get the conda CLI.
  source "${condaInstallDir}/etc/profile.d/conda.sh"

  hash conda

  # Update Conda
  conda update -yq conda
  conda update -n base conda

  # Create an Environment (EXAMPLE: creating an environment called
  # pyfuncebletesting with Python version "pythonVersion")
  # conda create -y -q -n "${PYFUNCEBLEPACKAGENAME}" python="${pythonVersion}"
  conda env update -f ".environment.${PYFUNCEBLEPACKAGENAME}.yaml" --prune -q

  # Activate this environment you just created
  # According to the https://docs.conda.io/projects/conda/en/latest/_downloads/843d9e0198f2a193a3484886fa28163c/conda-cheatsheet.pdf
  # We shall replace source with conda activate vs source
  conda activate "${PYFUNCEBLEPACKAGENAME}"

  # Calling function: version
  version

  # uhb-whitelist --version

  # prepared for installing through conda package
  #conda install -c pyfunceble "${PYFUNCEBLEPACKAGENAME}"

  # Copy default .pyfunceble-env to new environment
  # Calling function: copy_config
  copy_config

  # When finished - Deactivate the environment
  conda deactivate

else
  echo "We assume that Pyfunceble envs is already installed."
fi

if [[ ! -d ${condaInstallDir}/envs/pyfunceble-dev ]]
then
  # Setup pyfunceble@ version to be used
  export PYFUNCEBLEPACKAGENAME="pyfunceble-dev"

  # Get the conda CLI.
  source "${condaInstallDir}/etc/profile.d/conda.sh"

  hash conda

  # Update Conda
  conda update -yq conda

  # Create an Environment (EXAMPLE: creating an environment called
  # conda create -y -q -n "${PYFUNCEBLEPACKAGENAME}" python="${pythonVersion}"
  conda env update -f ".environment.${PYFUNCEBLEPACKAGENAME}.yaml" --prune -q

  # Activate this environment you just created
  # According to the https://docs.conda.io/projects/conda/en/latest/_downloads/843d9e0198f2a193a3484886fa28163c/conda-cheatsheet.pdf
  # We shall replace source with conda activate vs source
  conda activate "${PYFUNCEBLEPACKAGENAME}"

  # Calling function: version
  version

  # Calling function: copy_config
  copy_config

  # When finished - Deactivate the environment
  conda deactivate

else
  echo "We assume that Pyfunceble-dev envs is already installed."
fi

echo "Script exited with code: ${?}"

# Now you should be ready to run the miniconda_pyfunceble.sh

# For testing only
# conda env list

# conda env remove -n pyfunceble
# conda env remove -n pyfunceble-dev

# Cleanup
rm miniconda.sh
