---
name: r-parallel
description: Make R analysis runs use the machine's cores well - MCMC chains, independent model fits, scenario grids, posterior predictive simulations, cross-validation and bootstrap loops. Detects the hardware, sets a core budget (physical cores less one, overridable with N_CORES), runs jobs in forked workers dispatched one at a time and largest first, chunks many short jobs, splits cores between fits and chains, keeps results reproducible with a seed per job, and avoids thread oversubscription. Covers odin2/dust2/monty and Stan specifics. Use when writing or reviewing any R script that loops over independent work taking more than a few seconds, when a run is slow, or when asked to parallelise or speed up a pipeline.
---

# Parallel R runs

Every independent unit of work (a chain, a fit, a scenario, a posterior
draw, a bootstrap replicate) runs in parallel up to the machine's core
budget, and the wall time of a run is checked before and after. The helper
in `templates/parallel.R` implements the rules below; copy it to the
project's functions folder (for example `scripts/functions/parallel.R` or
`R/parallel.R`) and source it from each script that loops.

## 1. Know the hardware

Check before choosing a design:

```bash
sysctl -n hw.ncpu hw.perflevel0.physicalcpu hw.perflevel1.physicalcpu hw.memsize   # macOS
nproc; free -g                                                                     # Linux
```

```r
parallel::detectCores(logical = FALSE)
dust2::dust_openmp_support()$limit   # 1 means dust2 has no OpenMP threads
```

- **Core budget**: physical cores less one (one for the parent process and
  the system), or `N_CORES` if set, so a shared or smaller machine can cap
  it. Never use logical cores from hyperthreading for compute-bound R work.
- **Apple Silicon** has performance and efficiency cores. Efficiency cores
  run a job at roughly half speed, so dispatch jobs one at a time
  (`mc.preschedule = FALSE`); faster cores then take more jobs.
- **Memory**: workers x memory per worker must fit in RAM. Forked workers
  share the parent's memory until they write to it, but each result is
  copied back to the parent.

## 2. What to run in parallel, and at which level

Parallelise the outermost level with enough independent jobs to fill the
cores, and only one level unless the budget is split explicitly.

| Work | Unit of parallelism |
|---|---|
| MCMC | one chain per worker; for k fits at once, `floor(cores / k)` chains each (at least 4) |
| Several model variants | variants at once, each with its share of the cores |
| Posterior predictions | posterior draws (one job per draw, or chunks) |
| Scenario grids | scenarios, or draws within a scenario grid, whichever has more jobs |
| Optimisation | multi-start: one start per worker, keep the best |
| PSIS-LOO, bootstrap, permutations | blocks of draws or replicates, one block per core |
| Stochastic simulation (dust2) | particles inside one system (`n_threads` if OpenMP is available); otherwise scenarios across workers |

When the number of jobs is small, raise it: more chains per fit (more
draws in the same wall time) or more optimiser starts rather than idle
cores. A fit using 8 chains on a 16-core machine wastes half of it.

## 3. How

- **Fork, do not spawn.** On macOS and Linux use `parallel::mclapply`
  (through `par_map()`). Forked workers inherit loaded packages, compiled
  odin2/dust2 models, data and closures, so nothing has to be serialised or
  reloaded. Windows cannot fork; `par_map()` runs jobs in turn there.
- **Dispatch one job at a time, largest first** (`mc.preschedule = FALSE`,
  `size =` the expected cost), so the slowest job does not start last and
  run alone.
- **Chunk many short jobs** (thousands of simulations of milliseconds
  each) with `par_map_chunked()`: a few chunks per worker, each run
  serially, so fork overhead is paid per chunk.
- **Split the budget for nested work**: when variants run at once, give
  the outer `par_map()` `workers = n_variants` and each inner one
  `workers = floor(n_cores() / n_variants)`. Never let both levels use all
  cores.
- **Return small results**: summaries, matrices of draws, aggregates.
  Returning large objects (whole simulation states, data frames per draw
  with every time point) makes the parent the bottleneck.
- **Stop on the first failure**: `mclapply` returns `try-error` objects
  silently; `par_map()` checks and stops with the first error.

## 4. Reproducibility

With dynamic dispatch, which worker runs a job changes from run to run, so
set the seed inside each job from a job-specific value
(`set.seed(base + k)`), and pass explicit seeds to dust2
(`dust_system_create(..., seed =)`). Do not rely on the parent's seed or on
`mc.set.seed`.

## 5. Threads

Set one BLAS/OpenMP thread per worker (`OMP_NUM_THREADS`,
`VECLIB_MAXIMUM_THREADS`, `OPENBLAS_NUM_THREADS` = 1; the helper does this
on load) so that 15 workers do not each start a multithreaded BLAS. Use
multithreading inside a job (dust2 `n_threads`, Stan `threads_per_chain`,
data.table) only when the job count is below the core count, and then
size threads x workers to the budget.

## 6. Tool specifics

- **monty** (odin2/dust2 models): monty's process-based runners
  (`monty_runner_callr`, `monty_runner_parallel`) start fresh R sessions,
  which do not have a model odin2 compiled into a temporary package during
  the session. Run chains in forked workers instead
  (`monty_sample_forked()` in the helper: one single-chain `monty_sample()`
  per worker, thinned, then bound into a pars x steps x chains array). Use
  the process runners only when the model lives in an installed package.
- **dust2**: check `dust_openmp_support()`. Without OpenMP (the default
  Apple clang build), particles in one system run on one core; parallelise
  across systems instead. With OpenMP, use `n_threads` for many particles.
- **Stan** (`rstan`, `cmdstanr`): `parallel_chains` / `options(mc.cores)`
  for chains within a fit; for several fits at once, fork fits with
  `floor(cores / chains)` workers, as in
  `EVD-COD17-ve-retro/R/parallel.R`.
- **Quarto reports** fit nothing; parallelism belongs in the analysis
  scripts.

## 7. Check

1. Report the budget at the start of each script (`report_cores()`).
2. Time the run before and after (`/usr/bin/time -p Rscript script.R`) and
   report both.
3. While it runs, confirm the workers are busy:
   `ps -eo pid,etime,pcpu,command | grep R` should show one process per
   worker near 100% CPU, and not more workers than the budget.
4. Confirm results match a serial run in distribution (same seeds per job
   give identical results regardless of worker count).
