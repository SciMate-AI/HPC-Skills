# Skillization Roadmap

Use this reference when turning the hpclib.com knowledge snapshot into multiple narrower skills.

## Recommended Strategy

Do not make one skill per page.

That split would create too many shallow skills, repeat shared context, and make triggering unreliable. Prefer one hub skill plus a small set of topic skills that each own a coherent operational surface.

## Recommended Target Layout

### Keep

- `hpc-foundations`
  - role: taxonomy, orientation, first-pass explanation, page lookup
  - sources: the references in this folder

### Candidate follow-on skills

1. `hpc-slurm`
   - scope: Slurm concepts, job scripts, arrays, MPI launch, accounting, command lookup
   - initial source set:
     - `Scheduler/`
     - `HPC_Job_sc`
     - `Scheduler/Slurm/start`
     - `Scheduler/Slurm/mpi_guide`
     - `Scheduler/Slurm/job_array`
     - `Scheduler/Slurm/sacct`
     - `Scheduler/Slurm/man`
   - note: keep `sacctmgr` separate or clearly marked as admin-only
2. `hpc-linux-cluster`
   - scope: Linux CLI, login, package management, glibc compatibility, Linux versus Windows onboarding
   - initial source set:
     - `OS/`
     - Linux pages
     - Linux versus Windows
3. `hpc-env-tooling`
   - scope: Conda, containers, Singularity, software environment patterns
   - initial source set:
     - `soft/conda`
     - `soft/container`
     - `soft/Singularity`
     - `soft/soft_sum`
4. `hpc-storage-network`
   - scope: storage tiers, RDMA, hardware and network reasoning
   - initial source set:
     - `storage/`
     - `storage/storage-start`
     - `storage/compute-network`
     - `hardware/`
     - the architecture page from `hpc/HPC_Arch`
5. `hpc-cloud-admin`
   - scope: cloud orientation, site security and management, SSL, Hyper-V maintenance
   - initial source set:
     - `HPC_Cloud`
     - `HPC_SS`
     - `cloud/WEB_SSL`
     - `cloud/storage_extend`

## Trigger Design Guidance

- Trigger on user intent, not source page names.
- Prefer descriptions like:
  - "Use when the task is about Slurm job submission, job arrays, MPI launch, or Slurm accounting."
- Avoid descriptions like:
  - "Use for content from Slurm快速入门-用户指南."

## Migration Order

1. Keep this hub skill as the default entry point.
2. Extract `hpc-slurm` first because it has the densest and most operational material.
3. Extract `hpc-linux-cluster` and `hpc-env-tooling` next because they are common prerequisites for real users.
4. Extract `hpc-storage-network` once you need cluster-performance or infrastructure conversations more often.
5. Extract `hpc-cloud-admin` last unless platform administration is a frequent need.

## Maintenance Pattern

- Preserve the raw source catalog in one place.
- Move only the topic-specific pages into each new skill's `references/`.
- Keep `SKILL.md` short and procedural.
- Keep detailed taxonomies, command maps, and page inventories in `references/`.
- Re-check operational commands against official upstream docs before promoting them from index material into production-grade skill guidance.

## Practical Shortcut

If you want a faster next step, do this:

1. Treat `hpc-foundations` as the universal entry skill.
2. Add only one new specialized skill, `hpc-slurm`, when you first need real scheduler execution depth.
3. Leave the remaining hpclib pages inside this hub until repeated usage proves they deserve their own trigger surface.
