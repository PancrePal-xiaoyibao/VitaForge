---
description: VitaForge 主调度 — 描述医学-生命科学/科研需求后自动分诊路由到对应 skill（干实验/测序/文献/科研叙事/临床/写作/投稿/基金/文档/古籍/工程/编排/部署）
---

# /vitaforge-orchestrator

VitaForge 全场景分诊调度器。描述你的需求，自动路由到最合适的子 skill。

## 使用场景

- 不确定该用哪个 skill 时
- 需要跨场景编排多个 skill 联动时
- 首次进入 VitaForge 需要导航时

## 路由表

| 场景 | 命令 |
|------|------|
| 🧬 干实验引擎 | `/ai4s-lab` `/scrna-bindlab-full-workflow` `/scrna-celltype-annotation` |
| 📚 文献调研 | `/deep-research` `/paper-reader` `/update-pubmed-links` `/pdf-reader` |
| 🔬 科研叙事 | `/midas` `/extract` |
| 🩺 临床医学 | `/medical-advisory` |
| ✍️ 论文写作 | `/thesis-writing-mentor` |
| 📬 投稿发表 | `/paper-submission-manager` `/sci-journal-submission-expert` |
| 💰 基金申请 | `/nsfc-proposal-advisor` |
| 📄 文档办公 | `/office-docs` `/editing` `/pptxgenjs` |
| 📜 古籍处理 | `/shidianguji-fetcher` |
| 🔧 工程底座 | `/debug` `/code-review` `/dev-env-scan` `/ai-spec` `/codebase-context` |
| 🏗️ 系统编排 | `/loop-engineer` |
| 🚀 部署治理 | `/skill-deploy` `/skill-governor` |

## 参数

`$ARGUMENTS` — 需求描述（自然语言）
