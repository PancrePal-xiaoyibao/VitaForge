<div align="center">

<img src="./docs/assets/brand/vitaforge-hero-light.png" alt="VitaForge bright AI4S biomedical innovation hero banner" width="100%" />

<br />
<br />

<img src="./docs/assets/brand/vitaforge-logo-light.png" alt="VitaForge logo" width="118" />

# 🧬 VitaForge

### 面向医学与生命科学的 AI4S 干实验引擎

**_Forge your AI scientist. From single cell to bedside._**

<p>
  <a href="./LICENSE"><img src="https://img.shields.io/badge/License-BSL%201.1-blue.svg" alt="License: BSL 1.1" /></a>
  <a href="./ETHICS.md"><img src="https://img.shields.io/badge/Ethics-Medical%20%26%20AI%20Responsible-red.svg" alt="Ethics" /></a>
  <a href="#-一键部署"><img src="https://img.shields.io/badge/Platforms-Claude%20%7C%20Codex%20%7C%20Gemini-green.svg" alt="Platforms" /></a>
  <a href="#-技能矩阵"><img src="https://img.shields.io/badge/Skills-28%20%2B%20orchestrator-orange.svg" alt="Skills" /></a>
  <a href="#-一键部署"><img src="https://img.shields.io/badge/Deploy-One--Click-success.svg" alt="One-Click Deploy" /></a>
  <img src="https://img.shields.io/badge/中文-友好-brightgreen.svg" alt="中文友好" />
</p>

<p>
  <b>AI4S Dry Lab Engine</b> · <b>scRNA-seq Workflow</b> · <b>Evidence Medicine</b> · <b>Research-to-Publication OS</b>
</p>

<table>
  <tr>
    <td align="center"><b>SPEC + OODA</b><br /><sub>从模糊问题到可执行研究闭环</sub></td>
    <td align="center"><b>Single Cell → Bedside</b><br /><sub>测序分析、文献证据与临床语境贯通</sub></td>
    <td align="center"><b>28 Skills + Orchestrator</b><br /><sub>Claude / Codex / Gemini 三平台部署</sub></td>
    <td align="center"><b>BSL + Ethics</b><br /><sub>面向商业化的责任边界与授权模型</sub></td>
  </tr>
</table>

<p>
  <a href="#-一键部署"><b>🚀 一键部署</b></a>
  ·
  <a href="#-技能矩阵"><b>查看技能矩阵</b></a>
  ·
  <a href="./docs/medical-mcp-servers.md"><b>配置医学 MCP</b></a>
  ·
  <a href="./CONTRIBUTING.md"><b>参与共建</b></a>
</p>

<p>
  <sub><b>Vita</b> = life. <b>Forge</b> = the workshop. VitaForge turns a blank coding agent into a biomedical AI research cockpit.</sub>
</p>

</div>

---

## 📖 这是什么

**VitaForge** 是一个**一键部署的后平滑技能包**：把 28 个精心编排的 AI skill 融合去重，覆盖医学-生命科学 AI4S 的**全研究生命周期** —— 从测序数据到论文发表，从循证医学到基金申请。

> 空白的 Claude Code / Codex / Gemini 环境，`git clone` 后一条命令秒变医学-生命科学专家。

这不是一个普通的 prompt 集合。VitaForge 内置：

- 🧬 **AI4S 干实验引擎** — SPEC 驱动 + OODA 循环 + Gate 门控 + 强制 Worklog 的端到端研究自动化
- 🔬 **scRNA-seq 全流程** — 从 CellRanger 输出到细胞通讯的 8-Phase 标准化 pipeline，硬件感知 + AI 自动注释
- 🩺 **循证医学 + 中医** — 实时调用顶级医学数据库的私人医疗顾问
- 📚 **科研闭环** — 文献调研 → 实验分析 → 图表叙事 → 论文写作 → 期刊投稿 → 参考文献定稿
- 🤖 **自进化社区** — Agent 能自己优化 skill 并给仓库提 PR

---

## 💡 为什么需要 VitaForge

医学与生命科学的干实验研究者，每天在重复劳动上消耗大量精力：

