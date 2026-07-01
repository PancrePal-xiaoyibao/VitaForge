---
description: Skill Deploy — 融合去重并系统级部署所有 skill package 到 Claude/Codex/Gemini 环境路径，含后部署路由平滑
---

# /skill-deploy

启动 Skill Deploy（技能融合部署官），将仓库中多个 skill package 组合、去重、融合后统一部署到系统级路径。

## 使用场景

- 需要将多个 package 的 skill 融合后部署到 `~/.claude`、`~/.codex`、`~/.gemini` 时（Windows: `%USERPROFILE%\.claude` 等；macOS/Linux: `$HOME/.claude` 等）
- 需要对已有系统级部署进行去重整理和路由表平滑时
- 需要检查当前部署状态与仓库 package 的差异时

## 入口

读取并执行 `.claude/skills/skill-deploy.md`

## 参数

`$ARGUMENTS` — 部署选项，支持以下修饰符（可组合）：

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--packages=<列表>` | 只处理指定的 package（逗号分隔） | 全部 4 个 package |
| `--platforms=<列表>` | 只部署到指定平台（claude/codex/gemini） | 全部 3 个平台 |
| `--dry-run` | 仅扫描分析，不执行任何文件操作 | 关闭 |

## 示例

```
/skill-deploy
```

```
/skill-deploy --dry-run
```

```
/skill-deploy --packages=enterprise-use,学术脚手架 --platforms=claude
```

## 不可妥协的规则

1. 不静默覆盖系统级已有文件（必须先备份为 `.bak`）
2. 不删除用户手动创建的系统级 skill
3. 路由表补丁必须三平台同步写入
4. 每个 Gate 必须获得用户确认后才继续
5. 必须输出完整的部署报告
