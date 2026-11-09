# CR-035 — V2 : couleur de fiabilité des emprunteurs et périmètre V2

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité + Règle métier |
| **Date de création** | 2026-11-09 |
| **Date de décision** | 2026-11-09 |
| **Version livrée** | — |

## 1. Demande

La V1 est validée par le propriétaire du produit. Pour démarrer la V2, il demande :

1. Une **couleur** attribuée à chaque emprunteur selon sa ponctualité de remboursement :
   - **vert** : a toujours remboursé ses prêts au plus tard à la date de retour promise ;
   - **bleu** : un prêt remboursé après la date promise, avec un retard d'au plus un mois ;
   - **violet** : un prêt remboursé après la date promise, avec un retard de plus d'un mois ;
   - **jaune** : deux prêts remboursés en retard, chacun avec un retard d'au plus un mois ;
   - **orange** : deux prêts remboursés en retard, dont un seul avec un retard d'au plus un mois ;
   - **rouge** : trois prêts remboursés en retard ;
   - **noir** : plus de trois prêts remboursés en retard.
2. Une **page** listant les emprunteurs regroupés par couleur.
3. L'ajout des spécifications, epics et user stories nécessaires, et le rattachement à la **V2** des user stories déjà prévues (E7).

Précisions données par le propriétaire le 2026-11-09 :

| Question | Décision |
|---|---|
| Un prêt « En retard » pas encore soldé compte-t-il ? | **Oui** : son retard est mesuré jusqu'à aujourd'hui (Q-10). |
| Deux prêts en retard de plus d'un mois tous les deux ? | **Rouge** (Q-11). |
| Emprunteur qu'on ne peut pas encore juger ? | Catégorie **gris « Non évalué »** (Q-12). |
| Emplacement de la page par couleur ? | Nouvel écran ouvert **depuis la liste des emprunteurs** (ECR-02) ; la navigation à 3 onglets est conservée (Q-13). |

## 2. Motivation

Savoir d'un coup d'œil à qui il est raisonnable de prêter à nouveau, à partir de l'historique réel de ponctualité de chaque emprunteur, sans avoir à ouvrir le détail de chacun.

## 3. Changement proposé

- Nouvelles règles **RG-60 à RG-64** (`02-regles-metier.md`, section « Fiabilité des emprunteurs ») : retard d'un prêt, seuil d'un mois, couleur de fiabilité dérivée (jamais stockée), ordre des couleurs.
- Affichage de la couleur (pastille + libellé) dans ECR-02 et ECR-03 ; nouvel écran **ECR-07 — Emprunteurs par couleur** ouvert depuis la barre du haut d'ECR-02.
- Glossaire, périmètre V2 et questions ouvertes (Q-10 à Q-13) mis à jour.
- Backlog : nouvel epic **E8 — Fiabilité des emprunteurs** (US-8.1 à US-8.3), à implémenter en premier en V2 ; l'epic **E7** existant est confirmé en V2 et ses stories reçoivent des critères d'acceptation. Les identifiants US-7.x sont conservés (référencés par Q-05 et Q-06).

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | `01` : glossaire, périmètre V2 ; `02` : ajout RG-60 à RG-64 ; `03` : ECR-02, ECR-03, nouvel ECR-07, navigation, formats d'affichage ; `05` : Q-10 à Q-13 ; `README.md` : version 2.0 |
| Écrans | ECR-02, ECR-03, nouvel ECR-07 |
| Base de données | Non (valeur dérivée, aucune migration) |
| Format d'export JSON | Non (aucune valeur calculée exportée, RG-50) |
| Backlog | Ajout E8 (US-8.1, US-8.2, US-8.3) ; E7 confirmé en V2 et détaillé (US-7.1 à US-7.4) |
| Tests | À l'implémentation : tests unitaires du calcul (RG-60 à RG-63, cas limites), tests de widgets d'ECR-07 et des pastilles |

## 5. Critères d'acceptation

- [x] RG-60 à RG-64 rédigées sans ambiguïté, y compris les cas « Non évalué » et « deux retards longs ».
- [x] ECR-02, ECR-03 et ECR-07 décrits dans `03-ecrans-et-parcours.md`.
- [x] Glossaire, périmètre et questions ouvertes à jour.
- [x] Epic E8 et ses stories ajoutés au backlog ; E7 rattaché à la V2 avec des critères d'acceptation.
- [x] Aucune modification de code dans cette CR (chaque story aura sa propre CR à l'implémentation).

## 6. Décision

Approuvée par le propriétaire du produit le 2026-11-09 (demande et réponses aux questions Q-10 à Q-13).

## 7. Suivi de l'implémentation

- Commits / branches : non commité (à la demande de l'utilisateur).
- Renumérotation (CR-036, 2026-11-09) : l'epic de fiabilité est devenu **E7** (US-7.1 à US-7.3) et les améliorations **E8** (US-8.1 à US-8.4) ; les numéros cités ci-dessus sont ceux d'avant ce changement.
- Remarques : changement documentaire uniquement (specs + backlog), aucun code modifié, donc pas de `flutter analyze` / `flutter test`. Les stories E7 ont des critères d'acceptation mais leurs spécifications détaillées (règles, écrans, permissions, paquets) restent à rédiger dans la CR de chaque story. Les noms de libellés de RG-62 sont une proposition modifiable par le propriétaire.
