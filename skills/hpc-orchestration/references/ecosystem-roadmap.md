# HPC Agent Skills 集锦：计算物理自动化全生命周期实施计划

## 1. 核心设计理念：基于 CLI Agent Public Skills 协议
本计划旨在摒弃复杂的外部 RAG 依赖，将所有物理场和求解器的专业知识、API 语法、代码模板以及报错修复规则，**全部固化为高信息密度的结构化 Markdown 文件**。
CLI Agent（如 Cline, RooCode, OpenHands 或您当前的 AI Assistant）在执行计算任务前，通过工具（如 `read_file`）直接读取这些结构化的 `KNOWLEDGE.md` 和 `RULES.md`，从而精确、稳定地生成配置脚本，并调用 `execute` 完成自动化的部署、执行与后处理。

---

## 2. 市场调研与同类项目借鉴
在 AI 与 HPC 融合领域，目前行业正从“硬编码高通量工作流”向“LLM-Agent 自主驱动”演进。我们在设计 Skills 协议时，参考了以下开源项目或平台的设计模式：
- **AiiDA / ASE**：借鉴其对分子动力学（MD）和第一性原理（DFT）统一化 API 接口的思想，将 `VASP` 和 `LAMMPS` 的操作抽象为 Python 生成 Skill。
- **OpenFOAMGPT / FoamPilot**：参考其成功经验，Agent 最容易失败的地方是**超算排队脚本语法**和**物理量边界条件正交性**。因此，本计划将在 Markdown 知识库中强制设定边界条件的合法组合字典。
- **FEniCS / Firedrake**：此类软件本身即为 Python 偏微分方程（PDE）求解器，与 LLM 生成能力天然契合，是验证“代码生成”闭环的最佳起点。

---

## 3. HPC 物理仿真软件全景 Skill 图谱
为了打造“市面上所有 HPC 仿真软件的 Skills 集锦”，我们将按物理场和计算范式进行分类，为每一款软件开发独立的 Skill Package：

### 3.1 核心流体力学 (CFD)
- **OpenFOAM**：最广泛的工业开源 CFD 软件。重点 Skill：字典生成 (`blockMeshDict`, `controlDict`)、并行分解 (`decomposeParDict`)、残差监控。
- **SU2**：气动优化开源软件。重点 Skill：伴随方程 (Adjoint) 优化配置生成、网格变形脚本。
- **Nek5000**：高阶谱元法。重点 Skill：Fortran 代码插入、极高并行度的 HPC 部署脚本生成。

### 3.2 固体力学、多物理场与有限元 (FEM)
- **FEniCS / Firedrake**：代码即数学。重点 Skill：将自然语言 PDE（如变分形式）直接翻译为 Python UFL (Unified Form Language) 求解脚本。
- **Elmer FEM**：多物理场（热、流、电磁、声学）。重点 Skill：`sif` (Solver Input File) 配置语法规则的结构化映射。
- **MOOSE**：基于 libMesh 的大型核能与多物理场框架。重点 Skill：多块耦合输入文件的生成校验。
- **CalculiX**：Abaqus 开源替代品。重点 Skill：`.inp` 卡片生成（节点定义、材料本构、载荷步生成）。

### 3.3 第一性原理与量子化学 (DFT/Quantum)
- **VASP (商业/半开源)**：固态物理标准。重点 Skill：`INCAR` (参数控制)、`POSCAR` (结构)、`KPOINTS` 生成。
- **Quantum ESPRESSO**：全开源的 VASP 替代品。重点 Skill：赝势选择规则、自洽场 (SCF) 报错自愈。

### 3.4 分子动力学 (MD)
- **LAMMPS**：材料 MD 霸主。重点 Skill：`in.lammps` 脚本编写、力场 (Forcefield) 分配规则、系综 (NVE/NVT/NPT) 切换。
- **GROMACS**：生物分子霸主。重点 Skill：拓扑文件 (`.top`) 生成、能量最小化、MD 成品模拟工作流。

---

## 4. 标准化 Skill 目录与结构化知识规范 (无需 RAG)
每个 HPC 软件作为一个独立的 Skill 包，遵循公共 Skills 协议。以下以 `hpc-openfoam` 为例展示目录结构与知识组织形式：

```text
skills/hpc-openfoam/
├── SKILL.md                 # Agent 的入口文档：定义该技能的能力边界、使用场景、工作流顺序
├── KNOWLEDGE_DICT.md        # 核心知识库：结构化罗列 OpenFOAM 各个字典文件的语法树、必填项与可选项
├── KNOWLEDGE_PHYSICS.md     # 物理知识库：如 RANS/LES 对应的必需边界文件 (k, epsilon, nut) 及初始值公式
├── KNOWLEDGE_ERRORS.md      # 报错自愈库：罗列常见报错（如浮点溢出、Courant Number 过大）及 Agent 对应的修改动作
├── TEMPLATES/               # 静态模板库：基础边界条件、HPC Slurm 提交流程的 Jinja/文本模板
└── scripts/
    ├── log_monitor.py       # (执行域) 实时监听计算发散并中断的 Python 脚本
    └── post_paraview.py     # (后处理域) 自动提取升阻力或切片云图的脚本
```

