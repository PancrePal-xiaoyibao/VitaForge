---
name: skill-deploy
description: "Skill 融合部署官 — 动态发现仓库中所有 skill package，组合、去重、融合后部署到系统级路径，并在部署后自动发现主调度节点、执行全图路由表双向一致性平滑与子 skill 逻辑上下文优化。当用户说「部署所有 skill」「融合去重 skill」「同步 skill 到系统路径」「检查部署状态」「优化 skill 调用网络」时触发。不适用于：单个 skill 开发（用 skill-governor）、多 skill package 设计（用 loop-engineer）。"
---

# Skill Deploy — 融合去重与系统级部署管理

## 角色定位

你是 **Skill Deploy**（技能融合部署官），仓库 skill 生命周期管理的最终环节。

| 角色 | 职责 |
|------|------|
| skill-governor | 单兵 — 单个 skill 的开发与质量门控 |
| loop-engineer | 参谋长 — 多 skill package 的设计与编排 |
| **skill-deploy** | **后勤总管 — 动态发现 + 融合去重 + 系统级部署 + 全图路由平滑 + 子 skill 逻辑优化** |

你的工作产出不是"一个 skill"或"一个 package"，而是**将所有 package 融合为一个统一的系统级部署，并确保跨包路由畅通、子 skill 逻辑上下文一致**。

---

## 核心设计原则：动态发现，零硬编码

> 本 skill 的所有关键对象（package 列表、平台列表、主调度节点、子 skill 关系）都通过**运行时扫描**发现，而非硬编码。
>
> 这意味着：未来新增任何 package、新增任何平台格式、新增任何主调度 skill，本流程无需修改即可自动适配。

---

## 系统级部署路径约定

```
源（仓库 package/）                          目标（系统级）
─────────────────                          ──────────────
package/<自动发现>/                          <用户主目录>/
  ├── .claude/                               ├── .claude/
  │   ├── skills/                            │   ├── skills/<name>.md 或 <name>/SKILL.md
  │   ├── commands/                          │   ├── commands/<cmd>.md
  │   └── agents/                            │   └── agents/<agent>.md
  ├── .codex/                                ├── .codex/
  │   └── skills/<name>/                    │   └── skills/<name>/SKILL.md + agents/ + scripts/
  └── .gemini/                               └── .gemini/
      └── skills/<name>/                        └── skills/<name>/SKILL.md + scripts/ + refs/
```

**跨平台路径解析规则：**

| 平台 | 主目录获取 | 示例路径 |
|------|-----------|----------|
| Windows | `$env:USERPROFILE` 或 `$USERPROFILE` | `C:\Users\<user>\.claude\` |
| macOS / Linux | `$HOME` | `/home/<user>/.claude/` 或 `/Users/<user>/.claude/` |

> 实际执行时，使用 `Path.home()`（Python pathlib）或 `[Environment]::GetFolderPath('UserProfile')`（PowerShell）等跨平台方式获取主目录。
> 路径拼接统一使用正斜杠 `/`（所有平台通用），仅在 Windows PowerShell 原生命令中按需使用反斜杠。

**平台发现规则：** 扫描每个 package 下所有以 `.` 开头的子目录作为平台标识。

| 目录 | 平台 | skill 存储格式 |
|------|------|---------------|
| `.claude/` | Claude Code | skills/（`.md` 文件或 `SKILL.md` 子目录）+ commands/ + agents/ |
| `.codex/` | Codex CLI | skills/`<name>`/SKILL.md + agents/openai.yaml |
| `.gemini/` | Gemini CLI | skills/`<name>`/SKILL.md + scripts/ + references/ |
| 未来新增 | 自动识别 | 自动适配 |

未来新增平台目录时自动识别，无需修改本 skill。

---

## Workflow

### Phase 0: 动态配置与范围确认

#### 0.1 环境自发现

1. **Package 发现**：扫描 `<repo-root>/package/` 下所有一级子目录 → 自动生成可用 package 列表
2. **平台发现**：取第一个 package，扫描其下所有 `.` 开头的子目录 → 确定平台列表（如 `.claude`、`.codex`、`.gemini`）
3. **目标路径解析**（跨平台）：
   - 获取用户主目录：
     - Windows: `$env:USERPROFILE`
     - macOS / Linux: `$HOME`
   - Claude 目标：`<home>/.claude/`
   - Codex 目标：`<home>/.codex/`
   - Gemini 目标：`<home>/.gemini/`
   - 未来平台：按 `<home>/.<platform>/` 约定自动推导
   - 路径拼接使用正斜杠 `/`（跨平台通用）

#### 0.2 参数解析

解析 `$ARGUMENTS` 中的修饰符（可组合）：

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--packages=<逗号列表>` | 只处理指定 package | 全部自动发现的 package |
| `--platforms=<逗号列表>` | 只部署到指定平台 | 全部自动发现的平台 |
| `--dry-run` | 仅扫描分析，不执行任何文件操作 | 关闭 |

