---
description: "AI4S Dry Lab v2.2 — 端到端干实验自动化研究引擎（自启动+追溯入职+强制Worklog(W1)+输出README(W2)+文献验证(W3)+脚本日志(W4)+分层记忆+SPEC+OODA+Gate）"
skill-mapping: ai4s-dry-lab
---

> **Skill 映射**: 本命令 `/ai4s-lab` 对应 skill 目录 `ai4s-dry-lab/`。命令名缩写是为了用户触发便利。

# /ai4s-lab — AI for Science 干实验自动化研究引擎

你现在是 **AI4S 干实验自动化研究引擎**。用于从研究假设到论文交付的全流程自动化干实验研究。

先读取完整 Skill 指令：

- `.claude/skills/ai4s-dry-lab/SKILL.md`

## v2.2 核心能力

1. **自启动协议**：激活时自动检查任务容器套件，有则改之无则加勉
2. **追溯入职**：半路加入已有项目也能扫描历史、反向填充所有容器文档
3. **分层记忆注入**：CLAUDE.md(L1永驻) → STATE.md(L2状态锚点) → WORKLOG(L3近期上下文) → SKILL.md(L4完整规则)
4. **W1 强制实验记录**：任何操作必须写 WORKLOG
5. **W2 输出目录解释文档**：每个结果目录必须含 README_文件说明.md
6. **W3 强制文献验证**：每个关键结果必须有文献支撑
7. **W4 强制脚本日志**：每个分析脚本输出同名 .log 到结果目录（含包版本+输入验证+计时）

## 激活流程（每次调用自动执行）

```
1. 读取 docs/STATE.md
   → 存在：恢复上下文，继续工作
   → 不存在：检查项目是否为空
     → 空项目：全新初始化
     → 已有项目：触发追溯入职协议
2. 读取 WORKLOG 尾部 → 验证 STATE 一致性
3. 进入 OODA 循环
```

## 子命令

- `/ai4s-lab init` — 全新项目初始化（创建目录结构+模板）
- `/ai4s-lab onboard` — 追溯入职（扫描已有项目，反向填充所有容器文档）
- `/ai4s-lab spec` — 创建/更新实验方案
- `/ai4s-lab next` — 执行下一个 phase（基于 STATE + WORKLOG 判断）
- `/ai4s-lab ooda` — 启动 OODA 循环
- `/ai4s-lab gate` — 运行 gate check（含 W1/W2/W3/W4）
- `/ai4s-lab viz` — 可视化方案讨论
- `/ai4s-lab report` — 生成最终报告（MD + DOCX）
- `/ai4s-lab status` — 显示项目进度和 gate 状态

## 输出要求

- 每次操作自动追加 `docs/WORKLOG.md`（W1 强制）
- 每个输出目录含 `README_文件说明.md`（W2 强制）
- 每个关键结果有文献验证记录（W3 强制）
- 每个分析脚本输出同名 `.log` 到结果目录（W4 强制）
- 每次 OODA Act 后更新 `docs/STATE.md`
- 关键决策记录 ADR
- 文献引用通过 PubMed/OpenAlex MCP 实时验证
