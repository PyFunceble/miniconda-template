#!/usr/bin/env bash
# copyeight by @spirillen
# License: https://www.mypdns.org/w/license/
# Issues: https://www.mypdns.org/maniphest/
# Project: https://www.mypdns.org/project/profile/5/

# Stop on any error
set -e #-x

# Set python version
pythonVersion="python3.7"

pkgs="${pythonVersion} git tree"
if ! dpkg -s $pkgs >/dev/null 2>&1; then
  sudo apt-get install $pkgs
fi

pyfuncebleDir="${HOME}/Downloads/pyfunceble"

cd "${pyfuncebleDir}"

# Run this script by appending test-file to the script name in the shell prompt
# E.g. pyfunceble4-arm7.sh "/full/path/to/file"

# just a bit of fun
echo -e "\tI'm your hungry cheese missing a piece..."
echo -e "\tAre you ready to go hunting the red pills"
echo -e "\tso we can hunt down evil ghosts"
echo ""
echo -e "\tAre you ready to start?"
echo ""
echo -e "\tloading kacman..."

if [[ -z "${1}" ]]
then
    printf "\n\tYou have been eating a blue pill..."
    printf "\tThe ghosts caught you :skull:"
    printf "\tPlease show me the route to the ghosts"
    printf "\tYou want me to chew through\n\t.%s /blue/pills/is/dead/ghosts\n\n" "${0}"
    exit 1
fi

# Change the output directory to suite your needs
read -erp "Enter output directory for test results: " \
    -i "/tmp/pyfunceble4/$(date +'%H%M')" outputDir

# Clean output dir if exist for a clean test environment
if [[ -d "${outputDir}" ]]
then
    rm -fr "${outputDir}"
fi

# Set your desired pyfunceble verion
# We set pyfunceble-dev as default to avoid typos.
echo ''
echo 'What version would you like to use?'
echo '1. master'
echo '2. dev'
echo '3. 4.alpha'
echo ''

while true
do
read -erp "Which version of PyFunceble would you like to use?: pyfunceble4: " \
    -i "3" pyfuncebleVersion
case $pyfuncebleVersion in
    1)
    git checkout master
    source venv/bin/activate --upgrade --upgrade-deps
    break;; 

    2)
    git checkout dev
    source venv/bin/activate --upgrade --upgrade-deps
    break;;

    3)
    git checkout 4.0.0-dev
    source venv/bin/activate --upgrade --upgrade-deps
    break;;

    *)
    echo 'Invalid choice...'
esac
done

# Set your test string.
# IMPORTANT: the -f argument is preset as last argument

# Bug #3 test string
read -erp "Enter any custom test string: " \
    -i "-dbr 6 -ex --dns 192.168.1.104:53 -w $(nproc --ignore=2) -a --database-type mariadb --no-files --wildcard" -a pyfuncebleArgs

while true
do
read -erp "Would you like to use your default pyfunceble enviroment?: [Y/n] " -i "Y" pyfuncebleENV

case $pyfuncebleENV in
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

# Make sure output dir is present
mkdir -p "${outputDir}"

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
    export PYFUNCEBLE_CONFIG_DIR="$HOME/.config/PyFunceble/.pyfunceble-env"
else
    export PYFUNCEBLE_CONFIG_DIR="${outputDir}/"
fi

# Run PyFunceble
# Switched to use array to keep quotes for SC2086
pyfunceble "${pyfuncebleArgs[@]}" -f "${1}"

# Output the test variables at the end of the test, as it could have been
# Running for hours and terminal history could be to long to be visible

echo ""
echo ""
echo -e "\tThank you for feting me with all that junk food, I used to like you too..."
echo -e "\tYou tested with: " $(pyfunceble --version)
echo -e "\tYou tested this source: ${1}"
echo -e "\tWith the following variable: ${pyfuncebleArgs[@]}"
echo -e "\tYou're output location is: ${outputDir}"
echo -e "\tThe following files have been generated in the outputDir\n"
echo ""
echo ""

tree --prune -f "${outputDir}"

echo ${?}
