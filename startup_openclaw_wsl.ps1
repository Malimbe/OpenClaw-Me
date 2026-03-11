# ============================================================
# Script de démarrage OpenClaw + Ollama (Windows natif)
# Auteur: Antigravity — Ce script peut être placé dans shell:startup
# Ollama est utilisé en mode Windows natif (pas WSL)
# ============================================================

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Démarrage OpenClaw + Ollama         " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# 1. Vérifier qu'Ollama est lancé sur Windows
Write-Host "[1/3] Vérification d'Ollama (Windows)..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://127.0.0.1:11434" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    Write-Host "    -> Ollama Windows actif sur port 11434 ✓" -ForegroundColor Green
} catch {
    Write-Host "    [!] Ollama non détecté — tentative de démarrage..." -ForegroundColor Red
    Start-Process "ollama" -ArgumentList "serve" -WindowStyle Hidden
    Start-Sleep -s 5
    Write-Host "    -> Ollama démarré ✓" -ForegroundColor Green
}

# 2. Vérifier les modèles disponibles
Write-Host "[2/3] Vérification des modèles Ollama..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://127.0.0.1:11434/api/tags" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    $models = ($response.Content | ConvertFrom-Json).models
    if ($models.Count -gt 0) {
        Write-Host "    -> Modèles disponibles:" -ForegroundColor Green
        foreach ($m in $models) {
            Write-Host "       * $($m.name)" -ForegroundColor White
        }
    } else {
        Write-Host "    [!] Aucun modèle disponible." -ForegroundColor Yellow
        Write-Host "    -> Conseil: exécutez 'ollama pull qwen2.5-coder:1.5b' pour télécharger un modèle" -ForegroundColor Yellow
    }
} catch {
    Write-Host "    [!] Impossible de lister les modèles: $_" -ForegroundColor Red
}

# 3. Vérifier la configuration OpenClaw
Write-Host "[3/3] Vérification de la configuration OpenClaw..." -ForegroundColor Yellow
$configPath = "$env:USERPROFILE\.openclaw\openclaw.json"
if (Test-Path $configPath) {
    $config = Get-Content $configPath -Raw | ConvertFrom-Json
    $baseUrl = $config.models.providers.ollama.baseUrl
    $defaultModel = $config.agents.defaults.model
    Write-Host "    -> OpenClaw configuré ✓" -ForegroundColor Green
    Write-Host "       Provider Ollama : $baseUrl" -ForegroundColor White
    Write-Host "       Modèle par défaut : $defaultModel" -ForegroundColor White
} else {
    Write-Host "    [!] Fichier de config OpenClaw non trouvé: $configPath" -ForegroundColor Red
}

Write-Host ""
Write-Host "OpenClaw est prêt ! Lancez 'openclaw tui' pour démarrer." -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
