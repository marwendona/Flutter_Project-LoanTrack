# CR-002 — Passage à Flutter et IntelliJ IDEA, nom LoanTrack, décisions des questions ouvertes

| Champ | Valeur |
|---|---|
| **Statut** | Approuvée |
| **Type** | Technique + Règle métier |
| **Date de création** | 2026-10-30 |
| **Date de décision** | 2026-10-30 |
| **Version livrée** | — |

## 1. Demande

- Utiliser **Flutter** au lieu de Kotlin / Jetpack Compose, car c'est plus familier au développeur.
- Utiliser **IntelliJ IDEA** au lieu d'Android Studio.
- Prendre en compte les réponses du propriétaire dans `specifications/05-questions-ouvertes.md` : devise **TND** (Q-01), pas de changement de devise après saisie (Q-02), nom **LoanTrack** (Q-08).

## 2. Motivation

Développer plus vite et maintenir plus facilement l'application avec une technologie et un IDE déjà connus.

## 3. Changement proposé

- Stack : Flutter / Dart 3, Riverpod, Drift (SQLite), go_router, freezed / json_serializable, intl (ARB), file_picker, dynamic_color.
- IDE : IntelliJ IDEA (Community suffit) + plugins Flutter et Dart ; SDK Android installé sans Android Studio.
- Devise : TND par défaut (3 décimales) au lieu d'un choix au premier lancement (RG-40) ; changement de devise interdit dès qu'un prêt existe (RG-41, Q-02).
- Nom de l'application : **LoanTrack** au lieu de « Kridi » (Q-08) ; applicationId `com.loantrack.app`, paquet Dart `loantrack`.
- Aucun changement fonctionnel sur les écrans et les autres règles métier.

Analyse de faisabilité : **aucun point bloquant**. Limites acceptées (détaillées dans `ARCHITECTURE_TECHNIQUE.md` §10) : APK plus lourd (~15–20 Mo), Material You via un paquet, permission `INTERNET` présente uniquement en debug.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Nom | « Kridi » → « LoanTrack » dans tous les documents |
| Spécifications | `02-regles-metier.md` : RG-40 (TND par défaut), RG-41 (devise verrouillée dès qu'un prêt existe) ; `03-ecrans-et-parcours.md` : ECR-06 ; `04-exigences-non-fonctionnelles.md` : ENF-01, ENF-08 précisées ; `05-questions-ouvertes.md` : décisions + Q-09 |
| Architecture | `docs/ARCHITECTURE_TECHNIQUE.md` réécrit (v2.0) ; ADR-01 modifiée, ADR-07 et ADR-08 ajoutées |
| Agents IA | `AGENTS.md` et `CLAUDE.md` : stack, commandes, conventions Dart |
| Backlog | E0 (US-0.1 à US-0.6) réécrit pour Flutter ; US-5.1, US-6.1, US-6.2, US-6.3, US-6.4 ajustées |
| Configuration | `.gitignore` et `.editorconfig` adaptés à Flutter / Dart |
| Base de données | Aucune (projet non démarré) — schéma v1 identique, implémenté avec Drift |
| Format d'export JSON | Inchangé (version 1) |

## 5. Critères d'acceptation

- [ ] Documentation cohérente : aucune référence résiduelle à Kotlin / Compose / Room / Hilt / Android Studio comme choix retenu.
- [ ] Le projet Flutter s'ouvre, se compile et se lance depuis IntelliJ IDEA sur le S22 (vérifié en US-0.1).

## 6. Décision

**Approuvée** par le propriétaire le 2026-10-30 (conjointement avec CR-001).

## 7. Suivi de l'implémentation

- Appliquée dès l'epic E0.
