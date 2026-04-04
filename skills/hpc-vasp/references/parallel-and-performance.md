# VASP Parallel and Performance Optimization

## Parallelization Hierarchy

VASP has four levels of parallelization. Combine them for best performance:

```
Total MPI ranks = KPAR × (NBANDS / NCORE) × IMAGES
                   ↑         ↑                  ↑
              k-points   band/FFT          NEB images
```

## KPAR: K-Point Parallelization

KPAR distributes k-points across groups of MPI ranks.

| Rule | Guidance |
| --- | --- |
| Default | KPAR = 1 (no k-point parallelism) |
| Optimal | KPAR = min(number_of_nodes, number_of_irreducible_kpoints) |
| Must divide | KPAR must divide the number of k-points evenly |
| Memory | Higher KPAR = higher memory per rank |

**Quick recipe:**
- 1 node, many k-points: KPAR = 1 (all k-points serialized)
- 4 nodes, 12 k-points: KPAR = 4
- 8 nodes, 4 k-points: KPAR = 4 (not 8!)
- 1 node, Gamma-only: KPAR = 1

KPAR parallelism is the most efficient — always maximize it first.

## NCORE: Cores per Orbital (FFT Parallelization)

NCORE determines how many cores work together on each orbital's FFT.

| Rule | Guidance |
| --- | --- |
| Default | NCORE = 1 |
| Optimal | NCORE = cores per NUMA domain (check with `lstopo` or `numactl --hardware`) |
| Common values | 4, 8, 12, 16 (depends on hardware) |
| Small systems (<20 atoms) | NCORE = 1 (not enough bands to distribute) |
| Large systems (>100 atoms) | NCORE = 8–16 |

**Must be a factor of cores per node** to avoid cross-node FFT communication.

**Hardware check:**
```bash
lstopo --only pu | wc -l              # total cores per node
numactl --hardware | grep "node.*cpus" # cores per NUMA domain
# Typical: 2 NUMA domains × 32 cores = 64 cores/node → NCORE=32
```

## NPAR: Band Parallelization (Legacy)

NPAR and NCORE are inverses: NPAR = total_ranks_per_kpoint / NCORE.

**Never set both NPAR and NCORE** — if both present, NPAR takes precedence.

Prefer NCORE over NPAR in modern VASP (5.4+).

## LREAL: Real-Space Projection

| LREAL | Behavior | Use when |
| --- | --- | --- |
| `.FALSE.` | Reciprocal-space projection; exact | Small systems (<20 atoms), phonons, tight accuracy |
| `Auto` | Real-space; fast but slight accuracy loss | Large systems (>20 atoms), MD, routine relaxation |

Real-space projection (LREAL=Auto) can be 2–5x faster for large cells.

## ALGO Performance Impact

| ALGO | Speed | Robustness | Best for |
| --- | --- | --- | --- |
| `VeryFast` | Fastest | Least robust | AIMD, large systems where SCF is easy |
| `Fast` | Fast | Good | General production |
| `Normal` | Moderate | Very robust | Difficult convergence |
| `All` | Slow | Most robust | Magnetic, DFT+U, hybrids |
| `Damped` | Slow | Most robust for hybrids | HSE06, PBE0 |

## Quick-Start Recipes by System Type

### Small Bulk (2–20 atoms, many k-points)

```
KPAR   = <number_of_nodes>     # maximize k-point parallelism
NCORE  = 1                     # small cell = few bands per core anyway
LREAL  = .FALSE.
ALGO   = Fast
```

### Large Supercell (100+ atoms, few k-points)

```
KPAR   = 1                     # few k-points; no benefit from KPAR
NCORE  = <cores_per_NUMA>      # e.g., 16 on a 2x16 node
LREAL  = Auto
ALGO   = Fast
NSIM   = 4                     # batch RMM-DIIS eigenvalue optimization
```

### Hybrid Functional (HSE06)

```
KPAR     = <number_of_nodes>
NCORE    = <cores_per_NUMA>
ALGO     = Damped
TIME     = 0.4
PRECFOCK = Fast                # coarser FFT for Fock exchange (significant speedup)
LREAL    = .FALSE.             # hybrids generally need reciprocal space
```

### AIMD (Molecular Dynamics)

```
KPAR   = 1                     # Gamma-only for large supercell
NCORE  = <cores_per_NUMA>
LREAL  = Auto
ALGO   = VeryFast
NSIM   = 4
```

### NEB

```
IMAGES = 4
# Total ranks must be divisible by IMAGES
# Each image gets total_ranks/IMAGES
# Within each image, set KPAR and NCORE as usual
KPAR   = 1                     # unless many k-points
NCORE  = <cores_per_NUMA>
```

## Scaling Guidelines

| Metric | Rule of thumb |
| --- | --- |
| Bands per core | Minimum 2; ideally 8+ for good efficiency |
| Cores per k-point | total_ranks / KPAR; should have enough bands for this many cores |
| Maximum useful cores | NBANDS / 2 × KPAR (beyond this, efficiency drops below 50%) |
| Memory per core | ~0.5–2 GB for routine DFT; 2–8 GB for hybrids/GW |

## Benchmarking Protocol

1. Run a short test (5 ionic steps) with different KPAR × NCORE combinations.
2. Compare LOOP time in OUTCAR:
```bash
grep "LOOP:" OUTCAR | awk '{sum+=$NF; n++} END {print sum/n " sec/step"}'
```
3. Choose the combination with lowest time per step.
4. Check memory: `grep "maximum memory" OUTCAR`

## I/O Optimization

| Setting | Effect |
| --- | --- |
| `LWAVE = .FALSE.` | Skip WAVECAR write (saves GB of I/O) |
| `LCHARG = .FALSE.` | Skip CHGCAR write |
| `NWRITE = 0` | Minimal OUTCAR output (less disk I/O) |
| `LPLANE = .TRUE.` | Better communication for FFT (default; keep it) |

For MD or NEB with many steps: LWAVE=.FALSE. and LCHARG=.FALSE. are essential to avoid I/O bottleneck.

## GPU Acceleration (VASP 6+)

VASP 6.x supports GPU offloading:

```
NSIM   = 4                     # number of bands treated simultaneously on GPU
# Use vasp_gpu or OpenACC-enabled build
# Set OMP_NUM_THREADS=1 for MPI+GPU (no OpenMP threading)
```

Typical speedup: 3–10x for large systems with few k-points.

## Common Performance Pitfalls

1. **KPAR > number_of_kpoints**: Wastes resources; some ranks idle.
2. **NCORE = total_cores**: All cores on one orbital; very slow.
3. **Both NPAR and NCORE set**: NPAR wins; NCORE is ignored. Set only one.
4. **LREAL=Auto for small cells**: Introduces unnecessary approximation with no speed benefit.
5. **Huge WAVECAR writes during MD**: Set LWAVE=.FALSE. for MD.
6. **Wrong number of MPI ranks for NEB**: Must be divisible by IMAGES.
