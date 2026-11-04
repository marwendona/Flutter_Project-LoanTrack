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
- Filtre rapide de la liste « Par emprunteur » : *Tous* (par défaut) / *Avec reste dû* (reste dû > 0) / *En retard* (au moins un prêt en retard). Le tri RG-04 est conservé, les indicateurs globaux ne sont pas filtrés ; si aucun emprunteur ne correspond : « Aucun emprunteur ne correspond à ce filtre ». Le filtre est conservé pendant la session, non persisté (CR-026).
- État vide : message « Aucun prêt enregistré » + bouton « Ajouter un emprunteur ».
- Règles : RG-30 à RG-33.

## ECR-02 — Liste des emprunteurs

- Liste : nom, reste dû, nombre de prêts actifs, badge retard.
- Appui sur un emprunteur → ECR-03.
- Barre de recherche par nom.
- Bouton flottant **+** → dialogue / feuille « Nouvel emprunteur » (nom, téléphone, note).
- Menu ⋮ → Modifier / Supprimer ; suppression aussi par appui long → dialogue de confirmation (RG-03).
- État vide : « Aucun emprunteur. Appuyez sur + pour en ajouter un. »

## ECR-03 — Détail d'un emprunteur

- En-tête : nom, téléphone (tap = ouvrir le composeur), note ; menu ⋮ → Modifier / Supprimer.
- Résumé : total prêté, total remboursé, reste dû.
- **Liste des prêts** (RG-15). Chaque carte affiche :
  - montant prêté et **date du prêt** ;
  - **date de retour promise** (ou « Non définie ») ;
  - **montant remboursé** / **reste dû** + barre de progression ;
  - **statut** (puce colorée : En cours, Partiellement remboursé, Remboursé, En retard de N jours) ;
  - date de remboursement effective si « Remboursé » (RG-22) ;
  - menu ⋮ → Ajouter un remboursement (ECR-05b, masqué si le prêt est remboursé — CR-020) / Modifier le prêt (ECR-04 en modification) / Supprimer le prêt (dialogue de confirmation, RG-14).
  - appui sur la carte → ECR-05 (CR-021).
- État vide : « Aucun prêt. Appuyez sur « Prêt » pour en ajouter un. »
- Bouton flottant **+ Prêt** → ECR-04.
- Si l'emprunteur n'existe plus (supprimé) : message « Cet emprunteur n'existe plus. » ; après une suppression depuis le menu ⋮, retour à ECR-02.

## ECR-04 — Formulaire prêt (création / modification)

