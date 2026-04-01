# Linux And Operating Systems

Use this reference when the user needs Linux fluency for cluster work, package installation, login methods, compatibility fixes, or a Linux versus Windows comparison.

Related references:

- Foundations: [foundations-architecture-and-programming.md](foundations-architecture-and-programming.md)
- Schedulers: [schedulers-and-execution.md](schedulers-and-execution.md)
- Environments: [software-environments.md](software-environments.md)

## Role In The Knowledge Graph

This topic is the operational substrate below scheduler usage and software environment management. If the user cannot navigate Linux, most HPC workflow advice will not stick.

## Main Threads

### OS overview

- `操作系统`
  - overview-level page that routes into Linux and Windows material

### Linux foundations

- `Linux 概况`
  - overview
  - usage
  - learning direction
- `一篇熟悉 Linux 基本操作`
  - general CLI fluency and daily commands
- `Linux 用户登录方式总结`
  - local login
  - remote login
  - productivity tools

### Installation and package management

- `Linux 安装方式总结`
  - hardware
  - OS selection
  - personal suggestions
- `Linux软件的安装和管理`
  - `yum` syntax
  - common `yum` commands
  - repository configuration

### Compatibility and toolchain edge cases

- `在不覆盖系统原有glibc版本情况下编译安装高版本及使用方法`
  - preparation
  - checking system glibc
  - build environment
  - isolated install workflow

This page is especially useful when prebuilt binaries or modern Python packages are blocked by old enterprise distributions.

### Linux versus Windows

- `Linux与Windows之间的区别`
  - major differences
  - filesystem comparison
  - Linux file types
  - user model comparison
- `Windows`
  - Windows overview page
- `原版Windows系统镜像资源集锦`
  - Windows image resource index

The Windows pages are peripheral to core HPC cluster usage, but still relevant for workstation setup, dual-environment users, or training material.

## Source Pages

| Source page | Main sections | Use it for |
| --- | --- | --- |
| `https://hpclib.com/OS/` | overview | entry point into OS material |
| `https://hpclib.com/OS/Linux/Linux_info.html` | overview, usage, how to learn Linux | first Linux orientation page |
| `https://hpclib.com/OS/Linux/Linux_use.html` | basic Linux operations | CLI fundamentals |
| `https://hpclib.com/OS/Linux/Linux_login.html` | local and remote login, tools | SSH and access habits |
| `https://hpclib.com/OS/Linux/Linux_install.html` | hardware, OS choice, advice | workstation or test-node setup |
| `https://hpclib.com/OS/Linux/Linux_soft.html` | `yum`, repos | package management basics |
| `https://hpclib.com/OS/Linux/Linux_glibc.html` | isolated glibc build and usage | compatibility rescue path |
| `https://hpclib.com/OS/Linux%20vs%20Windows.html` | filesystem and user differences | onboarding Windows users into Linux |
| `https://hpclib.com/OS/Windows/` | overview | Windows context page |
| `https://hpclib.com/OS/Windows/iso_type.html` | image resources | Windows installation references |

## Routing Rules

- If the user is new to clusters, load Linux overview and Linux basic usage before scheduler details.
- If the user cannot log in or transfer files, load the login page before any execution workflow.
- If the blocker is package installation or missing runtime libraries, load `Linux软件的安装和管理` and the glibc page.
- If the user is transitioning from Windows to Linux, start from the Linux versus Windows comparison.

## Guardrails

- Package manager examples are distribution-specific and may not match `dnf`, `apt`, `zypper`, or site-managed module stacks.
- glibc replacement work is risky. Prefer isolated installs and local prefixes; never overwrite system libraries on shared clusters.
