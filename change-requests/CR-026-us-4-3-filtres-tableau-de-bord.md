# CR-026 — US-4.3 : filtres du tableau de bord

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | 1.0.0+1 |

## 1. Demande

Filtrer la liste « Par emprunteur » du tableau de bord : *Tous* / *Avec reste dû* / *En retard* (US-4.3).

## 2. Motivation

La liste « Par emprunteur » (US-4.2) affiche tous les emprunteurs, y compris ceux qui ont tout remboursé : il faut pouvoir isoler rapidement ceux qui doivent encore de l'argent ou qui sont en retard.

## 3. Changement proposé

- ECR-01 : boutons segmentés *Tous* / *Avec reste dû* / *En retard* sous le titre « Par emprunteur ».
  - *Tous* (par défaut) : tous les emprunteurs.
  - *Avec reste dû* : emprunteurs dont le reste dû est > 0.
  - *En retard* : emprunteurs ayant au moins un prêt en retard (RG-21).
- Le tri RG-04 est conservé ; les indicateurs globaux ne sont pas filtrés.
- Si aucun emprunteur ne correspond au filtre : message « Aucun emprunteur ne correspond à ce filtre ».
- Le filtre choisi est conservé en mémoire pendant la session (non persisté).

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | `03-ecrans-et-parcours.md` (ECR-01) : précision des critères des filtres |
| Écrans | ECR-01 |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-4.3 terminée |
| Tests | Tests unitaires du filtre, tests de widgets d'ECR-01 |

## 5. Critères d'acceptation

- [x] Filtres *Tous* / *Avec reste dû* / *En retard* sur la liste par emprunteur, *Tous* par défaut.
- [x] Tri RG-04 conservé, indicateurs globaux inchangés.
- [x] Message lorsqu'aucun emprunteur ne correspond au filtre.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (210 tests, dont 9 nouveaux).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - Fichiers : `lib/domain/models/borrower_summary_filter.dart` (enum pur Dart `BorrowerSummaryFilter` avec `matches` / `apply`), `lib/features/dashboard/dashboard_providers.dart` (`dashboardFilterProvider`, `dashboardBorrowersProvider`), `lib/features/dashboard/dashboard_screen.dart` (`_FilterButtons` en `SegmentedButton`, message d'absence de résultat), `lib/l10n/app_fr.arb` (4 clés `dashboardFilter*`) et fichiers l10n générés, `specifications/03-ecrans-et-parcours.md` (ECR-01 précisé).
  - Tests : `test/domain/models/borrower_summary_filter_test.dart` (5 tests) et groupe « filters (US-4.3) » de `test/features/dashboard/dashboard_screen_test.dart` (4 tests).
  - La section « Par emprunteur » (titre + filtres) reste affichée dès qu'au moins un emprunteur existe, même si le filtre ne retourne rien, pour pouvoir revenir à *Tous*.
  - Le filtre est un état Riverpod en mémoire : conservé en changeant d'onglet, remis à *Tous* au redémarrage de l'application (pas de `shared_preferences`, non demandé).
  - Mode sombre : uniquement des couleurs du thème (`SegmentedButton` Material 3, `onSurfaceVariant`) ; rendu visuel sur appareil à confirmer (US-6.4).
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
