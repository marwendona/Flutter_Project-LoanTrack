# CR-025 — US-4.2 : totaux par emprunteur

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | 1.0.0+1 |

## 1. Demande

Voir, pour chaque emprunteur, le total prêté, le total remboursé et le reste dû afin de comparer les situations (US-4.2).

## 2. Motivation

Le tableau de bord (ECR-01) n'affiche que les totaux globaux (US-4.1) : la répartition par emprunteur n'est visible qu'en ouvrant chaque fiche.

## 3. Changement proposé

- ECR-01 : liste « Par emprunteur » sous les indicateurs globaux. Pour chaque emprunteur : nom, total prêté, total remboursé, reste dû, badge « En retard » le cas échéant (RG-30).
- Tri : reste dû décroissant puis nom A→Z (RG-04), en réutilisant `borrowerSummariesProvider` et `BorrowerSummaryCalculator` (aucune nouvelle logique métier).
- Appui sur un emprunteur → ECR-03 (détail emprunteur).

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Non (ECR-01, RG-04 et RG-30 déjà décrits) |
| Écrans | ECR-01 (liste par emprunteur) |
| Base de données | Non (schéma v1 inchangé) |
| Format d'export JSON | Non |
| Backlog | US-4.2 terminée |
| Tests | Tests de widgets d'ECR-01 |

## 5. Critères d'acceptation

- [x] Liste sous les indicateurs : nom, total prêté, total remboursé, reste dû, badge « En retard ». — RG-30
- [x] Tri RG-04.
- [x] Appui sur un emprunteur → détail emprunteur (ECR-03).
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (201 tests, dont 4 nouveaux).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - Fichiers : `lib/features/dashboard/dashboard_screen.dart` (section `_ByBorrowerSection` / `_BorrowerTotalsTile`, paramètre `style` ajouté à `_IndicatorRow`), `lib/l10n/app_fr.arb` (`dashboardByBorrowerTitle`) et fichiers l10n générés ; tests `test/features/dashboard/dashboard_screen_test.dart` (routeur de test et override de `borrowerSummariesProvider` ajoutés).
  - Le tri RG-04 n'est pas recalculé à l'écran : il provient de `BorrowerSummaryCalculator.summarizeAll`, déjà couvert par `borrower_summary_calculator_test.dart` ; le test de widgets vérifie que l'ordre du provider est conservé.
  - **Tous les emprunteurs** sont listés, y compris ceux sans prêt (totaux à 0), conformément à « pour chaque emprunteur » d'ECR-01. La liste n'apparaît que si au moins un prêt existe (sinon l'état vide d'ECR-01 s'affiche, CR-024).
  - L'appui navigue avec `context.go` vers `/borrowers/:id` : l'onglet *Emprunteurs* devient actif et le retour depuis ECR-03 ramène à la liste des emprunteurs, pas au tableau de bord (comportement de la navigation par onglets, identique à ECR-02).
  - Les filtres *Tous* / *Avec reste dû* / *En retard* relèvent d'US-4.3 et ne sont pas inclus.
  - Mode sombre : uniquement des couleurs du thème (`onSurfaceVariant`, `OverdueBadge`) ; rendu visuel sur appareil à confirmer (US-6.4).
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
