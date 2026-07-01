# 医学 MCP 服务部署索引与模板

> Last updated: 2026-07-01. MCP 项目的包名、启动命令和环境变量可能随维护者发布方式变化；实际部署时优先以对应 ModelScope 页面和源码 README 为准。

本文档用于集中维护 VitaForge 推荐的医学/生命科学 MCP（Model Context Protocol）服务地址、源码入口、部署方式和 API Key 申请链接。它配合 [`deploy/mcp-config.template.json`](../deploy/mcp-config.template.json) 使用。

## 推荐服务清单

| MCP 服务 | 主要用途 | ModelScope 地址 | 源码/包地址 | API/账号 |
|---------|---------|----------------|-------------|---------|
| `mcp-pubmed-llm-server` | PubMed/NCBI 生物医学文献检索、摘要、PMID 级证据查询 | https://www.modelscope.cn/mcp/servers/liueic/mcp-pubmed-llm-server | 以 ModelScope 项目页的源码/README/部署命令为准；如后续发布 npm/PyPI/GitHub mirror，在本列补充 | NCBI E-utilities API Key: https://www.ncbi.nlm.nih.gov/account/settings/；说明文档: https://www.ncbi.nlm.nih.gov/books/NBK25497/ |
| `pubmed-openAlex-mcp` | PubMed + OpenAlex 联合文献检索、作者/机构/引用补充 | https://www.modelscope.cn/mcp/servers/Damncheater/pubmed-openAlex-mcp | 以 ModelScope 项目页的源码/README/部署命令为准；如后续发布 npm/PyPI/GitHub mirror，在本列补充 | OpenAlex: https://openalex.org/login；NCBI API Key 同上 |
| `mcp-KnowS-AI_medical_service` | KnowS/MedKnowS 医学问答、疾病/药物/指南类医学知识服务 | https://www.modelscope.cn/mcp/servers/caiql2002/mcp-KnowS-AI_medical_service | 以 ModelScope 项目页的源码/README/部署命令为准；如后续发布 npm/PyPI/GitHub mirror，在本列补充 | MedKnowS QuickQA: https://www.medknows.com/quickqa |
| `metasota-API-MCP` | 秘塔搜索 API 封装，用于医学网页、新闻、指南和中文资料交叉检索 | https://www.modelscope.cn/mcp/servers/Damncheater/metasota-API-MCP | 以 ModelScope 项目页的源码/README/部署命令为准；如后续发布 npm/PyPI/GitHub mirror，在本列补充 | 秘塔 Search API Keys: https://metaso.cn/search-api/api-keys |

## 和 VitaForge Skill 的对应关系

| VitaForge skill | 推荐 MCP |
|----------------|----------|
| `deep-research` | `pubmed-openAlex-mcp`, `mcp-pubmed-llm-server`, `metasota-API-MCP` |
| `paper-reader` | `pubmed-openAlex-mcp`, `mcp-pubmed-llm-server` |
| `ai4s-dry-lab` | `pubmed-openAlex-mcp`, `mcp-pubmed-llm-server` |
| `scrna-celltype-annotation` | `pubmed-openAlex-mcp`, `mcp-pubmed-llm-server` |
| `pubmed-linker` | `mcp-pubmed-llm-server` |
| `dr-midas` | `mcp-pubmed-llm-server`, `pubmed-openAlex-mcp` |
| `medical-advisory` | `mcp-KnowS-AI_medical_service`, `mcp-pubmed-llm-server`, `metasota-API-MCP` |

## 部署路径优先级

### 1. ModelScope 页面部署

优先打开对应 ModelScope MCP 页面，使用页面提供的安装、托管或本地部署按钮/命令。ModelScope 页面通常会展示 MCP 服务配置、工具列表、环境变量和 Playground 测试入口。

适用场景：

- 想快速验证服务是否可用。
- 项目主要托管在 ModelScope MCP 广场，暂未确认 npm/PyPI/GitHub mirror。
- 需要按照维护者页面上的最新环境变量名称配置。

### 2. npx/npm 部署模板

如果项目发布到了 npm，可在 MCP 客户端配置中使用：

```json
{
  "mcpServers": {
    "server-id": {
      "command": "npx",
      "args": ["-y", "<npm-package-name>"],
      "env": {
        "API_KEY_NAME": "<your-api-key>"
      }
    }
  }
}
```

注意：当前未在公开 npm 搜索中稳定确认上述 4 个项目的同名 npm 包；不要盲目把 ModelScope 项目名当作 npm 包名。以项目 README 或 ModelScope 页面显示的 npm 命令为准。

### 3. 本地源码部署模板

如果项目提供 Git 源码，但没有 npm 包，可本地部署后让 MCP 客户端调用本地入口。

Node.js 项目：

```bash
git clone <source-repo-url>
cd <repo>
npm install
npm run build
```

```json
{
  "mcpServers": {
    "server-id": {
      "command": "node",
      "args": ["<repo>/dist/index.js"],
      "env": {
        "API_KEY_NAME": "<your-api-key>"
      }
    }
  }
}
```

Python/uv 项目：

```bash
git clone <source-repo-url>
cd <repo>
uv venv
uv pip install -e .
```

```json
{
  "mcpServers": {
    "server-id": {
      "command": "uv",
      "args": ["--directory", "<repo>", "run", "python", "-m", "<server_module>"],
      "env": {
        "API_KEY_NAME": "<your-api-key>"
      }
    }
  }
}
```

## 环境变量建议

最终变量名以各 MCP 项目 README 为准。VitaForge 文档和模板采用以下占位命名，便于统一替换：

| 服务 | 推荐占位变量 |
|------|-------------|
| PubMed/NCBI | `NCBI_API_KEY`, `NCBI_EMAIL`, `NCBI_TOOL` |
| OpenAlex | `OPENALEX_EMAIL`, `OPENALEX_API_KEY` |
| MedKnowS/KnowS | `MEDKNOWS_API_KEY`, `MEDKNOWS_BASE_URL` |
| Metaso | `METASO_API_KEY` |

## 客户端配置位置

不同客户端的 MCP 配置文件位置不同：

| 客户端 | 常见配置位置 |
|--------|--------------|
| Claude Code | `~/.claude.json` 或项目 `.mcp.json` |
| Cursor | Cursor MCP 设置页或用户级 MCP 配置 |
| Codex/OpenAI 兼容 Agent | 以宿主 MCP 配置机制为准 |

复制 [`deploy/mcp-config.template.json`](../deploy/mcp-config.template.json) 后，替换以下内容：

1. `<npm-package-name>` 或 `<local-repo>`。
2. `<server_module>` 或 `dist/index.js`。
3. API Key、邮箱和工具名。
4. 与项目 README 一致的环境变量名称。

## 验证清单

- MCP 客户端能列出该服务的 tools。
- 每个服务至少执行一次最小查询，例如 PubMed 检索 `cancer immunotherapy`、OpenAlex 检索 DOI、Metaso 搜索医学指南关键词。
- 不把 API Key 提交到 Git；只放在本机 MCP 配置、密钥管理器或环境变量中。
- 医学/临床输出必须遵守 [`ETHICS.md`](../ETHICS.md)，仅作辅助参考，须由具备资质的专业人员复核。
