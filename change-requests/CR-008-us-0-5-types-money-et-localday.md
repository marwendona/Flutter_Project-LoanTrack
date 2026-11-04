# CR-008 — US-0.5 : types `Money` et `LocalDay`

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Technique |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — (non livrée, prévue en 1.0.0) |

## 1. Demande

Créer les types de base pour les montants et les dates (US-0.5, epic E0).

## 2. Motivation

Éviter les erreurs d'arrondi sur l'argent et les décalages de fuseau / heure d'été sur les dates (RG-40, ENF-05, `AGENTS.md` §5).

## 3. Changement proposé

- `Money(int amountMinor)` : montant en unités mineures (TND : millimes), addition, soustraction, comparaison ; jamais de `double`.
- `Currency` (code ISO 4217 + nombre de décimales), `Currency.tnd` par défaut (3 décimales).
- `MoneyParser` : saisie utilisateur → unités mineures (`"1250,5"` → `1250500`), saisies invalides refusées.
- `MoneyFormatter` : `1 250,500 TND` (espaces insécables).
- `LocalDay` : jour sans heure, stocké en `epochDay`, création depuis `clock.now()`, comparaison ; `DateFormatter` au format `dd/MM/yyyy`.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucun (applique RG-40 et « Formats d'affichage ») |
| Écrans | Aucun |
| Base de données | Non (convertisseur `LocalDay` livré avec CR-007) |
| Format d'export JSON | Non |
| Backlog | US-0.5 |
| Tests | `test/core/money/*_test.dart`, `test/core/date/local_day_test.dart` |

## 5. Critères d'acceptation

- [x] `Money` : addition, soustraction, comparaison.
- [x] Parsing et formatage des montants.
- [x] `LocalDay` : `clock.now()`, comparaison, `epochDay`, `dd/MM/yyyy`.
- [x] Tests couvrant 0, 2 et 3 décimales, saisies invalides, changement d'heure.

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : `88adaab`.
