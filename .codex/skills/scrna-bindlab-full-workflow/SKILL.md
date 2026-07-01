---
name: scrna-bindlab-full-workflow
description: scRNA-seq 端到端全流程自动化分析引擎。从 CellRanger 输出到高级下游分析的完整标准化 pipeline，强调并行计算效率、AI agent 自动文献注释（调用 /scrna-celltype-annotation）、硬件感知资源调度。覆盖 QC/Seurat 处理/marker 发现/细胞注释/DGE-GSEA/轨迹分析/细胞通讯等全部环节。适用于 10X Genomics scRNA-seq 数据分析项目。
version: 1.0.0
---

# scRNA-seq Bindlab Full Workflow — 单细胞转录组端到端全流程引擎

## Overview

本 skill 将博士级 scRNA-seq 分析经验蒸馏为可复用的标准化 pipeline，覆盖从 CellRanger 输出到论文级高级分析的完整流程。

## Workflow

### 激活流程

```
Skill 激活
  │
  ├─ 硬件感知检查 (Advisory)
  │   ├─ 检查 HARDWARE_CONFIG.md → 存在则读取
  │   └─ 不存在 → 探测系统 → 自动生成
  │
  └─ 进入 Pipeline Phases
```

### Pipeline Phases (8 阶段)

| Phase | 名称 | 输入 | 输出 | 并行策略 |
|-------|------|------|------|----------|
| 0 | Data Ingestion | CellRanger dirs | merged.rds | lapply |
| 1 | Quality Control | merged.rds | qc_filtered.rds + QC plots | single |
| 2 | Seurat Processing | qc_filtered.rds | processed.rds (PCA/UMAP/clusters) | future multisession |
| 3 | Marker Discovery | processed.rds | dge_all_clusters.csv + heatmap | future + foreach |
| 4 | Cell Annotation | DGE CSV | annotation report + recode scripts | calls /scrna-celltype-annotation |
| 5 | Visualization | annotated.rds | publication figures | future_lapply batch |
| 6 | DGE & Enrichment | annotated.rds + groups | DGE tables + GSEA | future_lapply per celltype |
| 7 | Advanced Analyses | annotated.rds | trajectory/communication/CNV/regulon | module-parallel |

### Phase 详细说明

#### Phase 0: Data Ingestion
- 读取 CellRanger `filtered_feature_bc_matrix/` 或 `.h5`
- `CreateSeuratObject(min.cells=3, min.features=50)`
- 多样本 `merge()` with cell ID prefixes

#### Phase 1: Quality Control
- 计算: percent.mt, percent.HB, percent.ribo, nFeature, nCount
- 阈值: `isOutlier()` 自适应 (scuttle) 或用户指定
- 必须输出 pre/post QC violin plots

#### Phase 2: Seurat Processing
- LogNormalize → FindVariableFeatures(4000) → ScaleData(regress nCount+mt)
- RunPCA(50) → RunHarmony(多样本) → findPC(最优PC数)
- FindNeighbors → FindClusters(res 0.1-1.0) → RunUMAP + RunTSNE
- 全程 `plan("multisession", workers = HW$max_workers)`

#### Phase 3: Marker Discovery
- `FindAllMarkers(only.pos=TRUE, min.pct=0.25, logfc.threshold=0.25)`
- 并行 FeaturePlot/VlnPlot 生成 (foreach %dopar%)
- 输出 DGE CSV + top10 heatmap

#### Phase 4: Cell Type Annotation (AI-Driven)
- **强制调用 `/scrna-celltype-annotation`**
- AI agent 逐 cluster 查 PubMed/OpenAlex
- 生成 major/minor 两层注释 + R recode 代码
- 禁止人工凭经验注释

#### Phase 5: Visualization
- UMAP by sample/celltype_major/celltype_minor/clusters
- VlnPlot + DotPlot for canonical markers
- Cell composition bar/pie charts
- 并行批量生成

### 可视化美学规范

> **所有图表必须具备专业设计师水准，配色多彩而不花哨，符合 SCI 期刊美学。**

