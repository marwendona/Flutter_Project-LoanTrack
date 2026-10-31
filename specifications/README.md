# Spécifications métier — LoanTrack

Ce dossier décrit **le quoi** (besoins et règles métier), indépendamment de la technique.

| Fichier | Contenu |
|---|---|
| [01-vision-et-glossaire.md](01-vision-et-glossaire.md) | Vision, périmètre, glossaire, hypothèses |
| [02-regles-metier.md](02-regles-metier.md) | Modèle de données métier, règles de gestion (RG-xx), calculs |
| [03-ecrans-et-parcours.md](03-ecrans-et-parcours.md) | Écrans, contenus, navigation, parcours utilisateur |
| [04-exigences-non-fonctionnelles.md](04-exigences-non-fonctionnelles.md) | Confidentialité, performance, sauvegarde, ergonomie |
| [05-questions-ouvertes.md](05-questions-ouvertes.md) | Points à valider par le propriétaire du produit |

## Règles de maintenance

- Chaque règle porte un identifiant stable (`RG-xx`, `ENF-xx`, `ECR-xx`) référencé par les user stories et les CR.
- Une règle n'est jamais renumérotée : si elle est supprimée, elle est barrée avec la référence de la CR concernée.
- Toute modification passe par une Change Request (voir `../change-requests/README.md`).

**Version** : 1.1 — CR-001, CR-002 (en attente d'approbation)
