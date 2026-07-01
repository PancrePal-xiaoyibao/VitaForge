# 贡献指南 (CONTRIBUTING.md)

> VitaForge 是一个社区驱动的医学-生命科学 AI4S 技能包。无论你是想修一个标点、优化一个 prompt、还是贡献一个全新的生信分析 skill —— 都欢迎你！φ(≧ω≦*)♪

**版本**: 1.0.0 · **License**: [PolyForm Noncommercial 1.0.0](./LICENSE) + [ETHICS.md](./ETHICS.md)

---

## 🌟 三种贡献方式

| 方式 | 适合谁 | 难度 |
|------|--------|------|
| 🐛 **报 Issue** | 所有用户 | ⭐ |
| ✏️ **优化现有 skill** | 用过某 skill 并发现问题的用户 | ⭐⭐ |
| 🆕 **新增 skill** | 想贡献新能力的开发者/研究者 | ⭐⭐⭐ |

> ⚠️ 所有贡献必须遵守 [ETHICS.md](./ETHICS.md)。涉及医学/生命科学的新 skill 须内置安全约束。

---

## 🚀 快速开始：Fork & 本地环境

```bash
# 1. 在 GitHub 上 Fork VitaForge 到你的账号
# 2. Clone 你的 fork
git clone https://github.com/<你的用户名>/VitaForge.git
cd VitaForge

# 3. 添加上游
git remote add upstream https://github.com/PancrePal-xiaoyibao/VitaForge.git

# 4. 创建特性分支（命名规范见下文）
git checkout -b fix/dr-midas-tone-down

# 5. 让 Claude Code / Codex / Gemini 读到本仓库的 skills
#    在仓库根目录启动 agent 即可（仓库本身就是部署根）
```

---

## ✏️ 方式二：优化现有 Skill（含「Agent 自我优化闭环」）

这是 VitaForge 最酷的玩法 —— **让你正在用的 AI agent 自己优化它用的 skill，并给社区提 PR**。

### 🎯 实战案例：Dr. Midas 讲故事太夸张

**场景**：你用 `/midas` 让 Dr. Midas 分析一张科研图表，发现它把结果吹得天花乱坠（"this finding will revolutionize..."），完全不像严谨的科研叙事。

**传统做法**：自己在 issue 里抱怨，等维护者改。

**VitaForge 做法**：直接对你的 agent 说 👇

```
我刚才用 /midas 时发现 Dr. Midas 讲故事太夸张了，把初步发现吹成了革命性突破，
不符合科研严谨性。请帮我：
1. 调用 /skill-governor 优化 dr-midas 的 SKILL.md（三镜像 .claude/.codex/.gemini 同步），
   增加叙事克制约束：禁止使用 revolutionize / groundbreaking / unprecedented 等绝对化词汇，
   要求所有论断必须挂不确定性限定词，并强制引用文献支撑。
2. fork 上游仓库 PancrePal-xiaoyibao/VitaForge 到我的账号，
   创建分支 fix/dr-midas-tone-down，commit 改动，
   提交 PR，PR 描述写清楚：问题现象、优化思路、三镜像改动清单。
```

agent 会自动完成：`skill-governor 优化 → 三镜像同步 → fork → 分支 → commit → PR`。**一个 prompt，一条流水线**。

### ✅ 优化 skill 的检查清单

无论人工还是 agent 操作，优化一个 skill 须满足：

- [ ] **三镜像同步** — `.claude/` + `.codex/` + `.gemini/` 三个版本同时修改（这是 VitaForge 最严格的规则，违反会被 review 打回）
- [ ] **frontmatter 完整** — `name` + `description`，description 说明触发条件
- [ ] **关联 Skill 段** — 若改动影响 skill 间路由，更新相关 skill 的关联段并保证双向一致
- [ ] **无死链** — `scripts/` `references/` 引用路径真实存在
- [ ] **伦理合规** — 医学/生命科学 skill 须保留或强化安全约束（见 ETHICS.md）
- [ ] **本地验证** — 在至少一个平台实际跑一遍该 skill

> 💡 用 `/skill-governor` 可以自动校验上述大部分项。

