# CLAUDE.md — LoanTrack

Les conventions communes à tous les agents IA sont dans `AGENTS.md` (source de vérité, partagée avec GitHub Copilot). Elles sont importées ci-dessous :

@AGENTS.md

## Spécifique à Claude Code

- **Langue de réponse** : répondre à l'utilisateur en **français**.
- **Change Request systématique** : tout changement, quel qu'il soit (story, correction de bug, refactoring, dépendance, configuration, documentation, fichiers d'agents), commence par la création de sa CR dans `change-requests/` selon `AGENTS.md` §8. Ne modifier aucun autre fichier avant que la CR existe. Si une demande ne précise pas de CR, la créer quand même.
- **Avant d'implémenter une user story** : relire la story dans `docs/EPICS_ET_USER_STORIES.md` et les spécifications qu'elle référence, créer la CR de la story, puis annoncer brièvement le plan (CR créée, fichiers créés/modifiés) avant de coder.
- **Une story à la fois** : ne pas anticiper les stories suivantes ni ajouter de fonctionnalités non demandées.
- **Changement fonctionnel demandé en cours de route** : créer d'abord sa CR (distincte de celle de la story en cours), mettre à jour la spec, puis coder.
- **Fin de tâche** : passer la CR à `Implémentée` avec ses critères cochés et les réserves éventuelles, mettre à jour l'index, et indiquer le numéro de la CR dans le compte rendu.
- **Vérification** : après modification du code, lancer `dart run build_runner build --delete-conflicting-outputs` (si des modèles/tables ont changé), puis `flutter analyze` et `flutter test`, et rapporter le résultat réel (succès ou échec avec la sortie).
- **Git** : ne committer ou pousser que si l'utilisateur le demande. Messages de commit en anglais au format Conventional Commits, en référençant la story et la CR (ex. `feat(borrowers): add borrower creation form [US-1.2, CR-011]`, ou `[CR-XXX]` seul hors story).
- **Environnement** : Windows 11, shell PowerShell, IDE IntelliJ IDEA (plugins Flutter/Dart). Ne pas proposer de solutions spécifiques à Android Studio.
- **Secrets** : ne jamais lire, afficher ni recopier le contenu de `android/key.properties` ou des fichiers keystore.
