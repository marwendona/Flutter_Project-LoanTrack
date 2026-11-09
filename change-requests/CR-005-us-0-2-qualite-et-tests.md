# CR-005 — US-0.2 : qualité et tests

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Technique |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | 1.0.0+1 |

## 1. Demande

Mettre en place l'analyse statique et l'outillage de tests du projet (US-0.2, epic E0).

## 2. Motivation

Détecter les erreurs au plus tôt et garantir que chaque story est livrée avec des tests verts (Definition of Done, `AGENTS.md` §7 et §9).

## 3. Changement proposé

- `analysis_options.yaml` : `flutter_lints` + `strict-casts`, `strict-raw-types` et règles supplémentaires (`avoid_dynamic_calls`, `prefer_final_locals`, `require_trailing_commas`, `unawaited_futures`…) ; fichiers générés et `android/` exclus de l'analyse.
- Dépendances de test : `flutter_test`, `mocktail`.
- Un premier test (`test/app_test.dart`) vérifiant le démarrage de l'application.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucun |
| Écrans | Aucun |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-0.2 |
| Tests | Socle de tests créé |

## 5. Critères d'acceptation

- [x] `analysis_options.yaml` avec `flutter_lints` et règles strictes, fichiers générés exclus.
- [x] `flutter_test` + `mocktail` ; un test exemple passe.
- [x] `flutter analyze` sans avertissement.

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : `88adaab`.
