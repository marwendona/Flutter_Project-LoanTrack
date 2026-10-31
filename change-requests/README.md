# Change Requests (CR)

Journal de **toutes les modifications** du produit : chaque changement fonctionnel, de règle métier, d'écran ou d'architecture y est tracé.

## Processus

1. Copier [`CR-000-modele.md`](CR-000-modele.md) en `CR-XXX-titre-court.md` (numéro suivant, 3 chiffres, titre en kebab-case).
2. Remplir la demande, l'analyse d'impact et les documents à modifier. Statut : **Proposée**.
3. Le propriétaire du produit valide → statut **Approuvée** (ou **Rejetée** avec motif).
4. Implémentation : mettre à jour les spécifications, le backlog et le code → statut **Implémentée** (indiquer la version de l'APK).
5. Ajouter / mettre à jour la ligne dans l'index ci-dessous.

Statuts possibles : `Proposée` · `Approuvée` · `Rejetée` · `En cours` · `Implémentée`

Non concerné : corrections de bugs sans changement du comportement attendu, refactorings internes, mises à jour de dépendances mineures.

## Index

| CR | Titre | Type | Statut | Date | Version |
|---|---|---|---|---|---|
| [CR-001](CR-001-initialisation-projet.md) | Initialisation du projet et périmètre V1 | Initialisation | Approuvée | 2026-10-30 | — |
| [CR-002](CR-002-flutter-et-intellij.md) | Passage à Flutter et IntelliJ IDEA, nom LoanTrack, décisions des questions ouvertes | Technique + Règle métier | Approuvée | 2026-10-30 | — |
| [CR-003](CR-003-material-ui.md) | Adoption du paquet `material_ui` pour Material Design | Technique | Approuvée | 2026-10-30 | — |
