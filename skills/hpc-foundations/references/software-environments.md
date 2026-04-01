# Software Environments

Use this reference when the question is about Python environments, Conda, container strategy, Singularity or Apptainer-style execution, or surveying common HPC software families.

Related references:

- OS prerequisites: [linux-and-os.md](linux-and-os.md)
- Storage and admin context: [storage-network-cloud-and-admin.md](storage-network-cloud-and-admin.md)
- Execution workflow: `skills/hpc-orchestration/SKILL.md`

## Main Threads

### Environment management

- `集群python环境管理就用conda`
  - what Conda is
  - installation
  - user usage
  - configuration management

This is the best entry point when the user needs isolated Python stacks without touching system packages.

### Containers

- `容器那些事儿`
  - container overview
  - Docker
  - Singularity
- `Singularity的基本用法`
  - build
  - pull
  - run
  - exec
  - shell
  - inspect
  - help

This pair covers the conceptual reason to use containers and the concrete Singularity command surface commonly seen on HPC clusters.

### Software catalog

- `HPC常用计算应用和软件汇总`
  - survey page for common scientific and HPC software families
- `软件&工具`
  - category landing page for the software branch

These pages are useful for mapping the ecosystem, not for deep operational detail.

### Low-priority productivity tooling

- `好用的Chrome插件`
  - translation
  - tab management
  - AI assistant browser plugins

This page is ancillary. Keep it out of most skills unless browser productivity is the explicit user need.

## Source Pages

| Source page | Main sections | Use it for |
| --- | --- | --- |
| `https://hpclib.com/soft/` | landing page | branch entry |
| `https://hpclib.com/soft/conda.html` | Conda intro, install, user flow, config | Python stack setup |
| `https://hpclib.com/soft/container.html` | containers, Docker, Singularity | tool selection and conceptual grounding |
| `https://hpclib.com/soft/Singularity.html` | build, pull, run, exec, shell, inspect | concrete Singularity command map |
| `https://hpclib.com/soft/soft_sum.html` | software summary | ecosystem survey |
| `https://hpclib.com/soft/chrome.html` | browser plugins | low-priority productivity appendix |

## Routing Rules

- If the user wants a Python environment on a cluster, start with Conda.
- If the user wants portable or reproducible runtime stacks, start with the container overview and then load the Singularity page.
- If the user needs actual launch scaffolds, leave this reference and load `hpc-orchestration`.

## Guardrails

- Cluster container policy varies widely. Some sites allow Apptainer only, some disallow unprivileged image builds, and some prefer centrally maintained module stacks.
- Conda is convenient but can be slow or storage-heavy on shared filesystems. Re-check with site policy before recommending large writable environments on home storage.
