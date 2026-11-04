# CR-017 — US-2.2 : voir le détail d'un emprunteur et ses prêts

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — (non livrée, prévue en 1.0.0) |

## 1. Demande

Voir, pour un emprunteur, ses informations, ses totaux et tous ses prêts avec leur statut (US-2.2, ECR-03).

## 2. Motivation

Connaître d'un coup d'œil la situation d'un emprunteur : ce qui lui a été prêté, ce qu'il a rendu, ce qu'il doit encore et les prêts en retard.

## 3. Changement proposé

- Nouvel écran **ECR-03 « Détail d'un emprunteur »** (route `/borrowers/:borrowerId`, dans l'onglet Emprunteurs), ouvert par un appui sur une ligne d'ECR-02 :
  - en-tête : nom (barre de titre), téléphone (appui → composeur du téléphone), note ;
  - menu ⋮ → Modifier (feuille US-1.4) / Supprimer (dialogue RG-03, puis retour à la liste) ;
  - résumé : total prêté, total remboursé, reste dû ;
  - liste des prêts du plus récent au plus ancien (RG-15), une carte par prêt : montant et date du prêt, date de retour promise (ou « Non définie »), remboursé / reste dû + barre de progression, puce de statut avec libellé (RG-20, RG-23), date de remboursement effective si « Remboursé » (RG-22) ;
  - état vide si aucun prêt ;
  - bouton flottant **« + Prêt »** → ECR-04.
- Le formulaire prêt devient la route enfant `/borrowers/:borrowerId/loans/new` (chemin inchangé).
- **Retrait du point d'entrée provisoire** « Nouveau prêt » du menu ⋮ d'ECR-02 (CR-016).
- Calculs dérivés dans `domain` :
  - `LoanSummary` (prêt + montant remboursé + date du dernier remboursement, reste dû calculé, RG-21, RG-22) ;
  - `LoanStatus` et `LoanStatusCalculator` (RG-20, nombre de jours de retard RG-23, date du jour injectée).
- Données : agrégation SQL par prêt (`SUM` et `MAX` des remboursements) dans `LoansDao`, lecture réactive d'un emprunteur par id dans `BorrowersDao`.
- Nouvelle dépendance **`url_launcher`** (flutter.dev) pour ouvrir le composeur (lien `tel:` : le composeur s'ouvre avec le numéro pré-rempli, aucune permission `CALL_PHONE` ni `INTERNET`) ; déclaration `<queries>` du schéma `tel` dans le manifeste.
- Le dialogue de suppression d'un emprunteur est extrait dans un fichier partagé entre ECR-02 et ECR-03.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | `03-ecrans-et-parcours.md` : ECR-02 (tap → ECR-03, retrait du point d'entrée provisoire), ECR-03 (état vide) |
| Architecture | `ARCHITECTURE_TECHNIQUE.md` : ajout de `url_launcher` |
| Écrans | ECR-03 (nouveau), ECR-02 (tap, menu ⋮) |
| Base de données | Non (requêtes de lecture seulement, schéma v1 inchangé) |
| Format d'export JSON | Non |
| Backlog | US-2.2 terminée ; US-2.3 (calcul du statut) en grande partie couverte, voir § 7 |
| Tests | `loan_status_calculator_test.dart`, tests repository (agrégations par prêt, emprunteur par id), `borrower_detail_screen_test.dart`, `borrowers_screen_test.dart` adapté |

## 5. Critères d'acceptation

- [x] En-tête (nom, téléphone cliquable, note) et résumé : total prêté, remboursé, reste dû.
- [x] Carte par prêt : montant, date du prêt, date promise, remboursé / reste dû + barre, statut, date de remboursement effective si soldé (RG-15, RG-20 à RG-23).
- [x] Bouton « + Prêt » → ECR-04 ; menu ⋮ → Modifier / Supprimer.
- [x] Appui sur un emprunteur d'ECR-02 → ECR-03 ; point d'entrée provisoire retiré.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (92 tests).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - **US-2.3** : le calcul du statut (RG-20, RG-23) est implémenté et testé ici (`LoanStatusCalculator.compute`, date du jour injectée en paramètre), car indispensable à l'affichage d'ECR-03. US-2.3 reste à valider via sa propre CR (nommage `ComputeLoanStatus` du backlog, revue des cas limites).
  - Les réserves de CR-012 et CR-013 (Supprimer / Modifier depuis ECR-03) sont levées par le menu ⋮ d'ECR-03.
  - L'info-bulle du menu ⋮ d'ECR-02 affichait « Annuler » : remplacée par « Plus d'actions » (nouveau texte partagé avec ECR-03).
  - Appui sur une carte de prêt → ECR-05 : non implémenté (US-3.2).
  - Ouverture du composeur et rendu clair / sombre non vérifiés sur appareil (tests automatiques uniquement) ; vérifier aussi l'absence de `INTERNET` dans l'APK release après l'ajout d'`url_launcher` (manifeste du plugin contrôlé : aucune permission) — US-6.4.
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
