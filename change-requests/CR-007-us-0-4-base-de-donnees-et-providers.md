# CR-007 — US-0.4 : base de données et providers

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Technique |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | 1.0.0+1 |

## 1. Demande

Créer la base de données locale et l'injection de dépendances (US-0.4, epic E0).

## 2. Motivation

Persister emprunteurs, prêts et remboursements hors ligne, selon le schéma v1 de `docs/ARCHITECTURE_TECHNIQUE.md` §5.

## 3. Changement proposé

- `AppDatabase` Drift, schéma **v1** : tables `borrowers` (avec `name_key` unique pour RG-02), `loans`, `repayments` ; clés étrangères `ON DELETE CASCADE` (`PRAGMA foreign_keys = ON`) ; index `idx_loans_borrower` et `idx_repayments_loan` ; contrôle `amount_minor > 0`.
- Convertisseur `LocalDay` ↔ `epochDay`.
- DAOs (`BorrowersDao`, `LoansDao`, `RepaymentsDao`), repositories (interfaces dans `domain`, implémentations dans `data`) et mappers vers les modèles domaine `Borrower`, `Loan`, `Repayment` (freezed).
- `ProviderScope` à la racine ; providers `appDatabaseProvider` et repositories (`lib/data/providers.dart`).
- Schéma exporté dans `drift_schemas/drift_schema_v1.json`.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucun (applique le modèle de `02-regles-metier.md` §1) |
| Écrans | Aucun |
| Base de données | Création du schéma v1 |
| Format d'export JSON | Non |
| Backlog | US-0.4 |
| Tests | `test/data/database/app_database_test.dart`, `test/data/repositories/repositories_test.dart` |

## 5. Critères d'acceptation

- [x] `ProviderScope` et providers de base.
- [x] `AppDatabase` v1 : 3 tables, cascade, index, convertisseur `LocalDay`.
- [x] Schéma v1 exporté dans `drift_schemas/`.
- [x] Tests DAO en mémoire : insertion, lecture, cascade.

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : `88adaab`.
