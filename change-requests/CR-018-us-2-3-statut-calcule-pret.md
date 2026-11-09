# CR-018 — US-2.3 : statut calculé d'un prêt

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | 1.0.0+1 |

## 1. Demande

Calculer le statut d'un prêt (RG-20) et le nombre de jours de retard (RG-23) à partir de la date du jour injectée, avec des tests couvrant chaque statut et les cas limites (US-2.3).

## 2. Motivation

Le statut n'est jamais stocké (règle non négociable n° 3) : il doit être dérivé de façon fiable et testée, car il conditionne l'affichage (ECR-03), les totaux en retard (RG-30, RG-31) et plus tard le tableau de bord.

## 3. Changement proposé

- Le calcul a été livré avec US-2.2 (CR-017) dans `LoanStatusCalculator.compute`. Cette CR le valide :
  - **Nommage** : on conserve `LoanStatusCalculator` (`lib/domain/services/loan_status_calculator.dart`), conforme à `ARCHITECTURE_TECHNIQUE.md` et à `BorrowerSummaryCalculator`. Le nom `ComputeLoanStatus` du backlog n'est pas repris ; le backlog est mis à jour.
  - **Règle « en retard » centralisée** : nouvelle méthode `LoanStatusCalculator.overdueDays` (jours de retard, `null` si le prêt n'est pas en retard), utilisée par `compute` et par `BorrowerSummaryCalculator.isOverdue`. La règle RG-20 n'est plus écrite qu'à un seul endroit.
  - La date du jour reste un paramètre (`today`). En production, elle est fournie par `LocalDay.today()`, qui lit `clock`.
- Tests unitaires complétés : chaque statut, ordre d'évaluation de RG-20, cas limites.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucune (RG-20, RG-23 inchangées) |
| Écrans | Aucun (comportement inchangé) |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-2.3 : nommage mis à jour, story terminée |
| Tests | `loan_status_calculator_test.dart` complété |

## 5. Critères d'acceptation

- [x] Calcul du statut implémentant RG-20 et le nombre de jours de retard (RG-23), avec date du jour injectée.
- [x] Tests unitaires couvrant chaque statut et les cas limites (échéance aujourd'hui = pas en retard, reste dû 0 avec date dépassée = Remboursé).
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (105 tests).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - Aucun changement de comportement visible : ECR-03 et la liste des emprunteurs utilisent la même règle qu'avant, désormais écrite à un seul endroit.
  - Cas limites ajoutés : échéance aujourd'hui (avec et sans remboursement), un millime restant, remboursé supérieur au montant (cas défensif, interdit par RG-16), retard sur plusieurs mois et années et sur un 29 février, statut qui change selon la date injectée.
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