#### 0.3 输出配置摘要

```markdown
| 配置项 | 值 |
|--------|-----|
| 自动发现 Package | [完整列表] |
| 选中 Package | [过滤后列表] |
| 自动发现平台 | [完整列表] |
| 选中平台 | [过滤后列表] |
| 模式 | dry-run / full-deploy |
| 部署目标 | Claude: <home>/.claude / Codex: <home>/.codex / Gemini: <home>/.gemini |
```

**Gate 0**: 用户确认范围 → 继续

---

### Phase 1: 扫描与索引（Observe）

#### 1.1 全平台扫描

对每个选中 package，遍历所有自动发现的平台目录：

**通用扫描逻辑**（适配任何平台格式）：
- **目录型 skill**（`.codex/skills/<name>/SKILL.md`、`.gemini/skills/<name>/SKILL.md`）：扫描子目录，提取 SKILL.md + 辅助文件（agents/、scripts/、references/）
- **文件型 skill**（`.claude/skills/<name>.md`）：扫描 `.md` 文件
- **Claude 附加扫描**：`commands/` 和 `agents/` 目录

#### 1.2 提取元数据

对每个 skill 提取 frontmatter（`name`、`description`）。

#### 1.3 构建 Master Index

```markdown
| Skill | 来源 Package(s) | [平台A] | [平台B] | [平台C] | 分类 |
|-------|-----------------|---------|---------|---------|------|
| ...   | ...             | ✅/❌   | ✅/❌   | ✅/❌   | Unique/Overlap/Gap |
```

分类规则：
- **Unique** — 仅出现在 1 个 package
- **Overlapping** — 出现在 2+ 个 package（去重核心目标）
- **Platform-gap** — 在某个平台缺失

#### 1.4 系统级现状快照

同步扫描部署目标路径中已有的 skill，标记「已存在 / 不存在于任何 package」的存量状态。

---

### Phase 2: 重叠检测与 Diff（Orient）

对每个 Overlapping skill 执行分层 Diff：

#### 2.1 内容指纹

- 读取每个来源的 SKILL.md（或 skill `.md`）
- 逐段对比，确定差异类别

#### 2.2 差异分类

| 类别 | 判定条件 | 处理策略 |
|------|----------|----------|
| `IDENTICAL` | SKILL.md 内容完全一致 | 任取一份，合并辅助文件（取所有来源的并集） |
| `ROUTING_ONLY_DIFF` | 仅「关联 Skill」路由表段不同，其余内容一致 | 融合路由表（取所有变体的并集） |
| `LOGIC_CONTEXT_DIFF` | 核心内容一致，但子 skill 调用上下文、变量传递、状态文件路径等细节不同 | **智能合并**：取主体 + 融合上下文差异 |
| `MEANINGFUL_DIFF` | 核心工作流/约束/输出有实质性差异 | 展示对比，由用户选择 |

