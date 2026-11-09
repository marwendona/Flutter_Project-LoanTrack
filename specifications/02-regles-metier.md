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
- **RG-11** — La date du prêt est obligatoire et ne peut pas être dans le futur. En modification, elle ne peut pas être postérieure à la date du premier remboursement du prêt (cohérence avec RG-17, CR-019).
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

### Fiabilité des emprunteurs (V2, CR-035)

Chaque emprunteur reçoit une **couleur de fiabilité** calculée à partir de la ponctualité de ses remboursements.

- **RG-60** — Retard d'un prêt. Seuls les prêts ayant une **date de retour promise** sont évalués. Pour un tel prêt :
  1. **soldé** (reste dû = 0) : la *date de fin* est sa date de remboursement effective (RG-22). Le prêt est **en retard** si la date de fin est strictement postérieure à la date promise ; sinon il est **à l'heure** (remboursé avant ou le jour de la date promise) ;
  2. **non soldé et date promise strictement antérieure à aujourd'hui** (statut « En retard », RG-20) : le prêt est **en retard** et sa *date de fin* est aujourd'hui (le retard continue de courir, Q-10) ;
  3. **non soldé et date promise aujourd'hui ou plus tard** : prêt **pas encore évaluable** ;
  4. un prêt **sans date de retour promise** n'est jamais évaluable.

  Un prêt est dit **évalué** s'il est à l'heure ou en retard. Seule la date de fin compte : les remboursements partiels antérieurs ne changent rien.
- **RG-61** — Retard court / retard long. Le retard d'un prêt en retard est **court** si la date de fin est au plus tard le même jour du mois suivant la date promise (« ne dépasse pas un mois ») ; il est **long** sinon. Si ce jour n'existe pas dans le mois suivant, on prend le dernier jour de ce mois.
  Exemples : date promise 15/03 → remboursé le 15/04 = court, le 16/04 = long ; date promise 31/01/2027 → limite du retard court le 28/02/2027.
- **RG-62** — Couleur de fiabilité. Soit **N** le nombre de prêts en retard de l'emprunteur et **L** le nombre de ces retards qui sont longs (RG-61) :

  | Couleur | Condition | Libellé affiché |
  |---|---|---|
  | **Vert** | N = 0 et au moins un prêt évalué (tous à l'heure) | Toujours à l'heure |
  | **Bleu** | N = 1 et L = 0 | 1 retard court |
  | **Violet** | N = 1 et L = 1 | 1 retard long |
  | **Jaune** | N = 2 et L = 0 | 2 retards courts |
  | **Orange** | N = 2 et L = 1 | 2 retards dont 1 long |
  | **Rouge** | N = 2 et L = 2 (Q-11), ou N = 3 | Retards fréquents |
  | **Noir** | N > 3 | Retards très fréquents |
  | **Gris** | aucun prêt évalué (aucun prêt, ou seulement des prêts non échus / sans date promise) | Non évalué (Q-12) |

  Les retards comptent sur **tous** les prêts de l'emprunteur, y compris ceux soldés depuis longtemps.
- **RG-63** — La couleur de fiabilité est une valeur **dérivée** : jamais saisie, stockée ni exportée (RG-50). Elle est recalculée à chaque affichage avec la date du jour ; elle peut donc changer sans action de l'utilisateur (ex. un retard en cours qui dépasse un mois devient long, un prêt dont la date promise est dépassée devient en retard) et après tout ajout, modification ou suppression d'un prêt ou d'un remboursement.
- **RG-64** — Ordre des couleurs, du plus fiable au moins fiable : Vert, Bleu, Violet, Jaune, Orange, Rouge, Noir, puis Gris (Non évalué) en dernier. À l'intérieur d'une même couleur, les emprunteurs sont triés selon RG-04.

### Devise
- **RG-40** — Une seule devise pour toute l'application, **TND par défaut** (3 décimales, unité mineure : millime). Le nombre de décimales suit la devise (code ISO 4217, ex. EUR : 2 décimales).
- **RG-41** — La devise ne peut être changée dans les paramètres **que tant qu'aucun prêt n'a été saisi**. Dès qu'un prêt existe, le choix est verrouillé et affiché en lecture seule avec le message « La devise ne peut plus être modifiée une fois des prêts enregistrés » (Q-02).

### Sauvegarde
- **RG-50** — L'export produit un fichier JSON contenant la version du format, la date d'export, la devise et toutes les données.
  - Format v1 (CR-028) : `{ formatVersion: 1, exportedAt, currency, borrowers[], loans[], repayments[] }` ; `exportedAt` en ISO 8601 UTC, `currency` en code ISO 4217.
  - Emprunteur : `id`, `name`, `phone`, `note`, `createdAt` ; prêt : `id`, `borrowerId`, `amountMinor`, `loanDate`, `promisedReturnDate`, `note` ; remboursement : `id`, `loanId`, `amountMinor`, `repaymentDate`, `note`.
  - Montants en unités mineures (entiers), dates au format `AAAA-MM-JJ`, champs facultatifs absents à `null`. Aucune valeur calculée (remboursé, reste dû, statut, totaux) n'est exportée.
- **RG-51** — L'import **remplace** toutes les données existantes, après confirmation. Un fichier invalide ou d'une version inconnue est refusé sans rien modifier.
  - Contrôles avant toute écriture (CR-029) : JSON UTF-8 conforme au format v1 (champs, types, nombres entiers, dates `AAAA-MM-JJ`) ; `formatVersion` = 1 ; devise proposée (RG-40) ; identifiants uniques ; chaque prêt référence un emprunteur du fichier et chaque remboursement un prêt du fichier ; RG-01, RG-02, RG-10, RG-12, RG-16 (somme des remboursements ≤ montant du prêt), RG-17 (remboursement ≥ date du prêt) et longueurs des notes. Les règles « pas de date dans le futur » ne sont pas contrôlées.
  - Le remplacement se fait dans une seule transaction (ENF-06), identifiants conservés ; la devise du fichier devient la devise de l'application.
