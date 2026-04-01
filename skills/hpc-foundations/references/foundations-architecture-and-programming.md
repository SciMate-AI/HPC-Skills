# Foundations, Architecture, And Programming

Use this reference when the question begins with "what is HPC", "how is an HPC system organized", "which programming model fits", or "where should optimization effort go first".

Related references:

- Scheduler follow-up: [schedulers-and-execution.md](schedulers-and-execution.md)
- OS follow-up: [linux-and-os.md](linux-and-os.md)
- Storage and network follow-up: [storage-network-cloud-and-admin.md](storage-network-cloud-and-admin.md)

## Knowledge Spine

### HPC basics

- `HPC基础知识` establishes the baseline vocabulary:
  - what HPC is
  - how it evolved
  - where it is applied
  - what advantages and limits come with parallel computing

### System architecture

- `HPC系统架构` splits the platform into:
  - hardware architecture
  - software architecture
  - network architecture

This is the bridge between abstract HPC concepts and concrete cluster operations.

### Programming models

- `HPC编程模型` gives the first-pass model choice space:
  - MPI for distributed memory
  - OpenMP for shared memory
  - CUDA for accelerator-oriented execution

Use this page to frame user questions before dropping into solver or scheduler specifics.

### Application development

- `HPC应用开发` focuses on:
  - parallel algorithm design
  - parallel application development practice

This is the page to load when the user is designing software rather than just using a cluster.

### Optimization

- `HPC性能优化` separates:
  - profiling and performance-analysis tools
  - program-level optimization
  - system-level optimization

This page pairs naturally with scheduler, storage, and network topics because performance issues usually cross those boundaries.

## Source Pages

| Source page | Main sections | Why it matters |
| --- | --- | --- |
| `https://hpclib.com/hpc/HPC_Base.html` | 什么是HPC, 历史和发展, 应用领域, 优势和局限 | good first page for any beginner or for framing an HPC explainer |
| `https://hpclib.com/hpc/HPC_Arch.html` | 硬件架构, 软件架构, 网络架构 | ties concepts to cluster topology and software stack layers |
| `https://hpclib.com/hpc/HPC_Code.html` | MPI, OpenMP, CUDA | gives the basic parallel model taxonomy |
| `https://hpclib.com/hpc/HPC_AD.html` | 并行算法设计, 并行应用开发实践 | useful when the task is code design instead of tool usage |
| `https://hpclib.com/hpc/HPC_op.html` | 性能分析工具, 程序优化技巧, 系统优化技巧 | the shortest route from “it runs” to “it scales” |

## Practical Routing

- If the user does not understand nodes, cores, ranks, or accelerators, start with `HPC_Base` and `HPC_Arch`.
- If the user is deciding between MPI, OpenMP, and GPU execution, load `HPC_Code` before any scheduler detail.
- If the user asks how to write or refactor parallel software, combine `HPC_AD` with the relevant solver or orchestration skill.
- If the user asks why a job is slow, read `HPC_op` and then load the scheduler or storage reference that matches the bottleneck.

## Boundaries

- This reference is conceptual and taxonomic.
- For command syntax and production batch patterns, continue to [schedulers-and-execution.md](schedulers-and-execution.md).
- For cluster-safe execution workflows, continue to `skills/hpc-orchestration/SKILL.md`.
