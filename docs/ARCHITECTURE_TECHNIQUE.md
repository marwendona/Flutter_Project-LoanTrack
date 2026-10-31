# Architecture technique — LoanTrack

**Version** : 2.0 (CR-002 : passage à Flutter et IntelliJ IDEA)

## 1. Contraintes structurantes

| Contrainte | Conséquence technique |
|---|---|
| Usage personnel, un seul appareil | Pas de backend, pas d'authentification, base locale |
| Gratuit | Outils et bibliothèques open source uniquement (IntelliJ IDEA Community suffit) |
| Installation par APK (hors Play Store) | Signature release avec keystore personnel, build local |
| Données financières privées | Aucune permission `INTERNET` en release, sauvegarde système désactivée, export manuel |
| Samsung S22 (Android 14+, arm64) | Material 3 + couleurs dynamiques, APK ciblé arm64 |
| Développeur familier de Flutter | Flutter / Dart plutôt que Kotlin / Compose |

## 2. Choix technologiques

| Domaine | Choix | Justification | Alternatives écartées |
|---|---|---|---|
| Framework | **Flutter 3.x (stable), Dart 3.x** | Maîtrisé par le développeur, productif, Material 3 complet | Kotlin/Compose (moins familier), React Native |
| Plateforme cible | **Android uniquement** (`--platforms android`) | Seul appareil visé ; projet plus léger | — |
| UI | **Material 3** via le paquet officiel **material_ui** (CR-003) + **dynamic_color** | Thème clair/sombre, couleurs Material You du S22 ; depuis Flutter 3.47, Material évolue dans `material_ui` et `dynamic_color` en dépend | `package:flutter/material.dart` (ancienne bibliothèque, types incompatibles avec `dynamic_color` 2.x) |
| Gestion d'état / DI | **flutter_riverpod** (`Notifier`, `StreamProvider`) | Standard de fait, testable, sert aussi d'injection de dépendances | Bloc (plus verbeux), Provider (limité), GetX |
| Persistance | **Drift** (SQLite) ; SQLite natif embarqué par `sqlite3` 3.x (dépendance de Drift ; `sqlite3_flutter_libs` est obsolète depuis cette version) ; **path_provider** + **path** pour l'emplacement du fichier de base | Typé, requêtes réactives (`watch()` → `Stream`), transactions, migrations testables, clés étrangères | sqflite (SQL brut, pas réactif), Hive/Isar (non relationnels) |
| Préférences | **shared_preferences** | Devise, thème — besoin minime | — |
| Navigation | **go_router** | Officiel (flutter.dev), routes déclaratives, imbrication avec barre inférieure (`StatefulShellRoute`) | Navigator 1.0 manuel |
| Modèles immuables | **freezed** + **json_serializable** | `copyWith`, égalité, sérialisation JSON pour l'export | Écriture manuelle |
| Génération de code | **build_runner** | Requis par Drift / freezed / json_serializable | — |
| Internationalisation / formats | **flutter_localizations** + **intl** (fichiers ARB, `gen-l10n`) | Textes en français centralisés, formatage montants et dates `fr` | Chaînes en dur |
| Fichiers (export/import) | **file_picker** (`saveFile` / `pickFiles`) | Utilise le sélecteur système Android (SAF) : aucune permission de stockage | Permissions de stockage (à éviter) |
| Date du jour | **clock** | Date du jour injectable dans les tests | `DateTime.now()` direct |
| Qualité | **flutter_lints** + règles strictes dans `analysis_options.yaml`, `dart format` | Gratuit, standard | very_good_analysis (option) |
| Tests | **flutter_test**, **mocktail**, Drift en mémoire (`NativeDatabase.memory()`) | Standard | — |
| Icône / splash | **flutter_launcher_icons**, **flutter_native_splash** (dev dependencies) | Génération automatique | — |

### Versions cibles

| Paramètre | Valeur |
|---|---|
| Flutter / Dart | Dernière version **stable** au moment de l'initialisation (E0), notée dans `pubspec.yaml` (`environment`) et le README |
| Paquets | Dernières versions stables à l'initialisation, verrouillées par `pubspec.lock` (versionné) |
| Android `minSdk` | 26 (Android 8.0) |
| Android `compileSdk` / `targetSdk` | Valeurs par défaut de Flutter (`flutter.compileSdkVersion`, `flutter.targetSdkVersion`) |
| JDK | 17 |
| applicationId / namespace | `com.loantrack.app` |
| Nom du paquet Dart | `loantrack` |

## 3. Environnement de développement : IntelliJ IDEA

IntelliJ IDEA (**Community**, gratuite, ou Ultimate) fonctionne parfaitement pour Flutter :

