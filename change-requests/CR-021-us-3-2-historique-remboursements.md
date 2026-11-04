# CR-021 — US-3.2 : historique des remboursements d'un prêt

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — (non livrée, prévue en 1.0.0) |

## 1. Demande

Afficher le détail d'un prêt (ECR-05) avec l'historique de ses remboursements (US-3.2).

## 2. Motivation

Consulter, pour un prêt, ce qui a été rendu et quand, et y ajouter un remboursement directement.

## 3. Changement proposé

- **Écran ECR-05** (route `/borrowers/:borrowerId/loans/:loanId`), ouvert par un appui sur une carte de prêt d'ECR-03 :
  - infos du prêt : montant, statut (puce), date du prêt, date de retour promise, date de remboursement effective si soldé (RG-22), note, remboursé / reste dû avec barre de progression ;
  - **historique des remboursements** : date réelle et montant (et note si présente), du plus récent au plus ancien ; état vide « Aucun remboursement. » ;
  - bouton flottant **+ Remboursement** → ECR-05b, **masqué si le prêt est soldé** ;
  - menu ⋮ → Modifier le prêt (ECR-04) / Supprimer le prêt (RG-14, retour à ECR-03 après suppression) ;
  - si le prêt n'existe plus : message « Ce prêt n'existe plus. ».
- L'écran se met à jour immédiatement (flux Drift) après un ajout de remboursement ou une modification du prêt.
- Données : nouveau flux `LoanRepository.watchSummaryById` (prêt + agrégats de remboursements) ; l'historique utilise `RepaymentRepository.watchByLoan` existant.
- Hors périmètre : modification / suppression d'un remboursement depuis l'historique (US-3.3).

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | `03-ecrans-et-parcours.md` : ECR-03 (appui sur une carte → ECR-05), ECR-05 (détails) |
| Écrans | ECR-03, ECR-05 |
| Base de données | Non (schéma v1 inchangé) |
| Format d'export JSON | Non |
| Backlog | US-3.2 terminée |
| Tests | flux `watchSummaryById` et ordre de l'historique (repository), widget d'ECR-05, navigation depuis ECR-03 |

## 5. Critères d'acceptation

- [x] Écran ECR-05 : infos du prêt + liste des remboursements (date réelle, montant), du plus récent au plus ancien.
- [x] Bouton + Remboursement masqué si le prêt est soldé.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (159 tests).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - Nouvel écran `LoanDetailScreen` et `loanDetailProvider` dans `lib/features/loan_detail/` ; route `AppRoutes.loanDetail` dans la branche « Emprunteurs » (la barre de navigation reste visible, comme ECR-03).
  - Nouveau `LoansDao.watchWithRepaymentsById` / `LoanRepository.watchSummaryById` (agrégats SQL réutilisés, aucun changement de schéma, pas de régénération nécessaire). L'ordre de l'historique vient de `RepaymentsDao.watchByLoan` (date desc, puis id desc).
  - L'action « Ajouter un remboursement » du menu ⋮ d'ECR-03 est conservée en plus du bouton d'ECR-05.
  - L'historique n'est pas encore interactif : modification / suppression d'un remboursement → US-3.3.
  - Rendu clair / sombre non vérifié sur appareil (tests automatiques uniquement) — US-6.4.
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
