# Documentation ClawBot - OpenClaw Telegram

## Overview

ClawBot est un bot IA basé sur OpenClaw qui utilise Telegram comme interface. Il est alimenté par le modèle local Ollama `qwen2.5-coder:1.5b`.

## Installation et Configuration

### Prérequis

- Node.js installé
- OpenClaw installé globalement (`npm install -g openclaw`)
- Ollama installé avec le modèle `qwen2.5-coder:1.5b`
- Un bot Telegram créé via @BotFather

### Structure des Fichiers

```
C:\Users\KONGO JOEL\Documents\MOLBOT\.openclaw-dev\
├── openclaw.json          # Configuration principale
├── agents/                # Configurations des agents
├── telegram/              # Données Telegram
├── canvas/                # Fichiers canvas
├── credentials/           # Identifiants
└── memory/                # Mémoire du bot
```

### Configuration Principale

Le fichier [`openclaw.json`](../../Documents/MOLBOT/.openclaw-dev/openclaw.json) contient :

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "dmPolicy": "allowlist",
      "allowFrom": [6900793067],
      "botToken": "VOTRE_TOKEN",
      "groupPolicy": "allowlist",
      "groupAllowFrom": [6900793067],
      "streaming": "partial"
    }
  }
}
```

## Politiques d'Accès

### dmPolicy (Messages Directs)

| Option | Description |
|--------|-------------|
| `pairing` | L'utilisateur doit être appairé via un code |
| `allowlist` | Seuls les IDs spécifiés peuvent envoyer des messages |
| `open` | Tout le monde peut envoyer des messages |
| `disabled` | Les messages directs sont désactivés |

### groupPolicy (Groupes)

| Option | Description |
|--------|-------------|
| `allowlist` | Seuls les IDs spécifiés peuvent écrire dans les groupes |
| `open` | Tout le monde peut écrire dans les groupes |

## Commandes

### Démarrer la Gateway

```bash
# Mode développement (Telegram)
openclaw --dev gateway

# Via le script batch
start_openclaw_dev.bat
```

### Interface de Chat

```bash
# Ouvrir le TUI
openclaw tui

# Via le script
open_chat.bat
```

### Couplage Telegram

```bash
# Approuver un nouveau utilisateur
openclaw --profile dev pairing approve telegram CODE_PAIRING
```

## Démarrage Rapide

1. **Démarrer Ollama** :
   ```bash
   ollama serve
   ollama pull qwen2.5-coder:1.5b
   ```

2. **Démarrer la Gateway** :
   ```bash
   openclaw --dev gateway
   ```

3. **Envoyer un message à @Clinhy_bot** sur Telegram

## Structure du Projet

### Fichiers de Lancement

| Fichier | Description |
|---------|-------------|
| `start_openclaw_dev.bat` | Script de démarrage rapide pour le mode dev |
| `open_chat.bat` | Ouvre une session de chat avec Ollama local |
| `start_openclaw.bat` | Script unifié pour WSL + Systemd |

### Ports Utilisés

| Port | Service |
|------|---------|
| 11434 | Ollama API |
| 18789 | Gateway OpenClaw (standard) |
| 19001 | Gateway OpenClaw (dev/Telegram) |
| 19003 | Serveur Browser/Canvas |

## Dépannage

### Le bot ne répond pas

1. Vérifier que la gateway est active :
   ```bash
   netstat -ano | findstr "19001"
   ```

2. Vérifier les logs dans le terminal

3. Redémarrer la gateway :
   ```bash
   taskkill /F /PID <PID>
   openclaw --dev gateway
   ```

### Avertissements Doctor

Si vous voyez des avertissements concernant `groupPolicy`, modifiez la configuration :

```json
"groupPolicy": "open"
```

ou ajoutez des IDs autorisés :

```json
"groupPolicy": "allowlist",
"groupAllowFrom": [6900793067]
```

## Informations Techniques

- **Modèle IA** : ollama/qwen2.5-coder:1.5b
- **Version OpenClaw** : 2026.3.2
- **Identité du bot** : C3-PO (🤖)
- **Token Bot** : Configuré via BotFather

## Annexe : Configuration Complète

```json
{
  "meta": {
    "lastTouchedVersion": "2026.3.2",
    "lastTouchedAt": "2026-03-11T19:22:00.000Z"
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "ollama/qwen2.5-coder:1.5b"
      },
      "workspace": "C:\\Users\\KONGO JOEL\\Documents\\MOLBOT\\.openclaw\\workspace-dev",
      "skipBootstrap": true
    },
    "list": [
      {
        "id": "dev",
        "default": true,
        "identity": {
          "name": "C3-PO",
          "theme": "protocol droid",
          "emoji": "🤖"
        }
      }
    ]
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "dmPolicy": "allowlist",
      "allowFrom": [6900793067],
      "groupPolicy": "allowlist",
      "groupAllowFrom": [6900793067],
      "streaming": "partial"
    }
  },
  "gateway": {
    "mode": "local",
    "bind": "loopback"
  }
}
```
