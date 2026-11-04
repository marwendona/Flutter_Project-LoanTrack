# CR-019 — US-2.4 : modifier / supprimer un prêt

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — (non livrée, prévue en 1.0.0) |

## 1. Demande

Pouvoir modifier un prêt (montant, dates, note) et le supprimer avec ses remboursements (US-2.4, RG-13, RG-14).

## 2. Motivation

Corriger une erreur de saisie ou retirer un prêt enregistré par erreur.

## 3. Changement proposé

- **Point d'entrée** : menu ⋮ sur chaque carte de prêt d'ECR-03 → « Modifier le prêt » / « Supprimer le prêt ». ECR-05 (détail d'un prêt, US-3.2) n'existant pas encore, ce menu est le seul accès pour l'instant ; ECR-05 offrira les mêmes actions.
- **Modification** : ECR-04 en mode modification (route `/borrowers/:borrowerId/loans/:loanId/edit`, titre « Modifier le prêt »), champs pré-remplis, mêmes validations que la création (RG-10 à RG-12) plus :
  - **RG-13** : le montant ne peut pas être inférieur au montant déjà remboursé (message sous le champ) ;
  - **cohérence avec RG-17** (complément de spécification) : la date du prêt ne peut pas être postérieure à la date du premier remboursement, sinon un remboursement existant deviendrait antérieur au prêt.
- **Suppression** : dialogue de confirmation rappelant le montant et la date du prêt et indiquant que ses remboursements seront supprimés ; suppression en cascade dans une transaction (RG-14, déjà en place dans `LoansDao.deleteById`).
- Données : lecture d'un prêt avec ses agrégats par id (`SUM`, `MIN`, `MAX` des remboursements), mise à jour d'un prêt ; `LoanSummary` expose la date du premier remboursement.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | `02-regles-metier.md` : RG-11 complétée (date du prêt ≤ premier remboursement) ; `03-ecrans-et-parcours.md` : ECR-03 (menu ⋮ par carte), ECR-04 (mode modification) |
| Écrans | ECR-03, ECR-04 |
| Base de données | Non (schéma v1 inchangé) |
| Format d'export JSON | Non |
| Backlog | US-2.4 terminée |
| Tests | validateur (RG-13, date / premier remboursement), repository (lecture par id, mise à jour, suppression en cascade), controller et écran du formulaire en modification, menu et dialogue de suppression d'ECR-03 |

## 5. Critères d'acceptation

- [x] Modification avec RG-13 (montant ≥ déjà remboursé).
- [x] Date du prêt refusée si postérieure au premier remboursement.
- [x] Suppression avec confirmation, cascade sur les remboursements (RG-14).
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (123 tests).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - Le formulaire ECR-04 gère création et modification : `LoanFormController` devient une famille Riverpod paramétrée par `LoanFormTarget` (emprunteur + prêt existant éventuel) ; le prêt modifié est lu une fois à l'ouverture (`editedLoanProvider`).
  - En modification, les erreurs du montant pré-rempli sont affichées immédiatement ; le sélecteur de date du prêt est borné à min(aujourd'hui, premier remboursement).
  - Une mise à jour d'un prêt supprimé entre-temps lève `LoanNotFoundException` → message « Impossible d'enregistrer. Réessayez. ».
  - RG-13 et la contrainte de date sont validées dans le formulaire uniquement (pas de contrainte SQL), comme les autres règles de saisie.
  - Rendu clair / sombre non vérifié sur appareil (tests automatiques uniquement) — US-6.4.
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
