# Klinhi - Documentation Maître 📚

**Dernière mise à jour** : 7 Mars 2026

⚠️ **INSTRUCTION CRITIQUE POUR TOUTE IA / DEVELOPPEUR** ⚠️
Avant de modifier ou d'ajouter une fonctionnalité dans Klinhi (Frontend, Backend ou MCP), vous DEVEZ lire et comprendre ce document pour garantir la stabilité, l'architecture et l'expérience utilisateur (UX) du projet.

---

## 1. VUE D'ENSEMBLE DU PROJET

**Klinhi** est une plateforme de gestion scolaire moderne et ultra-sécurisée avec un support multi-rôles (Étudiant, Parent, Professeur, Admin, SuperAdmin).
L'objectif principal est d'avoir une application sans faille (0 latence, UI/UX premium 9/10).

### Architecture Globale (La Trinité Klinhi)
1. **🚀 Le Frontend (Flutter)** : L'application cliente `Klinhi Lite`. Il utilise Riverpod pour la gestion d'état, GoRouter pour la navigation, et un Design System sombre très strict.
2. **🛡️ Le Backend (Go)** : L'API REST ultra-rapide (Gin, GORM, PostgreSQL) qui gère toute l'authentification (JWT) et le RBAC (Role-Based Access Control). Code hébergé sur GitHub via SSH.
3. **🧠 L'IA (Serveur MCP)** : Situé dans `Klinhi-Backend/mcp-server`. Écrit en TypeScript, il permet à l'IA Molbot/OpenClaw de dialoguer avec la base de données de l'école en respectant scrupuleusement les droits de l'utilisateur (Prof, Étudiant, Admin).

---

## 2. FRONTEND (Klinhi Lite - Flutter)

### A. Design System & UX/UI (Score visé : 10/10)
Tout nouveau développement visuel doit utiliser les composants situés dans `lib/src/common_widgets/` :
- **Couleurs (app_colors.dart)** : `#0F0F0F` (Fond Par défaut), `#C9FBBE` ou `#22C55E` (Accent/Primaire).
- **Style** : Dark Mode intégral. Bords arrondis (15px pour les cartes). Effets Glassmorphism et bordures subtiles (`Opacité 0.05`).
- **Composants Obligatoires** : 
  - `KlinhiButton` (inclut Loadings, Animations Scale)
  - `KlinhiTextField` (inclut Validation en temps réel)
  - `KlinhiCard` (Hover et état)
  - `KlinhiLoadingIndicator` / `SkeletonLoader` (Pour les temps d'attente réseau)
- **Les Icônes** : Utiliser exclusivement `LucideIcons` ou `BootstrapIcons`.

### B. Gestion d'État (State Management)
- **Framework OBLIGATOIRE** : `Riverpod` (^3.1.0).
- Le Provider doit gérer la logique (ex: `authRepositoryProvider`, `currentUserProvider`).  
- Les écrans (Widgets) ne doivent contenir **aucune** logique métier complexe, ils écoutent le Provider via `ConsumerWidget`.

### C. Validation & Formulaires
- Utiliser `AppValidators` (`lib/src/core/validators/app_validators.dart`) pour tous les formulaires (Email, Mot de passe, Matricule, Téléphone).
- Ne jamais coder en dur un regex dans un widget.

### D. Profils et Affichages
| Rôle | Couleur Associée | Accueil (HomeScreen) | Actions du rôle |
|---|---|---|---|
| **Student** | `#C9FBBE` | `/student/home` | Notes, Emploi du temps, Portefeuille. |
| **Professor** | `#22C55E` | `/teacher/home` | Appel, Saisie des notes, Agenda. |
| **Parent** | *(à définir)* | `/parent/home` | Suivi Enfants, Paiement, Alertes. |
| **Admin** | *(à définir)* | `/admin/home` | Statistiques, Finances, R.H., Logistique. |

---

## 3. BACKEND (Go - API REST)

### A. Architecture Clean
- **Dossiers** : `cmd/api` (EntryPoint), `internal/core/domain` (Modèles/Entités), `internal/adapters` (Handlers API, Repositories BD).
- **Rôles (RBAC)** : Gérés nativement. `STUDENT`, `PARENT`, `PROFESSOR`, `ADMIN`, `SUPERADMIN`.
- _Toute nouvelle route API doit utiliser le middleware :_ `middleware.RoleRequired(...)`.

### B. Base de Données (PostgreSQL)
- **ORM** : `GORM`
- N'ajouter un index que sur les clés étrangères fréquentes (`user_id`, `school_code`).
- Si besoin d'une transaction, utiliser les transactions Gorm pour prévenir les lock errors (notamment sur les Wallets).

---

## 4. INTELLIGENCE ARTIFICIELLE (Serveur MCP Klinhi-AI)

### A. Emplacement & Techno
- Dossier : `Klinhi-Backend/mcp-server/`
- Langage : TypeScript + Serveur Stdio via `@modelcontextprotocol/sdk`.

### B. Fonctionnement
- Le MCP interagit **directement** avec PostgreSQL (`pg` + `dbPool`), de manière asynchrone pour que l'IA puisse récupérer rapidement des données profilées.
- **Principe Strict** : Ne JAMAIS exposer "toute la base". L'outil de l'IA (le "Tool") doit toujours prendre en compte l'ID ou le Rôle de l'utilisateur qui fait la demande.
- Si le MCP doit écrire une donnée, il est préférable qu'il appelle l'API Go interne pour garantir l'intégrité des règles métiers, plutôt que d'écrire en dur dans PostgreSQL.

---

## 5. RECOMMANDATIONS & STANDARDS DE CONDUITE

1. **Stabilité Avant Tout** : Si un code est bancal, ne le commitez pas. Vérifiez toujours s'il n'y a pas déjà un composant existant avant d'en créer un nouveau.
2. **Propreté GitHub (Le Dépôt)** : Ne pas stocker des configurations locales (Molbot ou OpenClaw) dans les dépôts Github. Molbot reste chez le développeur, Klinhi.git vit sur le nuage.
3. **Tests** : 
   - Backend : Testez avec l'ID d'un rôle non autorisé pour valider le RBAC.
   - Frontend : Validez les inputs avant d'envoyer la requête.
4. **Mise à jour de cette Documentation** : À chaque fonctionnalité majeure ajoutée ou règle d'architecture modifiée, mettez à jour **ce** document : `KLINHI_MASTER_DOC.md`.

*Fin du document maître.*
