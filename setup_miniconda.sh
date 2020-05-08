#!/usr/bin/env bash
# All initial credits to @mitchellkrogza and @funilrys
# Modified by @spirillen
# -------------------------------
# Setup Conda Python Environments
# -------------------------------

# Set python version
_pyv="3.8.2"

# 1. Add Conda Path to .bashrc (add line below to bottom of bashrc)
export PATH="${HOME}/miniconda/bin:${PATH}"

# 2. Reload your bashrc
source .bashrc

# 3. Download Conda
wget -O miniconda.sh \
  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh 

# 4. Install Conda
bash miniconda.sh -b -p ${HOME}/miniconda

# 5. Setup Conda
hash -r
conda config --set always_yes yes --set changeps1 no

# 6. Update Conda
conda update -q conda

# 7. Create an Environment (EXAMPLE: creating an environment called
# pyfuncebletesting with Python version "_pyv")
conda create -q -n pyfuncebletesting python="${_pyv}"

# 8. Activate this environment you just created
source activate pyfuncebletesting

# 9. Query Python and Pip versions inside this environment
python -VV
pip --version

# 10. Install PyFunceble in this environment (pyfuncebletesting)
pip install "${_pyfv}"

# 14. When finished - Deactivate the environment
source deactivate pyfuncebletesting

# Now we should be ready to run the miniconda_pyfunceble.sh
