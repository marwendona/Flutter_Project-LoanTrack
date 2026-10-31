# LoanTrack

> Une application Android personnelle pour suivre l'argent que je prête.

**LoanTrack** est une application Android (Flutter) **100 % gratuite, hors ligne et à usage personnel** qui permet de suivre les prêts d'argent consentis à des proches : qui me doit combien, depuis quand, quand il a promis de rembourser et ce qu'il a déjà rendu.

- Appareil cible : Samsung Galaxy S22 (Android 14+)
- Distribution : APK signé, installé manuellement (pas de Play Store)
- Données : stockées uniquement sur le téléphone (aucune connexion Internet, aucun compte)
- Technologie : Flutter 3.47.9 (stable) / Dart 3.13.7, développé avec IntelliJ IDEA
- Devise par défaut : TND

## Fonctionnalités principales (V1)

1. **Emprunteurs** : liste, ajout, modification, suppression.
2. **Prêts et remboursements** par emprunteur : montant prêté, date du prêt, date de retour promise, remboursements (partiels ou totaux) avec la date réelle et le montant.
3. **Tableau de bord** : total prêté, total remboursé et reste à recevoir, globalement et par emprunteur.
4. **Sauvegarde / restauration** des données dans un fichier (export / import JSON).

## Organisation du dépôt

| Chemin | Contenu |
|---|---|
| [`CLAUDE.md`](CLAUDE.md) | Instructions pour Claude Code (importe `AGENTS.md`) |
| [`AGENTS.md`](AGENTS.md) | Instructions pour les agents IA (GitHub Copilot, etc.) — source de vérité des conventions |
| [`specifications/`](specifications/) | Spécifications métier (règles, écrans, glossaire) |
| [`change-requests/`](change-requests/) | Journal des demandes de modification (CR) |
| [`docs/ARCHITECTURE_TECHNIQUE.md`](docs/ARCHITECTURE_TECHNIQUE.md) | Choix technologiques et architecture |
| [`docs/EPICS_ET_USER_STORIES.md`](docs/EPICS_ET_USER_STORIES.md) | Backlog d'implémentation (epics, user stories, critères d'acceptation) |
| `lib/`, `test/`, `android/`, `pubspec.yaml` | Code source Flutter (créé à l'étape E0 du backlog) |

## Statut

🚧 **Développement V1** — [CR-001](change-requests/CR-001-initialisation-projet.md) et [CR-002](change-requests/CR-002-flutter-et-intellij.md) approuvées le 2026-10-30 ; epic E0 (socle technique) en cours.
