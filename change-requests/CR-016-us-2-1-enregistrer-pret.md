# CR-016 — US-2.1 : enregistrer un prêt

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | 1.0.0+1 |

## 1. Demande

Enregistrer un prêt pour un emprunteur : montant donné, date du prêt, date de retour promise et note (US-2.1, ECR-04).

## 2. Motivation

Garder une trace fiable de chaque somme prêtée et de la date de retour promise, base de tous les calculs (reste dû, statut, totaux).

## 3. Changement proposé

- Écran plein écran **ECR-04 « Nouveau prêt »** (route `/borrowers/:borrowerId/loans/new`, au-dessus de la barre de navigation) :
  - montant (clavier numérique, code de la devise affiché) ;
  - date du prêt (sélecteur, aujourd'hui par défaut via `clock`, pas de date future dans le sélecteur) ;
  - date de retour promise (sélecteur, facultative, « Non définie » par défaut, bouton pour l'effacer) ;
  - note / motif (≤ 500 caractères ; vide ou blanche → non enregistrée).
- Validations en ligne, messages sous les champs, bouton « Enregistrer » désactivé tant que le formulaire est invalide :
  - RG-10 : montant obligatoire, lisible (décimales de la devise), > 0, ≤ 999 999 999 unités majeures ;
  - RG-11 : date du prêt pas dans le futur ;
  - RG-12 : date promise ≥ date du prêt.
- Montant enregistré en unités mineures (`1250,5` → `1250500` millimes).
- **Point d'entrée provisoire** : entrée « Nouveau prêt » dans le menu ⋮ d'un emprunteur (ECR-02), en attendant le bouton « + Prêt » d'ECR-03 (US-2.2).
- Code : `lib/domain/services/loan_validator.dart`, `lib/features/loan/loan_form_controller.dart` (état freezed), `lib/features/loan/loan_form_screen.dart`, `lib/core/router/app_router.dart`, `lib/features/borrowers/borrowers_screen.dart`, textes dans `lib/l10n/app_fr.arb`.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | `03-ecrans-et-parcours.md` : ECR-02, mention du point d'entrée provisoire vers ECR-04 |
| Écrans | ECR-04 (nouveau), ECR-02 (menu ⋮) |
| Base de données | Non (table `loans` et `LoanRepository.add` existants) |
| Format d'export JSON | Non |
| Backlog | US-2.1 terminée ; E2 en cours |
| Tests | `test/domain/services/loan_validator_test.dart`, `test/features/loan/loan_form_controller_test.dart`, `test/features/loan/loan_form_screen_test.dart` |

## 5. Critères d'acceptation

- [x] Formulaire ECR-04 : montant, date du prêt (défaut aujourd'hui), date promise (optionnelle), note.
- [x] Validations RG-10, RG-11, RG-12 avec messages sous les champs ; « Enregistrer » désactivé si invalide.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (76 tests).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - le point d'entrée provisoire du menu ⋮ (ECR-02) est à retirer ou à conserver lors de US-2.2 ;
  - rendu clair / sombre non vérifié visuellement (tests automatiques uniquement) ;
  - `flutter analyze` signale 5 infos antérieures à cette CR : trois fichiers de test sont placés dans `lib/` au lieu de `test/` et ne sont donc pas exécutés par `flutter test` (correction à prévoir dans une CR séparée).
