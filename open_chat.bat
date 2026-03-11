@echo off
:: Ouvre une session de chat OpenClaw avec Ollama local (Windows)
title OpenClaw Chat - Ollama Local
color 0A

echo.
echo  ╔════════════════════════════════════════╗
echo  ║       OpenClaw - Chat IA Local         ║
echo  ║   Model: ollama/qwen2.5:14b     ║
echo  ║   Ollama: http://127.0.0.1:11434       ║
echo  ╚════════════════════════════════════════╝
echo.

:: Vérifier qu'Ollama tourne
curl -s http://127.0.0.1:11434 >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [!] Ollama non détecté sur le port 11434 — démarrage...
    start /B ollama serve
    timeout /t 5 /nobreak >nul
    echo [✓] Ollama démarré
) ELSE (
    echo [✓] Ollama actif sur http://127.0.0.1:11434
)

:: Vérifier que la gateway OpenClaw tourne
netstat -ano | findstr "18789" >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [!] Gateway non détectée — démarrage automatique...
    openclaw gateway start >nul 2>&1
    timeout /t 3 /nobreak >nul
    echo [✓] Gateway démarrée
) ELSE (
    echo [✓] Gateway OpenClaw active sur le port 18789
)

echo.
echo  Lancement du chat OpenClaw...
echo.

openclaw tui
