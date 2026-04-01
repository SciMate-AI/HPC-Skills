# Storage, Network, Cloud, And Admin

Use this reference when the task touches storage tiers, RDMA, hardware, cloud deployment, site security, SSL, or maintenance actions that sit near platform administration.

Related references:

- Concepts: [foundations-architecture-and-programming.md](foundations-architecture-and-programming.md)
- Environments: [software-environments.md](software-environments.md)
- Future skill split: [skillization-roadmap.md](skillization-roadmap.md)

## Main Threads

### Storage and filesystems

- `从硬盘到集群存储`
  - hardware chapter
  - disks
  - hardware storage solutions
  - software chapter
- `网络&存储`
  - landing page for this branch

This is the right entry when the user needs to reason about local disks, shared storage, or how cluster storage stacks differ from workstation disks.

### Network and RDMA

- `HPC网络-RDMA`
  - page focused on RDMA-oriented HPC networking
- `HPC系统架构`
  - network architecture section complements the RDMA page

Use this pair when the question is really about data movement, latency, or why network architecture changes scaling behavior.

### Hardware background

- `计算机硬件`
  - landing page for hardware
- `HPC系统架构`
  - hardware architecture section

The dedicated hardware page is light, so use it mainly as a routing node rather than a full knowledge source.

### Cloud and site administration

- `HPC云平台`
  - cloud-oriented HPC overview
- `HPC安全与管理`
  - cluster security and management context
- `WEB服务器自动申请和续订免费SSL证书`
  - web certificate automation
- `Hyper-v 虚拟机磁盘扩容`
  - virtualization maintenance operation

These are mixed-granularity pages. Treat them as seeds for future admin-facing skills rather than a finished admin manual.

## Source Pages

| Source page | Main sections | Use it for |
| --- | --- | --- |
| `https://hpclib.com/storage/` | landing page | entry into storage branch |
| `https://hpclib.com/storage/storage-start.html` | hardware, disks, storage solutions, software | storage taxonomy |
| `https://hpclib.com/storage/compute-network.html` | RDMA | network-performance background |
| `https://hpclib.com/hardware/` | landing page | hardware routing |
| `https://hpclib.com/hpc/HPC_Arch.html` | network and hardware architecture | complement to storage and RDMA |
| `https://hpclib.com/hpc/HPC_Cloud.html` | cloud page | HPC cloud orientation |
| `https://hpclib.com/hpc/HPC_SS.html` | security and management | security and admin framing |
| `https://hpclib.com/cloud/WEB_SSL.html` | overview, certificate application and renewal | web admin micro-playbook |
| `https://hpclib.com/cloud/storage_extend.html` | Hyper-V disk expansion | virtualization maintenance micro-playbook |

## Routing Rules

- If the user asks about parallel filesystem performance or shared storage choices, start with the storage page and then cross-load HPC architecture.
- If the user asks about low-latency fabric or MPI scaling pain, load the RDMA page and HPC architecture together.
- If the user asks about cloud-hosted HPC or site-level services, load the cloud and admin pages but keep expectations narrow because this part of hpclib is relatively shallow.

## Guardrails

- RDMA, storage stacks, and cluster security are highly implementation-specific. Use this reference for orientation only.
- SSL and Hyper-V pages are admin micro-guides, not generic HPC user material.
- Before applying any admin procedure, verify the exact platform, distribution, service manager, and backup or rollback path.
