# 03 — Écrans et parcours

## Navigation

Barre de navigation inférieure à 3 onglets :

| Onglet | Écran |
|---|---|
| 📊 Tableau de bord | ECR-01 (écran d'accueil) |
| 👥 Emprunteurs | ECR-02 |
| ⚙️ Paramètres | ECR-06 |

```
ECR-01 Tableau de bord ──(tap emprunteur)──► ECR-03 Détail emprunteur
ECR-02 Emprunteurs ──(tap)──► ECR-03 ──(+ Prêt)──► ECR-04 Formulaire prêt
                                     └─(tap prêt)──► ECR-05 Détail prêt ──(+ Remboursement)──► ECR-05b
```

## ECR-01 — Tableau de bord (accueil)

Visualisation de la totalité du crédit, global et par emprunteur.

- **Carte « Reste à recevoir »** (mise en avant) : montant global restant dû.
- **Indicateurs** : total prêté, total remboursé, taux de remboursement (barre de progression), nombre de prêts en retard + montant en retard (en rouge si > 0).
- **Liste « Par emprunteur »** : pour chaque emprunteur → nom, total prêté, total remboursé, reste dû, badge « En retard » le cas échéant. Tri : reste dû décroissant (RG-04).
- Filtre rapide : *Tous* / *Avec reste dû* / *En retard*.
- État vide : message « Aucun prêt enregistré » + bouton « Ajouter un emprunteur ».
- Règles : RG-30 à RG-33.

## ECR-02 — Liste des emprunteurs

- Liste : nom, reste dû, nombre de prêts actifs, badge retard.
- Barre de recherche par nom.
- Bouton flottant **+** → dialogue / feuille « Nouvel emprunteur » (nom, téléphone, note).
- Suppression : appui long ou menu ⋮ → « Supprimer » → dialogue de confirmation (RG-03).
- État vide : « Aucun emprunteur. Appuyez sur + pour en ajouter un. »

## ECR-03 — Détail d'un emprunteur

- En-tête : nom, téléphone (tap = ouvrir le composeur), note ; menu ⋮ → Modifier / Supprimer.
- Résumé : total prêté, total remboursé, reste dû.
- **Liste des prêts** (RG-15). Chaque carte affiche :
  - montant prêté et **date du prêt** ;
  - **date de retour promise** (ou « Non définie ») ;
  - **montant remboursé** / **reste dû** + barre de progression ;
  - **statut** (puce colorée : En cours, Partiellement remboursé, Remboursé, En retard de N jours) ;
  - date de remboursement effective si « Remboursé » (RG-22).
- Bouton flottant **+ Prêt** → ECR-04.

## ECR-04 — Formulaire prêt (création / modification)

- Champs : montant (clavier numérique, devise affichée), date du prêt (sélecteur, défaut aujourd'hui), date de retour promise (sélecteur, optionnelle), note.
- Validation en ligne avec messages d'erreur sous les champs (RG-10 à RG-13).
- Bouton « Enregistrer » désactivé tant que le formulaire est invalide.

## ECR-05 — Détail d'un prêt

- Toutes les infos du prêt + statut.
- **Historique des remboursements** : pour chacun, **date réelle** et **montant** ; appui → modifier / supprimer (RG-19).
- Bouton **+ Remboursement** → ECR-05b. Masqué si le prêt est remboursé.
- Menu ⋮ → Modifier le prêt / Supprimer le prêt (RG-14).

## ECR-05b — Saisie d'un remboursement (feuille modale)

- Champs : montant, date réelle (défaut aujourd'hui), note.
- Rappel du reste dû et bouton « Totalité » (RG-18).
- Validation RG-16, RG-17.

## ECR-06 — Paramètres

- Devise (RG-40, RG-41) : TND par défaut, verrouillée dès qu'un prêt existe.
- Exporter les données (choix de l'emplacement du fichier) — RG-50.
- Importer des données (choix du fichier + confirmation de remplacement) — RG-51.
- Thème : Système / Clair / Sombre.
- Version de l'application.

## Formats d'affichage

- Dates : `dd/MM/yyyy` (ex. 30/10/2026).
- Montants : séparateur de milliers espace, séparateur décimal virgule, symbole/code de la devise (ex. `1 250,500 TND`).
- Couleurs de statut : Remboursé = vert, En retard = rouge, Partiellement = orange, En cours = neutre/bleu. Le statut est toujours accompagné d'un libellé texte (pas seulement la couleur).
