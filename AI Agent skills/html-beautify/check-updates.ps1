# html-beautify upstream update checker
# Fuses two upstreams: pbakaus/impeccable + emilkowalski/skills.
# Usage:
#   check-updates.ps1              check only, report if updates available
#   check-updates.ps1 -Diff         show what changed (file-level diff summary)
#   check-updates.ps1 -SetBaseline  record current latest SHAs as baseline
#   check-updates.ps1 -AutoMerge    auto-merge direct-copy files only
param([switch]$Diff, [switch]$SetBaseline, [switch]$AutoMerge)

$ErrorActionPreference = "Stop"
$skillDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$metaFile = Join-Path $skillDir "upstreams.json"
$meta = Get-Content $metaFile -Raw | ConvertFrom-Json

$headers = @{ "Accept" = "application/vnd.github.v3+json" }
if ($env:GITHUB_TOKEN) { $headers["Authorization"] = "Bearer $env:GITHUB_TOKEN" }

# Local-patch marker: files whose local copy was rewritten
# ('skills/impeccable' -> 'skills/html-beautify') must NOT be
# auto-overwritten; after an upstream update they need the same
# sed re-applied. Detect by marker string, not by list, so the
# protection follows the actual file state.
$patchMarker = "skills/html-beautify"
$updatesFound = $false

