# prompt-enhancer upstream update checker
# Usage:
#   check-updates.ps1              check only, report if updates available
#   check-updates.ps1 -Diff         show what changed (file-level diff summary)
#   check-updates.ps1 -SetBaseline  record current latest SHAs as baseline
#   check-updates.ps1 -AutoMerge    auto-merge direct-copy files only
param([switch]$Diff, [switch]$SetBaseline, [switch]$AutoMerge)

$skillDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$metaFile = Join-Path $skillDir "upstreams.json"
$meta = Get-Content $metaFile -Raw | ConvertFrom-Json

$headers = @{ "Accept" = "application/vnd.github.v3+json" }
if ($env:GITHUB_TOKEN) { $headers["Authorization"] = "Bearer $env:GITHUB_TOKEN" }

$updatesFound = $false

foreach ($key in $meta.upstreams.PSObject.Properties.Name) {
    $up = $meta.upstreams.$key
    $repoOwner, $repoName = $up.repo -replace 'https://github.com/', '' -split '/'
    Write-Host "=== $key ===" -ForegroundColor Cyan

    try {
        # Fetch latest commit SHA for the skill path within the repo
        $apiUrl = "https://api.github.com/repos/$repoOwner/$repoName/commits?path=$($up.skill_path)&per_page=1"
        $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers -TimeoutSec 15
        $latestSha = $response[0].sha
        $latestDate = $response[0].commit.committer.date

        if ($SetBaseline) {
            $up.last_merged_sha = $latestSha
            Write-Host "  Baseline set: $($latestSha.Substring(0,7)) ($latestDate)" -ForegroundColor Green
            $updatesFound = $true
            continue
        }

        if (-not $up.last_merged_sha) {
            Write-Host "  No baseline SHA — run with -SetBaseline first" -ForegroundColor Yellow
            Write-Host "  Latest: $($latestSha.Substring(0,7)) ($latestDate)" -ForegroundColor Yellow
            $updatesFound = $true
            continue
        }

        if ($latestSha -eq $up.last_merged_sha) {
            Write-Host "  Up to date (SHA: $($latestSha.Substring(0,7)))" -ForegroundColor Green
            continue
        }

        Write-Host "  UPDATE AVAILABLE" -ForegroundColor Red
        Write-Host "  Baseline: $($up.last_merged_sha.Substring(0,7))  →  Latest: $($latestSha.Substring(0,7)) ($latestDate)"
        $updatesFound = $true

        if ($Diff) {
            $compareUrl = "https://api.github.com/repos/$repoOwner/$repoName/compare/$($up.last_merged_sha)...$latestSha"
            $compare = Invoke-RestMethod -Uri $compareUrl -Headers $headers -TimeoutSec 15

            $skillFiles = $compare.files | Where-Object {
                $_.filename -like "$($up.skill_path)/*"
            }

            if ($skillFiles) {
                Write-Host "  Changed in skill path:" -ForegroundColor Yellow
                foreach ($f in $skillFiles) {
                    $relativePath = $f.filename -replace "^$([regex]::Escape($up.skill_path))/", ""
                    $mapped = $up.mapped_to.$relativePath
                    $mapInfo = if ($mapped) { " → $mapped" } else { " → [NEW — needs mapping in upstreams.json]" }
                    Write-Host "    [$($f.status)] $relativePath$mapInfo"
                }
            } else {
                Write-Host "  (no changes within skill path — other repo files changed)" -ForegroundColor DarkGray
            }
        }

        if ($AutoMerge) {
            Write-Host "  AutoMerge: checking direct-copy files..." -ForegroundColor Yellow
            foreach ($file in $up.merged_files) {
                $mapped = $up.mapped_to.$file
                if ($mapped -match "direct copy") {
                    $rawUrl = "https://raw.githubusercontent.com/$repoOwner/$repoName/$latestSha/$($up.skill_path)/$file"
                    try {
                        $content = Invoke-RestMethod -Uri $rawUrl -Headers $headers -TimeoutSec 10
                        $targetFile = Join-Path $skillDir $file
                        $content | Out-File -FilePath $targetFile -Encoding UTF8 -NoNewline
                        Write-Host "    ✓ Merged: $file (direct copy)" -ForegroundColor Green
                    } catch {
                        Write-Host "    ✗ Failed: $file — $_" -ForegroundColor Red
                    }
                } else {
                    Write-Host "    ⚠ Skipped: $file → $mapped (manual review required)" -ForegroundColor Yellow
                }
            }
            # After auto-merge, update baseline
            if ($AutoMerge) { $up.last_merged_sha = $latestSha }
        }

    } catch {
        Write-Host "  ERROR: $_" -ForegroundColor Red
    }
    Write-Host ""
}

# Persist
$meta.last_check = (Get-Date).ToString("o")
$meta | ConvertTo-Json -Depth 6 | Out-File -FilePath $metaFile -Encoding UTF8

if ($SetBaseline) {
    Write-Host "Baselines recorded. Run without flags to check for future updates." -ForegroundColor Green
} elseif (-not $updatesFound) {
    Write-Host "All upstreams up to date." -ForegroundColor Green
} else {
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Review diffs:    .\check-updates.ps1 -Diff"
    Write-Host "  2. Manual merge into prompt-enhancer SKILL.md + references/"
    Write-Host "  3. Auto-merge safe: .\check-updates.ps1 -AutoMerge"
    Write-Host "  4. Record baseline: .\check-updates.ps1 -SetBaseline"
}