1. Installer le **Flutter SDK** (canal stable) et l'ajouter au `PATH`.
2. Dans IntelliJ : *Settings → Plugins* → installer **Flutter** (installe aussi **Dart**). Le plugin **Android** est inclus d'office dans IntelliJ.
3. Installer le **SDK Android** sans Android Studio :
   - soit via *Settings → Languages & Frameworks → Android SDK* dans IntelliJ (plugin Android) ;
   - soit via les **command-line tools** Android (`sdkmanager "platform-tools" "platforms;android-35" "build-tools;35.0.0"`, en adaptant les versions à celles demandées par Flutter).
4. `flutter config --android-sdk <chemin du SDK>` et, si besoin, `flutter config --jdk-dir <chemin JDK 17>`.
5. `flutter doctor --android-licenses` puis `flutter doctor`. L'avertissement « Android Studio not installed » **peut être ignoré** : seule la ligne « Android toolchain » doit être verte.
6. Ouvrir le dossier du projet dans IntelliJ, configurer le SDK Flutter (*Languages & Frameworks → Flutter*) et choisir le S22 (branché en USB avec débogage activé) comme appareil.

## 4. Architecture applicative

Architecture en **3 couches** avec flux de données unidirectionnel :

```
┌─────────────────────── presentation (features/*) ───────────────────────┐
│  Widgets (Screen)  ◄── state ──  Controller (Riverpod Notifier/Provider) │
│                     ── actions ──►                                       │
└──────────────────────────────────┬──────────────────────────────────────┘
                                   │ lit / appelle
┌─────────────────────────── domain ▼─────────────────────────────────────┐
│  Modèles (Borrower, Loan, Repayment, Money, LocalDay, LoanStatus, …)     │
│  Services métier purs (calcul statut, totaux, validations)               │
│  Interfaces de repositories                                              │
└──────────────────────────────────┬──────────────────────────────────────┘
                                   │ implémentées par
┌──────────────────────────── data ▼──────────────────────────────────────┐
│  Repositories (impl) ── DAOs Drift ── AppDatabase (SQLite)               │
│  SettingsStore (shared_preferences)   BackupService (JSON)               │
└─────────────────────────────────────────────────────────────────────────┘
```

- **Flux** : Drift émet des `Stream` (`watch()`) → le repository mappe vers les modèles domaine → un `StreamProvider` / `Notifier` Riverpod combine et expose l'état → les widgets affichent avec `ref.watch` ; les actions passent par des méthodes du controller.
- **Dépendances** : `features → domain ← data`. `domain` est du **Dart pur** (aucun import `package:flutter`, Drift ou `shared_preferences`).
- Les classes générées par Drift (lignes de tables) ne sortent jamais de `data` : elles sont mappées vers les modèles `domain`.
- Les providers Riverpod servent d'injection de dépendances (ex. `appDatabaseProvider`, `loanRepositoryProvider`), surchargés dans les tests via `ProviderContainer(overrides: …)`.

### Arborescence

```
.
├── pubspec.yaml / pubspec.lock / analysis_options.yaml / l10n.yaml
├── android/                         projet Android généré par Flutter (manifeste, signature)
├── assets/icon/                     icône source
├── lib/
│   ├── main.dart                    ProviderScope + LoanTrackApp
│   ├── app.dart                     MaterialApp.router, thème, localisations
│   ├── l10n/app_fr.arb              tous les textes de l'interface
│   ├── core/
│   │   ├── money/                   Money, MoneyFormatter, MoneyParser
│   │   ├── date/                    LocalDay, DateFormatter
│   │   ├── router/                  app_router.dart (go_router, StatefulShellRoute)
│   │   ├── theme/                   app_theme.dart, status_colors.dart
│   │   └── widgets/                 MoneyText, StatusChip, DateField, ConfirmDialog, EmptyState
│   ├── domain/
│   │   ├── models/                  borrower.dart, loan.dart, repayment.dart, loan_status.dart,
│   │   │                            loan_summary.dart, borrower_summary.dart, global_summary.dart
│   │   ├── repositories/            borrower_repository.dart, loan_repository.dart, …
│   │   └── services/                loan_status_calculator.dart, validators.dart, summary_calculator.dart
│   ├── data/
│   │   ├── database/                app_database.dart, tables.dart, daos/, converters.dart
│   │   ├── repositories/            *_repository_impl.dart + mappers
│   │   ├── settings/                settings_store.dart
│   │   └── backup/                  backup_dto.dart, backup_service.dart
│   └── features/
│       ├── dashboard/               dashboard_screen.dart, dashboard_controller.dart, widgets/
│       ├── borrowers/               liste + formulaire emprunteur
│       ├── borrower_detail/
│       ├── loan/                    formulaire et détail prêt, saisie remboursement
│       └── settings/
└── test/                            même arborescence que lib/
```

