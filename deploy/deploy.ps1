# ============================================================================
# VitaForge 一键部署脚本 (Windows PowerShell)
# 用法: 在仓库根目录运行  .\deploy\deploy.ps1
# 行为: 合并部署 .claude/.codex/.gemini 到 %USERPROFILE%，并写入 .agents/skills，重名文件自动备份
# ============================================================================
#requires -Version 5.1
[CmdletBinding()]
param(
    [Alias('y')]
    [switch]$Yes
)

$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot  = Split-Path -Parent $ScriptDir
$HomeDir   = $env:USERPROFILE
$Timestamp = Get-Date -Format 'yyyyMMddHHmmss'

$env:PYTHONUTF8 = 1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ''
Write-Host '  ====================================================' -ForegroundColor Cyan
Write-Host '    VitaForge - 一键部署 (Windows PowerShell)' -ForegroundColor Cyan
Write-Host '  ====================================================' -ForegroundColor Cyan
Write-Host "  Source:  $RepoRoot"
Write-Host "  Target:  $HomeDir"
Write-Host ''

if (-not $Yes) {
    $confirm = Read-Host '  将合并部署 .claude/.codex/.gemini/.agents，重名文件自动备份。继续？(y/N)'
    if ($confirm -notmatch '^[yY]') {
        Write-Host '  已取消。' -ForegroundColor Yellow
        exit 0
    }
}
else {
    Write-Host '  非交互模式：已跳过确认。' -ForegroundColor Yellow
}

function Merge-VitaForgeDir {
    param(
        [string]$SubPath,
        [string]$TargetSubPath = $SubPath
    )
    $src = Join-Path $RepoRoot $SubPath
    $dst = Join-Path $HomeDir $TargetSubPath
    if (-not (Test-Path $src)) {
        Write-Host "  [SKIP] 源不存在: $SubPath" -ForegroundColor DarkGray
        return
    }
    if (-not (Test-Path $dst)) {
        New-Item -ItemType Directory -Force -Path $dst | Out-Null
    }
    $relSrc = Get-Item $src
    $bakCount = 0
    Get-ChildItem $src -Force | ForEach-Object {
        $target = Join-Path $dst $_.Name
        if (Test-Path $target) {
            $bak = "$target.vitaforge-bak.$Timestamp"
            Move-Item $target $bak -Force
            Write-Host "    [BACKUP] $($_.Name) -> $(Split-Path -Leaf $bak)" -ForegroundColor Yellow
            $bakCount++
        }
        Copy-Item $_.FullName $target -Recurse -Force
    }
    Write-Host "  [OK] $SubPath -> $TargetSubPath  (备份 $bakCount 项)" -ForegroundColor Green
}

Write-Host ''
Write-Host '  正在部署...' -ForegroundColor Cyan
Merge-VitaForgeDir '.claude\skills'
Merge-VitaForgeDir '.claude\commands'
Merge-VitaForgeDir '.claude\agents'
Merge-VitaForgeDir '.claude\scripts'
Merge-VitaForgeDir '.codex\skills'
Merge-VitaForgeDir '.codex\skills' '.agents\skills'
Merge-VitaForgeDir '.gemini\skills'

Write-Host ''
Write-Host '  ====================================================' -ForegroundColor Green
Write-Host '    ✅ VitaForge 部署完成！' -ForegroundColor Green
Write-Host '  ====================================================' -ForegroundColor Green
Write-Host ''
Write-Host '  下一步：' -ForegroundColor Cyan
Write-Host '    1. 启动 Claude Code'
Write-Host '    2. 输入 /skill-deploy          做高级融合去重 + 后平滑（推荐）'
Write-Host '    3. 或直接 /vitaforge-orchestrator 开始描述需求'
Write-Host ''
Write-Host '  MCP 配置（可选，提升文献/医学能力）：'
Write-Host '    参考 deploy/mcp-config.template.json'
Write-Host ''
