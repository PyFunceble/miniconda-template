# [@PyFunceble](https://pyfunceble.github.io) on miniconda

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/7e9d0f339cd046c4ab8b162e6805f182)](https://app.codacy.com/gh/PyFunceble-Templates/pyfunceble-miniconda?utm_source=github.com&utm_medium=referral&utm_content=PyFunceble-Templates/pyfunceble-miniconda&utm_campaign=Badge_Grade_Settings)

This script consist of two parts.
1. `setup_miniconda.sh`
2. `miniconda_pyfunceble.sh`

## Setup

If everything works as expected, you should never run `setup_miniconda.sh`
more than once.

## Running PyFunceble

Simple, feat the scripts with answers or it staves and die... :skull:

For testing purpose you can use the default @PyFunceble test file from
<https://raw.githubusercontent.com/PyFunceble/ci_test/master/test.list>

The command would then be

```shell
$ ./miniconda_pyfunceble.sh "https://raw.githubusercontent.com/PyFunceble/ci_test/master/test.list"
```

## Read more

You can read more about environment variables at
<https://pyfunceble.readthedocs.io/en/dev/components/environment-variables.html#what-do-we-use-and-why>

## Test string

To alter the test options you should be reading more about this at
<https://pyfunceble.readthedocs.io/en/dev/usage/index.html>

## Why this script

See <https://github.com/funilrys/PyFunceble/issues/39> by
[@mitchellkrogza](https://github.com/mitchellkrogza)
and [@funilrys](https://github.com/funilrys) and since I'm running on a Ubuntu
which curses some troubles
as [@mitchellkrogza](https://github.com/mitchellkrogza) descripes it:

> Distributions like Ubuntu are especially troublesome with Python issues
> which are easily solved by just running Python in Conda environments.