### 知识库编写示例 (`KNOWLEDGE_DICT.md` 片段)
摒弃 RAG，要求大模型在编写文件前，必须严格读取以下 Markdown 规范：
```markdown
### 目标文件：`system/controlDict`
**必填键值对及合法参数范围**：
- `application`: [icoFoam | simpleFoam | pimpleFoam | interFoam] (根据物理场选择)
- `startFrom`: [startTime | firstTime | latestTime] (默认: latestTime)
- `deltaT`: 必须满足 Courant Number < 1，建议初始值 1e-4。
- `writeControl`: [timeStep | runTime | adjustableRunTime] (推荐: adjustableRunTime)

**禁止行为 (Constraints)**：
1. 绝对不要在字典中遗漏末尾的分号 `;`。
2. 对于不可压流体（simpleFoam），禁止定义热力学变量（如 `T`, `p_rgh`）。
```

---

## 5. 项目实施计划 (5 Phases)

### Phase 1: 协议定义与基础设施搭建 (Month 1)
- **目标**：完成《HPC CLI Agent Public Skills Protocol》的撰写，确立目录结构、触发条件和文档加载机制。
- **任务**：
  1. 制定通用 `SKILL.md` 模板，涵盖**前处理、配置、执行（训练）、后处理**四大标准化阶段。
  2. 开发基于 CLI 环境的通用工具：`hpc_slurm_deploy.py`（通用的作业排队生成器）和 `hpc_log_tracker.py`（通用残差监听器）。

### Phase 2: Python 原生计算生态跑通 (Month 2)
- **目标**：从最易于 LLM 代码生成的领域入手，验证“结构化知识 Markdown -> 脚本生成 -> 本地/容器执行”闭环。
- **实施对象**：`hpc-fenics` (有限元), `hpc-ase` (原子仿真环境，涵盖基础的 VASP/LAMMPS 预处理)。
- **产出**：
  1. 完成 FEniCS 的 `KNOWLEDGE_UFL.md` 语法规则编写。
  2. 实现自然语言生成求解线性弹性体或泊松方程的完整 Python 脚本，并自动提取 VTK 结果。

### Phase 3: 强配置型经典软件攻坚 (Month 3-4)
- **目标**：攻克输入文件高度定制化、极易因为一个拼写错误导致崩溃的经典 C/Fortran 求解器。
- **实施对象**：`hpc-openfoam`, `hpc-elmerfem`, `hpc-lammps`。
- **任务**：
  1. 大量编写纯文本结构化的 `KNOWLEDGE_DICT.md` 和 `KNOWLEDGE_PHYSICS.md`。
  2. 实现 Agent 的“试错自愈”（Self-Correction）机制：执行 `mpirun` -> 读取标准错误输出 -> 正则匹配 `KNOWLEDGE_ERRORS.md` -> 自动修改配置并重新提交。

### Phase 4: HPC 集群部署与大规模调度 (Month 5)
- **目标**：脱离本地单机 Sandbox，实现与真实超算节点（Slurm/PBS）的对接。
- **任务**：
  1. 完善 **部署与训练域 (Deployment & Training)** Skills：引入 `KNOWLEDGE_SLURM.md`，指导 Agent 根据网格数量自动计算最优节点数，生成 `sbatch` 脚本。
  2. 开发跨节点日志监控逻辑，使 Agent 能在本地 CLI 终端监听远端超算排队与计算状态。

### Phase 5: 后处理与跨软件协作 (Month 6)
- **目标**：实现数据可视化自动化，以及多 Agent 协同解决多物理场问题。
- **任务**：
  1. 完善 **后处理域 (Post-processing)** Skills：将 PyVista 和 ParaView 的 Trace 宏语法写入 `KNOWLEDGE_VISUAL.md`，使 Agent 能自动截取云图、绘制收敛曲线，并输出图文并茂的最终 Markdown/PDF 实验报告。
  2. 测试跨软件协作能力（例如：用 `hpc-openfoam` 算流场，提取表面压力后，传递给 `hpc-calculix` 计算结构应力）。

---

## 结语
将专家经验固化为**高密度的结构化 Markdown 规则**，让 CLI Agent 通过工具自主查阅并遵循这些规则，不仅绕过了 RAG 存在的“检索幻觉”和“上下文断裂”问题，更能以极低的成本，实现对物理仿真的精确控制。这将是打造开箱即用、高鲁棒性 HPC AI Agent 的最佳路径。