---

## 🆕 方式三：新增 Skill

### 命名规范

- 英文小写 + 连字符（kebab-case），如 `spatial-transcriptomics-workflow`
- 目录名 = skill name = command name（避免 `code-debugger`/`debug` 这种不一致）

### 标准开发流程（用 `/skill-governor`）

```
1. 写 Codex 源（真源）
   .codex/skills/<your-skill>/
   ├── SKILL.md          # name + description + Overview/Workflow/Output Contract/Resources
   ├── agents/openai.yaml # display_name / short_description / default_prompt
   ├── scripts/          # 可选：.py/.ps1/.sh
   └── references/       # 可选：静态文档

2. 同步 Gemini 镜像
   .gemini/skills/<your-skill>/SKILL.md  (frontmatter: name + description)

3. 同步 Claude 镜像
   .claude/skills/<your-skill>/SKILL.md  (Claude 官方目录格式)
   .claude/commands/<your-skill>.md      # slash command 入口

4. 更新主调度路由
   在 vitaforge-orchestrator 的路由表加入新 skill（三镜像同步）

5. Format Checklist 校验（/skill-governor 自动）

6. 更新 README 技能矩阵 + 三入口文档（CLAUDE.md/AGENTS.md/GEMINI.md）
```

> 完整规范见仓库内 `.claude/skills/skill-governor.md`（部署后用 `/skill-governor` 调用）。

---

## 🔀 Pull Request 流程

### 分支命名

| 类型 | 前缀 | 示例 |
|------|------|------|
| 修复 | `fix/` | `fix/dr-midas-tone-down` |
| 新功能 | `feat/` | `feat/spatial-transcriptomics` |
| 文档 | `docs/` | `docs/readpolish-readme` |
| 重构 | `refactor/` | `refactor/extract-rename` |

### Commit 信息

遵循 [Conventional Commits](https://www.conventionalcommits.org/)：

```
feat(scrna): add spatial transcriptomics downstream analysis
fix(dr-midas): tone down narrative, enforce uncertainty qualifiers
docs(readme): add MCP configuration section
```

### PR 模板（提交时复制到 PR 描述）

```markdown
## 改动类型
- [ ] 🐛 Bug 修复
- [ ] ✨ 新功能 / 新 skill
- [ ] 📚 文档
- [ ] ♻️ 重构

## 改动说明
<!-- 这个 PR 做了什么？为什么？ -->

## 关联 Issue
Closes #XXX

## 三镜像同步检查（必填）
- [ ] `.claude/` 已更新
- [ ] `.codex/` 已更新
- [ ] `.gemini/` 已更新

## 伦理检查（医学/生命科学相关必填）
- [ ] 已确认符合 [ETHICS.md](../ETHICS.md)
- [ ] 新增 skill 已内置安全约束（如适用）

## 本地验证
- [ ] 在 [Claude/Codex/Gemini] 实际跑通
```

### Review 标准

维护者会重点检查：
1. ✅ 三镜像一致性（最高优先级）
2. ✅ 伦理合规
3. ✅ description 触发条件清晰
4. ✅ 无死链、无格式错误
5. ✅ 与 vitaforge-orchestrator 路由表一致

---

## 🤝 行为准则

- **友善** — 尊重所有贡献者，无论背景与水平。
- **严谨** — 医学/生命科学领域，错误可能造成真实伤害，请认真对待每一次改动。
- **透明** — AI 辅助生成的改动请在 PR 中披露。
- **合规** — 遵守 [ETHICS.md](./ETHICS.md) 与所在地法律。

---

## 💬 沟通

- **Bug / 功能建议**: [GitHub Issues](https://github.com/PancrePal-xiaoyibao/VitaForge/issues)
- **安全/伦理举报**: 见 [ETHICS.md 第 7 节](./ETHICS.md#7-举报与反馈)
- **大改动讨论**: 先开 Issue 讨论，再动手

---

*VitaForge 的每一次进步，都来自像你这样的贡献者。让你的 agent 也加入进来吧喵～* (´｡• ᵕ •｡`) ♡
