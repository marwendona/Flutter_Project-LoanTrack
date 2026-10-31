# CR-003 — Adoption du paquet `material_ui` pour Material Design

| Champ | Valeur |
|---|---|
| **Statut** | Approuvée |
| **Type** | Technique |
| **Date de création** | 2026-10-30 |
| **Date de décision** | 2026-10-30 |
| **Version livrée** | — |

## 1. Demande

Utiliser le paquet officiel **`material_ui`** (flutter.dev) à la place de `package:flutter/material.dart` pour les widgets et le thème Material 3.

## 2. Motivation

Constaté pendant US-0.3 avec Flutter 3.47.9 :

- Material Design a été sorti du framework Flutter vers le paquet `material_ui` (`flutter/packages`). C'est là qu'il évolue désormais (nouveaux composants, corrections).
- `dynamic_color` 2.1.0, nécessaire aux couleurs Material You (ENF-08), renvoie des `ColorScheme` de `material_ui`, **incompatibles** avec ceux de `package:flutter/material.dart` : l'application ne compile pas si l'on mélange les deux.

Alternative écartée : rester sur `package:flutter/material.dart` et reconstruire le schéma de couleurs à partir de la seule palette système (`ColorScheme.fromSeed`). Le rendu Material You n'est alors qu'approché, et cette voie nous maintient sur l'ancienne bibliothèque, ce qui imposerait une migration plus tard.

## 3. Changement proposé

- Ajout de la dépendance `material_ui` ; les imports `package:flutter/material.dart` deviennent `package:material_ui/material_ui.dart` (`dart fix --apply --code=migrate_design_widgets`).
- Localisations Material fournies par `material_ui` (`GlobalMaterialLocalizations.delegates`).
- Si une dépendance tierce dépend encore de `package:flutter/material.dart` pour son interface, on utilise `MaterialUiCompatibilityBridge` dans `MaterialApp.builder`.
- Aucun changement fonctionnel (écrans, règles métier, données).

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucun (ENF-08 inchangée : Material 3 + couleurs dynamiques) |
| Écrans | Aucun |
| Architecture | `docs/ARCHITECTURE_TECHNIQUE.md` : ligne UI du tableau des choix, §10 (limites), ADR-09 ajoutée |
| Agents IA | `AGENTS.md` : stack (§3) |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-0.3 : thème Material 3 basé sur `material_ui` |
| Tests | Tests de widgets importent `material_ui` |

## 5. Critères d'acceptation

- [ ] Plus aucun import de `package:flutter/material.dart` dans `lib/` et `test/`.
- [ ] Couleurs dynamiques appliquées sans conversion de type.
- [ ] `flutter analyze` et `flutter test` passent.

## 6. Décision

**Approuvée** par le propriétaire le 2026-10-30, sur la base de l'analyse ci-dessus (option recommandée).

## 7. Suivi de l'implémentation

- Appliquée dans US-0.3 (epic E0).
