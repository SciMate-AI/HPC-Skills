# HPC Foundations Index Map

Snapshot source: `https://hpclib.com/` and directly linked internal pages crawled on 2026-03-26.

This snapshot contains 44 content pages. The goal of this reference set is not to mirror the site verbatim, but to make its knowledge loadable in smaller units and easy to evolve into future skills.

## Core Graph

1. Foundations
   Read [foundations-architecture-and-programming.md](foundations-architecture-and-programming.md).
   Start here when the user needs the conceptual model for what HPC is, where it is used, and why parallelism changes system design.
2. Execution And Schedulers
   Read [schedulers-and-execution.md](schedulers-and-execution.md).
   Load after the conceptual layer when the question shifts to queueing, resource requests, batch scripts, arrays, MPI launch, or accounting.
3. Operating Systems And Daily Cluster Use
   Read [linux-and-os.md](linux-and-os.md).
   Load when the practical blocker is Linux fluency, login method, package installation, glibc compatibility, or Windows comparison.
4. Software Environments
   Read [software-environments.md](software-environments.md).
   Load when the user needs Python environments, containers, Singularity, or a survey of common HPC software.
5. Storage, Network, Cloud, And Admin
   Read [storage-network-cloud-and-admin.md](storage-network-cloud-and-admin.md).
   Load when the question touches filesystem tiers, RDMA, hardware, cloud deployment, SSL, or site maintenance.
6. Raw Page Lookup
   Read [source-catalog.md](source-catalog.md).
   Use this when the task needs the original hpclib page title, URL, or heading list.
7. Future Skill Split
   Read [skillization-roadmap.md](skillization-roadmap.md).
   Use this when converting the index into narrower reusable skills.

## Dependency Order

- Foundations -> Schedulers
- Foundations -> Linux And OS
- Foundations -> Storage And Network
- Foundations -> Software Environments
- Linux And OS -> Software Environments
- Linux And OS -> Schedulers
- Storage And Network -> Performance Reasoning
- Schedulers -> `hpc-orchestration` for real execution workflows

## Recommended Reading Paths

### New HPC user

1. [foundations-architecture-and-programming.md](foundations-architecture-and-programming.md)
2. [linux-and-os.md](linux-and-os.md)
3. [schedulers-and-execution.md](schedulers-and-execution.md)
4. [software-environments.md](software-environments.md)

### Cluster user moving to production

1. [schedulers-and-execution.md](schedulers-and-execution.md)
2. [software-environments.md](software-environments.md)
3. [storage-network-cloud-and-admin.md](storage-network-cloud-and-admin.md)
4. `skills/hpc-orchestration/SKILL.md`

### Cluster admin or platform engineer

1. [foundations-architecture-and-programming.md](foundations-architecture-and-programming.md)
2. [storage-network-cloud-and-admin.md](storage-network-cloud-and-admin.md)
3. [schedulers-and-execution.md](schedulers-and-execution.md)
4. [linux-and-os.md](linux-and-os.md)

### Skill author

1. [source-catalog.md](source-catalog.md)
2. [skillization-roadmap.md](skillization-roadmap.md)
3. Reuse only the topic pages needed for the target skill instead of loading the whole site snapshot.

## Topic Coverage At A Glance

| Topic | Main hpclib pages | Use it for |
| --- | --- | --- |
| HPC basics | `HPC_Base`, `HPC_Arch`, `HPC_Code`, `HPC_AD`, `HPC_op` | definitions, architectures, programming models, development, optimization |
| Schedulers | `Scheduler/`, Slurm pages, PBS Pro pages, LSF quick reference | queue systems, batch usage, arrays, MPI launch, accounting |
| OS | `OS/`, Linux pages, Windows pages | Linux fluency, login, install, package management, glibc, OS comparison |
| Environments | `soft/`, `conda`, `container`, `Singularity`, software summary | Python stacks, containers, runtime isolation, tool selection |
| Storage and network | `storage/`, `compute-network`, `storage-start`, `hardware/` | RDMA, storage tiers, hardware background |
| Cloud and admin | `HPC_Cloud`, `HPC_SS`, `WEB_SSL`, `storage_extend` | cloud orientation, admin and maintenance topics |

## What This Skill Does Not Replace

- Vendor manuals for Slurm, PBS Pro, LSF, Lustre, BeeGFS, MPI stacks, or Linux distributions.
- Site-specific operating policies.
- Solver-specific skills such as VASP, LAMMPS, OpenFOAM, or GROMACS.
