#!/usr/bin/env pwsh
# Converte as tarefas de tasks.md em arquivos de issue locais + um script gh para publicar no GitHub.
# Fallback do /speckit-taskstoissues quando não há remote GitHub configurado.
[CmdletBinding()]
param(
    [string]$FeatureDir = $PSScriptRoot
)
$ErrorActionPreference = 'Stop'

$tasksFile = Join-Path $FeatureDir 'tasks.md'
$issuesDir = Join-Path $FeatureDir 'issues'
New-Item -ItemType Directory -Path $issuesDir -Force | Out-Null

$lines = Get-Content -LiteralPath $tasksFile -Encoding UTF8
$currentPhase = ''
$issues = @()

foreach ($line in $lines) {
    if ($line -match '^##+\s+(.*)') { $currentPhase = $matches[1].Trim() }
    # Linha de tarefa: - [ ] T001 [P] [US1] descrição...
    if ($line -match '^\s*-\s*\[[ xX]\]\s*(T\d{3})\b\s*(.*)$') {
        $id = $matches[1]
        $rest = $matches[2]
        # Remove marcadores [P] e [US#]/[Story] do início
        $desc = ($rest -replace '^\s*(\[P\]\s*)?(\[[A-Za-z0-9]+\]\s*)?', '').Trim()
        $story = ''
        if ($rest -match '\[(US\d+)\]') { $story = $matches[1] }
        $parallel = ($rest -match '\[P\]')
        $issues += [PSCustomObject]@{
            Id = $id; Title = "$id`: $desc"; Description = $desc
            Phase = $currentPhase; Story = $story; Parallel = $parallel
        }
    }
}

# Gera um arquivo .md por issue
foreach ($i in $issues) {
    $labels = @('sigof')
    if ($i.Story) { $labels += $i.Story.ToLower() }
    if ($i.Parallel) { $labels += 'parallel' }
    $tick = [char]0x60
    $body = @"
**Task ID**: $($i.Id)
**Fase**: $($i.Phase)
$(if ($i.Story) { "**User Story**: $($i.Story)" })
$(if ($i.Parallel) { "**Paraleliz" + [char]0xE1 + "vel**: sim" })

## Descri$([char]0xE7)$([char]0xE3)o

$($i.Description)

---
_Issue gerada automaticamente a partir de ${tick}tasks.md${tick} (Spec-Kit /speckit-taskstoissues) para a feature 001-gestao-ocorrencias-frete._
"@
    $path = Join-Path $issuesDir "$($i.Id).md"
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($path, $body, $utf8NoBom)
}

# Índice
$indexLines = @('# Issues — SIGOF (001-gestao-ocorrencias-frete)', '',
    "Total de issues geradas: $($issues.Count)", '',
    '| ID | User Story | Fase | Título |', '|----|-----------|------|--------|')
foreach ($i in $issues) {
    $indexLines += "| [$($i.Id)]($($i.Id).md) | $($i.Story) | $($i.Phase) | $($i.Description) |"
}
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Join-Path $issuesDir 'INDEX.md'), ($indexLines -join "`n"), $utf8NoBom)

# Script gh para publicar no GitHub (executar após `git remote add origin <url>` e `gh auth login`)
$ghLines = @('#!/usr/bin/env pwsh',
    '# Publica as issues no GitHub. Requer: repositório git com remote origin (GitHub) e `gh auth login`.',
    '# Uso: ./create-github-issues.ps1',
    '$ErrorActionPreference = ''Stop''',
    'Push-Location $PSScriptRoot',
    'try {')
foreach ($i in $issues) {
    $labelArgs = "--label sigof"
    if ($i.Story) { $labelArgs += " --label $($i.Story.ToLower())" }
    $titleEsc = $i.Title.Replace('"','`"')
    $ghLines += "    gh issue create --title `"$titleEsc`" --body-file `"issues/$($i.Id).md`" $labelArgs"
}
$ghLines += '} finally { Pop-Location }'
[System.IO.File]::WriteAllText((Join-Path $FeatureDir 'create-github-issues.ps1'), ($ghLines -join "`n"), $utf8NoBom)

Write-Output "Geradas $($issues.Count) issues em: $issuesDir"
Write-Output "Indice: $(Join-Path $issuesDir 'INDEX.md')"
Write-Output "Script de publicacao: $(Join-Path $FeatureDir 'create-github-issues.ps1')"
