# CR-032 — US-6.2 : accessibilité et ergonomie

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Évolution |
| **Date de création** | 2026-11-05 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — |

## 1. Demande

Implémenter US-6.2 (ENF-08) : `tooltip` / `Semantics` sur les icônes, statuts toujours accompagnés d'un libellé, zones tactiles ≥ 48 dp, test avec police agrandie.

## 2. Motivation

L'application doit rester utilisable avec TalkBack et avec la taille de police système agrandie du S22, sans élément tactile trop petit ni information portée uniquement par la couleur ou une icône.

## 3. Changement proposé

Un audit par test automatique (guidelines Flutter + police ×2 au format 360 × 780 dp du S22) a révélé des débordements, y compris à taille de police normale sur certains formulaires, et un bouton ⋮ réduit à 33,5 dp de large sur les cartes de prêt d'ECR-03. Corrections :

- **Nouveaux widgets partagés** (`lib/core/widgets/`) :
  - `FormActions` : boutons de bas de formulaire alignés à droite, empilés verticalement (`OverflowBar`) s'ils ne tiennent pas sur une ligne ;
  - `LabelValueRow` : libellé à gauche, valeur à droite ; la valeur passe sous le libellé si la ligne est trop étroite ; lu par TalkBack comme un seul élément (« Total prêté, 1 250,500 TND »).
- **ECR-01** : indicateurs et totaux par emprunteur via `LabelValueRow` ; barre du taux de remboursement exclue de la lecture (le taux est lu juste au-dessus).
- **ECR-02** : tuile emprunteur réorganisée — 1re ligne nom + badge « En retard », 2e ligne nombre de prêts actifs + reste dû (qui passe à la ligne si nécessaire), menu ⋮ seul à droite.
- **ECR-03** : totaux via `LabelValueRow` ; sur les cartes de prêt, le statut peut passer à la ligne au lieu de pousser le menu ⋮ hors de la carte ; barre de progression exclue de la lecture.
- **ECR-05** : remboursements de l'historique avec date et montant dans `LabelValueRow` (le montant n'est plus un `trailing` qui débordait) ; barre de progression exclue de la lecture.
- **ECR-04, feuille emprunteur, ECR-05b** : boutons via `FormActions`. ECR-05b : le bouton « Totalité » est placé à côté du rappel « Reste dû : … » (et passe dessous si nécessaire), le champ montant occupe toute la largeur ; en modification, « Supprimer » est désormais dans le groupe de boutons aligné à droite.
- Déjà conformes et vérifiés : infobulles des boutons ⋮ et « + », bouton d'effacement de la date promise, icône d'appel ; statuts (`LoanStatusChip`) et badge de retard toujours écrits en texte.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | `04-exigences-non-fonctionnelles.md` : ENF-08 précisée (infobulles, éléments décoratifs, statuts textuels, police agrandie) |
| Écrans | ECR-01, ECR-02, ECR-03, ECR-04, ECR-05, ECR-05b, feuille emprunteur : mise en page adaptée, sans changement fonctionnel |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-6.2 terminée |
| Tests | Nouveau `test/accessibility_test.dart` (28 tests) ; tests existants inchangés et verts |

## 5. Critères d'acceptation

- [x] Toute icône interactive a un `tooltip` ou un libellé sémantique ; les icônes et barres décoratives sont exclues de l'arbre sémantique ou redondantes avec un texte.
- [x] Les statuts de prêt et le badge de retard affichent toujours un libellé texte, lu par TalkBack (test dédié).
- [x] Zones tactiles ≥ 48 dp (vérifiées par `androidTapTargetGuideline`).
- [x] Libellés présents sur les cibles tactiles (`labeledTapTargetGuideline`) et contraste du texte (`textContrastGuideline`), en clair et en sombre.
- [x] Écrans testés avec un facteur de police ×2 sans débordement.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (320 tests).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-05) :
  - Fichiers créés : `lib/core/widgets/form_actions.dart`, `lib/core/widgets/label_value_row.dart`, `test/accessibility_test.dart`.
  - Fichiers modifiés : `lib/features/dashboard/dashboard_screen.dart`, `lib/features/borrowers/borrowers_screen.dart`, `lib/features/borrowers/borrower_form_sheet.dart`, `lib/features/borrower_detail/borrower_detail_screen.dart`, `lib/features/loan/loan_form_screen.dart`, `lib/features/loan_detail/loan_detail_screen.dart`, `lib/features/repayment/repayment_form_sheet.dart`.
  - Le test couvre 9 écrans / feuilles (dont ECR-05b en modification) : guidelines en clair et en sombre à la taille réelle du S22, police ×2 sur une vue haute pour construire toute la liste. Les guidelines ne vérifient que la partie visible de l'écran. La barre de navigation (composant Material standard) et les dialogues de confirmation ne sont pas inclus.
  - La police de test Flutter (glyphes carrés) est plus large que Roboto : les débordements détectés à taille normale (boutons des formulaires) sont pessimistes, mais auraient été réels avec une police agrandie sur l'appareil.
  - **Réserve** : vérification manuelle à faire sur le S22 avec TalkBack activé et la taille de police au maximum (US-6.4).
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
