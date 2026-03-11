@echo off
:: Script de démarrage rapide pour OpenClaw avec Telegram
:: Lance la gateway avec le profil dev

cd /d "%USERPROFILE%"
start "" cmd /k "openclaw --dev gateway start"
timeout /t 3 /nobreak >nul
start "" cmd /k "openclaw --dev tui"
