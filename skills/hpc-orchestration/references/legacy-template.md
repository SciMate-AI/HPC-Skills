# HPC Agent Skill: [Software Name]

## 1. 能力边界与适用场景 (Capabilities & Scope)
**目标软件**: [Software Name] (e.g., OpenFOAM, LAMMPS, FEniCS)
**适用物理场**: [适用领域，如：不可压流体，分子动力学拉伸测试等]
**核心能力**:
- [能力1，如：自动生成 blockMeshDict 和 controlDict]
- [能力2，如：自动修正时间步长发散报错]

## 2. 依赖与执行环境 (Dependencies & Environment)
- **命令**: [如 `mpirun`, `simpleFoam`, `lmp`]
- **测试命令**: [如 `[Software Name] -version` 以检查是否安装]
- **文件后缀**: [如 `.in`, `.txt`, `.dict`]

## 3. 标准化工作流 (Standardized Workflow)

作为 CLI Agent，当用户请求使用本软件时，**必须严格按照以下顺序执行**：

### Phase 1: 前处理 (Pre-processing)
1. **任务**: 生成或读取几何网格/初始拓扑。
2. **知识关联**: [此处说明应参考哪些知识库文件，例如: 参考 `KNOWLEDGE_DICT.md` 中关于 Mesh 的部分]
3. **输出期望**: [例如：生成 `constant/polyMesh/` 或 `data.lmp`]

### Phase 2: 配置生成 (Configuration)
1. **任务**: 根据用户物理需求生成核心输入文件。
2. **强制规则**:
   - 必须读取并遵循 `KNOWLEDGE_DICT.md` 中的“必填字段”和“约束条件”。
   - 必须参考 `KNOWLEDGE_PHYSICS.md` 选择正确的物理模型参数。
3. **输出期望**: [例如：生成 `system/` 下的各类字典文件]

### Phase 3: 执行与自愈 (Execution & Self-Healing)
1. **任务**: 启动计算进程或提交至 HPC 队列。
2. **工具调用**:
   - 本地运行使用 `execute` 运行命令。
   - HPC 集群运行需调用全局工具 `hpc_slurm_deploy.py` 生成脚本。
3. **自愈机制 (Self-Correction)**:
   - 若终端返回 Error Code != 0，**严禁自行猜测原因**。
   - 必须立即读取 `KNOWLEDGE_ERRORS.md`。
   - 使用正则表达式或关键字在标准错误（stderr）中匹配错误 ID。
   - 严格按照 Error ID 对应的 Agent Action 修改配置文件，并重试。

### Phase 4: 后处理与结果总结 (Post-processing)
1. **任务**: 提取标量结果、监控残差是否收敛，或者生成可视化后处理切片。
2. **工具调用**: 使用本 Skill 附带的 `scripts/` 下的后处理脚本（如 `post_paraview.py`）。
3. **输出期望**: 给用户输出最终收敛信息或关键物理量总结。

## 4. 相关知识库文件列表 (Knowledge Files Reference)
执行本 Skill 时，请随时调用 `read_file` 阅读以下规范：
- [ ] `KNOWLEDGE_DICT.md`: 配置语法与约束
- [ ] `KNOWLEDGE_PHYSICS.md`: 物理场经验规则
- [ ] `KNOWLEDGE_ERRORS.md`: 异常自愈指南
- [ ] `TEMPLATES/`: 基础配置模板目录
