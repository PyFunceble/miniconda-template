#!/usr/bin/env bash

#
# Modified by https://www.mypdns.org/p/Spirillen/
# License: https://www.mypdns.org/w/license/
# Issues: https://www.mypdns.org/maniphest/
# Project: https://www.mypdns.org/project/profile/5/
# ----------------------------------
# We will use the python 3.7 venv
# Since conda on arm7l only supports
# upto python 3.4.
# ----------------------------------

# Stop on any error
set -e

# Set python version
# to find the latest version
# `conda search --full-name python`
pythonVersion="3.7"

hash "${pythonVersion}" 2>/dev/null || { echo >&2 "We are installing python 3.7 for you" && sudo apt install python3.7 -y; }

cd "${HOME}/Downloads/"

git clone https://github.com/funilrys/PyFunceble.git pyfunceble

cd "${HOME}/Downloads/pyfunceble"

branch=('4.0.0-dev' 'dev' 'master')

if [ ! -d "${HOME}/Downloads/pyfunceble/venv" ]
then
    for i in "${branch[@]}"
    do 
        git checkout "${i}"
        python3.7 -m venv venv
        source venv/bin/activate --upgrade --upgrade-deps
        pip3 install -e .
        export PYFUNCEBLE_AUTO_CONFIGURATION=yes
        pyfunceble --version
        deactivate
    done
else
    git checkout master && git fetch
fi

git checkout master