**配色原则**:
- **多彩 ≠ 花哨**: 使用精心设计的调色板 (MetBrewer / scico / viridis)，而非默认色
- **组间对比清晰**: AG vs CG 使用红-蓝对比 (避免红绿盲)
- **聚类着色**: 使用 MetBrewer 的大调色板 (>20 色)
- **渐变**: 使用 viridis/magma 感知均匀色阶
- **背景**: `theme_classic()` 或 `theme_minimal()`，无默认灰色背景

**核心 R 可视化包**:
```r
library(MetBrewer)    # 纽约大都会博物馆配色 — 首选!
# 推荐: Hokusai3(20色聚类), Signac(多分组), VanGogh3(暖色), Demuth(冷色), Cassatt2(柔和), Cross(高饱和)
library(scico)        # 科学配色，感知均匀
library(viridis)      # 经典感知均匀渐变
library(RColorBrewer) # 基础调色板 (备用)
library(ggsci)        # 期刊风格 (Nature/Science/Lancet 色板)
library(ggrepel)      # 标签防重叠
library(patchwork)    # 图组合排版
library(ggridges)     # 脊线图 (小提琴替代)
library(ggpubr)       # 出版级主题
library(cowplot)      # 拼图 + 主题
```

**图表标准**:
- DPI ≥ 300, 标题 ≥ 12pt, 轴标签 ≥ 10pt
- `geom_text_repel()` 防重叠, 英文 Arial/Helvetica
- `patchwork` + `plot_annotation()` 统一标题和标签

**典型配色方案**:
```r
group_colors <- c("Acupuncture" = "#E74C3C", "Control" = "#3498DB")  # 组间
cluster_colors <- met.brewer("Hokusai3", n = 20)                      # 聚类
heatmap_gradient <- scico::scico(256, palette = "vik")                # 热图
volcano_colors <- c("Down" = "#3498DB", "NS" = "grey80", "Up" = "#E74C3C")
bubble_gradient <- viridis::viridis(256)                              # 气泡图
```

#### Phase 6: DGE & Enrichment
- 每个 celltype 做组间 DGE (FindMarkers)
- clusterProfiler: gseGO, gseKEGG, enrichPathway
- Volcano plots + enrichment dot plots

#### Phase 7: Advanced Analyses (模块化选配)
- **7A Trajectory**: CytoTRACE / Monocle3 / Slingshot / scVelo
- **7B Communication**: CellChat / CellCall / CellPhoneDB
- **7C CNV**: inferCNV (肿瘤微环境)
- **7D Regulatory**: pySCENIC / SCENIC+
- **7E Doublet**: DoubletFinder (可前置到 Phase 1)

---

## R 环境多平台适应性探测

> **很多用户并非顶级开发者，不清楚环境路径和服务商配置，长年累月的依赖都沉淀在默认路径中。本协议的目标是自动探测、适配，让用户无感使用最佳环境。**

### 设计原则

1. **先探测平台，再决定策略** — 不是一刀切"首选 X"，而是根据操作系统智能适配
2. **尊重用户已有的环境沉淀** — 服务商预装、长期积累的包都在默认路径，优先复用
3. **渐进式降级** — 最优环境不可用时才往下走降级链

### 探测流程

```
Skill 激活
  │
  ├─ Step 1: 识别操作系统
  │   ├─ Linux / macOS (POSIX)
  │   └─ Windows
  │
  ├─ Step 2: 按平台策略扫描 R 环境
  │   │
  │   ├─ [Linux/macOS 策略]
  │   │   ├─ ① 探测系统 R: which R → /usr/bin/R, /usr/local/bin/R
  │   │   │     (包括 HPC、生信云、自建服务器、RStudio Server 等场景)
  │   │   │     → 若存在且已装 Seurat/harmony 等核心包 → ✅ 采用
  │   │   │     → 若存在但缺核心包 → ⚠️ 提示可在此环境补充安装
  │   │   ├─ ② 探测 conda R: conda info --envs | grep -i r
  │   │   │     → 若存在 → ✅ 采用（conda activate r-env）
  │   │   └─ ③ 兜底: 提示用户安装 R 或新建 conda 环境
  │   │
  │   └─ [Windows 策略]
  │       ├─ ① 探测 conda R 环境: conda info --envs | findstr /i "r-"
  │       │     → 若存在 → ✅ 采用（conda activate r-4.3 或类似）
  │       ├─ ② 探测系统 R: where R
  │       │     → 若存在 → ✅ 采用
  │       └─ ③ 兜底: 提示用户安装 R 或新建 conda 环境
  │
  └─ Step 3: 验证核心包可用性
      ├─ 必检包: Seurat, harmony, future, parallel, tidyverse
      ├─ 缺包 → 提示安装命令
      └─ 输出环境摘要 → 写入 WORKLOG
```

