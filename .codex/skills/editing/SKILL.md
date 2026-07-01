---
name: editing
description: "PPT 模板编辑指南 — 用于以现有演示文稿为模板进行内容替换和布局优化。当用户需要编辑/修改已有 PPTX 时触发。"
---

# Editing Presentations

## Overview

Template-based workflow for editing existing presentations. Analyze existing slides, plan slide mapping, and produce varied layouts.

## Workflow

1. Analyze existing slides with thumbnail.py and markitdown
2. Plan slide mapping — for each content section choose a template slide
3. Use varied layouts (multi-column, image+text, quote slides)
4. Execute edits and verify output

## Output Contract

- Modified PPTX file with all content sections mapped
- Varied layout usage (no monotonous bullet slides)

## 关联 Skill（网络调度协议）

| 关系 | Skill | 场景 |
|------|-------|------|
| 被调用 | office-docs | 文档处理链路中需编辑已有 PPT |
| 被调用 | thesis-writing-mentor | 答辩稿 PPT 编辑 |
| 被调用 | vitaforge-orchestrator | 直接请求 PPT 编辑 |
| 被调用 | executive-consultant | 企业场景需编辑已有 PPT |