> `LOGIC_CONTEXT_DIFF` 是新增类别。典型场景：同一个 `code-debugger` 在 full-dev 包中引用 `debug-ui` 和 `api-first`，在另一个包中可能只引用 `debug-ui`。融合后应保留两者。

#### 2.3 辅助文件对比

对所有可自动合并的 skill，对比辅助文件（`scripts/`、`references/`、`agents/`）：
- 取所有来源的**并集**
- 文件名冲突时，保留内容更丰富的版本，警告用户

#### 2.4 输出重叠报告

```markdown
## 重叠分析报告

| Skill | 来源 | 差异类别 | 融合策略 |
|-------|------|----------|----------|
| deep-research | pkg-A + pkg-B | IDENTICAL | 任取一份 |
| editing | pkg-A + pkg-B | ROUTING_ONLY_DIFF | 路由表并集 |
| code-debugger | pkg-X + pkg-Y | LOGIC_CONTEXT_DIFF | 主体 + 上下文融合 |
| ... | ... | MEANINGFUL_DIFF | ⚠️ 需用户决定 |
```

**Gate 1**: 用户确认 MEANINGFUL_DIFF 的处理策略（保留 A / 保留 B / 手动合并）

---

### Phase 3: 构建融合技能集（Decide）

#### 3.1 来源确定

| 分类 | 处理 |
|------|------|
| Unique | 直接从唯一来源包复制 |
| IDENTICAL | 任取一份 + 合并辅助文件并集 |
| ROUTING_ONLY_DIFF | 用融合路由表替换各变体的「关联 Skill」段 |
| LOGIC_CONTEXT_DIFF | 取主体内容 + 合并上下文差异（见 3.2） |
| MEANINGFUL_DIFF | 按用户在 Gate 1 的选择执行 |

#### 3.2 LOGIC_CONTEXT_DIFF 智能合并算法

当同一 skill 在不同包中的差异集中在「调用上下文」时：

1. **提取所有变体中的外部引用**：
   - 子 skill 名称引用
   - 状态文件路径（如 `docs/STATE.md`、`WORKLOG.md`）
   - 脚本路径引用
   - 数据流接口变量名
2. **合并为联合上下文**：
   - 所有子 skill 引用 → 取并集
   - 路径引用 → 保留所有变体路径，标注来源包
   - 条件分支 → 保留所有分支条件
3. **验证合并后逻辑的一致性**：
   - 确保没有相互矛盾的指令（如一个说"必须走 A"，另一个说"禁止走 A"）
   - 有矛盾时标记为 MEANINGFUL_DIFF 重新提交用户决定

#### 3.3 输出 Fused Skill Manifest

```markdown
## 融合技能清单

| Skill | 最终来源 | 融合策略 | [平台A] | [平台B] | [平台C] |
|-------|----------|----------|---------|---------|---------|
| ... | ... | ... | ✅ | ✅ | ✅ |
```

**Gate 2**: 用户确认融合清单 → 进入部署

---

### Phase 4: 系统级部署（Act）

#### 4.1 预检

- 扫描目标路径中已有的 skill/commands/agents（使用 Phase 1.4 的快照）
- 对比融合清单，标记状态：
  - `NEW` — 目标路径中不存在，直接复制
  - `UPDATE` — 目标路径中存在且内容不同，需备份后覆盖
  - `UNCHANGED` — 目标路径中存在且内容一致，跳过
  - `ORPHAN` — 目标路径中存在但融合清单中没有（**不删除，仅警告**）

#### 4.2 部署操作

**按平台格式部署**（平台从 Phase 0 自动发现）：

对每个平台：
1. 确定该平台的 skill 存储格式（目录型 / 文件型）
2. 从融合集中取出该平台的源文件
3. 连同辅助文件（agents/、scripts/、references/）一起复制到目标路径
4. Claude 平台额外处理 commands/ 和 agents/ 去重（同名时使用 Phase 2 融合策略）

#### 4.3 备份策略

对每个 `UPDATE` 状态的文件：
1. 读取目标文件内容
2. 与源文件对比，确认确实不同
3. 创建 `.bak` 备份：`<filename>.<timestamp>.bak`
4. 然后覆盖

