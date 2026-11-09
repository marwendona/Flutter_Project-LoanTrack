# CR-036 — Renumérotation des epics V2 (E7 ↔ E8)

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Évolution (backlog) |
| **Date de création** | 2026-11-09 |
| **Date de décision** | 2026-11-09 |
| **Version livrée** | — (sans effet sur l'APK) |

## 1. Demande

Le propriétaire demande d'inverser la numérotation des epics V2 créée par CR-035 : l'epic « Fiabilité des emprunteurs (couleurs) » devient **E7** et l'epic « Améliorations V2 » devient **E8**.

## 2. Motivation

L'epic de fiabilité est le premier à implémenter en V2 : sa numérotation suit désormais l'ordre d'implémentation.

## 3. Changement proposé

| Avant (CR-035) | Après |
|---|---|
| E8 — Fiabilité des emprunteurs : US-8.1, US-8.2, US-8.3 | **E7** : US-7.1, US-7.2, US-7.3 |
| E7 — Améliorations V2 : US-7.1 à US-7.4 | **E8** : US-8.1 à US-8.4 |

Ordre d'implémentation V2 : E7 → E8. Contenu des stories inchangé.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | `01-vision-et-glossaire.md` (références au backlog), `05-questions-ouvertes.md` (Q-05 → US-8.1, Q-06 → US-8.2) |
| Écrans | Non |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | Renumérotation E7 ↔ E8 et de leurs stories dans `docs/EPICS_ET_USER_STORIES.md` |
| Tests | Non |

Les CR antérieures (CR-001, CR-035) ne sont pas réécrites : elles gardent la numérotation en vigueur à leur date ; une note de renvoi est ajoutée dans CR-035.

## 5. Critères d'acceptation

- [x] Fiabilité = E7 (US-7.1 à US-7.3), améliorations = E8 (US-8.1 à US-8.4) dans le backlog.
- [x] Références à jour dans les spécifications (Q-05, Q-06, périmètre V2).
- [x] Note de renvoi dans CR-035.

## 6. Décision

Approuvée par le propriétaire du produit le 2026-11-09.

## 7. Suivi de l'implémentation

- Commits / branches : non commité.
- Remarques : changement documentaire uniquement, aucun code modifié (pas de `flutter analyze` / `flutter test`). Contenu des stories inchangé.
