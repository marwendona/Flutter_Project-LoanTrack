# CR-015 — Change Request obligatoire pour tout changement

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Processus |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-11-04 |
| **Version livrée** | — (sans effet sur l'APK) |

## 1. Demande

Les agents IA doivent créer une Change Request pour **tous** les changements, y compris l'implémentation de chaque user story.

## 2. Motivation

Les stories des epics E0 et E1 ont été implémentées sans CR. Il a fallu les créer après coup (CR-004 à CR-014). Le propriétaire veut un historique complet et à jour de chaque modification du dépôt.

## 3. Changement proposé

- Une CR pour tout changement du dépôt, sans exception : user story (une CR par story), règle, écran, choix technique, dépendance, correction de bug, refactoring, configuration, documentation, fichiers d'agents.
- La CR est créée **avant** la modification (statut `En cours`), puis passée à `Implémentée` à la fin, avec les critères cochés et les réserves éventuelles.
- Les changements liés à une même demande sont regroupés dans une seule CR.
- Les messages de commit référencent la CR (ex. `[US-1.2, CR-011]`).
- Fin de l'exception « corrections de bug et refactorings sans CR ».

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucun |
| Écrans | Aucun |
| Base de données | Non |
| Format d'export JSON | Non |
| Agents IA | `AGENTS.md` §8 (processus) et §9 (Definition of Done) ; `CLAUDE.md` (CR systématique, plan, fin de tâche, format des commits) |
| Processus | `change-requests/README.md` : suppression de la liste « Non concerné » |
| Backlog | Aucun |
| Tests | Aucun |

## 5. Critères d'acceptation

- [x] `AGENTS.md` impose une CR pour tout changement, créée avant la modification.
- [x] La Definition of Done d'une story exige sa CR passée à `Implémentée`.
- [x] `CLAUDE.md` reprend la règle et la référence de la CR dans les commits.
- [x] `change-requests/README.md` ne prévoit plus d'exception.

## 6. Décision

**Approuvée** par le propriétaire le 2026-11-04.

## 7. Suivi de l'implémentation

- Fichiers modifiés : `AGENTS.md`, `CLAUDE.md`, `change-requests/README.md`.
- Remarques : la CR de ce changement a été rédigée après les modifications des fichiers de configuration. Les changements suivants appliquent la règle dès leur début.
