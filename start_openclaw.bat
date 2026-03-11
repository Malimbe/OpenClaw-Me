@echo off
:: Script de démarrage unifié Moltbot (WSL + Systemd)
:: Ce script garantit que le bot tourne dans WSL avec la config .openclaw-dev (Telegram)

echo [Moltbot] Vérification du service dans WSL...

:: S'assurer que le service est démarré dans WSL avec le profil dev (Telegram)
wsl -d Ubuntu -u monssio bash -c "systemctl --user start openclaw-gateway-dev 2>/dev/null || echo 'Service non trouvé, démarrage manuel...'"

:: Démarrer la gateway manuellement si le service n'existe pas (avec --dev pour Telegram)
wsl -d Ubuntu -u monssio bash -c "OPENCLAW_STATE_DIR=~/.openclaw-dev openclaw --dev gateway start > /dev/null 2>&1 &"

:: Vérifier si le port est ouvert (19001 pour --dev)
echo [Moltbot] Vérification de la gateway...
wsl -d Ubuntu -u monssio bash -c "sleep 3 && netstat -tlnp 2>/dev/null | grep -E '19001|18789' || echo 'Vérification ports...'"

echo [Moltbot] Connexion au terminal IA sur @Clinhy_bot...

:: Lancer le TUI via WSL avec le profil dev
wsl -d Ubuntu -u monssio bash -c "eval \"$(~/miniconda3/bin/conda shell.bash hook)\" && conda activate Moltbot && openclaw --dev tui"

pause
