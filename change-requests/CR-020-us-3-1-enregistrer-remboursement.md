# CR-020 — US-3.1 : enregistrer un remboursement (partiel ou total)

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — (non livrée, prévue en 1.0.0) |

## 1. Demande

Saisir le montant rendu et la date réelle d'un remboursement afin de suivre ce qui reste dû (US-3.1, RG-16 à RG-18).

## 2. Motivation

Enregistrer les remboursements partiels ou totaux pour que le reste dû, le statut des prêts et les totaux reflètent la réalité.

## 3. Changement proposé

- **Feuille ECR-05b** (feuille modale) : montant (clavier numérique, devise affichée), date réelle (sélecteur, défaut aujourd'hui, borné entre la date du prêt et aujourd'hui), note (≤ 200 car.) ; rappel du reste dû ; bouton « Totalité » qui pré-remplit le montant avec le reste dû (RG-18).
- **Validations** en ligne : RG-16 (montant > 0 et ≤ reste dû), RG-17 (date obligatoire, ≥ date du prêt, pas dans le futur), note ≤ 200 caractères. Bouton « Enregistrer » désactivé tant que le formulaire est invalide.
- **Point d'entrée** : ECR-05 (détail d'un prêt, US-3.2) n'existant pas encore, l'action « Ajouter un remboursement » est ajoutée au menu ⋮ de chaque carte de prêt d'ECR-03, masquée si le prêt est remboursé. ECR-05 offrira le bouton « + Remboursement ».
- **Mise à jour immédiate** : les listes étant des flux Drift, le reste dû, le statut et les totaux d'ECR-03 (et d'ECR-02) se mettent à jour dès l'enregistrement.
- Données : insertion d'un remboursement via `RepaymentRepository`.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | `03-ecrans-et-parcours.md` : ECR-03 (action « Ajouter un remboursement » du menu ⋮), ECR-05b (détails de la feuille) |
| Écrans | ECR-03, ECR-05b |
| Base de données | Non (schéma v1 inchangé) |
| Format d'export JSON | Non |
| Backlog | US-3.1 terminée |
| Tests | validateur de remboursement (RG-16, RG-17, note), controller de la feuille, widget de la feuille (bouton « Totalité », validations), menu d'ECR-03 |

## 5. Critères d'acceptation

- [x] Feuille ECR-05b : montant, date réelle (défaut aujourd'hui), note ; rappel du reste dû.
- [x] Bouton « Totalité » (RG-18).
- [x] Validations RG-16, RG-17 ; statut et totaux mis à jour immédiatement.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (149 tests).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - Nouveau `RepaymentValidator` (domaine) et `RepaymentFormController` (famille Riverpod paramétrée par le `LoanSummary` du prêt tel qu'affiché à l'ouverture de la feuille) ; feuille `RepaymentFormSheet` dans `lib/features/repayment/`.
  - Le champ date du formulaire de prêt est extrait en widget partagé `DateField` (`lib/core/widgets/date_field.dart`) pour être réutilisé par ECR-05b (refactoring sans changement de comportement).
  - Les messages « montant obligatoire / invalide / supérieur à zéro » réutilisent les textes du formulaire de prêt.
  - RG-16 est validée dans le formulaire à partir du reste dû lu à l'ouverture, sans contrainte SQL (comme RG-13) : un remboursement saisi en parallèle sur le même prêt n'est pas possible dans cette app mono-utilisateur.
  - Mise à jour immédiate assurée par les flux Drift (test de repository ajouté).
  - Rendu clair / sombre non vérifié sur appareil (tests automatiques uniquement) — US-6.4.
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
