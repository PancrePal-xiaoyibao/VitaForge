# AGENTS.md - VitaForge (Codex CLI 入口)

> 面向医学-生命科学 AI4S 的干实验引擎。本仓库为 OpenAI Codex CLI 提供 skills（见 `.codex/skills/`），每个 skill 通过 `$skill-name` 显式触发或自动匹配。

## 🚀 主调度入口

- **`$vitaforge-orchestrator`** — VitaForge 全场景分诊调度器（**推荐首选入口**）。描述你的医学/生命科学/科研需求，自动识别场景并路由到最合适的子 skill。不确定用哪个 skill 时，先用这个。

## 📋 技能清单（`.codex/skills/` 下，用 `$skill-name` 触发）

### 🧬 干实验引擎
- `$ai4s-dry-lab` — AI4S 干实验自动化引擎（scRNA-seq / 空间转录组 / 跨物种比较；SPEC+OODA+Gate+Worklog）
- `$scrna-celltype-annotation` — 单细胞亚群注释 + 文献报告
- `$scrna-bindlab-full-workflow` — scRNA-seq 端到端全流程（8 Phase，硬件感知）

### 📚 文献调研
- `$paper-reader` — 论文精读
- `$deep-research` — 多 agent 并行深度调研
- `$pubmed-linker` — PubMed 链接批量更新
- `$pdf-reader` — PDF 转 Markdown

### 🔬 科研叙事
- `$dr-midas` — 科研图表分析 + PubMed 叙事
- `$extract` — 研究方法论抽提

### 🩺 临床医学
- `$medical-advisory` — 循证医学 + 中医顾问

### ✍️ 写作投稿
- `$thesis-writing-mentor` — 学位论文顾问 + 盲审模拟
- `$paper-submission-manager` — 投稿全流程管理
- `$sci-journal-submission-expert` — SCI 期刊全流程专家

### 💰 基金申请
- `$nsfc-proposal-advisor` — 国自然基金辅导

### 📄 文档办公
- `$office-docs` — PPTX/DOCX/XLSX
- `$editing` — PPT 模板编辑
- `$pptxgenjs` — 代码生成 PPT

### 📜 古籍处理
- `$shidianguji-fetcher` — 识典古籍采集

### 🔧 工程底座
- `$code-debugger` — 代码调试
- `$code-review` — 代码审查
- `$codebase-context` — 代码库导航
- `$dev-env-scan` — 环境扫描
- `$ai-spec` — 需求规范

### 🏗️ 系统编排
- `$loop-engineer` — 多 skill package 设计

### 🚀 部署治理
- `$skill-deploy` — 一键融合部署 + 后平滑
- `$skill-governor` — skill 治理

## 🔗 典型联动链路

```
scRNA-seq 全流程：
  $deep-research + $paper-reader  →  文献调研
  → $ai4s-dry-lab                  →  实验方案 + OODA
  → $scrna-bindlab-full-workflow   →  全流程分析
  → $scrna-celltype-annotation     →  细胞注释
  → $dr-midas + $thesis-writing-mentor  →  叙事 + 论文
  → $sci-journal-submission-expert →  投稿
```

## ⚠️ 伦理红线

所有 skill 涉及医学/生命科学场景时，**必须遵守 [ETHICS.md](./ETHICS.md)**。输出为辅助参考，须经专业资质人员验证。License: [Business Source License 1.1](./LICENSE)（2030-07-01 后转 Apache 2.0，商业生产使用需授权）。

详细说明见 [README.md](./README.md)。贡献指南见 [CONTRIBUTING.md](./CONTRIBUTING.md)。

## 📌 Codex 部署路径

Codex 官方发现路径：`.agents/skills/<name>/`（CWD / 仓库根 / `~/.agents/skills/`）。
本仓库 `.codex/skills/` 为存储格式，部署时复制到 `.agents/skills/`。
