# CR-030 — US-5.4 : thème et informations

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — |

## 1. Demande

Choisir le thème de l'application (Système / Clair / Sombre) et afficher la version de l'application dans les Paramètres (US-5.4).

## 2. Motivation

Permettre de forcer le mode clair ou sombre indépendamment du réglage du téléphone, et connaître la version installée (utile lors des mises à jour d'APK, ENF-11).

## 3. Changement proposé

- ECR-06 Paramètres : ligne « Thème » affichant le thème choisi ; appui → dialogue « Choisir le thème » : *Système* (par défaut), *Clair*, *Sombre*.
- Le choix est enregistré dans `shared_preferences` (clé `themeMode`) et appliqué immédiatement à toute l'application (`MaterialApp.themeMode`) ; une valeur absente ou inconnue vaut *Système*. Les couleurs dynamiques (Material You) restent utilisées dans les deux modes.
- ECR-06 : ligne « Version » en lecture seule affichant `versionName (versionCode)`, ex. « 1.0.0 (1) », lue depuis le paquet installé.
- Nouveau paquet `package_info_plus` (Flutter Community, très largement adopté, sans permission) pour lire la version du paquet installé : évite de dupliquer la version de `pubspec.yaml` dans le code. Justification ajoutée à `docs/ARCHITECTURE_TECHNIQUE.md`.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | `03-ecrans-et-parcours.md` (ECR-06 : détail des lignes Thème et Version) ; `docs/ARCHITECTURE_TECHNIQUE.md` (paquet `package_info_plus`) |
| Écrans | ECR-06, thème global de l'application |
| Base de données | Non |
| Format d'export JSON | Non (le thème n'est pas exporté : préférence d'affichage propre à l'appareil) |
| Backlog | US-5.4 terminée |
| Tests | `SettingsStore` (thème), controller du thème, widget ECR-06 (choix du thème, version), application du thème à `MaterialApp` |

## 5. Critères d'acceptation

- [x] Choix du thème Système / Clair / Sombre, enregistré et appliqué immédiatement.
- [x] Affichage de la version de l'application.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (292 tests, dont 15 nouveaux).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - Fichiers : `lib/core/theme/app_theme_mode.dart` (enum `AppThemeMode`, Dart pur), `lib/data/settings/settings_store.dart` (`themeMode` / `setThemeMode`, clé `themeMode`), `lib/features/settings/theme_controller.dart` (`ThemeController`), `lib/features/settings/app_version_provider.dart` (`appVersionProvider`, sans retry automatique), `lib/app.dart` (`MaterialApp.themeMode`), `lib/features/settings/settings_screen.dart` (lignes Thème + dialogue, Version), `lib/l10n/app_fr.arb` (6 clés `settingsTheme*` / `settingsVersion*`) et fichiers l10n générés, `pubspec.yaml` / `pubspec.lock` (`package_info_plus` 10.2.2), `specifications/03-ecrans-et-parcours.md` (ECR-06), `docs/ARCHITECTURE_TECHNIQUE.md` §2, `docs/EPICS_ET_USER_STORIES.md` (US-5.4 ✅).
  - Tests : `test/data/settings/settings_store_test.dart` (+4), `test/features/settings/theme_controller_test.dart` (3), `test/features/settings/settings_screen_test.dart` (+5 : thème par défaut, choix, annulation, version, version illisible), `test/app_test.dart` (+3 : `themeMode` système par défaut, thème enregistré appliqué, changement depuis les Paramètres appliqué immédiatement) ; `_FailingSettingsStore` de `backup_service_test.dart` complété.
  - `package_info_plus` n'ajoute aucune permission au manifeste (vérifié dans le manifeste du plugin) ; sa dépendance transitive `http` ne sert qu'à l'implémentation web. À confirmer lors de la vérification de l'APK release (US-6.4, ENF-02).
  - Riverpod 3 relance automatiquement un provider en erreur : désactivé pour `appVersionProvider`, sinon « Indisponible » ne s'afficherait jamais.
  - À vérifier sur le S22 (US-6.4) : bascule Clair / Sombre avec les couleurs dynamiques, version affichée par l'APK release.
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
