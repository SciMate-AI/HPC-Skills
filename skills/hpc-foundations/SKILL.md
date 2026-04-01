---
name: hpc-foundations
description: Navigate foundational HPC knowledge across concepts, architectures, schedulers, Linux usage, storage and RDMA, containers, cloud basics, and cluster administration patterns distilled from hpclib.com. Use when the task is about understanding or explaining HPC basics, Slurm or PBS or LSF concepts, Linux-on-cluster workflows, software environment setup, storage or network fundamentals, or when turning general HPC knowledge into future skills.
---

# HPC Foundations

Use this skill as the general HPC knowledge hub that sits below solver-specific skills and beside `hpc-orchestration`.

## Start

1. Read `references/index-map.md` first for the knowledge graph and the shortest route to the right topic.
2. Read `references/foundations-architecture-and-programming.md` when the task starts from HPC concepts, system design, programming models, application development, or performance basics.
3. Read `references/schedulers-and-execution.md` when the task is about Slurm, PBS Pro, LSF, queue semantics, batch scripts, arrays, or accounting commands.
4. Read `references/linux-and-os.md` when the task is about Linux usage, login patterns, package management, glibc compatibility, or Linux versus Windows tradeoffs on clusters.
5. Read `references/software-environments.md` when the task is about Conda, containers, Singularity or Apptainer-style execution, or picking common HPC tools.
6. Read `references/storage-network-cloud-and-admin.md` when the task is about storage tiers, RDMA, hardware, cloud deployment, SSL, Hyper-V maintenance, or site-level administration topics.
7. Read `references/source-catalog.md` when a page-level lookup of the hpclib.com crawl is needed.
8. Read `references/skillization-roadmap.md` when splitting this index into narrower reusable skills.

## Positioning

- Prefer this skill for orientation, taxonomy, and first-pass explanation.
- Prefer `hpc-orchestration` once the question becomes an execution workflow on a real cluster.
- Prefer solver-specific skills once the question becomes input-deck or application specific.

## Guardrails

- Treat hpclib.com as a practical knowledge index, not as the final authority for production commands.
- Re-check scheduler flags, MPI launch syntax, package names, and admin procedures against official upstream documentation before applying them on a live cluster.
- Do not assume cluster policies, filesystem layouts, or security rules are portable across sites.
