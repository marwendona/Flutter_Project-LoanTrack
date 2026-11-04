# CR-013 — US-1.4 : modifier un emprunteur

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — (non livrée, prévue en 1.0.0) |

## 1. Demande

Modifier le nom, le téléphone et la note d'un emprunteur avec les mêmes validations que la création (US-1.4).

## 2. Motivation

Corriger une faute de frappe ou mettre à jour un numéro sans supprimer l'emprunteur et ses prêts.

## 3. Changement proposé

- Sur ECR-02, menu ⋮ → « Modifier l'emprunteur » : la feuille de saisie de US-1.2 (CR-011) s'ouvre pré-remplie.
- Mêmes validations que la création : RG-01, note ≤ 500 caractères, doublon refusé (RG-02) sauf pour l'emprunteur lui-même ; vérification dans une transaction (`updateBorrowerIfNameKeyFree`).
- Valeurs enregistrées sans espaces de début / fin ; téléphone ou note vides enregistrés comme absents.
- La date de création n'est pas modifiable.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucun |
| Écrans | ECR-02 (menu ⋮) ; ECR-03 (menu ⋮ → Modifier) à faire |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-1.4 |
| Tests | Aucun test ajouté (repository, controller ni feuille en mode modification) |

## 5. Critères d'acceptation

- [x] Modification nom / téléphone / note avec les mêmes validations que la création.

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : `67e42cc` (update borrower).
- Remarques : dépend de CR-011 (même formulaire et même controller) ; tests de la modification à ajouter (doublon avec un autre emprunteur, conservation de son propre nom).