| 痛点 | VitaForge 的解法 |
|------|-----------------|
| 🧪 scRNA-seq pipeline 各实验室各写一套，难复现 | `scrna-bindlab-full-workflow` — 8 Phase 标准化 + 硬件感知调度 |
| 📚 文献读不完、综述写不出 | `deep-research` 多 agent 并行 + `paper-reader` 批判性精读 |
| 🎨 图表做出来不会讲故事 | `dr-midas` 科研炼金术士（但可被你「调教」得更克制，见[社区闭环](#-让-agent-优化-skill-并提-pr)） |
| 📝 论文写作 AI 味太重 | `thesis-writing-mentor` RAG 风格模仿 + 去 AI 化 + 盲审模拟 |
| 📬 选刊、投稿、审稿回复一团乱 | `sci-journal-submission-expert` 全流程专家 |
| 💰 国自然基金本子写不好 | `nsfc-proposal-advisor` 资深评审视角辅导 |
| 🩺 病情复杂、循证证据难找 | `medical-advisory` 循证 + 中医整体观 |
| 🐛 R/Python 生信脚本 debug 难 | `code-debugger` + `code-review` + `codebase-context` 工程底座 |

---

## ✨ 核心特性

- **🎯 一键部署** — 仓库本身就是部署单元，`git clone` + 一条命令，三平台（Claude/Codex/Gemini）全就位
- **🌐 三镜像同步** — 每个 skill 在 `.claude/` `.codex/` `.gemini/` 三平台保持一致
- **🔀 后平滑网络** — skill 间通过有向网络协议互调，主调度 `vitaforge-orchestrator` 全局路由
- **🛡️ 伦理与商业化平衡** — BSL 1.1 保留未来商业化权力 + ETHICS.md 医学伦理红线
- **🤝 社区自进化** — Agent 可自我优化 skill 并贡献 PR（[Dr Midas 案例](#-让-agent-优化-skill-并提-pr)）

---

## 🌱 研究者 15 分钟第一次 AI4S 贡献

> **从"写代码不熟"到"给公益社区 PR 一份研究方案/SOP/pipeline"，一杯咖啡的时间搞定喵～** (´｡• ᵕ •｡`) ♡
>
> **谁适合走这条路径**：医学生 · 研究生小白 · 临床医生 · 专科护士 · 生信新手 · 想把 AI4S 方法学扩散给师弟师妹的 PI。

### 🗺️ 完整链路（一图看懂）

```
 ①小胰宝社区总入口     ②挑一个研究方向        ③开 Codespace / 本地   ④一句话部署 VitaForge
 ─────────────────  ──────────────────  ──────────────────  ──────────────────
  PancrePal Projects   单细胞/循证/病例     浏览器里的 VS Code       (贴部署 prompt)
        │                    │                     │                        │
        ▼                    ▼                     ▼                        ▼
 ⑧提 PR / 传播        ⑦Agent 沉淀成果-        ⑥一句话跑通            ⑤挂上医学 MCP
 ─────────────────  写方案-出图-成稿          AI4S 全流程          PubMed / OpenAlex
   gh pr create        (OODA + Gate 门控)      (SPEC → 分析 → 图 → 稿)   / KnowS
```

---

### Step 1 · 到社区总入口挑一个"研究方向"

📌 **官方 Project 面板**：<https://github.com/orgs/PancrePal-xiaoyibao/projects>

新手推荐从下面这些方向开始（每个方向都有对应的社区仓库或 issue 可以贡献）：

<details>
<summary><b>🔬 单细胞 & 空间组学方向（scRNA-seq / ST）</b></summary>

- 用 `/scrna-bindlab-full-workflow` 跑通一个公共数据集（GEO / CellxGene），把 QC → 聚类 → 注释 → 通讯的**完整分析日志**沉淀为 markdown 报告
- 用 `/scrna-celltype-annotation` 做一个专属癌种（胰腺癌 / 乳腺癌 / 淋巴瘤）的**细胞类型注释库**，PR 到相关子项目
- 对接 [openpancan](https://github.com/PancrePal-xiaoyibao/openpancan) 的 TCGA-PAAD / GTEx Phase，把某个基因的表达谱补齐

</details>

<details>
<summary><b>🩺 临床医生 & 专科护士方向（循证 / 病例 / 患者管理）</b></summary>

- 用 `/medical-advisory` + `/deep-research` 分析一个**匿名化复杂病例**，产出循证 + 中医整体观的双视角报告，PR 到 [opencare-skillhub](https://github.com/opencare-skillhub)
- 用 `/paper-reader` 精读 3-5 篇本专科最新 guideline，输出**结构化知识卡片**贡献到病情管理知识库
- 把您专科的**并发症管理 SOP** 沉淀为 skill / 知识库，让 AI 助手能回答专业问题

</details>

<details>
<summary><b>📚 医学生 & 研究生方向（文献 / 综述 / 开题）</b></summary>

- 用 `/deep-research` 做一次**跨学科文献扫描**，用 `/paper-reader` 精读关键文献，输出综述草稿 → PR 到相关项目 Wiki
- 用 `/thesis-writing-mentor` 走一遍**去 AI 化 + 盲审模拟**流程，把您学位论文的经验总结成一份"避坑指南"
- 用 `/extract` 从您已读的高分文献里反向提取**研究方法论**，让方法学在社区扩散

</details>

<details>
<summary><b>💰 PI & 高年资医生方向（基金 / 立项 / 教学）</b></summary>

- 用 `/nsfc-proposal-advisor` 走一遍破题 → 立项依据 → 预算的**完整辅导流程**，把您的经验（哪些坑要避、哪些创新点评审爱看）沉淀成教学 case
- 带您的研究生用 VitaForge 走一遍完整流程，作为**实验室 AI4S 上手 SOP** 提交 PR
- 优化 VitaForge 本身：您觉得哪个 skill 不好用？直接用 `/skill-governor` 迭代它

</details>

**认领方向**：在对应 issue 下评论 `我想沿 <方向> 做一份 AI4S 贡献，预计 X 天内提 PR`，或在项目讨论区发帖开新话题。

---

### Step 2 · 打开目标项目仓库，进入 Codespace

以 [VitaForge](https://github.com/PancrePal-xiaoyibao/VitaForge) 或您想贡献的目标仓库为例：

1. 打开仓库主页
2. **右上角 `<> Code` 按钮 → `Codespaces` 标签页 → `Create codespace on main`**
3. 等 30 秒–2 分钟，浏览器里就打开一个完整的 VS Code。

> 💡 **每个 GitHub 账号有 60 小时/月免费 Codespace 额度**，日常研究小任务足够。用完记得关闭，不然会继续计时。
>
> 🖥️ **有本地 R/Python + conda 环境的师兄师姐**：直接 `git clone` 到本地就行，Codespace 只是给"不想折腾环境"的师弟师妹准备的。

---

### Step 3 · 在 Codespace / 本地装一个 AI CLI

终端里选一个安装（**任选其一**）：

```bash
# 选项 A：Claude Code（推荐）
npm install -g @anthropic-ai/claude-code && claude

# 选项 B：OpenAI Codex CLI
npm install -g @openai/codex && codex

# 选项 C：Google Gemini CLI
npm install -g @google/gemini-cli && gemini
```

首次运行会提示登录 / 贴 API Key。

> [!IMPORTANT]
> **🇨🇳 国内医学院 / 医院开发者**：如果无法访问 Anthropic 官方 API，可以走国产大模型（**智谱 GLM-5.2**、**DeepSeek**、**Kimi**、**小米 MiMo**、**硅基流动**），配置方法与 CodeForge 完全一致，详见 [CodeForge 国内 API 指南](https://github.com/PancrePal-xiaoyibao/CodeForge/blob/main/docs/cn-api-providers.md)。GLM-5.2[1m] / DeepSeek-V4-Pro / Kimi-K2.7-Code 都能顺畅驱动 VitaForge 全流程 skill。

---

### Step 4 · 一句话部署 VitaForge

**在 Agent 会话里，把下面这段完整贴进去**（也见上方 `🚀 一键部署 · 方式零`）：

```text
请把 https://github.com/PancrePal-xiaoyibao/VitaForge 部署到当前用户的本机 Agent 环境。
详细步骤见 README「🚀 一键部署」章节。
```

部署完成后，`/vitaforge-orchestrator` `/ai4s-lab` `/scrna-bindlab-full-workflow` `/medical-advisory` `/nsfc-proposal-advisor` 等 28+ 命令立即可用。**推荐同时挂上医学 MCP**（PubMed / OpenAlex / KnowS / 秘塔），详见 [`docs/medical-mcp-servers.md`](./docs/medical-mcp-servers.md)。

---

### Step 5 · 一句话让 Agent 完成 AI4S 全流程 & 沉淀成果

**把下面这段贴给 Agent**（把 `<方向>` `<数据集/病例/文献>` `<目标仓库>` 换成 Step 1 认领的内容）：

```text
请遵循 VitaForge 方法论，完成一次开源研究贡献闭环：

方向: <单细胞分析 / 循证病例 / 文献综述 / 基金开题 / …>
数据源: <GEO 编号 / 病例摘要 / 文献主题 / …>
目标仓库: <PancrePal-xiaoyibao/xxx>

工作流(必须按顺序执行,每个环节完成后简报进度):

【一、SPEC 起草】
1. 跑 /vitaforge-orchestrator,让主调度识别所处研究阶段并路由。
2. 跑 /ai4s-lab 建立项目 SPEC(研究问题 / 假设 / 方法 / 输出物),
   写到 docs/spec/<slug>.md,先展示给我确认。

【二、文献 & 证据补齐】
3. 跑 /deep-research 做主题相关的多 agent 并行调研,保留引用。
4. 跑 /paper-reader 精读 top 3-5 篇关键文献,输出批判性精读报告。
5. 若涉及临床决策,跑 /medical-advisory 补循证支持;
   若涉及 PubMed 检索,用 pubmed-linker 更新 PMID/DOI。

【三、分析 / 写作 / 图表】
6. 按 SPEC 执行具体分析:
   - scRNA-seq 项目走 /scrna-bindlab-full-workflow (8 Phase)
   - 细胞注释走 /scrna-celltype-annotation
   - 图表叙事走 /midas (Dr. Midas,注意克制口吻)
   - 论文草稿走 /thesis-writing-mentor(去 AI 化 + 盲审模拟)
   - SCI 投稿准备走 /sci-journal-submission-expert
   - 基金本子走 /nsfc-proposal-advisor
7. 每完成一个大 Phase,强制写入 worklog(W1)+ 输出目录 README(W2)
   + 数据/文献验证(W3)+ 脚本日志(W4),这是 AI4S 方法论的强制门控。

【四、沉淀 & 贡献】
8. 把研究方案 / SOP / 分析日志 / 图表脚本 / 论文草稿整理到目标仓库
   合适位置(通常是 docs/ 或 experiments/<日期>-<slug>/)。
9. 用 conventional commit 提交:
   docs(<scope>): <一句话> / feat(<scope>): <一句话>
   commit message 末尾附:
     Contributed via VitaForge (ai4s-lab + deep-research + ...)
     Related: <issue link>
10. git push 到我的 fork 分支。
11. 用 gh pr create 开 PR,标题按 conventional commit,body 使用
    VitaForge 研究贡献模板,必填「AI 辅助披露」段,列出用到的 skill。
12. 在原 issue 下 gh issue comment,贴 PR 链接,@ 相关维护者请求 review。

【硬性约束】
- 每个大环节(SPEC、文献、每个 Phase、提交)必须停下等我 review。
- commit / push / 开 PR 前必须获得我的明确「continue」授权。
- 涉及临床数据:必须先脱敏,禁传真实患者可识别信息。
- 遵守本仓库(以及被贡献项目)的 LICENSE 与 ETHICS 要求。
```

**Agent 会一边工作一边简报**。您只需要：
- 看 SPEC 阶段,觉得靠谱说 `continue`
- 看每个 Phase 的 worklog,觉得靠谱说 `continue`
- commit / push / 开 PR 前,看一遍最终改动,说 `continue` 完成闭环

---

### Step 6 · 传播 · 让微光成炬

**做完一次贡献,顺手把经验扩散出去,是 VitaForge 最珍贵的部分喵～** ヽ(✿ﾟ▽ﾟ)ノ

- 📝 **写一篇教学 issue**:把您这次贡献的完整对话截图 + 踩坑记录发到目标仓库的 Discussions,标题类似「新手 X 天用 VitaForge 完成 <方向> 贡献 · 完整回放」
- 🎥 **录一段 15 分钟教学视频**:发 B 站 / YouTube / 医学院公众号,让您专科的同事 / 师弟师妹 15 分钟看会
- 👥 **拉师弟师妹入群 & 认领 issue**:您走通的方向,让下一个人接力,团队的 AI4S 能力就复制起来了
- 🔄 **迭代 VitaForge 本身**:发现某个 skill 不好用?直接用 `/skill-governor` 优化 + 三镜像同步 + 提 PR 到 VitaForge 仓库(见下方 [🤖 让 Agent 优化 Skill 并提 PR](#-让-agent-优化-skill-并提-pr))
- ✍️ **署名 & 学术引用**:您的贡献进入了社区,别忘了在自己的论文 / 论文致谢 / 学位论文中引用 VitaForge / 小胰宝社区,让开源公益 AI4S 得到应有的学术认可

> **一个人跑通全流程是"完成任务";带 3 个人一起跑通,才是"AI4S 方法学的复制"。** VitaForge 的目标从来不是替代研究者,而是**让专业能力可复制、可扩散、可沉淀**。

---

## 🚀 一键部署

VitaForge 的部署哲学是 **「能力分层 + 动态发现」** —— 不是只为某一个 agent 设计，而是按 agent **是否具备原生 skill 文件规范**分为三层。先对号入座，再选部署方式：

### 📊 第一步：你的 Agent 属于哪一层？

| Tier | 能力特征 | 代表 Agent | 部署方式 |
|:----:|----------|------------|----------|
| **A · 原生 Skill-Agent** | 有官方 skill 文件格式，可用 `/command` 或 `$command` 触发，支持 skill 路由网络 | **Claude Code** · **OpenAI Codex CLI** · **Google Gemini CLI** · **Google Antigravity** · Cursor · Cline · Continue | 三镜像格式化部署 + `skill-deploy` 融合去重 + 后平滑 |
| **B · 通用 Coding-Agent** | 无原生 skill 规范，仅依赖 `AGENTS.md` + 终端/文件权限 | **WorkBuddy** · **OpenClaw** · **Hermes / Hermas** · **Aider** · 各类 LLM CLI agent | 一句话部署 prompt + AGENTS.md 自动加载 + 主调度 markdown 路由 |
| **C · Hybrid / 边缘** | 支持 `.rules` 类文件但无完整 skill 网络 | Windsurf · Trae / 通义灵码 · GitHub Copilot · JetBrains AI | Tier B 为主 + 按需转 rules 文件 |

> 📖 **详细分类标准、判定算法、每个 agent 的部署路径/MCP/降级策略** → 见 [`docs/agent-deployment-rules.md`](./docs/agent-deployment-rules.md)
>
> 简化口诀：**「能不能用 `/命令` 触发」是 Tier A 的最直观判据。**

---

> 🎯 **怎么用本节**：找到你正在用的 agent（在 🅰️ 区或 🅱️ 区），照抄对应小节的 4 步命令即可。每个 agent 都有独立的【安装 → 部署 VitaForge → 验证 → 触发示例】。

---

## 🅰️ Tier A 区 · 原生 Skill-Agent（专业 · 有官方 skill 规范 · 可 `/命令` 触发）

> **特点**：原生支持 `skills/commands/agents` 文件格式，slash command 触发，MCP 原生支持，三镜像融合部署 + 路由后平滑。
> **代表**：Claude Code · Codex CLI · Gemini CLI · Antigravity · Cursor · Cline · Continue

### A1 · Claude Code ⭐（主推 · 体验最佳）

**① 安装 Claude Code**：

```bash
npm install -g @anthropic-ai/claude-code
```

**② 克隆并部署 VitaForge**：

```bash
git clone https://github.com/PancrePal-xiaoyibao/VitaForge.git
cd VitaForge
claude
```

进入 Claude Code 会话后，输入：

```text
/skill-deploy
```

> `/skill-deploy` 会一键融合去重部署到 `~/.claude/`、`~/.codex/`、`~/.gemini/`，并执行路由双向一致性后平滑。也可改用跨平台脚本：`.\deploy\deploy.ps1 -Yes`（Win）/ `./deploy/deploy.sh --yes`（Mac/Linux）。

**③ 验证部署成功**：

```text
/vitaforge-orchestrator
```

能弹出主调度说明 ✅。

**④ 触发示例**：

```text
/vitaforge-orchestrator  我要做一批 scRNA-seq 分析，从数据到投稿
```

---

### A2 · OpenAI Codex CLI

**① 安装**：

```bash
npm install -g @openai/codex
```

**② 克隆并部署 VitaForge**：

```bash
git clone https://github.com/PancrePal-xiaoyibao/VitaForge.git
cd VitaForge

# Windows PowerShell
.\deploy\deploy.ps1 -Yes

# macOS / Linux Bash
./deploy/deploy.sh --yes
```

> 脚本会自动复制 `.codex/skills/*` → `~/.codex/skills/` + `~/.agents/skills/`（Codex 双路径发现）。

**③ 验证**：

```bash
codex
# 进入会话后输入：
$vitaforge-orchestrator
```

**④ 触发语法**：`$skill-name`（Codex 用美元符号触发）

---

### A3 · Google Gemini CLI

**① 安装**：

```bash
npm install -g @google/gemini-cli
```

**② 克隆并部署 VitaForge**（任选一种）：

```bash
git clone https://github.com/PancrePal-xiaoyibao/VitaForge.git
cd VitaForge

# 方式一：批量符号链接（推荐，零拷贝，源码更新自动生效）
gemini skills link "$PWD/.gemini"

# 方式二：复制部署
# Windows:  .\deploy\deploy.ps1 -Yes
# Mac/Linux: ./deploy/deploy.sh --yes

# 方式三：从 Git 安装
gemini skills install https://github.com/PancrePal-xiaoyibao/VitaForge
```

**③ 验证**：

```bash
gemini
# 描述需求，Gemini 渐进式披露自动匹配对应 skill
```

**④ 触发语法**：自然语言匹配（无 slash command），靠 skill description 命中

---

### A4 · Google Antigravity

**① 安装**：从 <https://antigravity.google/> 下载 Antigravity IDE

**② 部署 VitaForge**：

```bash
git clone https://github.com/PancrePal-xiaoyibao/VitaForge.git
```

然后在 Antigravity IDE 内：

- 打开 **Settings → Skills**
- 点 **Add Skill** → 选择 VitaForge 仓库的 `.gemini/skills/` 目录（或通过 **Add Skill from Git** 直接导入仓库 URL）

**③ 验证**：Antigravity skill 列表中应出现 `vitaforge-orchestrator`

**④ 触发语法**：自然语言匹配（与 Gemini CLI 一致）

> ⚠️ Antigravity skill 格式仍在快速演进，**部署前请核对** [官方 Skills Codelab](https://codelabs.developers.google.com/getting-started-with-antigravity-skills) 的最新约定。

---

### A5 · Cursor / Cline / Continue（半专业 · Tier A 边缘）

这三个 IDE agent 各有 rules 文件格式，需要**把 VitaForge skill 转换为对应格式**：

| Agent | 文件位置 | 转换方式 |
|-------|----------|----------|
| **Cursor** | `.cursor/rules/vitaforge-orchestrator.mdc` | 主调度 SKILL.md → `.mdc`（YAML frontmatter + Markdown，附 `globs` 匹配规则） |
| **Cline** | `.clinerules`（项目根单文件） | 浓缩主调度 + 技能索引 + 伦理红线为单文件 |
| **Continue** | `.continue/rules/vitaforge.md` | 转 `.md` + YAML frontmatter |

> 📋 完整转换模板（含可直接复制的 `.mdc` / `.clinerules` 范例）见 [`docs/agent-deployment-rules.md` §2.6-2.7](./docs/agent-deployment-rules.md#26-cursor半专业--tier-a-边缘)

---

## 🅱️ Tier B 区 · 通用 Coding-Agent（无原生 skill 规范 · 靠 AGENTS.md + 终端）

> **特点**：**没有 slash command 网络**，靠 `AGENTS.md` 自动加载 + 一句话部署 prompt 工作。VitaForge 的 skill 路由在此退化为 markdown 指令。
> **代表**：OpenClaw · WorkBuddy · Hermes / Hermas · Aider · 任意 LLM CLI agent

> 💡 **关键**：所有 Tier B agent **共用同一段部署 prompt**，区别只在「触发主调度的话术」。先看 B1 学会模板，B2-B4 直接套用。

### B1 · OpenClaw（Tier B 模板示例）

**① 安装 OpenClaw**：见 [OpenClaw 官方 Onboard](https://github.com/openclaw/openclaw)

**② 部署 VitaForge**（在 OpenClaw 工作区粘贴下面这段）：

```text
请把 https://github.com/PancrePal-xiaoyibao/VitaForge 部署到当前用户的本机。

要求（按顺序执行，每步完成后简报）：
1. 确认本机有 git 和可用 shell；缺依赖请明确说明，不要擅自安装。
2. git clone 仓库到 ~/VitaForge（已存在则 git pull --ff-only 更新）。
3. 进入仓库根目录，按系统执行部署脚本：
   - Windows PowerShell: .\deploy\deploy.ps1 -Yes
   - macOS / Linux Bash: ./deploy/deploy.sh --yes
4. 脚本失败则手动兜底：复制 .codex/skills/* 到 ~/.agents/skills/，
   复制 .gemini/skills/* 到 ~/.gemini/skills/，覆盖前先备份。
5. 验证 ~/.agents/skills/vitaforge-orchestrator/ 存在。
6. 告诉我部署路径、是否备份、下一步如何用自然语言触发主调度。
```

**③ 验证**：

```bash
ls ~/.agents/skills/vitaforge-orchestrator/   # 应存在 SKILL.md
```

**④ 触发主调度**（这是 Tier B 的核心话术，记住它）：

```text
请先读取 ~/VitaForge/AGENTS.md，理解 VitaForge 的技能清单和路由逻辑。
我现在需要：<具体需求>。
请按 AGENTS.md 路由表分诊，加载对应 .codex/skills/<name>/SKILL.md 并执行。
每完成一个大环节停下等我 review。
```

---

### B2 · WorkBuddy

**① 安装**：见 WorkBuddy 官方文档

**② 部署 VitaForge**：直接粘贴 **B1 第 ② 步** 的部署 prompt（命令完全通用）

**③ 验证**：同 B1 第 ③ 步

**④ 触发主调度**：粘贴 **B1 第 ④ 步** 的触发话术

> 💡 WorkBuddy 与 OpenClaw 同属通用 agent，**部署命令 100% 通用**，区别仅在底层 LLM 和工作区 UI。

---

### B3 · Hermes / Hermas

**① 安装**：按 Hermes 模型发行版官方说明安装

**② 部署 VitaForge**：粘贴 **B1 第 ② 步** 的部署 prompt

**③ 验证 + ④ 触发**：同 B1

---

### B4 · Aider（特殊 · 需写配置文件）

**① 安装**：

```bash
pip install aider-chat
```

**② 克隆并写配置**：

```bash
git clone https://github.com/PancrePal-xiaoyibao/VitaForge.git
cd VitaForge

# 创建 .aider.conf.yml，强制 Aider 启动时读取 AGENTS.md
cat > .aider.conf.yml <<'EOF'
read:
  - AGENTS.md
  - ETHICS.md
  - .codex/skills/vitaforge-orchestrator/SKILL.md
auto-commits: false
EOF
```

**③ 验证**：

```bash
aider
# 在 aider 会话中描述需求，它会自动按 AGENTS.md 路由
```

**④ 触发**：直接用自然语言描述需求（如「帮我对这个 scRNA-seq 数据做 QC 和聚类，参考 ai4s-dry-lab 的方法论」）

---

## 🔄 跨平台一键脚本（所有 Tier 通用兜底）

无论你用哪个 agent，下面这两个脚本都是 VitaForge 部署的**最终兜底**：

```bash
# Windows PowerShell — 合并部署 .claude/.codex/.gemini 到 %USERPROFILE%，重名自动备份
.\deploy\deploy.ps1 -Yes

# macOS / Linux Bash
./deploy/deploy.sh --yes
```

脚本行为：合并部署（不覆盖，先备份 `.vitaforge-bak.<timestamp>`）→ 自动同步 `.codex/skills` → `~/.agents/skills/` → 输出部署日志。

---

## 🧭 还是不确定你的 agent 属于哪一层？

走 [`docs/agent-deployment-rules.md` §6 决策树](./docs/agent-deployment-rules.md#6--决策树你的-agent-属于哪一层) —— 15 个主流 agent 的快速对照表 + 判定算法。

> 📌 部署后，所有 28 个 skill + 主调度 `vitaforge-orchestrator` 立即可用。
> - **Tier A 用户**：直接 `/vitaforge-orchestrator`（或 `$`/自然语言）让主调度路由
> - **Tier B 用户**：用 B1 第 ④ 步的「触发话术」让主调度路由

### 🛡️ 跨 Tier 治理铁律（不可降级）

无论你的 agent 属于 A/B/C 哪层，以下原则必须一致：

- ✅ **ETHICS.md 医学红线** — 所有 Tier 强制（[详见](./ETHICS.md)）
- ✅ **BSL 1.1 商业边界** — 所有 Tier 强制（个人/科研/教育免费，商业需授权）
- ✅ **AGENTS.md 单点真相** — Tier B/C 强制，Tier A 推荐同步
- ✅ **commit 必须用户授权** — 所有 Tier 强制，禁止 agent 自动 commit/push
- ✅ **临床数据脱敏** — 所有 Tier 强制，禁传真实患者可识别信息
- ✅ **三镜像同步**（Tier A 专属）— `.claude` + `.codex` + `.gemini` 同步修改

---

## 🔌 推荐 MCP 配置

VitaForge 的部分 skill 依赖外部 MCP（Model Context Protocol）服务发挥完整能力。医学-生命科学场景优先维护以下开源/社区 MCP：

| MCP 服务 | 用途 | ModelScope | API 申请 |
|---------|------|------------|----------|
| `mcp-pubmed-llm-server` | PubMed/NCBI 医学文献检索、PMID 证据查询 | [liueic/mcp-pubmed-llm-server](https://www.modelscope.cn/mcp/servers/liueic/mcp-pubmed-llm-server) | [NCBI API Key](https://www.ncbi.nlm.nih.gov/account/settings/) |
| `pubmed-openAlex-mcp` | PubMed + OpenAlex 学术文献、作者、机构、引用检索 | [Damncheater/pubmed-openAlex-mcp](https://www.modelscope.cn/mcp/servers/Damncheater/pubmed-openAlex-mcp) | [OpenAlex](https://openalex.org/login) |
| `mcp-KnowS-AI_medical_service` | KnowS/MedKnowS 医学知识与问答服务 | [caiql2002/mcp-KnowS-AI_medical_service](https://www.modelscope.cn/mcp/servers/caiql2002/mcp-KnowS-AI_medical_service) | [MedKnowS QuickQA](https://www.medknows.com/quickqa) |
| `metasota-API-MCP` | 秘塔搜索 API，用于网页、指南、新闻和中文资料交叉检索 | [Damncheater/metasota-API-MCP](https://www.modelscope.cn/mcp/servers/Damncheater/metasota-API-MCP) | [秘塔 API Keys](https://metaso.cn/search-api/api-keys) |

> 📋 MCP 源码地址、ModelScope 页面、npx/npm/本地部署方法和 API Key 申请入口见 [`docs/medical-mcp-servers.md`](./docs/medical-mcp-servers.md)。配置模板见 [`deploy/mcp-config.template.json`](./deploy/mcp-config.template.json)。无 MCP 也能用 —— 大部分 skill 内置降级逻辑。

---

## 📊 技能矩阵

VitaForge 包含 **28 个 skill** + **1 个主调度**，按场景分组：

### 🧬 干实验引擎（核心）

| Skill | Command | 能力 |
|-------|---------|------|
| `ai4s-dry-lab` | `/ai4s-lab` | AI4S v2.3 端到端干实验引擎（SPEC+OODA+Gate+Worklog W1-W4） |
| `scrna-bindlab-full-workflow` | `/scrna-bindlab-full-workflow` | scRNA-seq 8-Phase 全流程（CellRanger→细胞通讯，硬件感知） |
| `scrna-celltype-annotation` | `/scrna-celltype-annotation` | 单细胞亚群注释 + 文献报告 |

### 📚 文献与科研

| Skill | Command | 能力 |
|-------|---------|------|
| `deep-research` | `/deep-research` | 2-8 agent 并行深度调研 |
| `paper-reader` | `/paper-reader` | 跨学科论文精读 + 批判性分析 |
| `pubmed-linker` | `/update-pubmed-links` | PubMed 链接/PMID/DOI 批量更新 + 全文下载 |
| `dr-midas` | `/midas` | 科研图表分析 + PubMed 叙事（可调教） |
| `extract` | `/extract` | 从内容抽提研究方法论框架 |
| `pdf-reader` | `/pdf-reader` | PDF → Markdown 前处理 |

### 🩺 临床医学

| Skill | Command | 能力 |
|-------|---------|------|
| `medical-advisory` | `/medical-advisory` | 循证医学 + 中医整体观的私人医疗架构师 |

### ✍️ 写作与投稿

| Skill | Command | 能力 |
|-------|---------|------|
| `thesis-writing-mentor` | `/thesis-writing-mentor` | 学位论文顾问 + RAG 风格模仿 + 盲审模拟 |
| `sci-journal-submission-expert` | `/sci-journal-submission-expert` | SCI 投稿全流程（预审/选刊/审稿回复/APC） |
| `paper-submission-manager` | `/paper-submission-manager` | 投稿清单 + QA + 材料打包 |
| `nsfc-proposal-advisor` | `/nsfc-proposal-advisor` | 国自然基金辅导（破题/立项/预算） |

### 📄 文档办公

| Skill | Command | 能力 |
|-------|---------|------|
| `office-docs` | `/office-docs` | PPTX/DOCX/XLSX 读取/编辑/创建/校验 |
| `editing` | `/editing` | PPT 模板编辑 |
| `pptxgenjs` | `/pptxgenjs` | 代码生成全新 PPTX |
| `shidianguji-fetcher` | `/shidianguji-fetcher` | 识典古籍批量采集 |

### 🔧 工程底座（干实验支撑）

| Skill | Command | 能力 |
|-------|---------|------|
| `code-debugger` | `/debug` | 上下文优先的精准调试（R/Python 生信脚本） |
| `code-review` | `/code-review` | 分析 pipeline 代码审查 |
| `codebase-context` | `/codebase-context` | 复杂生信代码库导航 |
| `dev-env-scan` | `/dev-env-scan` | 开发环境扫描（生信工具链检测） |
| `ai-spec` | `/ai-spec` | 需求 → 技术规范 |

### 🏗️ 系统编排与部署治理

| Skill | Command | 能力 |
|-------|---------|------|
| `vitaforge-orchestrator` | `/vitaforge-orchestrator` | **主调度** — 全场景分诊路由 |
| `loop-engineer` | `/loop-engineer` | 多 skill package 设计与编排 |
| `skill-deploy` | `/skill-deploy` | 一键融合部署 + 后平滑（路由双向一致性） |
| `skill-governor` | `/skill-governor` | 单 skill 开发与质量门控 |

---

## 🎯 典型场景

### 场景一：从零发表一篇 scRNA-seq 文章

```
/vitaforge-orchestrator  「我要做一批 scRNA-seq，从数据到投稿全流程」

  → /deep-research + /paper-reader      文献调研
  → /ai4s-lab                           实验方案 + OODA 循环
  → /scrna-bindlab-full-workflow         全流程分析（8 Phase）
  → /scrna-celltype-annotation           细胞注释
  → /dr-midas + /thesis-writing-mentor   图表叙事 + 论文撰写
  → /sci-journal-submission-expert       投稿
  → /update-pubmed-links                 参考文献定稿
```

### 场景二：复杂病情循证分析

```
/vitaforge-orchestrator  「帮我分析一个复杂病例，要循证 + 中医视角」

  → /medical-advisory                    循证 + 中医整体观
  → /deep-research                       最新文献支撑
  → /paper-reader                        关键证据精读
```

### 场景三：国自然基金本子

```
/vitaforge-orchestrator  「我要申请国自然，需要破题和立项依据」

  → /nsfc-proposal-advisor               破题 + 科学问题 + 立项依据
  → /deep-research                       前沿文献支撑
  → /thesis-writing-mentor               去AI化润色
```

### 场景四：日常 Play（PPT/文档/古籍）

```
/office-docs       做答辩 PPT
/editing           编辑已有 PPT 模板
/pptxgenjs         代码生成炫酷 PPT
/shidianguji-fetcher  批量采集古籍研究
```

---

## 🍴 Fork 写自己的 Agent

VitaForge 的每个 skill 都是独立的、可 fork 的。你可以在自己 fork 里：

1. 修改现有 skill 的 prompt 适配你的实验室流程
2. 新增针对你研究方向的 skill（如空间转录组、蛋白质组学）
3. 调整主调度路由表

详见 [CONTRIBUTING.md](./CONTRIBUTING.md)。

---

## 🤖 让 Agent 优化 Skill 并提 PR

VitaForge 最酷的玩法 —— **让你正在用的 agent 自己优化它用的 skill**。

### 实战：Dr. Midas 讲故事太夸张？

直接对你的 agent 说：

```
我刚用 /midas，发现 Dr. Midas 把初步发现吹成"革命性突破"，不符合科研严谨性。
请：
1. 调用 /skill-governor 优化 dr-midas 的 SKILL.md（三镜像同步），
   禁止 revolutionize/groundbreaking 等绝对化词，强制不确定性限定词 + 文献支撑。
2. fork 上游 PancrePal-xiaoyibao/VitaForge，建分支 fix/dr-midas-tone-down，
   commit + 提 PR，描述写清问题、优化思路、三镜像改动。
```

一个 prompt，agent 自动完成：`skill-governor 优化 → 三镜像同步 → fork → 分支 → commit → PR`。

> 📖 完整流程与 PR 模板见 [CONTRIBUTING.md](./CONTRIBUTING.md#-方式二优化现有-skill含agent-自我优化闭环)。

---

## 📜 License & Ethics

VitaForge 采用 **Business Source License（延迟开源）+ 伦理附加**：

| 文件 | 作用 |
|------|------|
| [LICENSE](./LICENSE) | **Business Source License 1.1** — 个人/科研/教育/非营利免费，商业生产需授权；**2030-07-01 后自动转 Apache 2.0** |
| [ETHICS.md](./ETHICS.md) | **医学/AI 负责任使用附加条款** — 禁基因歧视、禁未授权临床决策、禁未知情同意研究、禁生物武器、禁学术不端 |

**简言之**：
- ✅ 个人研究、教育、非营利机构、公益、内部测试 —— **免费使用、修改、分发**
- ❌ 商业生产（含 SaaS、付费服务、医院/药企商业产品）—— **需书面授权**
- ⏰ **2030-07-01 起** —— 自动转 Apache 2.0，**任何人皆可商业使用**
- ❌ 任何违反 ETHICS.md 的用途 —— **立即终止许可**

> 💡 **为什么选 BSL？** 既保护项目长期的商业化可能性（版权人保留授权收费的权利），又承诺 4 年后完全开源，避免永久锁定。HashiCorp Terraform、CockroachDB、Sentry 同款模式。

---

## 🙏 致谢

VitaForge 站在巨人的肩膀上：

- 所有贡献者与社区成员
- [Superpowers](https://github.com/obra/superpowers) 框架的启发
- [MariaDB Business Source License](https://mariadb.com/bsl11/) 的延迟开源模式
- Claude Code / OpenAI Codex / Gemini CLI 三个优秀平台

> 特别感谢每一位让 AI 在医学与生命科学领域负责任地发挥价值的实践者。

---

## 💬 社区

- 🐛 **Bug / 建议**: [GitHub Issues](https://github.com/PancrePal-xiaoyibao/VitaForge/issues)
- 🤝 **贡献**: [CONTRIBUTING.md](./CONTRIBUTING.md)
- 🔒 **伦理举报**: [ETHICS.md 第 7 节](./ETHICS.md#7-举报与反馈)

---

<div align="center">

**🧬 让 AI 在双螺旋上点火开炉喵～** (´｡• ᵕ •｡`) ♡

_If VitaForge helps your research, please consider starring ⭐ the repo and citing it in your work._

</div>
