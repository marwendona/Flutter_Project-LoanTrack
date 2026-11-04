# CR-022 — US-3.3 : modifier / supprimer un remboursement

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — (non livrée, prévue en 1.0.0) |

## 1. Demande

Pouvoir modifier ou supprimer un remboursement depuis l'historique du détail d'un prêt (US-3.3).

## 2. Motivation

Corriger une erreur de saisie (montant, date, note) ou retirer un remboursement enregistré par erreur.

## 3. Changement proposé

- **ECR-05** : un appui sur un remboursement de l'historique ouvre la feuille ECR-05b en **modification**.
- **ECR-05b en modification** :
  - titre « Modifier le remboursement », champs pré-remplis (montant, date réelle, note) ;
  - plafond du montant = **reste dû + montant initial** du remboursement modifié (RG-16), rappelé sous le titre (« Montant maximal : … ») ; le bouton « Totalité » pré-remplit ce plafond (le prêt est alors soldé) ;
  - date réelle validée comme à la création (RG-17) ;
  - bouton **Supprimer** → dialogue de confirmation « Supprimer ce remboursement ? » rappelant le montant et la date (RG-19) ; après suppression, la feuille se ferme.
- Le reste dû, le statut et les totaux se mettent à jour immédiatement (flux Drift).
- Données : nouveau `RepaymentRepository.update(Repayment)` (`RepaymentNotFoundException` si le remboursement n'existe plus) ; `delete` existant.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | `03-ecrans-et-parcours.md` : ECR-05 (appui sur un remboursement), ECR-05b (mode modification, suppression) |
| Écrans | ECR-05, ECR-05b |
| Base de données | Non (schéma v1 inchangé) |
| Format d'export JSON | Non |
| Backlog | US-3.3 terminée |
| Tests | `update` (repository), controller en modification (plafond, pré-remplissage, mise à jour), feuille en modification et suppression, ouverture depuis ECR-05 |

## 5. Critères d'acceptation

- [x] Modification d'un remboursement avec plafond = reste dû + montant initial (RG-16).
- [x] Suppression d'un remboursement avec confirmation (RG-19).
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (173 tests).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - `RepaymentFormController` est désormais paramétré par `RepaymentFormTarget = (loan, existing?)` (comme `LoanFormTarget`) ; le champ d'état `remaining` devient `maxAmount` (reste dû, + montant initial en modification). `showRepaymentFormSheet` garde sa signature avec un paramètre nommé `existing` : les appels existants (ECR-03, ECR-05) sont inchangés.
  - En modification, le message d'erreur de plafond est spécifique : « Le montant ne peut pas dépasser … (reste dû + montant initial). ».
  - Suppression : nouveau `showRepaymentDeleteDialog` (`lib/features/repayment/repayment_delete_dialog.dart`), sur le modèle de `showLoanDeleteDialog` ; le bouton « Supprimer » est en bas à gauche de la feuille, en couleur d'erreur.
  - Nouveau `RepaymentsDao.updateRepayment` / `RepaymentRepository.update` + `RepaymentNotFoundException` ; aucun changement de schéma (régénération lancée, fichiers générés à jour).
  - Le formulaire de modification ne revalide pas si le prêt change pendant que la feuille est ouverte (plafond figé à l'ouverture, comme en création).
  - Rendu clair / sombre non vérifié sur appareil (tests automatiques uniquement) — US-6.4.
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
