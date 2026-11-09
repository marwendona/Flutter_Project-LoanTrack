# CR-033 — US-6.3 : test du parcours complet

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Technique |
| **Date de création** | 2026-11-05 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — |

## 1. Demande

Implémenter US-6.3 : test de widgets (`testWidgets`) du parcours complet — ajouter un emprunteur → un prêt → un remboursement partiel → vérifier les totaux du tableau de bord.

## 2. Motivation

Les écrans et la persistance sont testés séparément (providers surchargés d'un côté, DAOs en mémoire de l'autre). Aucun test ne vérifie encore que l'application réelle (routeur, écrans, controllers, repositories, Drift) enchaîne correctement le parcours principal de bout en bout.

## 3. Changement proposé

- Nouveau test `test/journey_test.dart` : application complète (`LoanTrackApp`) avec une base Drift en mémoire (`NativeDatabase.memory()`) et une date du jour fixée par `clock` ; seuls les réglages, la version de l'app et la base sont surchargés.
- Parcours piloté par l'interface : création de l'emprunteur (ECR-02), création d'un prêt (ECR-04), saisie d'un remboursement partiel (ECR-05b), puis contrôle des totaux du tableau de bord (ECR-01) et des montants affichés en chemin.
- Aucun changement de code de production prévu.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Non |
| Écrans | Non |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-6.3 terminée |
| Tests | Nouveau `test/journey_test.dart` |

## 5. Critères d'acceptation

- [ ] Test de widgets : ajouter emprunteur → prêt → remboursement partiel → vérifier les totaux du tableau de bord.
- [ ] `flutter analyze` sans nouvel avertissement et `flutter test` vert.

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : —
- Remarques :
