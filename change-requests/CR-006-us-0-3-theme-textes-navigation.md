# CR-006 — US-0.3 : thème, textes et navigation

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — (non livrée, prévue en 1.0.0) |

## 1. Demande

Une barre de navigation à 3 onglets (Tableau de bord, Emprunteurs, Paramètres), le thème Material 3 et les textes en français (US-0.3, epic E0).

## 2. Motivation

Poser la structure de navigation et l'apparence communes à tous les écrans (`specifications/03-ecrans-et-parcours.md`, ENF-08).

## 3. Changement proposé

- Thème Material 3 clair / sombre (`lib/core/theme/app_theme.dart`) avec couleurs dynamiques Material You (`dynamic_color`), via le paquet `material_ui` (CR-003).
- Couleurs de statut (`StatusColors`, extension de thème) : Remboursé = vert, En retard = rouge, Partiellement = orange, En cours = bleu.
- Localisation française : `l10n.yaml`, `lib/l10n/app_fr.arb`, `locale: fr`.
- Navigation `go_router` avec `StatefulShellRoute` et 3 écrans squelettes (ECR-01, ECR-02, ECR-06).

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucun (applique ECR-01/02/06 et « Formats d'affichage ») |
| Écrans | Navigation principale ; squelettes ECR-01, ECR-02, ECR-06 |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-0.3 ; vérification visuelle sur le S22 reportée à US-6.4 |
| Tests | `test/app_test.dart` (onglets, navigation), `test/core/theme/app_theme_test.dart` |

## 5. Critères d'acceptation

- [x] Thème Material 3 clair / sombre + couleurs dynamiques.
- [x] Localisation française.
- [x] `go_router` avec `StatefulShellRoute` et 3 écrans squelettes.
- [x] Couleurs de statut définies.

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30. Le choix de `material_ui` fait l'objet de CR-003.

## 7. Suivi de l'implémentation

- Commit : `88adaab`.
- Remarques : rendu validé sur émulateur ; rendu clair / sombre et Material You sur le S22 reportés à US-6.4.
