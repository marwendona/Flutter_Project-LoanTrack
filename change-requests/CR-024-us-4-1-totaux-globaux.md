# CR-024 — US-4.1 : totaux globaux

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — (non livrée, prévue en 1.0.0) |

## 1. Demande

En tant que prêteur, voir la totalité du crédit donné à tous les emprunteurs afin de connaître sa situation d'un coup d'œil (US-4.1).

## 2. Motivation

Le tableau de bord (ECR-01) n'est encore qu'un squelette : aucun indicateur global n'est disponible.

## 3. Changement proposé

- Domaine : modèle `GlobalTotals` et service `GlobalTotalsCalculator` calculant, à partir des soldes de tous les prêts, le total prêté, le total remboursé, le reste à recevoir, le nombre d'emprunteurs ayant un reste dû > 0, le nombre et le montant (reste dû) des prêts en retard (RG-31), le taux de remboursement (RG-32, 0 % sans prêt), en incluant les prêts soldés (RG-33).
- `globalTotalsProvider` (flux réactif sur `watchAllWithLoanBalances`).
- ECR-01 : carte « Reste à recevoir » mise en avant (avec le nombre d'emprunteurs concernés), indicateurs total prêté, total remboursé, taux de remboursement avec barre, prêts en retard (nombre + montant, en rouge si > 0).
- État vide d'ECR-01 (« Aucun prêt enregistré » + bouton « Ajouter un emprunteur ») quand aucun prêt n'existe.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Non (ECR-01 et RG-31 à RG-33 déjà décrits) |
| Écrans | ECR-01 (indicateurs globaux) |
| Base de données | Non (schéma v1 inchangé) |
| Format d'export JSON | Non |
| Backlog | US-4.1 terminée |
| Tests | Tests unitaires du calculateur, tests de widgets d'ECR-01, override dans `app_test.dart` |

## 5. Critères d'acceptation

- [x] Carte « Reste à recevoir » + total prêté, total remboursé, taux de remboursement (barre), prêts en retard (nombre + montant, en rouge si > 0). — RG-31, RG-32, RG-33
- [x] Totaux mis à jour immédiatement après toute modification.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (197 tests, dont 14 nouveaux).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - Fichiers : `lib/domain/models/global_totals.dart`, `lib/domain/services/global_totals_calculator.dart`, `lib/features/dashboard/dashboard_providers.dart`, `lib/features/dashboard/dashboard_screen.dart`, `lib/l10n/app_fr.arb` ; tests `test/domain/services/global_totals_calculator_test.dart`, `test/features/dashboard/dashboard_screen_test.dart`, override ajouté dans `test/app_test.dart`.
  - Le **montant en retard** est la somme des restes dus des prêts en retard (pas leur montant initial).
  - Le **taux de remboursement** est arrondi à l'entier inférieur (calcul entier), pour n'afficher 100 % que si tout est remboursé ; la barre utilise le ratio exact (affichage uniquement).
  - Le nombre d'emprunteurs ayant un reste dû (RG-31) est affiché sous le montant de la carte « Reste à recevoir ».
  - La mise à jour immédiate repose sur le flux `watchAllWithLoanBalances`, dont la réactivité est déjà couverte par les tests d'intégration de CR-023.
  - L'état vide d'ECR-01 (« Aucun prêt enregistré » + « Ajouter un emprunteur », qui ouvre la feuille de création) est inclus : il s'affiche tant qu'aucun prêt n'existe. La liste « Par emprunteur » et les filtres relèvent d'US-4.2 et US-4.3.
  - Mode sombre vérifié par test de widgets (couleur rouge du thème sombre) ; rendu visuel sur appareil à confirmer (US-6.4).
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
