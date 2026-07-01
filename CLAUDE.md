# CLAUDE.md - VitaForge

> 面向医学-生命科学 AI4S 的干实验引擎。本仓库为 Claude Code 提供 slash commands（见 `.claude/commands/`），核心逻辑在 `.claude/skills/` 与各技能子目录中。

## 🚀 主调度入口

- **`/vitaforge-orchestrator`** — VitaForge 全场景分诊调度器（**推荐首选入口**）。描述你的医学/生命科学/科研需求，自动识别场景并路由到最合适的子 skill。不确定用哪个命令时，先用这个。

## 📋 技能命令一览（与 `.claude/commands/*.md` 文件名一致）

### 🧬 干实验引擎
- `/ai4s-lab` — AI4S 干实验自动化引擎（scRNA-seq / 空间转录组 / 跨物种比较；SPEC+OODA+Gate+Worklog）
- `/scrna-celltype-annotation` — 单细胞亚群注释 + 文献报告
- `/scrna-bindlab-full-workflow` — scRNA-seq 端到端全流程（CellRanger→高级分析，硬件感知+AI注释）

### 📚 文献调研
- `/paper-reader` — 论文精读（PMID/DOI/本地 PDF）
- `/deep-research` — 多 agent 并行深度调研
- `/update-pubmed-links` — PubMed 链接 / PMID / DOI 批量更新
- `/pdf-reader` — PDF 转 Markdown 前处理

### 🔬 科研叙事
- `/midas` — Dr. Midas 科研图表分析 + PubMed 叙事
- `/extract` — 研究方法论抽提

### 🩺 临床医学
- `/medical-advisory` — 循证医学 + 中医整体观顾问

### ✍️ 写作投稿
- `/thesis-writing-mentor` — 学位论文顾问 + RAG 风格模仿 + 盲审模拟
- `/paper-submission-manager` — 投稿全流程管理
- `/sci-journal-submission-expert` — SCI 期刊全流程专家

### 💰 基金申请
- `/nsfc-proposal-advisor` — 国自然基金辅导

### 📄 文档办公
- `/office-docs` — PPTX/DOCX/XLSX 读取/编辑/创建/校验
- `/editing` — PPT 模板编辑
- `/pptxgenjs` — 代码生成全新 PPTX

### 📜 古籍处理
- `/shidianguji-fetcher` — 识典古籍批量采集

### 🔧 工程底座
- `/debug` — 代码调试（code-debugger，R/Python 生信脚本）
- `/code-review` — 代码审查
- `/codebase-context` — 代码库导航
- `/dev-env-scan` — 开发环境扫描
- `/ai-spec` — 需求 → 技术规范

### 🏗️ 系统编排
- `/loop-engineer` — 多 skill package 设计与编排

### 🚀 部署治理
- `/skill-deploy` — 一键融合部署 + 后平滑（路由双向一致性）
- `/skill-governor` — 单 skill 开发与质量门控

## 🔗 典型联动链路

```
从零到一发表一篇 scRNA-seq 文章：
  /deep-research + /paper-reader      →  文献调研
  → /ai4s-lab                          →  实验方案 + OODA 循环
  → /scrna-bindlab-full-workflow       →  全流程分析
  → /scrna-celltype-annotation         →  细胞注释
  → /midas + /thesis-writing-mentor    →  图表叙事 + 论文撰写
  → /sci-journal-submission-expert     →  投稿
  → /update-pubmed-links               →  参考文献定稿

病情循证分析：
  /medical-advisory → /deep-research → /paper-reader
```

## ⚠️ 伦理红线

本仓库所有 skill 涉及医学/生命科学场景时，**必须遵守 [ETHICS.md](./ETHICS.md)**：

- 不得用于基因/遗传歧视、未授权临床决策、未知情同意研究、生物武器、学术不端
- 所有输出为**辅助参考**，须经具备资质的专业人员独立验证
- License: [Business Source License 1.1](./LICENSE) — 个人/科研/教育/非营利免费，商业生产需授权；**2030-07-01 后自动转 Apache 2.0 完全开源**

详细说明、技能矩阵、MCP 配置、部署方式见 [README.md](./README.md)。贡献指南见 [CONTRIBUTING.md](./CONTRIBUTING.md)。
