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
pythonVersion="python3.7"

installDir="${HOME}/Downloads"

branch=('4.0.0-dev' 'dev' 'master')

# First install pythonVersion if not
# already installed
# https://stackoverflow.com/questions/1298066/check-if-an-apt-get-package-is-installed-and-then-install-it-if-its-not-on-linu/54239534#54239534

pkgs="${pythonVersion} git tree"
if ! dpkg -s $pkgs >/dev/null 2>&1; then
  sudo apt-get install $pkgs
fi

if [ ! -d "${installDir}/pyfunceble" ]
then
    cd "${installDir}"
    git clone https://github.com/funilrys/PyFunceble.git pyfunceble

elif [ -d "${installDir}/pyfunceble" ]
then
    cd "${installDir}/pyfunceble"
fi

if [ -d "${installDir}/pyfunceble/venv" ]
then
    echo 'We only need to update the repo to fetch latest'
    git checkout master && git fetch
else
    for i in "${branch[@]}"
    do 
        cd "${installDir}/pyfunceble"
        echo 'We are setting up the venv'
        git checkout "${i}"
        "${pythonVersion}" -m venv venv
        source venv/bin/activate --upgrade --upgrade-deps
        pip3 install -e .
        export PYFUNCEBLE_AUTO_CONFIGURATION=yes
        pyfunceble --version
        deactivate
    done
fi

git checkout master

echo "Script exited with code: ${?}"