### 各平台典型路径

| 平台 | 常见 R 路径 | 常见 Rscript 路径 | 说明 |
|------|-----------|------------------|------|
| Linux (HPC/生信云) | `/usr/bin/R` | `/usr/bin/Rscript` | 服务商预装，包最全，RStudio Server 常见此路径 |
| Linux (自建服务器) | `/usr/local/bin/R` | `/usr/local/bin/Rscript` | 手动编译安装常见路径 |
| Linux (conda) | conda env 内 PATH | 同左 | `conda activate r-4.3` 等 |
| macOS (Homebrew) | `/opt/homebrew/bin/R` | `/opt/homebrew/bin/Rscript` | ARM Mac 默认 |
| macOS (系统) | `/usr/local/bin/R` | `/usr/local/bin/Rscript` | Intel Mac 或 CRAN .pkg 安装 |
| Windows (conda) | conda env 内 PATH | 同左 | `conda activate r-4.3`，首选方案 |
| Windows (CRAN) | `C:\Program Files\R\R-*\bin\R.exe` | `C:\Program Files\R\R-*\bin\Rscript.exe` | 官方安装包 |

### R 环境探测代码模板

```r
# === R 环境自动探测函数 ===
detect_r_env <- function() {
  os <- Sys.info()["sysname"]
  env_info <- list(os = os, r_path = R.home("bin"), version = R.version.string)

  # 检查核心包
  core_pkgs <- c("Seurat", "harmony", "future", "parallel", "tidyverse")
  env_info$installed_cores <- sapply(core_pkgs, function(pkg) {
    requireNamespace(pkg, quietly = TRUE)
  })

  # Linux/macOS: 检查系统 R vs conda R
  if (os %in% c("Linux", "Darwin")) {
    sys_r <- tryCatch(Sys.which("R"), error = function(e) "")
    conda_env <- tryCatch(
      system("conda info --envs 2>/dev/null | grep -i 'r-'", intern = TRUE),
      error = function(e) ""
    )
    env_info$system_r <- unname(sys_r)
    env_info$conda_r_envs <- conda_env
  }

  # Windows: 检查 conda R 环境
  if (os == "Windows") {
    conda_env <- tryCatch(
      system("conda info --envs 2>NUL | findstr /i \"r-\"", intern = TRUE),
      error = function(e) ""
    )
    env_info$conda_r_envs <- conda_env
  }

  return(env_info)
}

# 执行探测并报告
env <- detect_r_env()
cat("=== R Environment Report ===\n")
cat("OS:", env$os, "\n")
cat("R Path:", env$r_path, "\n")
cat("R Version:", env$version, "\n")
cat("Core packages:", paste(names(env$installed_cores), "=", env$installed_cores, collapse = ", "), "\n")
if (length(env$conda_r_envs) > 0 && any(nzchar(env$conda_r_envs))) {
  cat("Conda R envs:", paste(env$conda_r_envs, collapse = "; "), "\n")
}
```

> **⚠️ 重要提醒**：执行分析脚本时，务必先运行 `detect_r_env()` 确认环境状态，并将结果写入 WORKLOG。不要假设用户的 R 环境在哪。

---

## Seurat 并发计算协议

> **Seurat 的并发计算有特殊约束，错误使用会导致数据损坏或计算失败。**

### 核心约束

