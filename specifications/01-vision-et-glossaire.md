# 01 — Vision et glossaire

## Vision

Savoir à tout moment, en quelques secondes, **qui me doit de l'argent, combien, et qui est en retard**, sans tableur ni carnet papier.

## Utilisateur

Un seul utilisateur : le propriétaire du téléphone (appelé « le prêteur »). Pas de multi-utilisateurs, pas de partage, pas de compte.

## Périmètre

### Inclus (V1)
- Gestion des emprunteurs (ajout, modification, suppression, recherche).
- Enregistrement de prêts pour un emprunteur (montant, date du prêt, date de retour promise, note).
- Enregistrement de remboursements partiels ou totaux pour un prêt (montant, date réelle).
- Calcul automatique du reste dû et du statut de chaque prêt (dont le retard).
- Tableau de bord : totaux globaux et totaux par emprunteur.
- Export / import des données dans un fichier JSON (sauvegarde manuelle).
- Réglage de la devise d'affichage.

### Exclus (V1)
- Synchronisation cloud, multi-appareils, comptes.
- Intérêts, échéanciers, pénalités de retard.
- Argent emprunté *par* le prêteur (seuls les prêts *donnés* sont suivis).
- Multi-devises simultanées (une seule devise pour toute l'application).
- Notifications / rappels (envisagé en V2, voir backlog E7).

## Glossaire

| Terme | Définition |
|---|---|
| **Prêteur** | L'utilisateur de l'application, qui donne l'argent. |
| **Emprunteur** | Personne à qui le prêteur a prêté de l'argent. Identifiée par son nom. |
| **Prêt** | Une somme d'argent donnée à un emprunteur à une date donnée. Un emprunteur peut avoir plusieurs prêts. |
| **Date du prêt** | Date à laquelle l'argent a été donné. |
| **Date de retour promise** | Date à laquelle l'emprunteur s'est engagé à rembourser. Optionnelle. |
| **Remboursement** | Une somme rendue par l'emprunteur pour un prêt donné, à une date réelle. Un prêt peut avoir plusieurs remboursements (remboursement partiel). |
| **Date de remboursement réelle** | Date à laquelle l'emprunteur a effectivement rendu (tout ou partie de) l'argent. |
| **Montant remboursé** | Somme des remboursements d'un prêt. |
| **Reste dû** | Montant prêté − montant remboursé. |
| **Statut du prêt** | État calculé : En cours, Partiellement remboursé, Remboursé, En retard (voir RG-20). |
| **Total prêté** | Somme des montants prêtés (par emprunteur ou global). |
| **Encours / Reste à recevoir** | Somme des restes dus (par emprunteur ou global). |

## Hypothèses

- H1 — Le volume de données reste modeste (quelques dizaines d'emprunteurs, quelques centaines de prêts).
- H2 — Toutes les sommes sont exprimées dans une seule et même devise.
- H3 — Les dates sont gérées au jour près (pas d'heure).