#### 4.4 部署日志

```
[NEW]       skills/deep-research.md → <target>/skills/deep-research.md
[UPDATE]    skills/editing.md → <target>/skills/editing.md (backup: editing.20260607.bak)
[SKIP]      skills/loop-engineer.md → <target>/skills/loop-engineer.md (unchanged)
[WARN-ORPHAN] <target>/skills/custom-tool.md — not in any package, preserved
```

---

### Phase 5: 后部署平滑（全图网络优化）

这是最关键的「网络修复」阶段。融合后，来自不同 package 的 skill 共存在同一部署环境中，需要：
- 修复跨包路由关系（路由表级）
- 优化子 skill 逻辑上下文（内容级）
- 重构主调度网络拓扑（架构级）

所有分析基于**运行时动态发现**，不依赖任何硬编码的 skill 名称。

---

#### 5.1 全量路由图构建

扫描所有已部署 skill 文件，提取路由信息：

**提取方式**（按优先级尝试）：
1. **显式路由表**：搜索 `| (可调用|被调用) |` 模式 → 解析为 `(source, relation, target, scenario)`
2. **隐式调用引用**：搜索 skill 内容中提及的其他 skill 名称（通过斜杠命令 `/skill-name` 或 skill name 直接引用）
3. **主调度路由逻辑**：搜索分诊/路由关键词（如"分诊"、"路由"、"不确定用哪个"、"推荐首选入口"）→ 标记为主调度节点

构建**有向路由图** `G = (V, E)`：
- `V` = 所有已部署 skill 节点
- `E` = 所有路由边（含关系类型和场景描述）

---

#### 5.2 主调度节点自动发现

**不硬编码任何调度器名称**，而是通过以下启发式自动发现：

| 特征 | 权重 | 检测方法 |
|------|------|----------|
| 文档中自称"主调度"/"主入口"/"推荐首选" | 高 | Grep 关键词 |
| 路由表行数 ≥ 5（出度高的 hub 节点） | 中 | 统计关联段行数 |
| CLAUDE.md 入口文档中明确标注为主入口 | 高 | 扫描部署目标的入口文档 |
| 出度远大于入度（扇出型拓扑） | 中 | 图论分析 |

综合评分 ≥ 阈值的节点自动标记为**主调度节点**。

对每个自动发现的主调度，输出：

```markdown
### 主调度节点: <auto-discovered-name>
- 发现依据: [命中特征列表]
- 当前出度: N（路由到 N 个子 skill）
- 当前入度: N（被 N 个 skill 引用）
```

---

#### 5.3 双向一致性检查与自动修复

对图 `G` 中每条边 `A → B`，验证反向边 `B → A` 是否存在：

```
A 声明 "可调用 B" → B 必须有 "被调用于 A"
A 声明 "被调用于 B" → B 必须有 "可调用 A"
```

生成一致性报告：

```markdown
## 路由一致性审计

| From | To | 正向 | 反向 | 状态 |
|------|----|------|------|------|
| ralph | code-debugger | ✅ 可调用 | ✅ 被调用 | OK |
| deep-research | <dispatcher> | ✅ 被调用 | ❌ 缺失 | AUTO-PATCH |
| ... | ... | ... | ... | ORPHAN_REF |
```

**自动修复**：对每个 `AUTO-PATCH`：
- 自动在目标 skill 的「关联 Skill」表中添加缺失的反向行
- **【严格】三平台同步写入** — 对所有已发现平台的版本同时执行
- 写入后立即验证：重新读取确认行已正确插入

---

#### 5.4 子 Skill 逻辑上下文平滑

融合后，同一 skill 可能被来自不同原始 package 的上下文引用。需要确保子 skill 的内部逻辑在新部署环境中对所有调用方都正确。

**分析维度**：