| 函数 | 能否并发 | 说明 |
|------|---------|------|
| `NormalizeData()` | ❌ **不可并发** | 必须单线程执行，使用 `LogNormalize` + `scale.factor = 10000` |
| `ScaleData()` | ✅ | 通过 `future` + `parallel` 并发 |
| `FindVariableFeatures()` | ✅ | 同上 |
| `RunPCA()` | ✅ | 同上 |
| `RunHarmony()` | ✅ | 同上 |
| `FindNeighbors()` | ✅ | 同上 |
| `FindClusters()` | ✅ | 同上 |
| `RunUMAP()` | ✅ | 同上 |
| `RunTSNE()` | ✅ | 同上 |
| `JackStraw()` | ✅ | 同上 |
| `FindAllMarkers()` | ✅ | 使用 `future` 并发（注意：future 框架会吞掉进度条） |

### 并发控制核心模式

```r
library(Seurat)
library(future)
library(parallel)

# === 并发初始化辅助函数 ===
makecore <- function(workcore, memory) {
  plan("multisession", workers = workcore)
  options(future.globals.maxSize = memory * 1024 * 1024^2)  # memory 单位: GB
}
```

**使用模式**: `plan("multisession")` → 执行计算 → `plan("sequential")` → `stopCluster(cl)` → `rm(cl)`

> **⚠️ 每段并发计算结束后，必须恢复为 sequential 并清理 cluster，否则会内存泄漏！**

### 实战并发模板: `seurat_process()`

以下为经过实战验证的完整 Seurat 处理并发模板，可直接复用：

```r
seurat_process <- function(seurat_object, workers1 = 5, workers2 = 10, do_harmony = TRUE) {
  library(Seurat)
  library(tidyverse)
  library(patchwork)
  library(harmony)
  library(parallel)

  makecore <- function(workcore, memory) {
    if (!require(Seurat)) install.packages("Seurat")
    if (!require(future)) install.packages("future")
    plan("multisession", workers = workcore)
    options(future.globals.maxSize = memory * 1024 * 1024^2)
  }

  # === Phase A: NormalizeData (单线程!) ===
  seurat_object <- NormalizeData(
    seurat_object,
    normalization.method = "LogNormalize",
    scale.factor = 10000
  )

  # === Phase B: ScaleData (并发 batch 1) ===
  makecore(workers1, 96)
  cl <- makeCluster(workers1)
  seurat_object <- ScaleData(
    seurat_object,
    vars.to.regress = c("nCount_RNA", "percent.mt"),
    verbose = TRUE
  )
  plan("sequential")
  stopCluster(cl)
  rm(cl)

  # === Phase C: FindVariableFeatures + RunPCA + 后续 (并发 batch 2) ===
  makecore(workers2, 96)
  cl <- makeCluster(workers2)
  seurat_object <- FindVariableFeatures(seurat_object, nfeatures = 4000)
  seurat_object <- RunPCA(seurat_object, npcs = 50, verbose = FALSE)

  if (do_harmony) {
    seurat_object <- RunHarmony(
      seurat_object,
      group.by.vars = "orig.ident",
      assay.use = "SCT",
      max.iter.harmony = 10
    )
    seurat_object <- FindNeighbors(seurat_object, reduction = "harmony", dims = 1:50)
    seurat_object <- FindClusters(seurat_object, resolution = seq(from = 0.1, to = 1.0, by = 0.2))
    seurat_object <- RunUMAP(seurat_object, reduction = "harmony", dims = 1:50)
    seurat_object <- RunTSNE(seurat_object, reduction = "harmony", dims = 1:50)
    seurat_object <- JackStraw(object = seurat_object, num.replicate = 100)
    seurat_object <- ScoreJackStraw(object = seurat_object, dims = 1:20)
  } else {
    seurat_object <- FindNeighbors(seurat_object, reduction = "pca", dims = 1:50)
    seurat_object <- FindClusters(seurat_object, resolution = seq(from = 0.1, to = 1.0, by = 0.2))
    seurat_object <- RunUMAP(seurat_object, reduction = "pca", dims = 1:50)
    seurat_object <- RunTSNE(seurat_object, reduction = "pca", dims = 1:50)
    seurat_object <- JackStraw(object = seurat_object, num.replicate = 100)
    seurat_object <- ScoreJackStraw(object = seurat_object, dims = 1:20)
  }

  plan("sequential")
  stopCluster(cl)
  rm(cl)

  return(seurat_object)
}
```

