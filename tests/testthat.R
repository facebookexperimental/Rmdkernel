# Copyright (c) IRkernel authors

# see https://github.com/hadley/testthat/issues/144
Sys.setenv(R_TESTS = '')

library(testthat)
library(Rmdkernel)

test_check('Rmdkernel')
