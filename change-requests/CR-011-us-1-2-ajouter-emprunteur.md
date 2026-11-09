# CR-011 — US-1.2 : ajouter un emprunteur

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | 1.0.0+1 |

## 1. Demande

**Je veux** ajouter un emprunteur (nom, téléphone, note) **afin de** lui associer des prêts (US-1.2, ECR-02).

## 2. Motivation

Sans emprunteur, aucun prêt ne peut être enregistré.

## 3. Changement proposé

- Bouton flottant **+** sur ECR-02 → feuille « Nouvel emprunteur » : Nom, Téléphone (facultatif), Note (facultative).
- Nom obligatoire, 1 à 60 caractères après suppression des espaces de début / fin (RG-01) ; note de 500 caractères au plus.
- Valeurs enregistrées sans espaces de début / fin ; téléphone ou note vides enregistrés comme absents.
- Nom déjà utilisé (sans tenir compte de la casse ni des espaces) refusé avec le message « Un emprunteur porte déjà ce nom. » sous le champ (RG-02) ; le message disparaît dès que le nom est modifié. Vérification faite dans une transaction (`insertBorrowerIfNameKeyFree`).
- Erreur imprévue : « Impossible d'enregistrer. Réessayez. »
- Après enregistrement, la feuille se ferme et l'emprunteur apparaît dans la liste.
- Téléphone : texte libre, aucun format imposé (les spécifications n'en prévoient pas).

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucun (applique RG-01, RG-02 et le modèle Emprunteur) |
| Écrans | ECR-02 (bouton +, feuille de saisie) |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-1.2 |
| Tests | Validateur, DAO, repository (espaces, doublon), controller (`mocktail`), feuille de saisie |

## 5. Critères d'acceptation

- [x] Bouton + → formulaire ; nom obligatoire 1–60 caractères, espaces retirés (RG-01).
- [x] Doublon de nom refusé avec message (RG-02).
- [x] Après enregistrement, l'emprunteur apparaît dans la liste.

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : `e7bb420` (add borrower creation form).
- Remarques : dans ce commit, les tests `borrower_validator_test.dart`, `borrower_form_controller_test.dart` et `borrower_form_sheet_test.dart` se trouvent sous `lib/` au lieu de `test/` ; à déplacer (`test/` doit reproduire l'arborescence de `lib/`).
