# Change Requests (CR)

Journal de **toutes les modifications** du produit : chaque changement fonctionnel, de règle métier, d'écran ou d'architecture y est tracé.

## Processus

1. Copier [`CR-000-modele.md`](CR-000-modele.md) en `CR-XXX-titre-court.md` (numéro suivant, 3 chiffres, titre en kebab-case).
2. Remplir la demande, l'analyse d'impact et les documents à modifier. Statut : **Proposée**.
3. Le propriétaire du produit valide → statut **Approuvée** (ou **Rejetée** avec motif).
4. Implémentation : mettre à jour les spécifications, le backlog et le code → statut **Implémentée** (indiquer la version de l'APK).
5. Ajouter / mettre à jour la ligne dans l'index ci-dessous.

Statuts possibles : `Proposée` · `Approuvée` · `Rejetée` · `En cours` · `Implémentée`

**Aucune exception** (CR-015) : chaque implémentation de user story (une CR par story), correction de bug, refactoring, mise à jour de dépendance, modification de configuration, de documentation ou des fichiers d'agents a sa CR, créée **avant** la modification avec le statut `En cours`. Les changements liés à une même demande sont regroupés dans une seule CR.

## Index

| CR | Titre | Type | Statut | Date | Version |
|---|---|---|---|---|---|
| [CR-001](CR-001-initialisation-projet.md) | Initialisation du projet et périmètre V1 | Initialisation | Approuvée | 2026-10-30 | — |
| [CR-002](CR-002-flutter-et-intellij.md) | Passage à Flutter et IntelliJ IDEA, nom LoanTrack, décisions des questions ouvertes | Technique + Règle métier | Approuvée | 2026-10-30 | — |
| [CR-003](CR-003-material-ui.md) | Adoption du paquet `material_ui` pour Material Design | Technique | Approuvée | 2026-10-30 | — |
| [CR-004](CR-004-us-0-1-creation-projet-flutter.md) | US-0.1 : environnement et création du projet Flutter | Technique | Implémentée | 2026-11-04 | — |
| [CR-005](CR-005-us-0-2-qualite-et-tests.md) | US-0.2 : qualité et tests | Technique | Implémentée | 2026-11-04 | — |
| [CR-006](CR-006-us-0-3-theme-textes-navigation.md) | US-0.3 : thème, textes et navigation | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-007](CR-007-us-0-4-base-de-donnees-et-providers.md) | US-0.4 : base de données et providers | Technique | Implémentée | 2026-11-04 | — |
| [CR-008](CR-008-us-0-5-types-money-et-localday.md) | US-0.5 : types `Money` et `LocalDay` | Technique | Implémentée | 2026-11-04 | — |
| [CR-009](CR-009-us-0-6-signature-release.md) | US-0.6 : signature release | Technique | Implémentée | 2026-11-04 | — |
| [CR-010](CR-010-us-1-1-lister-emprunteurs.md) | US-1.1 : lister les emprunteurs | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-011](CR-011-us-1-2-ajouter-emprunteur.md) | US-1.2 : ajouter un emprunteur | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-012](CR-012-us-1-3-supprimer-emprunteur.md) | US-1.3 : supprimer un emprunteur | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-013](CR-013-us-1-4-modifier-emprunteur.md) | US-1.4 : modifier un emprunteur | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-014](CR-014-us-1-5-rechercher-emprunteur.md) | US-1.5 : rechercher un emprunteur | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-015](CR-015-cr-pour-tout-changement.md) | Change Request obligatoire pour tout changement | Processus | Implémentée | 2026-11-04 | — |
| [CR-016](CR-016-us-2-1-enregistrer-pret.md) | US-2.1 : enregistrer un prêt | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-017](CR-017-us-2-2-detail-emprunteur.md) | US-2.2 : voir le détail d'un emprunteur et ses prêts | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-018](CR-018-us-2-3-statut-calcule-pret.md) | US-2.3 : statut calculé d'un prêt | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-019](CR-019-us-2-4-modifier-supprimer-pret.md) | US-2.4 : modifier / supprimer un prêt | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-020](CR-020-us-3-1-enregistrer-remboursement.md) | US-3.1 : enregistrer un remboursement | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-021](CR-021-us-3-2-historique-remboursements.md) | US-3.2 : historique des remboursements d'un prêt | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-022](CR-022-us-3-3-modifier-supprimer-remboursement.md) | US-3.3 : modifier / supprimer un remboursement | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-023](CR-023-us-3-4-tests-integration-reste-du.md) | US-3.4 : tests d'intégration du calcul de reste dû | Technique | Implémentée | 2026-11-04 | — |
| [CR-024](CR-024-us-4-1-totaux-globaux.md) | US-4.1 : totaux globaux | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-025](CR-025-us-4-2-totaux-par-emprunteur.md) | US-4.2 : totaux par emprunteur | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-026](CR-026-us-4-3-filtres-tableau-de-bord.md) | US-4.3 : filtres du tableau de bord | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-027](CR-027-us-5-1-choix-devise.md) | US-5.1 : choix de la devise | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-028](CR-028-us-5-2-exporter-donnees.md) | US-5.2 : exporter les données | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-029](CR-029-us-5-3-importer-donnees.md) | US-5.3 : importer des données | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-030](CR-030-us-5-4-theme-et-informations.md) | US-5.4 : thème et informations | Nouvelle fonctionnalité | Implémentée | 2026-11-04 | — |
| [CR-031](CR-031-us-6-1-icone-et-ecran-de-demarrage.md) | US-6.1 : icône et écran de démarrage | Nouvelle fonctionnalité | Implémentée | 2026-11-05 | — |
| [CR-032](CR-032-us-6-2-accessibilite-et-ergonomie.md) | US-6.2 : accessibilité et ergonomie | Évolution | Implémentée | 2026-11-05 | — |
| [CR-033](CR-033-us-6-3-test-parcours-complet.md) | US-6.3 : test du parcours complet | Technique | En cours | 2026-11-05 | — |
