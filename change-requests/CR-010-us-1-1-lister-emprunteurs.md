# CR-010 — US-1.1 : lister les emprunteurs

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — (non livrée, prévue en 1.0.0) |

## 1. Demande

**En tant que** prêteur, **je veux** voir la liste de mes emprunteurs **afin de** retrouver rapidement une personne (US-1.1, ECR-02).

## 2. Motivation

L'écran Emprunteurs est le point d'entrée de la gestion des personnes et des prêts.

## 3. Changement proposé

- Chaque ligne de ECR-02 affiche : nom, reste dû (`1 250,500 TND`), nombre de prêts actifs, badge « En retard » si au moins un prêt de l'emprunteur est en retard (RG-20).
- **Prêt actif** = prêt dont le reste dû est strictement positif (précision apportée par cette story, le terme n'étant pas défini dans les spécifications).
- Tri par reste dû décroissant, puis par nom A→Z sans tenir compte de la casse (RG-04).
- État vide : « Aucun emprunteur. Appuyez sur + pour en ajouter un. »
- Totaux par emprunteur (RG-21, RG-30) calculés à la volée : agrégation SQL des remboursements par prêt (`BorrowersDao.watchWithLoanBalances`), puis calcul dans `domain/services/borrower_summary_calculator.dart`. Rien n'est stocké.
- Liste mise à jour automatiquement à chaque changement d'emprunteur, de prêt ou de remboursement (flux Drift).
- Devise fournie par `currencyProvider` (TND fixe en attendant E5).

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucun changement de règle ; la définition de « prêt actif » est notée dans le backlog |
| Écrans | ECR-02 |
| Base de données | Non (nouvelle requête de lecture uniquement) |
| Format d'export JSON | Non |
| Backlog | US-1.1 |
| Tests | Calculateur (retard, totaux, tri), requête Drift, repository, écran (`borrowers_screen_test.dart`) |

## 5. Critères d'acceptation

- [x] Chaque ligne : nom, reste dû, nombre de prêts actifs, badge « En retard ».
- [x] Tri par reste dû décroissant puis nom (RG-04).
- [x] État vide explicite.

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : `2b02bdf` (list the borrowers).
- Remarques : définition de « prêt actif » à reporter dans le glossaire (`specifications/01-vision-et-glossaire.md`) si le propriétaire la confirme.
