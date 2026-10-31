# CLAUDE.md — LoanTrack

Les conventions communes à tous les agents IA sont dans `AGENTS.md` (source de vérité, partagée avec GitHub Copilot). Elles sont importées ci-dessous :

@AGENTS.md

## Spécifique à Claude Code

- **Langue de réponse** : répondre à l'utilisateur en **français**.
- **Avant d'implémenter une user story** : relire la story dans `docs/EPICS_ET_USER_STORIES.md` et les spécifications qu'elle référence. Annoncer brièvement le plan (fichiers créés/modifiés) avant de coder.
- **Une story à la fois** : ne pas anticiper les stories suivantes ni ajouter de fonctionnalités non demandées.
- **Changement fonctionnel demandé en cours de route** : créer d'abord la CR (`change-requests/`), mettre à jour la spec, puis coder.
- **Vérification** : après modification du code, lancer `dart run build_runner build --delete-conflicting-outputs` (si des modèles/tables ont changé), puis `flutter analyze` et `flutter test`, et rapporter le résultat réel (succès ou échec avec la sortie).
- **Git** : ne committer ou pousser que si l'utilisateur le demande. Messages de commit en anglais au format Conventional Commits, en référençant la story (ex. `feat(borrowers): add borrower creation form [US-1.2]`).
- **Environnement** : Windows 11, shell PowerShell, IDE IntelliJ IDEA (plugins Flutter/Dart). Ne pas proposer de solutions spécifiques à Android Studio.
- **Secrets** : ne jamais lire, afficher ni recopier le contenu de `android/key.properties` ou des fichiers keystore.
