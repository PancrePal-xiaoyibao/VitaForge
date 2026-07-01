---
description: scRNA-seq 端到端全流程自动化分析。从 CellRanger 输出到高级下游分析（轨迹/通讯/CNV/调控网络），强调并行效率和 AI 自动注释。
---

# /scrna-bindlab-full-workflow

单细胞转录组全流程分析引擎。

## 使用场景

- 拿到 10X CellRanger 输出，需要完整的 scRNA-seq 分析
- 多样本/多条件的单细胞数据对比分析
- 需要标准化、可复现的 pipeline（从 QC 到论文级图表）

## 调用方式

```
/scrna-bindlab-full-workflow                    # 启动完整 pipeline
/scrna-bindlab-full-workflow phase1             # 单独执行 QC Phase
/scrna-bindlab-full-workflow phase7 cellchat    # 执行高级分析-细胞通讯模块
/scrna-bindlab-full-workflow status             # 查看当前进度
```

## Pipeline 概览

| Phase | 名称 | 说明 |
|-------|------|------|
| 0 | Data Ingestion | CellRanger → Seurat 对象 |
| 1 | Quality Control | 自适应 QC 过滤 |
| 2 | Seurat Processing | 标准化→聚类→降维 |
| 3 | Marker Discovery | FindAllMarkers (并行) |
| 4 | Cell Annotation | AI 自动文献注释 (调用 /scrna-celltype-annotation) |
| 5 | Visualization | 全套发表级可视化 |
| 6 | DGE & Enrichment | 组间差异 + GSEA/GO/KEGG |
| 7 | Advanced Analyses | 轨迹/通讯/CNV/调控 (按需选配) |

## 核心特性

1. **硬件感知**: 自动检测并生成 HARDWARE_CONFIG.md，防止资源耗尽
2. **并行优先**: 所有计算密集步骤默认 `future` + `foreach` 并行
3. **AI 注释**: Phase 4 强制调用 `/scrna-celltype-annotation`，agent 自查文献
4. **W1-W4 兼容**: 与 ai4s-dry-lab 无缝集成，遵循强制记录规则
5. **模块化**: Phase 7 各模块可独立执行

## 注意事项

- 首次运行会自动生成 HARDWARE_CONFIG.md
- Phase 4 注释过程需要 MCP 文献工具（PubMed/OpenAlex）
- 高级分析模块可能需要额外依赖（CellChat, infercnv, scVelo 等）
- 当由 ai4s-dry-lab 调用时，自动继承 W1-W4 强制记录规则