- Champs : montant (clavier numérique, devise affichée), date du prêt (sélecteur, défaut aujourd'hui), date de retour promise (sélecteur, optionnelle), note.
- Validation en ligne avec messages d'erreur sous les champs (RG-10 à RG-13).
- Bouton « Enregistrer » désactivé tant que le formulaire est invalide.
- En modification (titre « Modifier le prêt ») : champs pré-remplis ; le montant ne peut pas être inférieur au montant déjà remboursé (RG-13) et la date du prêt ne peut pas dépasser la date du premier remboursement (RG-11). Si le prêt n'existe plus : message « Ce prêt n'existe plus. »
- Suppression d'un prêt : dialogue « Supprimer ce prêt ? » rappelant le montant et la date du prêt et indiquant que ses remboursements seront supprimés (RG-14).

## ECR-05 — Détail d'un prêt

- Titre « Détail du prêt ». Ouvert par un appui sur une carte de prêt d'ECR-03.
- Toutes les infos du prêt + statut : montant, puce de statut, date du prêt, date de retour promise (ou « Non définie »), date de remboursement effective si « Remboursé » (RG-22), note, montant remboursé / reste dû + barre de progression.
- **Historique des remboursements** : pour chacun, **date réelle** et **montant** (et note si présente), du plus récent au plus ancien ; état vide « Aucun remboursement. » ; appui sur un remboursement → ECR-05b en modification (RG-19, CR-022).
- Bouton **+ Remboursement** → ECR-05b. Masqué si le prêt est remboursé.
- Menu ⋮ → Modifier le prêt / Supprimer le prêt (RG-14) ; après suppression, retour à ECR-03.
- Mise à jour immédiate après un ajout de remboursement ou une modification du prêt.
- Si le prêt n'existe plus : message « Ce prêt n'existe plus. ».

## ECR-05b — Saisie d'un remboursement (feuille modale)

- Titre « Nouveau remboursement ».
- Champs : montant (clavier numérique, devise affichée), date réelle (sélecteur borné entre la date du prêt et aujourd'hui, défaut aujourd'hui), note (facultative, ≤ 200 caractères).
- Rappel du reste dû et bouton « Totalité » qui pré-remplit le montant avec le reste dû (RG-18).
- Validation en ligne RG-16, RG-17 avec messages sous les champs ; bouton « Enregistrer » désactivé tant que la saisie est invalide.
- Après enregistrement, la feuille se ferme ; reste dû, statut et totaux sont mis à jour immédiatement.
- **En modification** (CR-022, ouverte depuis l'historique d'ECR-05) : titre « Modifier le remboursement », champs pré-remplis ; le rappel devient « Montant maximal : … » = reste dû + montant initial du remboursement (RG-16), plafond aussi utilisé par « Totalité » ; bouton **Supprimer** → dialogue « Supprimer ce remboursement ? » rappelant le montant et la date (RG-19), puis fermeture de la feuille.

## ECR-06 — Paramètres

- Devise (RG-40, RG-41) : TND par défaut, verrouillée dès qu'un prêt existe (CR-027).
  - Ligne « Devise » affichant le code et le nom de la devise (ex. « TND — Dinar tunisien »).
  - Aucun prêt : appui → dialogue « Choisir la devise » parmi TND (3 décimales), EUR, USD, GBP, CHF, CAD, MAD, DZD (2 décimales), LYD (3 décimales) ; le choix est enregistré et appliqué immédiatement à tous les montants.
  - Au moins un prêt : ligne en lecture seule (icône cadenas) avec le message « La devise ne peut plus être modifiée une fois des prêts enregistrés ».
- Exporter les données (choix de l'emplacement du fichier) — RG-50 (CR-028).
  - Ligne « Exporter les données » → sélecteur de fichier système, nom proposé `loantrack-sauvegarde-AAAA-MM-JJ.json` (date du jour).
  - Après enregistrement : message « Données exportées » ; en cas d'erreur : « L'export des données a échoué » ; aucun message si le sélecteur est annulé. Ligne désactivée (indicateur de progression) pendant l'export.
- Importer des données (choix du fichier + confirmation de remplacement) — RG-51 (CR-029).
  - Ligne « Importer des données » → sélecteur de fichier système ; aucun message si le sélecteur est annulé.
  - Fichier valide → dialogue « Remplacer toutes les données ? » avec l'aperçu « Sauvegarde du JJ/MM/AAAA : N emprunteurs, M prêts. » et l'avertissement que les données actuelles seront remplacées ; boutons « Annuler » / « Remplacer ».
  - Messages : « Données importées » ; « Fichier invalide : aucune donnée n'a été modifiée » ; « Version de fichier non prise en charge : aucune donnée n'a été modifiée » ; « L'import des données a échoué ». Ligne désactivée (indicateur de progression) pendant la lecture et l'import.
- Thème : Système / Clair / Sombre.
- Version de l'application.

## Formats d'affichage

- Dates : `dd/MM/yyyy` (ex. 30/10/2026).
- Montants : séparateur de milliers espace, séparateur décimal virgule, symbole/code de la devise (ex. `1 250,500 TND`).
- Couleurs de statut : Remboursé = vert, En retard = rouge, Partiellement = orange, En cours = neutre/bleu. Le statut est toujours accompagné d'un libellé texte (pas seulement la couleur).
