---
name: vitaforge-orchestrator
description: "VitaForge 主调度 — 面向医学-生命科学 AI4S 的全场景分诊入口。接收用户自然语言需求，识别所处场景（干实验引擎/测序分析/文献科研/科研叙事/临床医学/论文写作/投稿发表/基金申请/文档办公/古籍处理/工程底座/系统编排/部署治理），路由到对应子 skill。当用户进入 VitaForge 环境并描述任何医学、生命科学或科研相关需求时自动激活。不确定用哪个 skill 时，先用这个。不适用于：已被精确路由到单一子 skill 的明确任务。"
---

# VitaForge Orchestrator — 医学-生命科学 AI4S 全场景分诊调度器

## Overview

VitaForge 的顶层分诊调度器与主入口。不执行具体任务，而是理解用户需求、判断场景、路由到最合适的子 skill，并在跨场景任务中给出执行编排。

定位：**医学-生命科学 AI4S 干实验引擎的「前台分诊台」**。

## Workflow

### Step 1: 场景识别

| 场景 | 关键词 / 意图 | 路由目标 |
|------|--------------|----------|
| 🧬 干实验引擎 | scRNA-seq、单细胞、空间转录组、跑分析、CellRanger、Seurat、OODA | `ai4s-lab` → `scrna-bindlab-full-workflow` → `scrna-celltype-annotation` |
| 📚 文献调研 | 读论文、文献综述、找文献、PMID、DOI | `deep-research` `paper-reader` `pubmed-linker` `pdf-reader` |
| 🔬 科研叙事 | 图表分析、讲故事、抽提方法论、研究框架 | `dr-midas` `extract` |
| 🩺 临床医学 | 病情分析、循证、用药、健康管理、中医 | `medical-advisory` |
| ✍️ 论文写作 | 学位论文、写作、盲审、去 AI 化 | `thesis-writing-mentor` |
| 📬 投稿发表 | 选刊、投稿、审稿意见、Cover Letter | `sci-journal-submission-expert` `paper-submission-manager` |
| 💰 基金申请 | 国自然、课题申报、立项依据 | `nsfc-proposal-advisor` |
| 📄 文档办公 | PPT、Word、Excel、PDF 处理 | `office-docs` `editing` `pptxgenjs` |
| 📜 古籍处理 | 古书、识典古籍 | `shidianguji-fetcher` |
| 🔧 工程底座 | 调代码、审查 pipeline、环境配置、需求规范 | `code-debugger` `code-review` `dev-env-scan` `ai-spec` `codebase-context` |
| 🏗️ 系统编排 | 设计多技能联动、开发新 package | `loop-engineer` |
| 🚀 部署治理 | 一键部署、融合去重、优化 skill 网络 | `skill-deploy` `skill-governor` |

### Step 2: 确认与路由

1. 用 1 句话复述对用户意图的理解
2. 推荐最匹配的 1 个主 skill
3. 若跨场景，给出执行编排（阶段序列）
4. 用户确认后衔接

### Step 3: 回流

子 skill 完成后，可回到本调度器继续下一场景，或直接结束。本调度器不强制回流——子 skill 之间亦可直接互调。

## 典型编排链路

```
从零到一发表一篇 scRNA-seq 文章：
  deep-research + paper-reader      →  文献调研
  → ai4s-lab                        →  实验方案 + OODA 循环
  → scrna-bindlab-full-workflow     →  全流程分析（8 Phase）
  → scrna-celltype-annotation       →  细胞注释
  → dr-midas + thesis-writing-mentor →  图表叙事 + 论文撰写
  → sci-journal-submission-expert   →  投稿
  → pubmed-linker                   →  参考文献定稿

病情分析与循证决策：
  medical-advisory                  →  循证 + 中医整体观
  → deep-research                   →  最新文献支撑
  → paper-reader                    →  关键证据精读
```

## Output Contract

- 意图判断（1 句话，明确场景）
- 推荐 skill 路由（主 skill + 可选辅助）
- 复杂任务给出阶段编排（编号序列）

## 关联 Skill（网络调度协议）

本 skill 为 VitaForge Package **主调度**，拥有全局路由表。所有子 skill 均可被路由。子 skill 之间亦可直接互调，不受树形层级约束。
