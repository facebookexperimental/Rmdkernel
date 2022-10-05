# Native Rmarkdown kernel for Jupyter [![b-CI]][CI] [![b-CRAN]][CRAN]

<!-- [b-CI]: https://github.com/facebookexperimental/Rmdkernel/actions/workflows/r.yml/badge.svg "Build status" -->
[CI]: https://github.com/facebookexperimental/Rmdkernel/actions/workflows/r.yml
[b-CRAN]: https://www.r-pkg.org/badges/version/Rmdkernel "Comprehensive R Archive Network"
[CRAN]: https://cran.r-project.org/package=Rmdkernel

LICENSE: MIT

<!-- For detailed requirements and install instructions see [irkernel.github.io](https://irkernel.github.io/) -->

## Requirements

* [Jupyter](https://jupyter.org).
* A current [R installation](https://www.R-project.org).

## Installation

This package is not available on CRAN. You can install with remotes:

```R
remote::instal_github('facebookexperimental/Rmdkernel')
Rmdkernel::installspec()  # to register the kernel in the current R installation
```

Per default `Rmdkernel::installspec()` will install a kernel with the name “rmarkdown” and a
display name of “Rmarkdown”. Multiple calls will overwrite the kernel with a kernel spec pointing to the last
R interpreter you called that commands from. You can install kernels for multiple versions of R
by supplying a `name` and `displayname` argument to the `installspec()` call (You still need to
install these packages in all interpreters you want to run as a jupyter kernel!):

```r
# in R 3.3
Rmdkernel::installspec(name = 'rmd33', displayname = 'R 3.3')
# in R 3.2
Rmdkernel::installspec(name = 'rmd32', displayname = 'R 3.2')
```

By default, it installs the kernel per-user.  To install system-wide,
use `user = FALSE`.  To install in the `sys.prefix` of the currently
detected `jupyter` command line utility, use `sys_prefix = TRUE`.

Now both R versions are available as an Rmarkdown kernel in the notebook.

## Running the notebook

If you have Jupyter installed, you can create a notebook using Rmdkernel from the dropdown menu.

You can also start other interfaces with an R kernel:

```bash
# “rmarkdown” is the kernel name installed by the above `Rmdkernel::installspec()`
# change if you used a different name!
jupyter qtconsole --kernel=rmarkdown
jupyter console --kernel=rmarkdown
```

## How does it know where to install?

The Rmdkernel does not have any Python dependencies whatsoever, and
does not know anything about any other Jupyter/Python installations
you may have.  It only requires the `jupyter` command to be available
on `$PATH`.  To install the kernel, it prepares a kernelspec directory
(containing `kernel.json` and so on), and passes it to the command
line `jupyter kernelspec install [options] prepared_kernel_dir/`,
where options such as `--name`, `--user`, `--prefix`, and
`--sys-prefix` are given based on the options.
