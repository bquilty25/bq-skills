# Parallel execution helpers (r-parallel skill; adapted from
# EVD-COD17-ve-retro/R/parallel.R).
#
# Cores: the physical cores less one (one left for the parent process and the
# system), or N_CORES if set. Parallelism comes from forked R workers
# (parallel::mclapply), one job per worker, which inherit loaded packages and
# compiled models. Jobs are dispatched one at a time (mc.preschedule = FALSE), largest
# first, so that a slow job does not run alone at the end and faster
# (performance) cores pick up more jobs than slower (efficiency) cores.
# Windows cannot fork, so it runs jobs in turn.
#
# Each worker is limited to one BLAS/OpenMP thread to avoid oversubscription
# when many workers run at once.

Sys.setenv(OMP_NUM_THREADS = "1", VECLIB_MAXIMUM_THREADS = "1",
           OPENBLAS_NUM_THREADS = "1")

#' Number of cores to use: N_CORES if set, otherwise physical cores less one.
n_cores <- function() {
  as.integer(Sys.getenv(
    "N_CORES",
    as.character(max(1, parallel::detectCores(logical = FALSE) - 1,
                     na.rm = TRUE))
  ))
}

#' Chains per fit when `n_fits` fits run at once: an equal share of the
#' cores, and at least `min_chains`.
chains_per_fit <- function(n_fits, cores = n_cores(), min_chains = 4) {
  max(min_chains, floor(cores / n_fits))
}

#' Apply `f` to each element of `jobs` in forked workers, largest `size`
#' first; results return in the order of `jobs`. Stops with the first worker
#' error. Runs serially on Windows or when there is one worker or one job.
par_map <- function(jobs, f, size = rep(1, length(jobs)),
                    workers = n_cores()) {
  stopifnot(length(size) == length(jobs))
  by_size <- order(size, decreasing = TRUE)
  serial <- .Platform$OS.type == "windows" || workers <= 1 ||
    length(jobs) <= 1
  out <- if (serial) {
    purrr::map(jobs[by_size], f)
  } else {
    parallel::mclapply(jobs[by_size], f,
                       mc.cores = min(workers, length(jobs)),
                       mc.preschedule = FALSE)
  }
  failed <- purrr::map_lgl(out, \(x) inherits(x, "try-error"))
  if (any(failed)) stop("Parallel job failed:\n", out[failed][[1]])
  out[order(by_size)]
}

#' As par_map(), for many short jobs: splits `jobs` into a few chunks per
#' worker (so fork overhead is paid per chunk, not per job) and runs each
#' chunk serially. Results return in the order of `jobs`.
par_map_chunked <- function(jobs, f, workers = n_cores(),
                            chunks_per_worker = 4) {
  if (length(jobs) == 0) return(list())
  n_chunks <- min(length(jobs), workers * chunks_per_worker)
  idx <- split(seq_along(jobs),
               cut(seq_along(jobs), n_chunks, labels = FALSE))
  out <- par_map(idx, \(ii) purrr::map(jobs[ii], f), workers = workers)
  unlist(unname(out), recursive = FALSE)
}

#' Run MCMC chains for a monty posterior, one forked worker per chain, and
#' thin each chain. monty's own parallel runners start fresh R processes,
#' which cannot see the temporary package odin2 compiles a model into, so
#' chains are forked instead. `initial` is a list of starting vectors, one
#' per chain. Returns a list with `pars` (pars x steps x chains), the shape
#' used downstream.
monty_sample_forked <- function(posterior, vcv, n_steps, initial, burnin,
                                thin, workers = n_cores(), seed = 1) {
  chains <- par_map(seq_along(initial), function(k) {
    set.seed(seed + k)
    s <- monty::monty_sample(
      posterior, monty::monty_sampler_adaptive(vcv), n_steps,
      initial = initial[[k]], n_chains = 1,
      runner = monty::monty_runner_serial()
    )
    monty::monty_samples_thin(s, burnin = burnin, thinning_factor = thin)$pars
  }, workers = workers)
  pars <- array(unlist(chains),
                dim = c(dim(chains[[1]])[1:2], length(chains)),
                dimnames = list(rownames(chains[[1]]), NULL, NULL))
  list(pars = pars)
}

#' Report the cores in use.
report_cores <- function(label = "") {
  message("Cores: ", n_cores(), if (nzchar(label)) paste0(" (", label, ")"))
}
