# 05 — Questions ouvertes

Points à trancher par le propriétaire du produit. Les décisions ci-dessous sont celles du propriétaire ; elles deviennent définitives à l'approbation de CR-001 et CR-002.

| ID | Question | Réponse du propriétaire | Décision |
|---|---|---|---|
| Q-01 | Quelle devise utiliser ? | TND. | ✅ TND par défaut, 3 décimales (RG-40) |
| Q-02 | Faut-il pouvoir changer de devise après avoir saisi des données ? | Non. | ✅ Devise verrouillée dès qu'un prêt existe (RG-41) |
| Q-03 | Un emprunteur peut-il avoir plusieurs prêts distincts, chacun avec sa date promise ? | Oui (modèle Emprunteur → Prêts → Remboursements). | ✅ |
| Q-04 | Désactiver la sauvegarde Google/Samsung automatique pour la confidentialité ? | Oui, export JSON manuel à la place (ENF-02). | ✅ |
| Q-05 | Verrouiller l'application par empreinte / code du téléphone ? | Non en V1, prévu en V2 (US-8.1). | ✅ |
| Q-06 | Rappels (notification à la date promise) ? | Non en V1, prévu en V2 (US-8.2). | ✅ |
| Q-07 | La date de retour promise est-elle obligatoire ? | Non, optionnelle (certains prêts n'ont pas de date convenue). | ✅ |
| Q-08 | Nom de l'application : « Kridi » convient-il ? | Non. « LoanTrack ». | ✅ **LoanTrack** (`com.loantrack.app`) |
| Q-09 | Technologie et IDE ? | Flutter + IntelliJ IDEA. | ✅ (CR-002) |
| Q-10 | Un prêt en retard pas encore soldé compte-t-il pour la couleur de fiabilité ? | Oui, son retard court jusqu'à aujourd'hui. | ✅ RG-60 (CR-035) |
| Q-11 | Deux prêts en retard, tous deux de plus d'un mois : quelle couleur ? | Rouge. | ✅ RG-62 (CR-035) |
| Q-12 | Couleur d'un emprunteur sans prêt évalué ? | Gris « Non évalué ». | ✅ RG-62 (CR-035) |
| Q-13 | Où placer la page des emprunteurs par couleur ? | Écran ouvert depuis la liste des emprunteurs ; 3 onglets conservés. | ✅ ECR-07 (CR-035) |