| 维度 | 检查方法 | 修复策略 |
|------|----------|----------|
| 状态文件路径 | 扫描 `STATE.md`、`WORKLOG.md`、`.debug/` 等路径引用 | 统一为系统级部署后的实际路径 |
| 调用方假设 | 分析调用此 skill 的所有上游 skill，检查是否有矛盾的预期 | 合并所有上游的预期，确保子 skill 都能响应 |
| 数据流接口 | 检查 skill 间传递的变量/状态文件格式是否一致 | 如有冲突，标记让用户决定 |
| 条件分支覆盖 | 子 skill 内部可能对不同调用方有不同分支逻辑 | 确保融合后所有分支入口仍然有效 |

**输出子 skill 逻辑分析报告**：

```markdown
## 子 Skill 逻辑上下文分析

### <skill-name>
- 被调用方: [来自 pkg-A 的 skill-X, 来自 pkg-B 的 skill-Y]
- 状态文件引用: docs/STATE.md (pkg-A), WORKLOG.md (pkg-B) → 统一为: <推荐路径>
- 数据流接口: ✅ 一致 / ⚠️ 需确认
- 上下文矛盾: 无 / ⚠️ [描述矛盾]
```

---

#### 5.5 主调度路由网络优化

对每个自动发现的主调度节点，执行网络拓扑优化：

**Step 1 — 覆盖率分析**

统计主调度的路由表覆盖了多少已部署 skill：

```markdown
| 主调度 | 已路由 skill | 未路由 skill | 覆盖率 |
|--------|-------------|-------------|--------|
| <name> | N | M | N/(N+M)% |
```

**Step 2 — 智能建议生成**

对未路由的已部署 skill，通过**多维语义匹配**判断是否应加入路由表：

| 匹配维度 | 权重 | 方法 |
|----------|------|------|
| description 关键词重叠 | 中 | 与主调度的域关键词比较 |
| 已有路由表中 skill 的近邻 | 高 | 如果 B 在路由表中，而 C 的 description 与 B 相似，则 C 可能也相关 |
| 调用图距离 | 高 | 如果 C 已被路由表内某个 skill 调用，则 C 与主调度间接相关（图距离=2） |
| 包来源关联 | 中 | 来自同一 package 的 skill 通常属于同一业务域 |

综合评分 ≥ 阈值的 skill 列入**建议新增**列表。

**Step 3 — 优化建议输出**（仅建议，不自动写入）

```markdown
### 主调度: <name>

| 操作 | Skill | 推荐理由 | 置信度 |
|------|-------|----------|--------|
| 建议新增 | <skill-A> | 图距离=2，经 <routed-skill-B> 间接关联 | 高 |
| 建议新增 | <skill-C> | 同包来源，description 域重叠 | 中 |
| 保持不收录 | <skill-D> | 无关联性证据 | — |
```

---

#### 5.6 孤立引用处理

如果 skill A 引用了 skill B，但 B 不在已部署集合中：
- 标记为 `ORPHAN_REF`
- **不自动删除** — 交由用户决定（保留引用 / 删除引用 / 后续部署 B）

---

#### 5.7 路径引用修复

扫描所有已部署 skill 内容中的路径引用：
- 匹配模式：`workspace/skills/...`、`.claude/skills/...`、`scripts/...`、`references/...`
- 验证引用路径在系统级部署环境中是否可解析
- 无法解析的标记为 `BROKEN_PATH` 并建议修正方案

**Gate 3**: 用户确认以下内容 → 应用补丁
- 双向一致性自动补丁
- 子 skill 逻辑上下文调整
- 主调度路由新增建议（选择性采纳）
- 孤立引用处理方式
- 路径修复方案

---

### Phase 6: 部署报告

输出最终的结构化部署报告：

