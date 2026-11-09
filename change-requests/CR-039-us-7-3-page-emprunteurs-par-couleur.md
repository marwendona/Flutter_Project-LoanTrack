# CR-039 — US-7.3 : page « Emprunteurs par couleur »

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-09 |
| **Date de décision** | 2026-11-09 (périmètre V2 validé par CR-035) |
| **Version livrée** | — |

## 1. Demande

Implémenter la user story US-7.3 : page ECR-07 « Emprunteurs par couleur », ouverte depuis la barre du haut d'ECR-02, regroupant les emprunteurs par couleur de fiabilité.

## 2. Motivation

Voir rapidement qui est fiable et qui ne l'est pas, sans parcourir toute la liste des emprunteurs.

## 3. Changement proposé

- **Navigation** : route `go_router` ECR-07 sous l'onglet Emprunteurs ; bouton icône « Emprunteurs par couleur » (infobulle) dans la barre du haut d'ECR-02.
- **Domaine** : regroupement des `BorrowerSummary` par `ReliabilityColor` dans l'ordre RG-64, tri RG-04 dans chaque groupe, couleurs vides omises (Dart pur, testé).
- **ECR-07** : une section par couleur (en-tête : pastille, libellé, nombre d'emprunteurs) ; ligne : nom, reste dû, N et L ; appui → ECR-03 ; bouton « Signification des couleurs » → dialogue reprenant RG-62 ; état vide « Aucun emprunteur. ».
- **Textes** : nouveaux libellés dans `app_fr.arb`.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucune (ECR-07 déjà décrit par CR-035) |
| Écrans | ECR-02 (bouton), ECR-07 (nouveau) |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-7.3 passée à Terminé |
| Tests | Regroupement (unitaire), ECR-07 (widgets), ECR-02 (bouton), test d'accessibilité |

## 5. Critères d'acceptation

- [x] Bouton icône « Emprunteurs par couleur » (infobulle) dans la barre du haut d'ECR-02 → ECR-07 (route `go_router` sous l'onglet Emprunteurs).
- [x] Une section par couleur dans l'ordre RG-64, en-tête avec pastille, libellé et nombre d'emprunteurs ; couleurs vides masquées ; tri RG-04 dans chaque section.
- [x] Ligne : nom, reste dû, N et L ; appui → ECR-03.
- [x] Bouton « Signification des couleurs » → dialogue reprenant RG-62 en clair.
- [x] État vide « Aucun emprunteur. » ; mode sombre et police agrandie vérifiés (test d'accessibilité étendu à ECR-07).
- [x] Tests de widgets : regroupement, ordre des sections, navigation vers ECR-03.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (380 tests).

## 6. Décision

Approuvée dans le cadre du périmètre V2 (CR-035) le 2026-11-09.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-09) :
  - Route `/borrowers/by-color` (`AppRoutes.borrowersByColor`), déclarée avant `:borrowerId` pour être prioritaire. ECR-02 l'ouvre par `context.go` (retour → ECR-02) ; ECR-07 ouvre ECR-03 par `context.push`, pour que le retour depuis ECR-03 ramène à ECR-07.
  - Regroupement dans `ReliabilityGrouping.group` (`lib/domain/services`, Dart pur) ; `borrowersByColorProvider` dérive de `borrowerSummariesProvider` (mise à jour immédiate, RG-63) et ignore la recherche d'ECR-02.
  - Ligne : « N prêts en retard, dont L de plus d'un mois » (clé existante `reliabilityDelayDetail`) ; « Aucun prêt en retard » quand N = 0 (Vert, Non évalué).
  - Dialogue « Signification des couleurs » : pour chaque couleur, pastille + libellé + condition en clair (`reliabilityColorCondition`), suivi d'une note définissant un prêt en retard (RG-60, RG-61). Bouton « Fermer » (nouvelle clé `actionClose`).
  - Icône du bouton d'ECR-02 : `palette_outlined` ; bouton du dialogue sur ECR-07 : `help_outline`.
  - En-tête de section en `Wrap` : le nombre d'emprunteurs passe à la ligne en police ×2 (ENF-08). En-tête annoncé comme titre par TalkBack.
  - Tests ajoutés : `reliability_grouping_test.dart`, `borrowers_by_color_screen_test.dart` (état vide, regroupement et ordre, N / L, navigation ECR-02 → ECR-07 → ECR-03 et retours, dialogue) ; `accessibility_test.dart` étendu à ECR-07 et au dialogue (clair, sombre, police ×2).
  - `docs/ARCHITECTURE_TECHNIQUE.md` : dossier `features/borrowers_by_color/` ajouté à l'arborescence.
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
  - Reste à faire manuellement : vérification visuelle sur le S22 (clair / sombre).
