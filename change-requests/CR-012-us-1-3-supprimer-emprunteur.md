# CR-012 — US-1.3 : supprimer un emprunteur

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — (non livrée, prévue en 1.0.0) |

## 1. Demande

**Je veux** supprimer un emprunteur **afin de** nettoyer ma liste (US-1.3, ECR-02, RG-03).

## 2. Motivation

Retirer les personnes qui ne sont plus suivies.

## 3. Changement proposé

- Sur ECR-02, appui long sur une ligne ou menu ⋮ → « Supprimer ».
- Dialogue « Supprimer cet emprunteur ? » indiquant le nombre de prêts supprimés et le reste dû (ex. « 2 prêts seront supprimés. Reste dû : 1 000,000 TND. ») ; boutons « Annuler » / « Supprimer » (RG-03).
- Suppression en cascade des prêts et remboursements dans une transaction (clés étrangères `CASCADE`, livrées avec CR-007) ; la liste et les totaux se mettent à jour immédiatement.
- En cas d'échec : message « Impossible d'enregistrer. Réessayez. »

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucun (applique RG-03) |
| Écrans | ECR-02 (appui long, menu ⋮, dialogue) ; ECR-03 (menu ⋮ → Supprimer) à faire |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-1.3 |
| Tests | Cascade testée au niveau DAO et repository (CR-007) ; aucun test de l'écran ni du dialogue |

## 5. Critères d'acceptation

- [x] Accessible par appui long / menu ⋮ sur ECR-02.
- [ ] Accessible depuis le détail de l'emprunteur — ECR-03 n'existe pas encore (arrive avec E2).
- [x] Dialogue de confirmation indiquant le nombre de prêts et le reste dû supprimés (RG-03).
- [x] Suppression en cascade dans une transaction ; totaux mis à jour immédiatement.

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : `2784eeb` (delete borrower).
- Remarques :
  - l'accès depuis ECR-03 reste à ajouter lors de la création de cet écran ;
  - pas de test de widget pour le dialogue de suppression ;
  - l'info-bulle du menu ⋮ utilise le texte « Annuler » (`actionCancel`) au lieu d'un libellé dédié.