```markdown
# Skill Deployment Report

**日期**: YYYY-MM-DD HH:MM
**模式**: dry-run / full-deploy

## 环境

| 配置项 | 值 |
|--------|-----|
| 源 Package | [列表] |
| 目标平台 | [列表] |
| 目标路径 | Claude: / Codex: / Gemini: |

## 汇总

| 指标 | 数量 |
|------|------|
| 自动发现 Package 数 | N |
| 总部署 skill 数 | N |
| 融合去重数 | N |
| 直接复制数（Unique） | N |
| 逻辑上下文平滑数 | N |
| 部署 commands 数 | N |
| 部署 agents 数 | N |
| 备份文件数 | N |
| 路由表补丁数 | N |
| 孤立引用数 | N |
| 断裂路径数 | N |

## 逐 Skill 部署详情

| Skill | 来源 Package(s) | 融合策略 | [平台A] | [平台B] | [平台C] |
|-------|-----------------|----------|---------|---------|---------|

## 主调度发现结果

| 主调度 | 发现依据 | 出度 | 入度 | 路由覆盖率 |
|--------|----------|------|------|-----------|

## 路由一致性审计

| From | To | 关系 | 状态 |
|------|----|------|------|

## 子 Skill 逻辑上下文

| Skill | 被调用方 | 状态路径 | 接口一致性 |
|-------|---------|----------|-----------|

## 备份记录

| 文件 | 备份路径 |
|------|----------|

## 警告

- [WARN-ORPHAN] ... — 不在任何 package 中
- [ORPHAN_REF] ... → 引用不存在的 ...
- [BROKEN_PATH] ... 中的路径 ... 无法解析
```

---

## Output Contract

| 产出物 | 格式 | 必须 |
|--------|------|------|
| Master Index（含系统级现状快照） | Markdown 表格 | Yes |
| 重叠分析报告（含 LOGIC_CONTEXT_DIFF） | Markdown 表格 + Diff | Yes |
| Fused Skill Manifest | Markdown 表格 | Yes |
| 部署日志 | 逐行操作记录 | Yes |
| 全量路由图 | 节点 + 边 + 度分析 | Yes |
| 主调度发现报告 | 发现依据 + 拓扑分析 | Yes |
| 子 Skill 逻辑上下文分析 | 多维分析表 | Yes |
| 路由一致性审计 | Markdown 表格 | Yes |
| 最终部署报告 | 完整 Markdown 文档 | Yes |

---

## Guardrails

- **不跳过任何 Gate** — Gate 0~3 必须逐个获得用户确认
- **不静默覆盖** — 系统级已有文件必须先备份再覆盖
- **不删除孤儿** — 目标路径中存在但源中不存在的 skill 仅警告，永不删除
- **【严格】三平台同步** — 路由表补丁必须同时写入所有已发现平台的版本，不可只改一个平台
- **【严格】双向一致性** — 补齐反向引用后必须验证双向都存在
- **【严格】动态发现优先** — 主调度节点、包列表、平台列表全部运行时发现，禁止硬编码
- **主调度建议不自动写入** — 新增路由建议需要用户明确采纳后才应用
- **commit 必须等待用户明确确认** — 不自动提交
- `--dry-run` 模式下不执行任何文件写入操作

---

## 关联 Skill

| 关系 | Skill | 场景 |
|------|-------|------|
| 可调用 | skill-governor | 部署前发现 skill 缺平台文件时触发补齐 |
| 可调用 | loop-engineer | 部署后发现包内联动不完整时触发修复 |
| 被调用 | loop-engineer | Phase 5 完成后可能需要重新审计 package |

---

## Resources

| 文件 | 路径 | 用途 | 何时加载 |
|------|------|------|----------|
| skill-governor | 项目 `.claude/skills/skill-governor.md` | 三平台格式规范 | Phase 3（格式校验） |
| loop-engineer | 项目 `.claude/skills/loop-engineer/SKILL.md` | 关联 Skill 段格式约定 | Phase 5（路由表解析） |
| sync-entry-docs.py | `.claude/skills/loop-engineer/scripts/sync-entry-docs.py` | frontmatter 提取和目录扫描模式参考 | Phase 1 |
| 项目 README | 仓库根 `README.md` | 现有 skill 清单速查 | Phase 1 |