### 实战并发模板: `maketop10()`

Marker 发现的并发模板（配合 `FindAllMarkers` 使用）：

```r
maketop10 <- function(seurat_object, object_name, logFCfilter = 0.5, adjPvalFilter = 0.05) {
  seurat_object$seurat_clusters <- seurat_object$RNA_snn_res.0.9
  seurat_object@active.ident <- seurat_object$RNA_snn_res.0.9
  seurat_object$Annot_clusters <- seurat_object$seurat_clusters

  # future 框架会吃掉进度条，别急
  plan("multisession", workers = 20)
  seurat_object.markers <- FindAllMarkers(
    object = seurat_object,
    only.pos = FALSE,
    min.pct = 0.25,
    logfc.threshold = logFCfilter
  )
  plan("sequential")

  # 筛选显著 marker
  sig.markers <- seurat_object.markers[
    (abs(as.numeric(as.vector(seurat_object.markers$avg_log2FC))) > logFCfilter &
       as.numeric(as.vector(seurat_object.markers$p_val_adj)) < adjPvalFilter),
  ]

  write.table(
    sig.markers,
    file = paste0("04.markers_", object_name, ".xls"),
    sep = "\t", row.names = FALSE, quote = FALSE
  )

  # 提取 top10 用于阶梯热图
  top10_seurat_object <- sig.markers %>%
    group_by(cluster) %>%
    slice_max(n = 10, order_by = avg_log2FC)
  top10_seurat_object <- unique(top10_seurat_object$gene)

  return(top10_seurat_object)
}
```

---

## 硬件感知协议

```
检查 HARDWARE_CONFIG.md
├─ 存在 → 读取 (cpu_cores, ram_gb, gpu, max_workers, future_globals_maxsize)
└─ 不存在 → 探测 → 生成配置文件

模式: Advisory (警告但不阻塞)
```

**R 探测代码**:
```r
hw <- list(
  cpu_cores = parallel::detectCores(),
  ram_gb = as.numeric(system("free -g | awk '/Mem/{print $7}'", intern=TRUE)),
  gpu = tryCatch(system("nvidia-smi --query-gpu=name --format=csv,noheader", intern=TRUE), error=function(e)"None"),
  max_workers = min(parallel::detectCores()-1, 16)
)
hw$future_globals_maxsize <- (hw$ram_gb * 0.8 / hw$max_workers) * 1024^3
```

---

## 联动规则

| 被谁调用 | 行为 |
|----------|------|
| ai4s-dry-lab | 继承 W1-W4 规则，每个 Phase = 一轮 OODA |
| 独立调用 | W1-W4 不强制（建议），硬件检查仍执行 |

| 本 skill 调用 | 时机 |
|----------------|------|
| /scrna-celltype-annotation | Phase 4 (强制) |

---

## Output Contract

每个 Phase 产出:
- 分析脚本: `scripts/phase{N}_*.R`
- 结果: `results/phase{N}/` (data + plots)
- 目录说明: `results/phase{N}/README_文件说明.md`
- 执行日志: `results/phase{N}/phase{N}_*.log` (含版本+时间戳)

---

## Resources

| 文件 | 用途 |
|------|------|
| SKILL.md (本文件) | 完整 pipeline 定义 |
| /scrna-celltype-annotation | 细胞注释子 skill |
| HARDWARE_CONFIG.md template | 硬件配置模板 |

## 关联 Skill（网络调度协议）

| 关系 | Skill | 场景 |
|------|-------|------|
| 可调用 | scrna-celltype-annotation | 全流程中的注释步骤 |
| 可调用 | ai4s-dry-lab | 高级分析环节 |
| 被调用 | vitaforge-orchestrator | scRNA-seq 全流程 |
