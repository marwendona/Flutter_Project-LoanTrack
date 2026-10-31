# CR-001 — Initialisation du projet et périmètre V1

| Champ | Valeur |
|---|---|
| **Statut** | Approuvée |
| **Type** | Initialisation |
| **Date de création** | 2026-10-30 |
| **Date de décision** | 2026-10-30 |
| **Version livrée** | — |

## 1. Demande

Créer une application Android gratuite, à usage personnel, installée par APK sur un Samsung Galaxy S22, pour visualiser les crédits (argent prêté) :
- liste des emprunteurs avec ajout et suppression ;
- pour chaque emprunteur : montant donné, date du don, date de retour promise, date réelle de retour, montant retourné (remboursement partiel possible) ;
- vue de la totalité du crédit donné, globalement et par emprunteur.

Préparer : nom de l'application, `CLAUDE.md`, `AGENTS.md`, spécifications métier, dossier de change requests, document technique, backlog epics / user stories.

## 2. Motivation

Remplacer un suivi informel (mémoire, papier, notes) par un outil fiable, privé et toujours disponible.

## 3. Changement proposé

- Nom : ~~**Kridi** — package `com.kridi.app`~~ → remplacé par **LoanTrack** — `com.loantrack.app` (voir [CR-002](CR-002-flutter-et-intellij.md)).
- Modèle métier Emprunteur → Prêts → Remboursements (permet plusieurs prêts par personne et des remboursements partiels multiples).
- Spécifications V1 : `specifications/01` à `05`.
- Architecture : ~~Kotlin + Jetpack Compose + Room + Hilt, MVVM~~ → remplacée par Flutter (voir [CR-002](CR-002-flutter-et-intellij.md)), 100 % hors ligne (`docs/ARCHITECTURE_TECHNIQUE.md`).
- Backlog : epics E0 à E6 pour la V1, E7 pour la V2 (`docs/EPICS_ET_USER_STORIES.md`).
- Fonctionnalités ajoutées par rapport à la demande initiale, à valider :
  - export / import JSON (indispensable : les données n'existent que sur le téléphone) ;
  - statut « En retard » calculé automatiquement ;
  - paramètre de devise.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Création de la version 1.0 |
| Base de données | Schéma initial (version 1) |
| Format d'export JSON | Version 1 |
| Backlog | Création |

## 5. Critères d'acceptation

- [ ] Le propriétaire a relu et validé les spécifications.
- [ ] Les questions ouvertes (`specifications/05-questions-ouvertes.md`) sont tranchées.
- [ ] Les choix techniques sont validés.
- [ ] Le backlog et l'ordre des epics sont validés.

## 6. Décision

**Approuvée** par le propriétaire le 2026-10-30 (conjointement avec CR-002) : spécifications, questions ouvertes, choix techniques et backlog validés.

## 7. Suivi de l'implémentation

- Démarrage par l'epic E0 après approbation.
