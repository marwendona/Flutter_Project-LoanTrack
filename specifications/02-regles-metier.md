# 02 — Modèle métier et règles de gestion

## 1. Modèle de données métier

```
Emprunteur 1 ──── * Prêt 1 ──── * Remboursement
```

### Emprunteur
| Champ | Type | Obligatoire | Remarque |
|---|---|---|---|
| Nom | Texte (1–60 car.) | Oui | Affiché partout |
| Téléphone | Texte | Non | Information de contact uniquement |
| Note | Texte (≤ 500 car.) | Non | Libre |
| Date de création | Date | Auto | |

### Prêt
| Champ | Type | Obligatoire | Remarque |
|---|---|---|---|
| Emprunteur | Référence | Oui | |
| Montant prêté | Montant > 0 | Oui | |
| Date du prêt | Date | Oui | Par défaut : aujourd'hui |
| Date de retour promise | Date | Non | ≥ date du prêt |
| Note / motif | Texte (≤ 500 car.) | Non | Ex. « pour la voiture » |

### Remboursement
| Champ | Type | Obligatoire | Remarque |
|---|---|---|---|
| Prêt | Référence | Oui | |
| Montant remboursé | Montant > 0 | Oui | ≤ reste dû |
| Date réelle de remboursement | Date | Oui | Par défaut : aujourd'hui |
| Note | Texte (≤ 200 car.) | Non | |

## 2. Règles de gestion

### Emprunteurs
- **RG-01** — Le nom d'un emprunteur est obligatoire, sans espaces en début/fin, de 1 à 60 caractères.
- **RG-02** — Deux emprunteurs ne peuvent pas avoir le même nom (comparaison insensible à la casse et aux espaces de début/fin). Message : « Un emprunteur porte déjà ce nom. »
- **RG-03** — La suppression d'un emprunteur demande une confirmation explicite indiquant le nombre de prêts et le reste dû qui seront supprimés. Elle supprime en cascade ses prêts et remboursements.
- **RG-04** — La liste des emprunteurs est triée par défaut par reste dû décroissant, puis par nom (A→Z).

### Prêts
- **RG-10** — Le montant prêté est strictement positif et ne dépasse pas 999 999 999 (en unités majeures).
- **RG-11** — La date du prêt est obligatoire et ne peut pas être dans le futur.
- **RG-12** — La date de retour promise, si renseignée, est postérieure ou égale à la date du prêt.
- **RG-13** — Le montant d'un prêt ne peut pas être modifié à une valeur inférieure au montant déjà remboursé.
- **RG-14** — La suppression d'un prêt demande confirmation et supprime ses remboursements.
- **RG-15** — Les prêts d'un emprunteur sont affichés du plus récent au plus ancien (date du prêt).

### Remboursements
- **RG-16** — Le montant d'un remboursement est strictement positif et **ne peut pas dépasser le reste dû** du prêt (en modification : reste dû + montant initial du remboursement modifié).
- **RG-17** — La date réelle de remboursement est obligatoire, ≥ date du prêt et ne peut pas être dans le futur.
- **RG-18** — Un raccourci « Rembourser la totalité » pré-remplit le montant avec le reste dû.
- **RG-19** — Un remboursement peut être modifié ou supprimé (avec confirmation).

### Calculs (toujours dérivés, jamais saisis)
- **RG-20** — Statut d'un prêt (évalué dans cet ordre) :
  1. **Remboursé** si reste dû = 0 ;
  2. **En retard** si une date de retour promise existe, qu'elle est strictement antérieure à aujourd'hui et que reste dû > 0 ;
  3. **Partiellement remboursé** si montant remboursé > 0 ;
  4. **En cours** sinon.
- **RG-21** — Montant remboursé d'un prêt = somme de ses remboursements. Reste dû = montant prêté − montant remboursé.
- **RG-22** — Date de remboursement effective d'un prêt (affichée quand le statut est « Remboursé ») = date du dernier remboursement.
- **RG-23** — Retard affiché : nombre de jours entre la date de retour promise et aujourd'hui pour un prêt « En retard ».

### Totaux
- **RG-30** — Par emprunteur : total prêté (somme des prêts), total remboursé, reste dû, nombre de prêts, nombre de prêts en retard.
- **RG-31** — Global : total prêté, total remboursé, reste à recevoir, nombre d'emprunteurs ayant un reste dû > 0, nombre de prêts en retard et montant en retard.
- **RG-32** — Taux de remboursement global = total remboursé / total prêté (affiché en %, 0 % si aucun prêt).
- **RG-33** — Les totaux tiennent compte de tous les prêts, y compris ceux entièrement remboursés (le reste dû de ces derniers est 0).

### Devise
- **RG-40** — Une seule devise pour toute l'application, **TND par défaut** (3 décimales, unité mineure : millime). Le nombre de décimales suit la devise (code ISO 4217, ex. EUR : 2 décimales).
- **RG-41** — La devise ne peut être changée dans les paramètres **que tant qu'aucun prêt n'a été saisi**. Dès qu'un prêt existe, le choix est verrouillé et affiché en lecture seule avec le message « La devise ne peut plus être modifiée une fois des prêts enregistrés » (Q-02).

### Sauvegarde
- **RG-50** — L'export produit un fichier JSON contenant la version du format, la date d'export, la devise et toutes les données.
- **RG-51** — L'import **remplace** toutes les données existantes, après confirmation. Un fichier invalide ou d'une version inconnue est refusé sans rien modifier.
