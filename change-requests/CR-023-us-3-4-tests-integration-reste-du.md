# CR-023 — US-3.4 : tests d'intégration du calcul de reste dû

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Technique |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | 1.0.0+1 |

## 1. Demande

Couvrir par des tests d'intégration (Drift en mémoire) les agrégations remboursé / reste dû par prêt et par emprunteur, y compris les prêts sans remboursement (US-3.4).

## 2. Motivation

Le reste dû (RG-21) et les totaux par emprunteur (RG-30) sont dérivés de requêtes SQL agrégées (`LEFT JOIN` + `SUM` + `GROUP BY`), jamais stockés. Une erreur de jointure (somme multipliée, remboursements d'un autre prêt comptés, prêt sans remboursement perdu ou à `NULL`) fausserait silencieusement tous les montants affichés.

## 3. Changement proposé

- Nouveau fichier de tests `test/data/database/daos/balance_aggregation_test.dart` sur `LoansDao` (`watchWithRepaymentsByBorrower`, `watchWithRepaymentsById`, `getWithRepaymentsById`) et `BorrowersDao.watchWithLoanBalances`, avec contrôle du reste dû par prêt et des totaux par emprunteur via `BorrowerSummaryCalculator`.
- Cas couverts : prêt sans remboursement (remboursé 0, dates `null`), plusieurs remboursements, prêt soldé, plusieurs prêts × plusieurs remboursements (pas de produit cartésien), isolation entre prêts et entre emprunteurs, emprunteur sans prêt, grands montants (au-delà de 2³¹ millimes), mise à jour réactive après ajout / modification / suppression de remboursement et suppression de prêt.
- Aucun changement de code de production.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Non |
| Écrans | Non |
| Base de données | Non (schéma v1 inchangé) |
| Format d'export JSON | Non |
| Backlog | US-3.4 terminée |
| Tests | Ajout des tests d'agrégation DAO |

## 5. Critères d'acceptation

- [x] Tests DAO : agrégations remboursé / reste dû par prêt et par emprunteur, y compris prêts sans remboursement.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (183 tests, dont 10 nouveaux).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - Aucun défaut trouvé dans les requêtes agrégées : aucun code de production modifié, pas de régénération nécessaire.
  - Les totaux par emprunteur sont vérifiés en passant les lignes de `BorrowersDao.watchWithLoanBalances` à `BorrowerSummaryCalculator.summarize`, comme le font les écrans ; il n'existe pas (encore) d'agrégation SQL par emprunteur — les totaux globaux relèvent d'US-4.1.
  - Les tests existants de `app_database_test.dart` et `repositories_test.dart` qui couvraient déjà une partie de ces agrégations sont conservés tels quels.
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
