# CR-038 — US-7.2 : afficher la couleur de fiabilité d'un emprunteur

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-09 |
| **Date de décision** | 2026-11-09 (périmètre V2 validé par CR-035) |
| **Version livrée** | — |

## 1. Demande

Implémenter la user story US-7.2 : afficher la couleur de fiabilité (calculée par US-7.1, CR-037) dans la liste des emprunteurs (ECR-02) et sur la fiche d'un emprunteur (ECR-03).

## 2. Motivation

Repérer d'un coup d'œil la fiabilité d'un emprunteur, sans chercher ni relire son historique.

## 3. Changement proposé

- **Thème** : extension `ReliabilityColors` (`lib/core/theme/reliability_colors.dart`) avec les 8 couleurs fixes (non issues de Material You), variantes claire et sombre ; contour clair de la pastille noire en mode sombre.
- **Domaine** : `BorrowerSummary` porte la `BorrowerReliability` de l'emprunteur, calculée par `BorrowerSummaryCalculator.summarize` via `ReliabilityCalculator.evaluate` (date du jour injectée). Les providers existants d'ECR-02 et ECR-03 (flux Drift) la recalculent donc à chaque changement de prêt ou de remboursement.
- **Widget** `ReliabilityIndicator` (`lib/core/widgets/`) : pastille + libellé RG-62 ; la pastille est décorative, le libellé est toujours affiché (ENF-08).
- **ECR-02** : indicateur sur chaque ligne. **ECR-03** : section « Fiabilité » avec l'indicateur et « N prêts en retard, dont L de plus d'un mois » (omis si Vert ou Non évalué).
- **Textes** : libellés RG-62 et détail N / L dans `app_fr.arb`.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucune (ECR-02, ECR-03 et « Formats d'affichage » déjà décrits par CR-035) |
| Écrans | ECR-02, ECR-03 |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-7.2 passée à Terminé |
| Tests | Calculateur des totaux, écrans ECR-02 / ECR-03, nouveau test du widget, test d'accessibilité |

## 5. Critères d'acceptation

- [x] Couleurs de fiabilité fixes définies dans le thème, lisibles en clair et en sombre (contour de la pastille noire en sombre).
- [x] ECR-02 : pastille + libellé (RG-62) sur chaque ligne.
- [x] ECR-03 : pastille + libellé et « N prêts en retard, dont L de plus d'un mois » (omis si Vert ou Non évalué).
- [x] Mise à jour immédiate après ajout / modification / suppression d'un prêt ou d'un remboursement.
- [x] Libellés dans `app_fr.arb` ; couleur jamais seule (ENF-08) ; tests de widgets et test d'accessibilité mis à jour.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (364 tests).

## 6. Décision

Approuvée dans le cadre du périmètre V2 (CR-035) le 2026-11-09.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-09) :
  - `BorrowerSummary.reliability` est requis et calculé par `BorrowerSummaryCalculator.summarize` ; la constante `BorrowerReliability.notEvaluated` sert aux cas sans prêt évalué et aux tests. ECR-07 (US-7.3) pourra réutiliser `borrowerSummariesProvider`, `ReliabilityIndicator` / `ReliabilityDot` et la clé ARB `reliabilityColorLabel`.
  - Libellés RG-62 via un message ICU `select` sur le nom de la couleur (`reliabilityColorLabel`) ; détail N / L via `reliabilityDelayDetail`. Pour L = 0 (Bleu, Jaune), le texte devient « 1 prêt en retard, dont aucun de plus d'un mois » plutôt que « dont 0 ».
  - ECR-02 : la fiabilité est sur une ligne propre sous le nom, annoncée « Fiabilité » par TalkBack. ECR-03 : carte « Fiabilité » sous la carte des totaux.
  - Couleurs choisies : teintes Material 700 en clair, 200-300 en sombre ; le noir reste noir dans les deux modes, avec un contour `#E0E0E0` en sombre.
  - Tests ajoutés / mis à jour : `app_theme_test.dart`, `borrower_summary_calculator_test.dart`, `borrowers_screen_test.dart`, `borrower_detail_screen_test.dart`, `accessibility_test.dart` (couleurs Noir / Vert, libellés lus par TalkBack, ECR-03 en sombre), nouveau `borrowers_reliability_update_test.dart` (providers + Drift en mémoire : ajout, modification, suppression de prêt et de remboursement).
  - `build_runner` a de nouveau régénéré des fichiers sans rapport (espaces uniquement) ; ils ont été restaurés.
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
  - Reste à faire manuellement : vérification visuelle sur le S22 (clair / sombre).
