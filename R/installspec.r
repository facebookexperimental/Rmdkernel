# Copyright (c) IRkernel authors
# Copyright (c) Meta Platforms, Inc. and affiliates.

#' Install the kernelspec to tell Jupyter about Rmdkernel.
#'
#' This can be called multiple times for different R interpreter, but you have to give a
#' different name (and displayname to see a difference in the notebook UI). If the same
#' name is give, it will overwrite older versions of the kernel spec with that name!
#'
#' @param user         Install into user directory (\href{https://specifications.freedesktop.org/basedir-spec/latest/ar01s03.html}{\code{$XDG_DATA_HOME}}\code{/jupyter/kernels}) or globally? (default: NULL but treated as TRUE if "prefix" is not specified)
#' @param name         The name of the kernel (default \dQuote{rmarkdown})
#' @param displayname  The name which is displayed in the notebook (default: \dQuote{Rmarkdown})
#' @param rprofile     (optional) Path to kernel-specific Rprofile (defaults to system-level settings)
#' @param prefix       (optional) Path to alternate directory to install kernelspec into (default: NULL)
#' @param sys_prefix   (optional) Install kernelspec using the \code{--sys-prefix} option of the currently detected jupyter (default: \code{NULL})
#' @param verbose      (optional) If \code{FALSE}, silence output of \code{install}
#' 
#' @return Exit code of the \code{jupyter kernelspec install} call.
#' 
#' @export
installspec <- function(
    user = NULL, name = 'rmarkdown', displayname = 'Rmarkdown', rprofile = NULL, prefix = NULL, sys_prefix = NULL, verbose = getOption('verbose')
) {
    exit_code <- system2('jupyter', c('kernelspec', '--version'), FALSE, FALSE)
    if (exit_code != 0)
        stop('jupyter-client has to be installed but ', dQuote('jupyter kernelspec --version'), ' exited with code ', exit_code, '.\n')

    # default to 'user' install if neither 'user' or 'prefix' is specified
    if (is.null(user)) user <- (is.null(prefix) && is.null(sys_prefix))
    if (sum(user, !is.null(prefix), !is.null(sys_prefix)) > 1)
        stop('"user", "prefix", "sys_prefix" are mutually exclusive')
    
    # make a kernelspec with the current interpreter's absolute path
    srcdir <- system.file('kernelspec', package = 'Rmarkdown')
    tmp_name <- tempfile()
    dir.create(tmp_name)
    file.copy(srcdir, tmp_name, recursive = TRUE)
    spec_path <- file.path(tmp_name, 'kernelspec', 'kernel.json')
    spec <- fromJSON(spec_path)
    spec$argv[[1]] <- file.path(R.home('bin'), 'R')
    spec$display_name <- displayname
    if (!is.null(rprofile)) {
        spec$env <- list(R_PROFILE_USER = rprofile)
    }
    write(toJSON(spec, pretty = TRUE, auto_unbox = TRUE), file = spec_path)
    
    user_flag <- if (user) '--user' else character(0)
    prefix_flag <- if (!is.null(prefix)) c('--prefix', prefix) else character(0) 
    sys_prefix_flag <- if (!is.null(sys_prefix)) c('--sys-prefix', prefix) else character(0)
    quiet_flag <- if (!verbose) '--log-level=WARN' else character(0)
    args <- c(
        'kernelspec', 
        'install', 
        '--replace', 
        '--name', 
        name, 
        user_flag, 
        prefix_flag, 
        sys_prefix_flag, 
        quiet_flag, 
        file.path(tmp_name, 'kernelspec')
    )
    exit_code <- system2('jupyter', args)
    
    unlink(tmp_name, recursive = TRUE)
    
    invisible(exit_code)
}
