# CR-014 — US-1.5 : rechercher un emprunteur

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | 1.0.0+1 |

## 1. Demande

Un champ de recherche filtrant la liste des emprunteurs par nom, sans tenir compte de la casse ni des accents (US-1.5, ECR-02).

## 2. Motivation

Retrouver rapidement une personne quand la liste devient longue.

## 3. Changement proposé

- Champ « Rechercher un emprunteur... » sous le titre de ECR-02.
- Filtrage en direct : un emprunteur est affiché si son nom contient le texte saisi, comparaison sans casse ni accents (`lib/core/string/string_normalizer.dart`).
- L'ordre de la liste reste celui de RG-04.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucun |
| Écrans | ECR-02 |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-1.5 |
| Tests | Aucun test ajouté (normalisation, filtre, écran) |

## 5. Critères d'acceptation

- [x] Champ de recherche filtrant la liste par nom, insensible à la casse.
- [ ] Insensible aux accents — voir remarques.

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : `2541308` (search borrower).
- Remarques (réserves constatées le 2026-11-04) :
  - `StringNormalizer` ne retire que les accents « décomposés » (U+0300–U+036F). Les lettres accentuées saisies au clavier (é, è, à, ç… précomposées) ne sont pas converties : « eleonore » ne trouve pas « Éléonore ». Correction à prévoir (table de correspondance des lettres accentuées) ;
  - quand la recherche ne trouve rien, l'écran affiche « Aucun emprunteur. Appuyez sur + pour en ajouter un. » au lieu d'un message « aucun résultat » ;
  - les états chargement et erreur de la liste (US-1.1) ne sont plus affichés ;
  - aucun test.
