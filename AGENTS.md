# AGENTS.md — LoanTrack

Instructions pour tout agent IA (GitHub Copilot, Claude Code, …) travaillant sur ce dépôt.
Ce fichier est la **source de vérité** des conventions du projet. `CLAUDE.md` l'importe.

## 1. Le projet en bref

**LoanTrack** est une application **Flutter** (Android uniquement), personnelle, gratuite et **hors ligne**, pour suivre les prêts d'argent consentis à des emprunteurs (montants prêtés, dates promises, remboursements partiels, totaux).

- Un seul utilisateur, un seul appareil (Samsung Galaxy S22), installation par APK.
- Aucun serveur, aucun compte, **aucune permission `INTERNET` dans l'APK release**.
- Devise par défaut : **TND** (3 décimales).
- IDE utilisé : **IntelliJ IDEA** avec les plugins Flutter et Dart (pas d'Android Studio).

## 2. Documents à lire avant de coder

| Besoin | Document |
|---|---|
| Règles métier, écrans, glossaire | `specifications/` (commencer par `specifications/README.md`) |
| Stack, architecture, conventions techniques | `docs/ARCHITECTURE_TECHNIQUE.md` |
| Quoi implémenter et dans quel ordre | `docs/EPICS_ET_USER_STORIES.md` |
| Historique des changements | `change-requests/` |

En cas de contradiction : **spécifications > architecture technique > code existant**. Si un doute subsiste, demander à l'utilisateur plutôt que deviner.

## 3. Stack technique (résumé)

- Flutter (stable) / Dart 3, Material 3 via `material_ui` (importer `package:material_ui/material_ui.dart`, jamais `package:flutter/material.dart` — CR-003) + `dynamic_color`
- État et injection de dépendances : `flutter_riverpod`
- Persistance : Drift (SQLite) ; préférences : `shared_preferences`
- Navigation : `go_router`
- Modèles : `freezed` + `json_serializable` ; génération par `build_runner`
- Textes : `flutter_localizations` + `intl` (ARB, `lib/l10n/app_fr.arb`)
- Fichiers : `file_picker` (sélecteur système, pas de permission de stockage)
- Tests : `flutter_test`, `mocktail`, Drift en mémoire

Détails et justification : `docs/ARCHITECTURE_TECHNIQUE.md`.

## 4. Commandes

```bash
flutter pub get                                      # dépendances
dart run build_runner build --delete-conflicting-outputs   # génération (Drift, freezed, json)
dart run build_runner watch --delete-conflicting-outputs   # génération continue en dev
flutter gen-l10n                                     # textes (aussi fait automatiquement au build)
dart format .                                        # formatage
flutter analyze                                      # analyse statique
flutter test                                         # tests
flutter run                                          # lancer en debug sur le S22 branché
flutter build apk --release --target-platform android-arm64   # APK release signé
flutter install --release                            # installer l'APK release sur le S22
```

## 5. Règles métier non négociables

1. **Montants** : toujours en `int` en **unités mineures** (TND : millimes, `1 250,500 TND` → `1250500`). Jamais de `double` pour l'argent. Manipulation via le type `Money`, formatage uniquement dans la présentation.
2. **Dates** : type `LocalDay` (sans heure), stocké en `epochDay` (`int`). Ne jamais comparer des `DateTime` avec heure pour une règle métier. La date du jour vient du paquet `clock` (`clock.now()`), jamais de `DateTime.now()` direct.
3. **Valeurs calculées non stockées** : montant remboursé, reste dû, statut d'un prêt (`enCours`, `partiellementRembourse`, `rembourse`, `enRetard`) et totaux sont **dérivés**, jamais persistés.
4. Un remboursement ne peut pas dépasser le reste dû du prêt. Un montant est toujours strictement positif.
5. Toute suppression (emprunteur, prêt, remboursement) demande une **confirmation** ; la suppression d'un emprunteur supprime ses prêts et remboursements (cascade, en transaction).

Règles complètes : `specifications/02-regles-metier.md`.

## 6. Conventions de code

- **Langue** : code (identifiants), commits en **anglais** ; textes de l'interface en **français** dans `lib/l10n/app_fr.arb` (aucune chaîne affichée en dur dans les widgets) ; documentation en **français**.
- Respect de [Effective Dart](https://dart.dev/effective-dart) : fichiers en `snake_case.dart`, classes en `UpperCamelCase`, membres en `lowerCamelCase`.
- Structure : `lib/core`, `lib/domain`, `lib/data`, `lib/features/<fonctionnalité>` (voir l'architecture). `test/` reproduit l'arborescence de `lib/`.
- `lib/domain` est du **Dart pur** : aucun import de `package:flutter`, `drift` ou `shared_preferences`.
- Les classes générées par Drift ne sortent pas de `lib/data` : mapper vers les modèles `domain`.
- Un écran = un widget `XxxScreen` (de préférence `ConsumerWidget`) + un controller Riverpod (`XxxController extends Notifier`/`AsyncNotifier`) si l'écran a de la logique. Logique métier dans `domain/services`, jamais dans les widgets.
- Widgets : constructeurs `const` dès que possible, découper les gros `build` en widgets privés plutôt qu'en méthodes.
- Fichiers générés (`*.g.dart`, `*.freezed.dart`) : ne jamais les modifier à la main ; ils sont versionnés.
- Pas de nouveau paquet sans le justifier dans `docs/ARCHITECTURE_TECHNIQUE.md`. Préférer les paquets publiés par `flutter.dev`, `dart.dev` ou très largement adoptés.
- Ne jamais ajouter la permission `INTERNET` au manifeste `main` ni de SDK d'analytics / publicité / crash reporting distant.
- Ne jamais committer `android/key.properties`, `*.jks`, `*.keystore`.

## 7. Tests

- Toute règle de calcul (reste dû, statut, totaux, validations, `Money`, `LocalDay`) est couverte par des **tests unitaires**.
- Les DAOs Drift sont testés avec `NativeDatabase.memory()`.
- Les controllers sont testés via `ProviderContainer` avec overrides et `mocktail`.
- Ne pas déclarer une tâche terminée si `flutter analyze` ou `flutter test` échoue.

## 8. Processus de changement

1. **Tout changement du dépôt fait l'objet d'une Change Request**, sans exception (CR-015). Cela inclut :
   - l'implémentation d'une user story (**une CR par story**) ;
   - une nouvelle règle, un nouvel écran, un changement de comportement ;
   - un choix technique, un changement de stack, l'ajout ou la mise à jour d'une dépendance ;
   - une correction de bug, un refactoring ;
   - une modification de configuration (Android, build, analyse), de documentation, de spécification ou des fichiers d'agents (`AGENTS.md`, `CLAUDE.md`).
2. La CR est créée **avant** toute modification : copier `CR-000-modele.md` en `CR-XXX-titre-court.md` (numéro suivant), statut `En cours`, et l'ajouter à l'index `change-requests/README.md`.
3. Les changements liés à une même demande sont regroupés dans **une seule CR** ; des demandes indépendantes donnent des CR distinctes.
4. Mettre à jour la ou les spécifications impactées dans `specifications/` **dans le même changement**, et `docs/EPICS_ET_USER_STORIES.md` si le backlog est impacté.
5. Une fois le travail terminé et vérifié : passer la CR à `Implémentée`, cocher ses critères d'acceptation, noter dans « Suivi de l'implémentation » les écarts ou réserves éventuels, puis mettre à jour l'index. Le commit (s'il est demandé) est référencé dans la CR.

## 9. Definition of Done d'une user story

- [ ] Critères d'acceptation de la story satisfaits
- [ ] Tests ajoutés / mis à jour et verts (`flutter test`)
- [ ] `flutter analyze` sans erreur ni avertissement, code formaté (`dart format`)
- [ ] Code généré à jour (`build_runner`)
- [ ] Textes UI dans `app_fr.arb`, mode sombre vérifié
- [ ] CR de la story créée avant le développement et passée à `Implémentée` (index `change-requests/README.md` à jour)
- [ ] Spécifications à jour si le comportement a changé
- [ ] Statut de la story mis à jour dans `docs/EPICS_ET_USER_STORIES.md`