foreach ($key in $meta.upstreams.PSObject.Properties.Name) {
    $up = $meta.upstreams.$key
    $repoOwner, $repoName = ($up.repo -replace 'https://github.com/', '') -split '/'
    Write-Host "=== $key ===" -ForegroundColor Cyan

    try {
        # Latest commit SHA touching the skill path within the repo
        $apiUrl = "https://api.github.com/repos/$repoOwner/$repoName/commits?path=$($up.skill_path)&per_page=1"
        $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers -TimeoutSec 20
        $latestSha = $response[0].sha
        $latestDate = $response[0].commit.committer.date

        if ($SetBaseline) {
            $up.last_merged_sha = $latestSha
            Write-Host "  Baseline set: $($latestSha.Substring(0,7)) ($latestDate)" -ForegroundColor Green
            $updatesFound = $true
            continue
        }

        if ($latestSha -eq $up.last_merged_sha) {
            Write-Host "  Up to date (SHA: $($latestSha.Substring(0,7)))" -ForegroundColor Green
            continue
        }

        Write-Host "  UPDATE AVAILABLE" -ForegroundColor Red
        Write-Host "  Baseline: $($up.last_merged_sha.Substring(0,7))  ->  Latest: $($latestSha.Substring(0,7)) ($latestDate)"
        $updatesFound = $true

        if ($Diff) {
            $compareUrl = "https://api.github.com/repos/$repoOwner/$repoName/compare/$($up.last_merged_sha)...$latestSha"
            $compare = Invoke-RestMethod -Uri $compareUrl -Headers $headers -TimeoutSec 20
            $skillFiles = $compare.files | Where-Object { $_.filename -like "$($up.skill_path)/*" }
            if ($skillFiles) {
                Write-Host "  Changed in skill path:" -ForegroundColor Yellow
                foreach ($f in $skillFiles) {
                    $relativePath = $f.filename -replace "^$([regex]::Escape($up.skill_path))/", ""
                    Write-Host "    [$($f.status)] $relativePath"
                }
            } else {
                Write-Host "  (no changes within skill path — other repo files changed)" -ForegroundColor DarkGray
            }
        }

        if ($AutoMerge) {
            Write-Host "  AutoMerge: downloading skill subtree via codeload tarball..." -ForegroundColor Yellow
            $tmpDir = Join-Path $env:TEMP ("html-beautify-update-" + $repoOwner + "-" + $repoName)
            if (Test-Path $tmpDir) { Remove-Item $tmpDir -Recurse -Force }
            New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
            $tarball = Join-Path $tmpDir "repo.tar.gz"
            $tarballUrl = "https://codeload.github.com/$repoOwner/$repoName/tar.gz/refs/heads/main"
            try {
                Invoke-WebRequest -Uri $tarballUrl -OutFile $tarball -TimeoutSec 300
            } catch {
                Write-Host "  ERROR: tarball download failed for $tarballUrl ($_)" -ForegroundColor Red
                Remove-Item $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
                continue
            }
            # Use Windows bsdtar explicitly: Git Bash's GNU tar is often first on PATH
            # and misparses "C:\..." as a remote host (host:path syntax).
            $tarExe = Join-Path $env:SystemRoot "System32\tar.exe"
            & $tarExe -xzf $tarball -C $tmpDir 2>$null
            if ($LASTEXITCODE -ne 0 -and -not (Get-ChildItem $tmpDir -Directory | Where-Object Name -match "$repoName-")) {
                Write-Host "  ERROR: tar extraction failed" -ForegroundColor Red
                Remove-Item $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
                continue
            }
            $extractedRoot = Get-ChildItem $tmpDir -Directory | Where-Object Name -match "^$repoName-" | Select-Object -First 1
            $upstreamSkillDir = Join-Path $extractedRoot.FullName ($up.skill_path -replace '/', '\')

            if ($key -eq "emilkowalski/skills") {
                # Direct copy: whole subtree, no local patches
                $dest = Join-Path $skillDir "reference\emil"
                Copy-Item (Join-Path $upstreamSkillDir '*') $dest -Recurse -Force
                Write-Host "    v Merged: skills/ -> reference/emil/ (direct copy)" -ForegroundColor Green
            } elseif ($up.dest_map) {
                # Generic dest_map branch (anthropics/skills, qiaomu-design, ...):
                # maps upstream relative paths to local destinations, file- or directory-level
                foreach ($srcRel in $up.dest_map.PSObject.Properties.Name) {
                    $destRel = $up.dest_map.$srcRel
                    $srcPath = Join-Path $upstreamSkillDir ($srcRel -replace '/', '\')
                    if (-not (Test-Path $srcPath)) {
                        Write-Host "    ! Missing upstream path: $srcRel" -ForegroundColor DarkYellow
                        continue
                    }
                    $destPath = Join-Path $skillDir ($destRel -replace '/', '\')
                    if (Test-Path $srcPath -PathType Container) {
                        # Directory-level: copy with patch protection per file
                        $srcFiles = Get-ChildItem $srcPath -Recurse -File
                        foreach ($sf in $srcFiles) {
                            $rel = $sf.FullName.Substring($srcPath.Length).TrimStart('\','/')
                            $target = Join-Path $destPath $rel
                            $isPatched = $false
                            if (Test-Path $target) {
                                $localContent = Get-Content $target -Raw -ErrorAction SilentlyContinue
                                if ($localContent -match [regex]::Escape($patchMarker)) { $isPatched = $true }
                            }
                            if ($isPatched) {
                                Write-Host "    ! Skipped (locally patched): $destRel/$rel" -ForegroundColor DarkYellow
                            } else {
                                New-Item -ItemType Directory -Force -Path (Split-Path $target) | Out-Null
                                Copy-Item $sf.FullName $target -Force
                            }
                        }
                        Write-Host "    v Merged: $srcRel -> $destRel (directory, patch-protected)" -ForegroundColor Green
                    } else {
                        # File-level rename
                        New-Item -ItemType Directory -Force -Path (Split-Path $destPath) | Out-Null
                        Copy-Item $srcPath $destPath -Force
                        Write-Host "    v Merged: $srcRel -> $destRel" -ForegroundColor Green
                    }
                }
            } else {
                # impeccable: reference/ + scripts/ with patch protection
                foreach ($sub in @("reference", "scripts")) {
                    $srcDir = Join-Path $upstreamSkillDir $sub
                    if (-not (Test-Path $srcDir)) { continue }
                    $destDir = Join-Path $skillDir $sub
                    $srcFiles = Get-ChildItem $srcDir -Recurse -File
                    foreach ($sf in $srcFiles) {
                        $rel = $sf.FullName.Substring($srcDir.Length).TrimStart('\','/')
                        $target = Join-Path $destDir $rel
                        $isPatched = $false
                        if (Test-Path $target) {
                            $localContent = Get-Content $target -Raw -ErrorAction SilentlyContinue
                            if ($localContent -match [regex]::Escape($patchMarker)) { $isPatched = $true }
                        }
                        if ($isPatched) {
                            Write-Host "    ! Skipped (locally patched): $sub/$rel — after update re-apply: sed -i 's|skills/impeccable|skills/html-beautify|g'" -ForegroundColor DarkYellow
                        } else {
                            $destFile = Join-Path $destDir $rel
                            New-Item -ItemType Directory -Force -Path (Split-Path $destFile) | Out-Null
                            Copy-Item $sf.FullName $destFile -Force
                            Write-Host "    v Merged: $sub/$rel" -ForegroundColor Green
                        }
                    }
                }
                Write-Host "    NOTE: SKILL.md is a manual fusion — review upstream changes and merge into html-beautify SKILL.md by hand." -ForegroundColor Yellow
            }
            Remove-Item $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
            # Record the merge point after successful auto-merge
            $up.last_merged_sha = $latestSha
        }
    } catch {
        Write-Host "  ERROR: $_" -ForegroundColor Red
    }
    Write-Host ""
}

# Persist
$meta.last_check = (Get-Date).ToString("o")
$meta | ConvertTo-Json -Depth 8 | Out-File -FilePath $metaFile -Encoding UTF8

if ($SetBaseline) {
    Write-Host "Baselines recorded. Run without flags to check for future updates." -ForegroundColor Green
} elseif (-not $updatesFound) {
    Write-Host "All upstreams up to date." -ForegroundColor Green
} else {
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Review diffs:       .\check-updates.ps1 -Diff"
    Write-Host "  2. Auto-merge safe:    .\check-updates.ps1 -AutoMerge"
    Write-Host "  3. Re-patch skipped files: sed -i 's|skills/impeccable|skills/html-beautify|g' (scripts/ + reference/)"
    Write-Host "  4. Manual-merge SKILL.md changes from upstream impeccable into html-beautify SKILL.md"
    Write-Host "  5. Record baseline:    .\check-updates.ps1 -SetBaseline"
}
