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
set -ex

# Set python version
pythonVersion="3.9.1"

# Set conda install dir
condaInstallDir="${HOME}/miniconda"

arc="$(uname -m)"

conda_source () {
  if [ "${arc}" == x86_64]
    then
    source "$HOME/miniconda/etc/profile.d/conda.sh"
    
  elif [ "${arc}" == arm7l]
    then
    if [ ! -d "${condaInstallDir}" ]
    then
      export PATH="${condaInstallDir}/bin:$PATH"
      echo "conda install anaconda-client"
      echo "'"export PATH="${condaInstallDir}/bin:$PATH""'" \
        >> "~/.bash_aliases"
      source "~/.bashrc"
    else
    export PATH="${condaInstallDir}/bin:$PATH"
    fi
  
  fi
}

# Download and Install Conda
if [ ! -d "${condaInstallDir}" ]
  then
      if [ ! -f "miniconda-${arc}.sh" ]
        then
        wget -O "miniconda-${arc}.sh" \
          "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${arc}.sh"
      fi
    bash "miniconda-${arc}.sh" -b -p "${condaInstallDir}"

  # inspired by https://gitlab.com/my-privacy-dns/test-suites-and-drafts/OpenWPM/-/blob/master/scripts/install-miniconda.sh#L14-18
  conda_source
  hash -r
  conda config --set always_yes yes --set changeps1 no
  conda update -q conda
  conda info -a
else
  echo "We assume that conda is already installed."
  echo "We are updating the environment"
  conda_source
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
  conda_source

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
  if [ -f "${condaInstallDir}/etc/profile.d/conda.sh" ]
    then
    source "${condaInstallDir}/etc/profile.d/conda.sh"
    elif [ $(grep -q -i 'conda' "$HOME/.bash_aliases") == '' ]
      then
      echo -e "'"\nexport PATH="${condaInstallDir}/bin:$PATH"\n"'" \
        >> "$HOME/.bash_aliases"
      export PATH="${condaInstallDir}/bin:$PATH"
  fi

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
