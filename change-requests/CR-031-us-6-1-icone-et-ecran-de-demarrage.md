# CR-031 — US-6.1 : icône et écran de démarrage

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-05 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — |

## 1. Demande

Doter l'application d'une icône propre et d'un écran de démarrage (US-6.1) : icône adaptative, icône thématique Android 13+ (`flutter_launcher_icons`), écran de démarrage (`flutter_native_splash`).

## 2. Motivation

L'application utilise encore l'icône Flutter par défaut et un écran de démarrage blanc/noir vide : elle doit être reconnaissable sur l'écran d'accueil du S22 et s'ouvrir sans flash incohérent avec son thème.

## 3. Changement proposé

- Icône source dessinée pour le projet (aucune icône fournie) : pièce de monnaie blanche entourée d'une flèche circulaire (argent prêté qui revient), sur fond vert sarcelle `#00695C` (couleur de base du thème, `AppTheme.seedColor`). Fichiers dans `assets/icon/` :
  - `icon.png` (1024 px, icône classique complète) ;
  - `icon_foreground.png` (1024 px, motif blanc sur fond transparent, dans la zone de sécurité de l'icône adaptative) ;
  - `icon_monochrome.png` (1024 px, même motif, pour l'icône thématique Android 13+) ;
  - `splash.png` (motif seul pour l'écran de démarrage).
  - Les PNG sont produits par le script `tool/generate_icon_sources.dart` (reproductible, Dart pur avec `dart:io` : aucun paquet ajouté).
- `flutter_launcher_icons` (configuration `flutter_launcher_icons.yaml`) : Android uniquement, icône classique + adaptative (fond `#00695C`, premier plan) + monochrome (Android 13+). `minSdk` 26 : l'icône adaptative est toujours utilisée sur le S22.
- `flutter_native_splash` (configuration `flutter_native_splash.yaml`) : fond `#00695C` en mode clair et `#00332C` (sarcelle foncé) en mode sombre, motif blanc centré ; API SplashScreen d'Android 12+ configurée (`android_12`). Pas de maintien de l'écran de démarrage depuis le code Dart (`preserve`/`remove` non utilisés) : il disparaît à la première image Flutter, ce qui respecte ENF-04.
- Aucun texte d'interface, aucun écran Flutter, aucune permission ajoutée.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucune règle ni écran modifiés ; `docs/ARCHITECTURE_TECHNIQUE.md` : précision de la ligne Icône / splash et de l'arborescence (`assets/icon/`, `tool/`) |
| Écrans | Icône du lanceur, écran de démarrage Android (avant ECR-01) |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-6.1 terminée |
| Tests | Aucun test automatique possible sur les ressources Android générées ; les tests existants doivent rester verts. Vérification visuelle sur le S22 (US-6.4) |

## 5. Critères d'acceptation

- [x] Icône adaptative générée (fond + premier plan) et icône thématique (monochrome) Android 13+.
- [x] Écran de démarrage généré (Android ≤ 11 et API SplashScreen Android 12+), clair et sombre.
- [x] Manifeste sans nouvelle permission.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (292 tests).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-05) :
  - Fichiers créés : `tool/generate_icon_sources.dart`, `assets/icon/{icon,icon_foreground,icon_monochrome,splash}.png`, `flutter_launcher_icons.yaml`, `flutter_native_splash.yaml`.
  - Ressources Android générées : `mipmap-*/ic_launcher.png` (remplacées), `mipmap-anydpi-v26/ic_launcher.xml`, `drawable-*/ic_launcher_foreground.png` et `ic_launcher_monochrome.png`, `values/colors.xml` (`ic_launcher_background`), `drawable*/launch_background.xml` + `background.png` / `splash.png` (dont variantes `night`), `drawable-*/android12splash.png`, `values-v31/styles.xml`, `values-night-v31/styles.xml`, `values/styles.xml` et `values-night/styles.xml` (attributs ajoutés au `LaunchTheme`).
  - `flutter_launcher_icons` applique un retrait (`inset`) de 16 % au premier plan et au monochrome : le motif occupe environ 57 % de la zone visible de l'icône, proportion usuelle.
  - Le dossier `assets/` n'est pas déclaré dans `pubspec.yaml` : les images ne servent qu'à la génération et ne sont pas embarquées dans l'APK.
  - Documentation : `docs/ARCHITECTURE_TECHNIQUE.md` (§2 ligne Icône / splash, §4 arborescence), `docs/EPICS_ET_USER_STORIES.md` (US-6.1 ✅).
  - **Réserve** : aucun SDK Android dans l'environnement de l'agent (`flutter build apk --debug` : « No Android SDK found ») ; la compilation des ressources par `aapt` n'a donc pas été vérifiée. À faire au prochain build sur le poste de développement, puis vérification visuelle sur le S22 (icône, icône thématique activée, démarrage clair / sombre) — US-6.4.
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
