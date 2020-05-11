# @PyFunceble on miniconda
This script consist of two parts.
1. setup_miniconda.sh
1. miniconda_pyfunceble.sh

## Setup
If everything works as expected you should never run setup_miniconda more than once.
I f you by any means needs to rerun this script, please first to ensure the destination
folder are deleted, this script do not check this.

## Running pyfunceble
Simple, feat the scripts with answers or it staves and die... :skull: 

For testing purpose you can use the default @PyFunceble test file from
<https://raw.githubusercontent.com/PyFunceble/ci_test/master/test.list>

The command would then be
```
./miniconda_pyfunceble.sh "https://raw.githubusercontent.com/PyFunceble/ci_test/master/test.list"
```

## Read more
You can read more about environment variables at <https://pyfunceble.readthedocs.io/en/dev/components/environment-variables.html?highlight=PYFUNCEBLE_AUTO_CONFIGURATION#what-do-we-use-and-why>

## Test string
To alter the test options you should be reading more about this at <https://pyfunceble.readthedocs.io/en/dev/usage/index.html>

## Why this script
See <https://github.com/funilrys/PyFunceble/issues/39> by @mitchellkrogza and @funilrys and since I'm running un a Ubuntu whch curses some troubles as @mitchellkrogza descripes it:

> Distributions like Ubuntu are especially troublesome with Python issues which are easily solved by just running Python in Conda environments.