## 5. Modèle de données (Drift — schéma v1)

```sql
CREATE TABLE borrowers (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT    NOT NULL,
  name_key    TEXT    NOT NULL UNIQUE,   -- nom normalisé (trim + minuscules + sans accents) pour RG-02
  phone       TEXT,
  note        TEXT,
  created_at  INTEGER NOT NULL           -- jour (epochDay)
);

CREATE TABLE loans (
  id                    INTEGER PRIMARY KEY AUTOINCREMENT,
  borrower_id           INTEGER NOT NULL REFERENCES borrowers(id) ON DELETE CASCADE,
  amount_minor          INTEGER NOT NULL CHECK (amount_minor > 0),
  loan_date             INTEGER NOT NULL,  -- epochDay
  promised_return_date  INTEGER,           -- epochDay, nullable
  note                  TEXT
);
CREATE INDEX idx_loans_borrower ON loans(borrower_id);

CREATE TABLE repayments (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  loan_id         INTEGER NOT NULL REFERENCES loans(id) ON DELETE CASCADE,
  amount_minor    INTEGER NOT NULL CHECK (amount_minor > 0),
  repayment_date  INTEGER NOT NULL,        -- epochDay
  note            TEXT
);
CREATE INDEX idx_repayments_loan ON repayments(loan_id);
```

Les tables sont déclarées en Dart (`class Loans extends Table`) ; le SQL ci-dessus est leur équivalent.

**Décisions clés**

- **Argent en `int` (unités mineures)** : `1 250,500 TND` → `1250500` (les `int` Dart sont sur 64 bits sur Android). Le type domaine `Money` encapsule les opérations ; jamais de `double` pour l'argent. Formatage via `intl` (`NumberFormat` locale `fr`) selon les décimales de la devise.
- **Dates sans heure** : Dart n'a pas de type « date seule » ; un type `LocalDay` (année, mois, jour, basé sur `DateTime.utc`) évite les décalages de fuseau/heure d'été. Stocké en `epochDay` via un `TypeConverter` Drift.
- **Rien de calculé n'est stocké** (remboursé, reste dû, statut, totaux) : agrégations SQL (`SUM`, `LEFT JOIN`, `GROUP BY`) exposées en `Stream`, puis statut calculé dans `domain` (il dépend de la date du jour fournie par `clock`).
- **Clés étrangères** activées (`PRAGMA foreign_keys = ON` dans `beforeOpen`), cascade + opérations multi-étapes dans `transaction()` (ENF-06).
- **Migrations** : `schemaVersion` incrémenté à chaque évolution ; schémas exportés avec `drift_dev schema dump` dans `drift_schemas/` et migrations testées (ENF-07).

### Exemple d'agrégation (totaux par emprunteur)

```sql
SELECT b.id, b.name,
       COALESCE(SUM(l.amount_minor), 0) AS total_lent,
       COALESCE(SUM(r.repaid), 0)       AS total_repaid
FROM borrowers b
LEFT JOIN loans l ON l.borrower_id = b.id
LEFT JOIN (SELECT loan_id, SUM(amount_minor) AS repaid FROM repayments GROUP BY loan_id) r
       ON r.loan_id = l.id
GROUP BY b.id;
```

## 6. Sauvegarde / restauration

- Format JSON versionné (`formatVersion: 1`) : `{ formatVersion, exportedAt, currency, borrowers[], loans[], repayments[] }` (DTO `freezed` + `json_serializable`).
- Export : `FilePicker.platform.saveFile(bytes: …)` → sélecteur système Android ; nom proposé `loantrack-sauvegarde-AAAA-MM-JJ.json`.
- Import : `FilePicker.platform.pickFiles(withData: true)` ; validation complète en mémoire **avant** toute écriture, puis remplacement dans une seule transaction.
- Aucune permission de stockage requise.

## 7. Sécurité et confidentialité

- `android/app/src/main/AndroidManifest.xml` : **aucune permission**.
  - ⚠️ Flutter ajoute `INTERNET` dans les manifestes `debug` et `profile` (nécessaire au hot reload) : c'est normal et n'affecte **pas** l'APK release.
  - Après chaque ajout de paquet, vérifier qu'aucun plugin n'injecte `INTERNET` dans l'APK release (`aapt dump permissions app-release.apk` ou analyse de l'APK dans IntelliJ). En cas de besoin, la retirer avec `tools:node="remove"`.
