# 多 Agent 分类部署规则（Agent Deployment Rules）

> VitaForge 的「引导部署原则」并非只为某一个 agent 设计 —— 它是一套**能力分层 + 动态发现**的通用部署哲学。本文把任意一个拿到手上的 AI coding agent，按其**是否具备原生 skill 文件规范**归入三层，并给出每层的具体部署路径、约定文件、触发方式、MCP 配置和降级策略。
>
> **配套入口**：[`README.md` → 🚀 一键部署](../README.md#-一键部署) · [`CONTRIBUTING.md`](../CONTRIBUTING.md) · [`ETHICS.md`](../ETHICS.md)

**版本**：1.0.0 · **维护者**：VitaForge Core · **最后更新**：2026-07-05

---

## §0 · TL;DR — 三层分类一图速查

```
                  你拿到一个 AI coding agent
                            │
                  ┌─────────┴─────────┐
                  │  它有官方 skill    │
                  │  文件格式约定吗？  │
                  └───────┬─────┬─────┘
                          │     │
                  有 ✅   │     │ ❌ 没有
                          │     │
            ┌─────────────┘     └─────────────┐
            ▼                                   ▼
   ╔═══════════════════╗              ╔═══════════════════╗
   ║ Tier A · 原生     ║              ║ Tier B · 通用     ║
   ║ Skill-Agent       ║              ║ Coding-Agent      ║
   ╠═══════════════════╣              ╠═══════════════════╣
   ║ Claude Code       ║              ║ WorkBuddy         ║
   ║ Codex CLI         ║              ║ OpenClaw          ║
   ║ Gemini CLI        ║              ║ Hermes / Hermas   ║
   ║ Antigravity       ║              ║ Aider             ║
   ║ Cursor / Cline *  ║              ║ 任意 LLM CLI      ║
   ╚═══════════════════╝              ╚═══════════════════╝
            │                                   │
            ▼                                   ▼
   三镜像格式化部署                  AGENTS.md + 一句话部署
   + skill-deploy 融合去重           + 主调度 markdown 路由
   + 后平滑（路由双向一致）          + 无 skill 网络（手动维护）

   * Cursor / Cline / Continue 介于 A/B 之间，详见 §4 Tier C
```

> **核心原则**：分类不看品牌名，只看「**是否具备原生 skill 文件规范**」这个稳定的能力特征。品牌会变（Cursor 今天 `.mdc` 明天可能改），但能力特征不变。

---

## §1 · 分类标准（量化判定）

### 1.1 判定五维矩阵

| 维度 | Tier A · 原生 | Tier B · 通用 | Tier C · Hybrid |
|------|:---:|:---:|:---:|
| ① **官方 skill 文件格式** | ✅ 有 | ❌ 无 | ⚠️ 部分（rules 文件） |
| ② **Slash command 触发** | ✅ `/cmd` 或 `$cmd` | ❌ 仅自然语言 | ⚠️ 部分 |
| ③ **Skill 路由网络** | ✅ 主调度 + 路由表 | ❌ 单 AGENTS.md | ⚠️ 单文件 |
| ④ **MCP 原生支持** | ✅ `.mcp.json` | ⚠️ 手动配置 | ✅ / ⚠️ |
| ⑤ **VitaForge deploy 脚本支持** | ✅ `deploy.ps1`/`deploy.sh` | ⚠️ 仅 prompt 兜底 | ⚠️ 需格式转换 |

### 1.2 判定算法

```
def classify(agent):
    score = 0
    if agent.has_native_skill_format:    score += 2   # 维度①（权重最高）
    if agent.supports_slash_command:     score += 1   # 维度②
    if agent.supports_skill_routing:     score += 1   # 维度③
    if agent.supports_mcp_native:        score += 1   # 维度④

    if score >= 4:  return "Tier A · 原生 Skill-Agent"
    if score == 0:  return "Tier B · 通用 Coding-Agent"
    else:           return "Tier C · Hybrid / 边缘"
```

> 简化口诀：**「能不能 `/命令` 触发」是 Tier A 的最直观判据。**

### 1.3 为什么这样分

| 替代方案 | 为什么不采用 |
|----------|--------------|
| 按品牌分层 | 品牌演进快（Cursor 文件格式已迭代多次），维护成本高 |
| 按模型分层 | 同一 agent 可换模型（Claude/国产 LLM），分层会失真 |
| 按收费/开源 | 与部署规则无强相关性，仅作 Tier B 内部备注 |

---

## §2 · Tier A · 原生 Skill-Agent 部署规则

> **核心特征**：有官方 skill/command/agent 文件格式约定，可被结构化命令触发，支持 skill 路由网络。
>
> **部署原则**：**三镜像格式化部署** + `skill-deploy` 融合去重 + 后平滑（路由双向一致性）。

### 2.1 Tier A 总览

| Agent | 部署源 | 系统目标路径 | 触发方式 | MCP 配置 |
|-------|--------|--------------|----------|----------|
| **Claude Code** | `.claude/` | `~/.claude/{skills,commands,agents}/` | `/skill-name` | `~/.claude/.mcp.json` |
| **OpenAI Codex CLI** | `.codex/skills/` | `~/.codex/skills/` + `~/.agents/skills/` | `$skill-name` | `~/.codex/config.toml` |
| **Google Gemini CLI** | `.gemini/skills/` | `~/.gemini/skills/` | 自动匹配 / skill name | `~/.gemini/settings.json` |
| **Google Antigravity** | `.gemini/skills/`（同源） | Antigravity workspace skills 目录 | 自动匹配 / 自然语言 | Antigravity settings |
| **Cursor** | `.cursor/rules/*.mdc` | `.cursor/rules/`（项目级） | 自动激活 / `@rule` | `.cursor/mcp.json` |
| **Cline** | `.clinerules` | `.clinerules`（项目根） | 自动读取 | `.cline/mcp_settings.json` |
| **Continue.dev** | `.continue/rules/*.md` | `.continue/rules/`（项目级） | 自动激活 | `config.yaml` |

> 📌 **跨平台路径规则**：Windows 用 `%USERPROFILE%`，macOS/Linux 用 `$HOME`。脚本内部统一正斜杠。

---

### 2.2 Claude Code（VitaForge 主推）

**为什么主推**：原生 `skills/` + `commands/` + `agents/` 三段式，slash command 触发最直观，MCP 支持最成熟。

**部署路径**：

```
仓库源                                     系统级目标
.claude/skills/        ──deploy──→        ~/.claude/skills/
.claude/commands/      ──deploy──→        ~/.claude/commands/
.claude/agents/        ──deploy──→        ~/.claude/agents/
.claude/scripts/       ──deploy──→        ~/.claude/scripts/
```

**部署命令**：

```powershell
# Windows PowerShell
git clone https://github.com/PancrePal-xiaoyibao/VitaForge.git
cd VitaForge
.\deploy\deploy.ps1 -Yes
# 或在 Claude Code 会话内：
/skill-deploy          # 高级融合去重 + 后平滑（推荐）
```

```bash
# macOS / Linux
git clone https://github.com/PancrePal-xiaoyibao/VitaForge.git
cd VitaForge
./deploy/deploy.sh --yes
```

**触发验证**：

```text
启动 claude 后输入 /vitaforge-orchestrator  应立即可用
```

**MCP 配置**：复制 `deploy/mcp-config.template.json` → `~/.claude/.mcp.json`，详见 [`docs/medical-mcp-servers.md`](./medical-mcp-servers.md)。

---

### 2.3 OpenAI Codex CLI

**部署路径**：

```
仓库源                                     系统级目标
.codex/skills/<name>/SKILL.md  ──deploy──→  ~/.codex/skills/<name>/SKILL.md
                                          + ~/.agents/skills/<name>/SKILL.md  (Codex 通用发现路径)
```

**触发方式**：`$skill-name` 显式触发，或自动匹配（description 命中）。

**部署命令**：同 §2.2（`deploy.ps1`/`deploy.sh` 自动处理 `.codex/skills` → `~/.agents/skills` 映射）。

**入口文档**：[`AGENTS.md`](../AGENTS.md) — Codex CLI 启动时自动读取。

**验证**：

```text
启动 codex 后输入 $vitaforge-orchestrator
```

---

### 2.4 Google Gemini CLI

**部署路径**：

```
仓库源                                     系统级目标
.gemini/skills/<name>/SKILL.md  ──deploy──→  ~/.gemini/skills/<name>/SKILL.md
```

**触发方式**：Gemini 渐进式披露 —— frontmatter（name + description）常驻，全文按需加载。**无 slash command**，靠自然语言匹配。

**进阶**：

```bash
# 批量符号链接（推荐，避免重复复制）
gemini skills link /path/to/VitaForge/.gemini

# 或从 Git 安装
gemini skills install https://github.com/PancrePal-xiaoyibao/VitaForge
```

**入口文档**：[`GEMINI.md`](../GEMINI.md)。

---

### 2.5 Google Antigravity（新增纳入）

> Antigravity 是 Google 2025 年推出的 agentic IDE，基于 Gemini，原生支持 skills 系统。官方 codelab：[Authoring Google Antigravity Skills](https://codelabs.developers.google.com/getting-started-with-antigravity-skills)。

**部署策略**：Antigravity 与 Gemini CLI 共享 skill 源（`.gemini/skills/`），但部署目标为 Antigravity workspace 内的 skills 目录。

**部署路径（示意，以官方文档为准）**：

```
仓库源                                     Antigravity 目标
.gemini/skills/<name>/SKILL.md  ──→      <workspace>/.antigravity/skills/<name>/
                                          （或通过 Antigravity 的 "Add Skill" UI 导入）
```

**触发方式**：自然语言匹配（与 Gemini CLI 一致），Antigravity UI 中可见 skill 列表。

**MCP 配置**：在 Antigravity settings 中添加 MCP server（与 Gemini CLI 配置兼容）。

**降级**：若 Antigravity 暂不支持 `.gemini/skills/` 直读，则把整个 `.gemini/skills/` 目录作为「workspace context」导入，或手动复制 SKILL.md 到 Antigravity 约定路径。

> ⚠️ **注意**：Antigravity 的 skill 格式仍在快速演进。**部署前请核对 [Antigravity 官方文档](https://antigravity.google/) 的最新约定**。本文规则随官方更新同步。

---

### 2.6 Cursor（半专业 · Tier A 边缘）

> Cursor 用 `.cursor/rules/*.mdc`（YAML frontmatter + Markdown），介于原生 skill 和通用 rules 之间。

**部署策略**：把 VitaForge 主调度 skill 转换为 Cursor rules。

**转换模板**（`vitaforge-orchestrator.mdc`）：

```markdown
---
description: VitaForge 主调度 — 医学/生命科学/科研需求分诊路由
globs:
  - "**/*.md"
  - "**/*.R"
  - "**/*.py"
alwaysApply: false
---

# VitaForge Orchestrator（Cursor 适配版）

[此处粘贴 vitaforge-orchestrator.md 的核心路由逻辑，去掉 slash command 语法，
 改为「当用户描述 X 时，建议查阅 Y 文档」的自然语言指令]
```

**部署路径**：

```
.cursor/rules/vitaforge-orchestrator.mdc
.cursor/rules/ai4s-lab.mdc
.cursor/rules/medical-advisory.mdc
...（按需转换核心 skill）
```

**触发**：Cursor 自动按 `globs` 匹配激活，或用户 `@vitaforge-orchestrator` 显式调用。

**MCP 配置**：`.cursor/mcp.json`（格式与 Claude `.mcp.json` 兼容，可互转）。

> 📌 **不必全量转换 28 个 skill**：Cursor 推荐精挑核心 5-10 个 skill 转 rules，其余靠 `AGENTS.md` 索引。

---

### 2.7 Cline / Continue.dev（半专业 · Tier A 边缘）

| Agent | 文件 | 格式 | 触发 |
|-------|------|------|------|
| **Cline** | `.clinerules`（项目根，单文件） | Markdown + headers + bullets | 自动读取，作为 context 注入 |
| **Continue.dev** | `.continue/rules/*.md` | Markdown + YAML frontmatter | 自动激活 |

**部署策略**：把 VitaForge 主调度 + 关联 skill 表浓缩为单文件 rules。

**Cline `.clinerules` 模板**：

```markdown
# VitaForge for Cline

## 项目身份
本仓库为 VitaForge — 医学-生命科学 AI4S 干实验引擎。

## 主调度
当用户描述医学/科研需求时，参考 .codex/skills/vitaforge-orchestrator/SKILL.md
进行分诊路由。可用 skill 清单见 AGENTS.md。

## 核心技能索引
- AI4S 干实验 → .codex/skills/ai4s-dry-lab/
- 循证医学   → .codex/skills/medical-advisory/
- 文献精读   → .codex/skills/paper-reader/
... (按需列出)

## 伦理红线
必须遵守 ETHICS.md。输出为辅助参考，须经专业资质人员验证。
```

**Continue `.continue/rules/vitaforge.md` 模板**：

```markdown
---
description: VitaForge 主调度路由
globs: ["**/*.md", "**/*.R", "**/*.py"]
---

[同 Cline 模板内容]
```

---

## §3 · Tier B · 通用 Coding-Agent 部署规则

> **核心特征**：**无官方 skill 文件格式约定**，仅依赖 `AGENTS.md` + `README.md` 等通用约定文件 + 终端/文件读写权限。
>
> **部署原则**：**一句话部署 prompt** + **AGENTS.md 自动加载** + **主调度 markdown 路由**（无 slash command 网络）。

### 3.1 Tier B 总览

| Agent | 身份 | 接入方式 | skill 网络能力 |
|-------|------|----------|----------------|
| **WorkBuddy** | 通用工作助手（字节系/类似） | AGENTS.md + 一句话部署 | ❌ 无，靠主调度 markdown |
| **OpenClaw** | 开源 Claude 替代 | AGENTS.md + 一句话部署 | ❌ 无 |
| **Hermes / Hermas** | Nous Hermes 模型驱动 agent | AGENTS.md + 一句话部署 | ❌ 无 |
| **Aider** | 开源 pair programming | `.aider.conf.yml` + AGENTS.md | ❌ 无（但支持 conventions） |
| **任意 LLM CLI agent** | 基于 OpenAI/Anthropic/国产 API 的通用 CLI | AGENTS.md + 一句话部署 | ❌ 无 |

> ⚠️ **身份说明**：WorkBuddy / OpenClaw / Hermas 等通用 agent 的精确身份与能力可能随项目演进变化。本节按**能力特征**对号入座 —— 只要它「能读终端 + 能读写文件 + 能加载 AGENTS.md」，就适用本节规则。

### 3.2 通用一句话部署 Prompt（Tier B 黄金模板）

> 把下面这段**完整粘贴**给任意通用 agent（可替换 URL 为你的 fork）：

```text
请把 https://github.com/PancrePal-xiaoyibao/VitaForge 部署到当前用户的本机 Agent 环境。

要求（按顺序执行，每步完成后简报）：

1. 【环境自检】
   - 确认本机有 git 和可用 shell（bash/powershell/zsh 任一）；
   - 确认有读写用户主目录的权限；
   - 如果缺依赖，先明确告诉用户缺什么，不要擅自安装。

2. 【克隆或更新仓库】
   - 克隆到一个合适的本地目录（推荐 ~/VitaForge 或 %USERPROFILE%\VitaForge）；
   - 如果目录已存在且是 Git 仓库，先执行 git pull --ff-only 更新；
   - 如果目录存在但非 Git 仓库，停下来问用户怎么办。

3. 【进入仓库根目录后按系统执行部署脚本】
   - Windows PowerShell:
       powershell -ExecutionPolicy Bypass -File .\deploy\deploy.ps1 -Yes
   - macOS / Linux Bash:
       chmod +x ./deploy/deploy.sh && ./deploy/deploy.sh --yes
   - 脚本会自动合并部署 .claude/.codex/.gemini 到用户主目录，重名文件自动备份。

4. 【如果脚本执行失败，改用手动兜底部署】
   - 复制 .claude/* 到 ~/.claude/
   - 复制 .codex/skills/* 到 ~/.agents/skills/ 和 ~/.codex/skills/
   - 复制 .gemini/skills/* 到 ~/.gemini/skills/
   - 覆盖同名文件前必须先备份（命名为 <file>.vitaforge-bak.<timestamp>）。

5. 【验证部署完成】
   检查至少存在这些入口之一：
   - ~/.agents/skills/vitaforge-orchestrator/
   - ~/.codex/skills/vitaforge-orchestrator/
   - ~/.claude/commands/vitaforge-orchestrator.md
   - ~/.gemini/skills/vitaforge-orchestrator/

6. 【告知结果】
   最后明确告诉我：
   - 实际部署路径
   - 是否发生备份（列出备份文件）
   - 下一步应该用哪个入口启动 VitaForge
   - 如果我是 Tier B 通用 agent（无 slash command），告诉我如何用自然语言
     触发主调度（例如：「请按 AGENTS.md 路由表帮我分诊这个需求：...」）
```

### 3.3 Tier B 的工作模式：AGENTS.md 路由

通用 agent **没有 slash command 网络**，所以 VitaForge 的 skill 路由**退化为 markdown 指令**：

| Tier A 行为 | Tier B 等价行为 |
|-------------|-----------------|
| `/vitaforge-orchestrator <需求>` | 「请按 `AGENTS.md` 的路由表分诊：`<需求>`」 |
| `/ai4s-lab` | 「请加载 `.codex/skills/ai4s-dry-lab/SKILL.md` 并按其 Workflow 执行」 |
| `/medical-advisory` | 「请加载 `.codex/skills/medical-advisory/SKILL.md` 执行循证分析」 |
| `/skill-deploy`（融合去重） | ❌ 不适用 —— Tier B 不需要融合（单一源） |
| 路由后平滑（双向一致） | ❌ 不适用 —— Tier B 路由靠 AGENTS.md 单点 |

**通用 agent 触发主调度的标准话术**：

```text
请先读取仓库根目录的 AGENTS.md，理解 VitaForge 的技能清单和路由逻辑。
我现在需要：<具体需求>。请按 AGENTS.md 的路由表帮我分诊到合适的 skill，
加载对应 .codex/skills/<name>/SKILL.md，并按其 Workflow 执行。
每完成一个大环节停下等我 review。
```

### 3.4 Aider 特殊说明

Aider 支持 `.aider.conf.yml` 和 `CONVENTIONS.md`，部署规则略调整：

```yaml
# .aider.conf.yml（项目根）
read:
  - AGENTS.md
  - ETHICS.md
  - CONTRIBUTING.md
  - .codex/skills/vitaforge-orchestrator/SKILL.md
auto-commits: false   # VitaForge 禁止自动 commit
```

### 3.5 Tier B 降级策略（关键）

通用 agent **必须明确降级路径**，否则用户体验断裂：

| 场景 | 降级方案 |
|------|----------|
| 通用 agent 不会读 `.codex/skills/` 子目录 | 退化为「主调度 AGENTS.md 单文件 + 按需手动粘贴 SKILL.md 内容」 |
| 通用 agent 不支持 MCP | skill 内置降级逻辑（VitaForge 大部分 skill 已支持无 MCP 模式） |
| 通用 agent 不支持并行 agent | `deep-research` 退化为单 agent 串行调研 |
| 通用 agent 模型能力弱（如小模型） | 主调度建议用户改用 `vitaforge-orchestrator` 的「最小路由子集」（仅 AI4S / paper-reader / medical-advisory） |
| 通用 agent 无法 commit/push | 明确告知用户哪些步骤需要人工接管（commit 必须用户授权） |

> 💡 **设计哲学**：Tier B 的部署不是「把 Tier A 的能力砍半」，而是「**用最小约定达成最大复用**」—— 只要 AGENTS.md 在，VitaForge 的方法论就能跑起来。

---

## §4 · Tier C · Hybrid / 边缘情形

> 部分新 IDE agent 支持 `.rules` 类文件但**没有完整 skill 网络**，介于 A/B 之间。处理策略：**优先按 Tier B 部署（AGENTS.md）+ 按需转 Tier A 边缘格式（rules 文件）**。

| Agent | 文件约定 | 推荐部署 |
|-------|----------|----------|
| **Windsurf** | `.windsurfrules`（项目根，单文件） | Tier B + 转单文件 rules |
| **Trae / 通义灵码** | `.trae/rules/` 或项目 rules | Tier B + 按需转 |
| **GitHub Copilot** | `.github/copilot-instructions.md` | Tier B（浓缩主调度到该文件） |
| **JetBrains AI** | `.junie/guidelines.md` | Tier B |

**统一策略**：把 VitaForge 主调度的「路由表 + 核心技能索引 + 伦理红线」浓缩为单文件 `<约定文件>`，其余 skill 靠 `AGENTS.md` 索引按需加载。

---

## §5 · 跨 Tier 治理原则（必须一致）

无论 agent 属于哪一层，以下铁律**不可降级**：

| 治理项 | Tier A | Tier B | Tier C | 来源 |
|--------|:---:|:---:|:---:|------|
| **三镜像同步** | ✅ 强制 | N/A（单源） | ⚠️ 仅 rules | CONTRIBUTING.md |
| **ETHICS.md 医学红线** | ✅ 强制 | ✅ 强制 | ✅ 强制 | ETHICS.md |
| **BSL 1.1 商业边界** | ✅ 强制 | ✅ 强制 | ✅ 强制 | LICENSE |
| **AGENTS.md 单点真相** | ✅ 推荐同步 | ✅ 强制 | ✅ 强制 | 行业标准 |
| **commit 必须用户授权** | ✅ 强制 | ✅ 强制 | ✅ 强制 | skill-deploy Guardrails |
| **临床数据脱敏** | ✅ 强制 | ✅ 强制 | ✅ 强制 | ETHICS.md |

> ⚠️ **特别注意**：通用 agent（Tier B）容易在「无 skill 网络」情况下**绕过 ETHICS 约束**（因为没有 skill frontmatter 强制注入）。部署时**必须在 AGENTS.md 顶部强制写入 ETHICS 引用**，确保任何 agent 启动时第一眼看到伦理红线。

---

## §6 · 决策树：你的 agent 属于哪一层？

```
                    你的 agent 是什么？
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
   能用 /command         只能自然语言         有 .rules 文件
   或 $command 触发      交互                但无 slash cmd
        │                   │                   │
        ▼                   ▼                   ▼
   ┌─────────┐         ┌─────────┐         ┌─────────┐
   │ Tier A  │         │ Tier B  │         │ Tier C  │
   │ 原生    │         │ 通用    │         │ Hybrid  │
   └────┬────┘         └────┬────┘         └────┬────┘
        │                   │                   │
        ▼                   ▼                   ▼
   走 §2 部署         走 §3 一句话         走 §4 rules
   + skill-deploy     prompt 部署          转换 + AGENTS.md
```

### 6.1 快速对照表

| 你的 agent | 所属 Tier | 跳转 |
|------------|:---------:|------|
| Claude Code | A | §2.2 |
| OpenAI Codex CLI | A | §2.3 |
| Google Gemini CLI | A | §2.4 |
| Google Antigravity | A | §2.5 |
| Cursor | A（边缘） | §2.6 |
| Cline | A（边缘） | §2.7 |
| Continue.dev | A（边缘） | §2.7 |
| WorkBuddy | B | §3 |
| OpenClaw | B | §3 |
| Hermes / Hermas | B | §3 |
| Aider | B | §3.4 |
| Windsurf | C | §4 |
| Trae / 通义灵码 | C | §4 |
| GitHub Copilot | C | §4 |
| JetBrains AI / Junie | C | §4 |
| 其他未知 agent | 走 §1 判定算法 | §1.2 |

---

## §7 · 故障兜底与回滚

### 7.1 部署失败的分级兜底

```
Level 1: deploy 脚本成功 → 直接使用
   ↓ 失败
Level 2: 手动复制 .claude/.codex/.gemini → 三镜像路径
   ↓ 失败（如权限不足）
Level 3: 仅克隆仓库 + AGENTS.md 模式 → Tier B 降级运行
   ↓ 失败（如无 git）
Level 4: 下载 ZIP + 手动放置 AGENTS.md → 最小可用
```

### 7.2 回滚

VitaForge 部署脚本**所有覆盖操作都先备份**（`<file>.vitaforge-bak.<timestamp>`），回滚方法：

```bash
# 找到备份文件
ls ~/.claude/skills/*.vitaforge-bak.* 2>/dev/null

# 恢复（示例）
mv ~/.claude/skills/some-skill.md.vitaforge-bak.20260705120000 \
   ~/.claude/skills/some-skill.md
```

### 7.3 常见问题（FAQ）

| 问题 | 解法 |
|------|------|
| 通用 agent 不认识 `.codex/skills/` | 让它读 `AGENTS.md`，按需粘贴 SKILL.md 内容 |
| Antigravity 找不到 skill | 核对 [官方文档](https://antigravity.google/) 最新路径约定 |
| Cursor 转换后 rule 不生效 | 检查 `.mdc` 的 `globs` 是否匹配你的工作文件 |
| 国产 LLM agent 能力弱 | 用 `vitaforge-orchestrator` 最小路由子集（AI4S + paper-reader + medical-advisory） |
| MCP 配置失败 | skill 内置降级逻辑，可无 MCP 运行（详见各 skill 的 Guardrails 段） |

---

## §8 · 参考

### 8.1 内部文档
- [`README.md`](../README.md) — VitaForge 总入口
- [`CONTRIBUTING.md`](../CONTRIBUTING.md) — 三镜像同步铁律
- [`AGENTS.md`](../AGENTS.md) — Codex CLI 入口（Tier B 通用 agent 也用这个）
- [`CLAUDE.md`](../CLAUDE.md) — Claude Code 入口
- [`GEMINI.md`](../GEMINI.md) — Gemini CLI 入口
- [`ETHICS.md`](../ETHICS.md) — 医学/AI 伦理红线
- [`docs/medical-mcp-servers.md`](./medical-mcp-servers.md) — MCP 配置详解

### 8.2 外部参考（各 agent 官方）
- **Antigravity Skills**: <https://codelabs.developers.google.com/getting-started-with-antigravity-skills>
- **Antigravity 官网**: <https://antigravity.google/>
- **Cursor Rules**: <https://docs.cursor.com/context/rules>
- **Cline Rules**: <https://docs.cline.bot/customization/cline-rules>
- **Continue Rules**: <https://docs.continue.dev/customize/rules>
- **Aider Config**: <https://aider.chat/docs/config/aider_conf.html>
- **AGENTS.md 标准**: <https://agents.md/>

### 8.3 部署脚本
- [`deploy/deploy.ps1`](../deploy/deploy.ps1) — Windows 一键部署
- [`deploy/deploy.sh`](../deploy/deploy.sh) — macOS/Linux 一键部署
- [`deploy/mcp-config.template.json`](../deploy/mcp-config.template.json) — MCP 配置模板

---

## §9 · 维护约定

- **新增 agent**：在 §6.1 对照表加一行 + 在对应 Tier 小节加部署规则小节
- **格式变更**：若某 agent（如 Antigravity）的官方格式迭代，**更新对应小节并标注日期**
- **分类标准演进**：§1 判定算法是稳定锚点，慎改
- **三镜像同步**：本文档变更时同步更新 `README.md` 的部署章节摘要

> 维护者 PR 请走 [`CONTRIBUTING.md`](../CONTRIBUTING.md) 的标准流程，分支命名 `docs/agent-deploy-*`。

---

<div align="center">

**让任意 agent 都能点燃 VitaForge 的双螺旋喵～** (´｡• ᵕ •｡`) ♡

_分类不看品牌，看能力。部署不靠硬编码，靠动态发现。_

</div>