- `android:allowBackup="false"` + `android:fullBackupContent="false"` + `dataExtractionRules` excluant tout (ENF-02).
- Release : réduction du code Android par R8 (par défaut avec Flutter) et code Dart compilé AOT.
- V2 (optionnel) : verrouillage via `local_auth` (empreinte / code) et masquage dans les applications récentes.

## 8. Build, signature et installation

1. **Clé personnelle (une seule fois)** :
   ```
   keytool -genkeypair -v -keystore loantrack-release.jks -alias loantrack -keyalg RSA -keysize 4096 -validity 36500
   ```
   Conserver le `.jks` **hors du dépôt** et en lieu sûr : sans lui, impossible d'installer une mise à jour par-dessus la version existante (il faudrait désinstaller et perdre les données non exportées).
2. Créer `android/key.properties` (ignoré par git) :
   ```
   storeFile=C:/chemin/vers/loantrack-release.jks
   storePassword=…
   keyAlias=loantrack
   keyPassword=…
   ```
   `android/app/build.gradle.kts` lit ce fichier pour la `signingConfig` release (procédure officielle Flutter « Build and release an Android app »).
3. Build : `flutter build apk --release --target-platform android-arm64` → `build/app/outputs/flutter-apk/app-release.apk` (APK arm64 uniquement, plus léger, adapté au S22).
4. Installation sur le S22, au choix :
   - **USB** : débogage USB activé, puis `flutter install --release` ou `adb install -r build/app/outputs/flutter-apk/app-release.apk` ;
   - **Fichier** : copier l'APK sur le téléphone, l'ouvrir avec « Mes fichiers », autoriser « Installer des applis inconnues ».
5. Versionnement : `version: 1.0.0+1` dans `pubspec.yaml` (`versionName+versionCode`) ; le numéro après `+` est incrémenté à chaque APK.

## 9. Stratégie de tests

| Niveau | Cible | Outils |
|---|---|---|
| Unitaires domaine | Statut, reste dû, totaux, validations RG-xx, `Money`, `LocalDay` | `flutter_test` (ou `test`) |
| Controllers | États exposés, validations de formulaires | `ProviderContainer` + overrides, `mocktail` |
| Base de données | DAOs, agrégations, cascades, migrations | Drift `NativeDatabase.memory()`, `drift_dev` schema tests |
| Sauvegarde | Aller-retour export → import, fichiers invalides | `flutter_test` |
| Widgets | Formulaires, écrans clés, parcours principal | `testWidgets` (peu de tests, ciblés) |

## 10. Limites connues de Flutter (acceptées)

| Point | Impact | Mitigation |
|---|---|---|
| Taille de l'APK (~15–20 Mo contre ~5 Mo en natif) | Négligeable sur un S22 | Build arm64 uniquement |
| Material You non automatique | Couleurs dynamiques non natives | Paquet `dynamic_color` |
| Transition `package:flutter/material.dart` → `material_ui` | Un paquet tiers encore basé sur l'ancien Material peut mal hériter du thème | `MaterialUiCompatibilityBridge` si nécessaire (CR-003) |
| Débogage = permission `INTERNET` | Uniquement en debug/profile | Vérification de l'APK release (§7) |
| Génération de code (build_runner) | Étape supplémentaire | `dart run build_runner watch` pendant le développement ; fichiers générés **versionnés** pour un build reproductible |

## 11. Registre des décisions d'architecture (ADR)

| ID | Décision | Statut |
|---|---|---|
| ADR-01 | ~~Kotlin/Compose natif~~ → **Flutter (Android uniquement)**, familier au développeur (CR-002) | Acceptée |
| ADR-02 | Un seul paquet Flutter, couches séparées par dossiers (`domain` / `data` / `features`) | Acceptée |
| ADR-03 | Montants en `int` unités mineures, devise unique (TND par défaut, verrouillée dès qu'un prêt existe) | Acceptée |
| ADR-04 | Valeurs calculées jamais persistées | Acceptée |
| ADR-05 | Pas de permission `INTERNET` en release, sauvegarde système désactivée, export JSON manuel via sélecteur système | Acceptée |
| ADR-06 | Riverpod pour l'état et l'injection de dépendances, Drift pour la persistance | Acceptée |
| ADR-07 | IntelliJ IDEA + plugin Flutter comme IDE (pas d'Android Studio) (CR-002) | Acceptée |
| ADR-08 | Fichiers générés (`*.g.dart`, `*.freezed.dart`, localisations `lib/l10n/generated/`) versionnés dans git | Acceptée |
| ADR-09 | Material via le paquet `material_ui` au lieu de `package:flutter/material.dart` (CR-003) | Acceptée |
